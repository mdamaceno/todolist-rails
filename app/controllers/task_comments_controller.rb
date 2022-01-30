class TaskCommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :user_profile?
  before_action :find_task

  def create
    @comment = @task.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @task.save
        format.html do
          redirect_to [@task], notice: 'Comment was successfully created.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_task
    @task = Task.find(params[:task_id])
  end
end
