Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end

desc 'Automatically run specs as files change'
task :watchr => 'db:test:prepare' do
  Kernel.exec('bundle exec watchr watchr/specs.rb')
end

Rake.application.remove_task :default
task :default => :watchr
