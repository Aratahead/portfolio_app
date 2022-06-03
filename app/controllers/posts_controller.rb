class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show destroy edit update review_complete review_incomplete]
  PER_PAGE = 10

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result.page(params[:page]).per(PER_PAGE)
    @tag_list = Tag.all
  end

  def new
    @post = Post.new
    @contest = Contest.new
    @tag = @post.tags.pluck(:name).join(" ")
  end

  def create
    @post = current_user.posts.new(post_params)
    contest = params[:post].slice(:contest_name, :contest_number)
    @post.save_contest(contest)
    @post.contest_id = Contest.find_by(contest_name: contest[:contest_name],
                                       contest_number: contest[:contest_number]).id
    tag_list = params[:post][:name].split(" ")
    if @post.correct == "AC"
      @post.review_completion = 1
      @post.review_date = Time.current
    end
    if @post.save
      @post.save_tag(tag_list)
      redirect_to @post
    else
      flash.now[:alert] = "投稿に失敗しました"
      render :new
    end
  end

  def show
    @post_tags = @post.tags
  end

  def destroy
    post_tag_id = @post.tags.pluck(:tag_id)
    @post.destroy!
    post_tag_id.each do |number|
      Tag.find_by(id: number).delete if PostTag.where(tag_id: number).count.zero?
    end
    @post.destroy!
    redirect_to posts_path
  end

  def edit
    @contest = Contest.find(@post.contest_id)
    @tag = @post.tags.pluck(:name).join(" ")
  end

  def update
    tag_list = params[:post][:name].split(" ")
    if @post.correct == "AC"
      @post.review_completion = 1
      @post.review_date = Time.current
    end
    if @post.update(post_params)
      @post.save_tag(tag_list)
      if @old_tags.present?
        @old_tags.each do |tag|
          Tag.find_by(id: tag.id).delete if PostTag.where(tag_id: tag.id).count.zero?
        end
      end
      redirect_to @post
    else
      render :edit
    end
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:id])
    @posts = @tag.posts
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

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:question_name, :code, :comment, :correct, :contest_id, :image)
  end
end
