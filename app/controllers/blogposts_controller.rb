# encoding: utf-8
class BlogpostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :update, :edit]
  before_filter :correct_user, only: [:destroy, :update, :edit]

  def new 
    @blogpost = Blogpost.new
  end

  def index
    @blogposts = Blogpost.paginate(page: params[:page])
  end

  def create
    @blogpost = current_user.blogposts.build(params[:blogpost])
    if @blogpost.save
      flash[:success] = "Blogpost erzeugt!"
      redirect_to root_path
    else
      render 'blogpost.new'
    end
  end

  def edit 
    @blogpost = current_user.blogposts.find_by_url_slug(params[:id])
  end

  def update
    @blogpost = current_user.blogposts.find_by_url_slug(params[:id])
    if @blogpost.update_attributes(params[:blogpost])
      flash[:success] = "Blogpost erfolgreich geändert"
      redirect_to root_path
    else
      @titel = "Blogpost editieren"
      render 'blogpost.edit'
    end
  end

  def destroy
    @blogpost = current_user.blogposts.find_by_url_slug(params[:id])
    redirect_to root_path
  end

  def show
    @blogpost = Blogpost.find_by_url_slug(params[:id])
  end

  private

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Bitte anmelden"
    end
  end

  def correct_user
    @user = current_user
    @blogpost = current_user.blogposts.find_by_url_slug(params[:id])
    redirect_to root_path if @blogpost.nil?
  end

end
