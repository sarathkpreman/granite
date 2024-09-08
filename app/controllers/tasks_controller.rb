# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    tasks = Task.all
    render status: :ok, json: { tasks: }
  end

  def create
    task = Task.new(task_params)
    task.save!
    render_notice(t("successfully_created"))
  end

  before_action :load_task!, only: %i[show update]

  def show
    render_json({ task: @task })
  end

  def update
    @task.update!(task_params)
    render_notice("Task was successfully updated!")
    render_notice(t("successfully_updated"))
  end

  before_action :load_task!, only: %i[show update destroy]

  def destroy
    @task.destroy!
    render_json
  end

  private

    def load_task!
      @task = Task.find_by!(slug: params[:slug])
    end

    def task_params
      params.require(:task).permit(:title)
    end
end
