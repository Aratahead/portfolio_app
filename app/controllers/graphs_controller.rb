class GraphsController < ApplicationController
  def index
    @post = current_user.posts
    @ac_num = @post.where(correct: "AC").count
    @commentary_ac_num = @post.where(correct: "解説AC").count
    @tle_num = @post.where(correct: "TLE").count
    @wa_num = @post.where(correct: "WA").count
    @review_completion_num = @post.where(review_completion: "復習完了").count
    @review_incompletion_num = @post.where(review_completion: "未完了").count
    @correct_ratio = @post.count.zero? ? 0 : (100 * @review_completion_num / @post.count).to_f
  end
end
