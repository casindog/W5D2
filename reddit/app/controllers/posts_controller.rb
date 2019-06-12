class PostsController < ApplicationController
  before_action :require_log_in
  helper_method :can_edit?

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end
  
  def edit
    @post = current_user.posts.find(params[:id])

    if @post
      render :edit
    else
      flash[:errors] = ["Can't edit post from other users"]
      redirect_to post_url(params[:id])
    end
  end
  
  def update
    @post = Post.find(params[:id])
    
    if current_user.id != @post.user_id
      flash[:errors] = ["Can't edit post from other users"]
      render :edit
    elsif @post.update_attributes(post_params)
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      render :edit
    end
  end
  
  def destroy
    post = Post.find(params[:id])
    
    if can_edit?(post)
      post.destroy
      redirect_to sub_url(post.sub_id)
    else
      flash[:errors] = ["Can't edit post from other users"]
      redirect_to post_url(post)
    end
    
  end
  
  def can_edit?(post)
    user = post.user
    moderator = post.sub.moderator
    current_user.id == user.id || current_user.id == moderator.id
  end
  private

  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end
end
