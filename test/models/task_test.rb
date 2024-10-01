# frozen_string_literal: true

require "test_helper"

# revert backed into previous version
class TaskTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
    @task = create(:task, assigned_user: @user, task_owner: @user)
  end

  def test_task_should_not_be_valid_without_user
    @task.assigned_user = nil
    assert_not @task.save
    assert_includes @task.errors.full_messages, "Assigned user must exist"
  end

  def test_task_title_should_not_exceed_maximum_length
    @task.title = "a" * (Task::MAX_TITLE_LENGTH + 1)
    assert_not @task.valid?
  end

  def test_task_count_increases_on_saving
    assert_difference ["Task.count"] do
      create(:task)
    end
  end

  def test_creates_multiple_tasks_with_unique_slug
    tasks = create_list(:task, 10, assigned_user: @user, task_owner: @user)
    slugs = tasks.pluck(:slug)
    assert_equal slugs.uniq, slugs
  end
end
