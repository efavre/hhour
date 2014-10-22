class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  default_scope -> { order('created_at ASC') }
  validates :title, presence: true
  validates :content, presence: true
  validates :user, presence: true

end
