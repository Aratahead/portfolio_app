class PostsController < ApplicationController
  before_action :authenticate_user!
  PER_PAGE = 10

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result.page(params[:page]).per(PER_PAGE)
    @tag_list = Tag.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    contest = params[:post].slice(:contest_name, :contest_number)
    if Contest.where(contest_name: contest[:contest_name],
                     contest_number: contest[:contest_number]).count == 0
      Contest.create(contest_name: contest[:contest_name], contest_number: contest[:contest_number])
    end
    @post.contest_id = Contest.find_by(contest_name: contest[:contest_name],
                                       contest_number: contest[:contest_number]).id
    tag_list = params[:post][:name].split(',')

    if @post.save
      @post.save_tag(tag_list)
      redirect_to @post, notice: '投稿しました'
    else
      flash.now[:alert] = '投稿に失敗しました'
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
  end

  def destroy
    post = Post.find(params[:id])
    post_tag_id = post.tags.pluck(:tag_id)
    post.destroy!
    post_tag_id.each do |number|
      Tag.find_by(id: number).delete if PostTag.where(tag_id: number).count.zero?
    end
    post.destroy!
    redirect_to root_path
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
    if @post.update(post_params)
      @post.save_tag(tag_list)

      unless @old_tags.blank?
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
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts
  end

  private

  def post_params
    params.require(:post).permit(:question_name, :code, :comment, :correct, :contest_id)
  end
end
