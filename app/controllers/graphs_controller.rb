class GraphsController < ApplicationController
  def index
    @post = current_user.posts
    @ac_num = @post.where(correct: "AC").count
    @commentary_ac_num = @post.where(correct: "解説AC").count
    @tle_num = @post.where(correct: "TLE").count
    @wa_num = @post.where(correct: "WA").count
    @correct_ratio = @post.count.zero? ? 0 : (100 * @ac_num / @post.count).to_f
  end
end
