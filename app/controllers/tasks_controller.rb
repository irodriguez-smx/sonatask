class TasksController < ApplicationController
  before_filter :restrict_access, only: [:create]
  
  def create
    description = params[:description]
    if not description.nil?
      task = Task.create(task_params)
      task.user = current_user
      task.save!
      res = {:status=>200, :msg=>'task created succesfully', :task=>task}
    else
      res = {:status=>400, :errors=> 'Not description specified'}
    end
    respond_to do |format|
      format.json { render json: res, :status => 200 }
    end
  end

  def index
    tasks = Task.where(:user_id=> current_user.id)
    res = {:status=> 200, :tasks=>tasks}
    respond_to do |format|
      format.json { render json: res, :status => res[:status] }
    end
  end

  private
  def task_params
    params.permit(:description)
  end
end
