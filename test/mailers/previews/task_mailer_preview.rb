# frozen_string_literal: true

class TaskMailerPreview < ActionMailer::Preview
  def pending_tasks_email
    TaskMailer.with(preview: true).pending_tasks_email(User.first.id)
  end
end
