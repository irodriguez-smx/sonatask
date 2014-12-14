class TasksController < ApplicationController
  before_filter :restrict_access, only: [:create]
  
  def create
    description = params[:description]
    if not description.nil?
      user = User.find(params[:user_id])
      task = user.tasks.create(task_params)
      task.user = current_user
      task.save!
      @response = {:status=>200, :msg=>'task created successfully', :task=>task}
    else
      @response = {:status=>400, :errors=> 'Not description specified'}
    end
    json_api_response
  end

  def update
    task =  Task.find(params[:id])
    task.update_attributes(task_params)
    @response = {:status=>200, :msg=>'task updated successfully',:task=>task}
    json_api_response
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy!
    @response = {:status=>200, :method=>'delete',:msg=>'task has been deleted successfully'}
    json_api_response
  end 

  def index
    user = User.find(params[:user_id])
    @response = {:status=> 200, :tasks=>user.tasks}
    json_api_response
  end

  def sort
    params[:tasks].each_with_index do |obj, index|
      #puts "id: #{obj["id"]} and index: #{index}"
      Task.where(:id=>obj["id"]).update_all(:position=>(index+1))
    end
    @response = {:status=>200, :msg=>"tasks have been sorted successfully"}
    json_api_response
  end

  def search
    user = User.find(params[:user_id])
    tasks = user.tasks.search_by_description(params[:query])
    @response = {:status=>200, :tasks=>tasks}
    json_api_response
  end


  private
  def task_params
    params.permit(:description,:status,:expiration,{:tags=>[]})
  end
end
