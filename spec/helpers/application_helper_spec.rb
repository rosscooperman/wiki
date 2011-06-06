require 'spec_helper'

describe ApplicationHelper do
  describe '#delete_link' do
    before do
      @html = helper.delete_link('foo', '/foo')
    end

    it 'should produce a link with method of delete' do
      @html.should match(/data-method="delete"/)
    end

    it 'should produce a link with a confirmation message' do
      @html.should match(/data-confirm=".*"/)
    end

    it 'should produce a link with a class of delete' do
      @html.should match(/class="delete"/)
    end

    it 'should allow any of the default link options to be overidden' do
      @html = helper.delete_link('foo', '/foo', :class => 'foo')
      @html.should_not match(/class="delete"/)
      @html.should match(/class="foo"/)
    end
  end
end
