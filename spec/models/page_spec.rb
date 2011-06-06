require 'spec_helper'

describe Page do
  describe '#content' do
    it 'should render content as wiki text' do
      page = Page.make!(:content => "*foo*")
      page.content.should match(/<strong>/)
    end

    it 'should mark the resulting string as HTML safe' do
      page = Page.make!(:content => "foo")
      page.content.html_safe?.should be_true
    end
  end
end
