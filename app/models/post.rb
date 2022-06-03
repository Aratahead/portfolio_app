class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  belongs_to :contest
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  enum correct: {
    AC: 1,
    解説AC: 2,
    TLE: 3,
    WA: 4
  }

  enum review_completion:{未完了: 0,復習完了: 1}

  def save_contest(sent_contest)
    if Contest.where(contest_name: sent_contest[:contest_name],
                     contest_number: sent_contest[:contest_number]).count.zero?
      Contest.create(contest_name: sent_contest[:contest_name], contest_number: sent_contest[:contest_number])
    end
  end

  def save_tag(sent_tags)
    current_tags = tags.pluck(:name) unless tags.nil?
    @old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    # 古いタグがあれば古いタグを消す
    if @old_tags.present?
      @old_tags.each do |old|
        tags.delete(Tag.find_by(name: old))
      end
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      tags << new_post_tag
    end
  end
end
