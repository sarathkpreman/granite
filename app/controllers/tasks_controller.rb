# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @task = Task.all
  end
end
