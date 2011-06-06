ENV["WATCHR"] = "1"
system 'clear'

SUCCESS = 0
FAILURE = 1
PENDING = 2

@interrupted = false
@ignore_hup = false
@state = SUCCESS

def state(message)
  if message.match(/[1-9][0-9]* (failures?|errors?)/)
    FAILURE
  elsif message.match(/[1-9][0-9]* pending/)
    PENDING
  else
    SUCCESS
  end
end

def growl(message)
  growlnotify = `which growlnotify`.chomp
  title = "Watchr Test Results"
  image = case(@state)
    when FAILURE then "~/.watchr_images/failed.png"
    when PENDING then "~/.watchr_images/pending.png"
    else "~/.watchr_images/passed.png"
  end
  options = "-w -n Watchr --image '#{File.expand_path(image)}' -m '#{message}' '#{title}'"
  system %(#{growlnotify} #{options} &)
end

def run(cmd, output=true)
  puts(cmd) if output
  @ignore_hup = true

  result = ''
  IO.popen(cmd) do |io|
    until io.eof?
      char = io.getc
      print char
      result << char
    end
  end

  @ignore_hup = false
  @state = state(result)
  result
end

def cmd_for_files(*files)
  %Q(rspec --color --backtrace --tty #{files.join(' ')})
end

def run_spec_files(*files)
  files.reject! { |file| !File.exists?(file) }
  return if files.empty?
  system('clear')
  previous_state = @state
  result = run cmd_for_files(*files)
  growl result.split("\n").last.gsub(/\[\d+m/, '') rescue nil
  if @state == SUCCESS && previous_state != SUCCESS
    Kernel.sleep 1.5
    run_all_specs
  end
end

def run_all_specs
  system('clear')
  puts 'Running all specs...'
  result = run cmd_for_files(Dir['spec/**/*_spec.rb']), false
  growl result.split("\n").last.gsub(/\[\d+m/, '') rescue nil
end

watch(__FILE__)                       { reload }
watch('spec/spec_helper\.rb')         { reload }
watch('spec/support/blueprints\.rb')  { reload }
watch('spec/.*/.*_spec\.rb')          { |m| run_spec_files m[0] }
watch('^app/(.*?)?\.rb')              { |m| run_spec_files "spec/#{m[1]}_spec.rb" }

# Ctrl-C
Signal.trap 'INT' do
  unless @ignore_hup
    if @interrupted then
      @wants_to_quit = true
      abort("\n")
    else
      puts "Interrupt a second time to quit"
      @interrupted = true
      Kernel.sleep 1.5
      @interrupted = false
      reload
    end
  end
end

run_all_specs