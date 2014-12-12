class TasksController < ApplicationController
  def create
    res = {:param1=> 'hola',:status=> 200}
    respond_to do |format|
      format.json { render json: params, :status => res[:status] }
    end
  end

  def index
    res = {:param1=> 'hola',:status=> 200}
    respond_to do |format|
      format.json { render json: res, :status => res[:status] }
    end
  end
end
