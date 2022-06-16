class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post_contest, only: %i[show destroy edit update review_complete review_incomplete]
  before_action :set_tag_list, only: %i[update create]
  PER_PAGE = 10

  def index
    @q = current_user.posts.includes(:contest, :tags).ransack(params[:q])
    @posts = @q.result.page(params[:page]).order(created_at: :desc).per(PER_PAGE)
  end

  def new
    @contest = Contest.new
    @post = @contest.posts.new
    @tag = @post.tags.pluck(:name).join(" ")
  end

  def create
    contest = Contest.create(contest_params)
    @post = contest.posts.new(post_params)
    @post.user_id = current_user.id
    @post.post_correct?
    if @post.save
      @post.save_tag(@tag_list)
      flash[:notice] = t "flash.new"
      redirect_to @post
    else
      flash.now[:alert] = t "flash.new _fail"
      render :new
    end
  end

  def show
    @post_tags = @post.tags
  end

  def destroy
    tags = @post.tags.pluck(:name)
    @post.destroy!
    @post.old_tag_destroy?(tags)
    flash.now[:alert] = t "flash.destroy"
    redirect_to posts_path
  end

  def edit
    @tag = @post.tags.pluck(:name).join(" ")
  end

  def update
    @post.post_correct?
    if @post.update(post_params) && @contest.update(contest_params)
      @post.save_tag(@tag_list)
      @post.old_tag_destroy?
      flash[:notice] = t "flash.update"
      redirect_to @post
    else
      flash.now[:alert] = t "flash.update_fail"
      render :edit
    end
  end

  def search
    @q = current_user.posts.includes(:contest, :tags).ransack(search_params)
    @posts = @q.result.page(params[:page]).per(PER_PAGE)
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.includes(:contest, :tags).page(params[:page]).per(PER_PAGE)
  end

  def review_complete
    @post.review_date = Time.current
    @post.review_completion = 1
    @post.save
    redirect_back(fallback_location: posts_path)
  end

  def review_incomplete
    @post.review_completion = 0
    @post.save
    redirect_back(fallback_location: posts_path)
  end

  private

  def set_tag_list
    @tag_list = params[:post][:name].split
  end

  def search_params
    params.require(:q).permit!
  end

  def set_post_contest
    @post = Post.find(params[:id])
    @contest = Contest.find(@post.contest_id)
  end

  def post_params
    params.require(:post).permit(:question_name, :code, :comment, :correct, :contest_id, :image)
  end

  def contest_params
    params.require(:post).permit(:contest_name, :contest_number)
  end
end
