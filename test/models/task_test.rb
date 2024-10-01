# frozen_string_literal: true

require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
    @task = create(:task, assigned_user: @user, task_owner: @user)
  end

  def test_values_of_created_at_and_updated_at
    task = Task.new(title: "This is a test task", assigned_user: @user, task_owner: @user)
    assert_nil task.created_at
    assert_nil task.updated_at

    task.save!
    assert_not_nil task.created_at
    assert_equal task.updated_at, task.created_at

    task.update!(title: "This is a updated task")
    assert_not_equal task.updated_at, task.created_at
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

  def test_validation_should_accept_valid_titles
    valid_titles = %w[title title_1 title! -title- _title_ /title 1]

    valid_titles.each do |title|
      @task.title = title
      assert @task.valid?
    end
  end

  def test_validation_should_reject_invalid_title
    invalid_titles = %w[/ *** __ ~ ...]

    invalid_titles.each do |title|
      @task.title = title
      assert @task.invalid?
    end
  end

  def test_task_count_increases_on_saving
    assert_difference ["Task.count"] do
      create(:task)
    end
  end

  def test_task_slug_is_parameterized_title
    title = @task.title
    @task.save!
    assert_equal title.parameterize, @task.slug
  end

  def test_incremental_slug_generation_for_tasks_with_duplicate_two_worded_titles
    first_task = Task.create!(title: "test task", assigned_user: @user, task_owner: @user)
    second_task = Task.create!(title: "test task", assigned_user: @user, task_owner: @user)

    assert_equal "test-task", first_task.slug
    assert_equal "test-task-2", second_task.slug
  end

  def test_incremental_slug_generation_for_tasks_with_duplicate_hyphenated_titles
    first_task = Task.create!(title: "test-task", assigned_user: @user, task_owner: @user)
    second_task = Task.create!(title: "test-task", assigned_user: @user, task_owner: @user)

    assert_equal "test-task", first_task.slug
    assert_equal "test-task-2", second_task.slug
  end

  def test_slug_generation_for_tasks_having_titles_one_being_prefix_of_the_other
    first_task = Task.create!(title: "fishing", assigned_user: @user, task_owner: @user)
    second_task = Task.create!(title: "fish", assigned_user: @user, task_owner: @user)

    assert_equal "fishing", first_task.slug
    assert_equal "fish", second_task.slug
  end

  def test_error_raised_for_duplicate_slug
    another_test_task = Task.create!(title: "another test task", assigned_user: @user, task_owner: @user)

    assert_raises ActiveRecord::RecordInvalid do
      another_test_task.update!(slug: @task.slug)
    end

    error_msg = another_test_task.errors.full_messages.to_sentence
    assert_match I18n.t("task.slug.immutable"), error_msg
  end

  def test_creates_multiple_tasks_with_unique_slug
    tasks = create_list(:task, 10, assigned_user: @user, task_owner: @user)
    slugs = tasks.pluck(:slug)
    assert_equal slugs.uniq, slugs
  end
end
