class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    Post.create!(question_name: post_params[:question_name], code: post_params[:code], comment: post_params[:comment],
                 user_id: current_user.id)
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy!
    redirect_to root_path
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update!(post_params)
    redirect_to post
  end

  private

  def post_params
    params.require(:post).permit(:question_name, :code, :comment)
  end
end
