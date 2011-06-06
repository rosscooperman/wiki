class Page < ActiveRecord::Base

  def content
    RedCloth.new(read_attribute(:content)).to_html.html_safe
  end
end
