class PagesController < ApplicationController

  def index
    @pages = Page.all
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to page_path(@page), :notice => 'Page created successfully'
    else
      render :new
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to page_path(@page), :notice => 'Page updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @page = Page.find(params[:id])
    if @page.destroy
      redirect_to pages_path, :notice => 'Page deleted successfully'
    else
      redirect_to pages_path, :alert => 'Page could not be deleted'
    end
  end
end
