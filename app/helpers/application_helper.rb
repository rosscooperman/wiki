module ApplicationHelper

  def delete_link(content, path, options={})
    link_to(content, path, {
      :method => :delete,
      :confirm => 'Are you sure?',
      :class => 'delete'
    }.merge(options))
  end
end
