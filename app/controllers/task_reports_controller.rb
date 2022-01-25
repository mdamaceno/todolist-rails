class TaskReportsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @tasks = current_user.tasks.where(status: Task.statuses[:complete]).includes(:comments).order('comments.body')
  end
end
