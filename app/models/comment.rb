# frozen_string_literal: true

class Comment < ApplicationRecord
  MAX_CONTENT_LENGTH = 511
  belongs_to :task
  belongs_to :user
  belongs_to :task, counter_cache: true
  validates :content, presence: true, length: { maximum: MAX_CONTENT_LENGTH }
end
