class TasksController < ApplicationController
  before_filter :restrict_access
  before_action :find_token, only: [:update, :destroy]

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      json_api_response(status: 200, object: @task, message: "Task created successfully")
    else
      json_api_response(status: 400, message: task.errors)
    end
  end

  def update
    if @task.update(task_params)
      json_api_response(status: 200, object: @task, message: "Task updated sucessfully")
    else
      json_api_response(status: 400, message: @task.errors)
    end
  end

  def destroy
    if @task.destroy
      json_api_response(status: 200, message: "Task destroyed sucessfully")
    else
      json_api_response(status: 400, message: @task.errors)
    end
  end

  def index
    json_api_response(status: 200, object: current_user.tasks)
  end

  def sort
    unless params[:tasks]
      json_api_response(status: 400, message: "No tasks param was submitted")
    end

    ids = params[:tasks].map(&:id)
    @tasks = current_user.tasks.find(ids)

    unless ids.length == @tasks.length
      json_api_response(status: 400, message: "Not all tasks submitted for_sort were found")
    end

    params[:tasks].each_with_index do |obj, index|
      task = @tasks.find(obj["id"])
      task.update(:position=>(index+1))
    end

    json_api_response(status: 200, message: "Successfully sorted tasks")
  end

  def search
    unless params[:query]
      json_api_response(status: 400, message: "No query param was submitted")
    end

    @tasks = current_user.tasks.search_by_description(params[:query])
    json_api_response(status: 200, object: @tasks)
  end

  private

  def find_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.permit(
      :description,
      :status,
      :expiration,
      :attachment,
      {
        tags: []
      }
    )
  end
end
