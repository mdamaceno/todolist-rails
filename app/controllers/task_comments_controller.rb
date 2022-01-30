class TaskCommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :user_profile?
  before_action :find_task
  before_action :find_comment, only: :destroy

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
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to [@task], notice: 'Comment was successfully deleted' }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_task
    @task = Task.find(params[:task_id])
  end

  def find_comment
    @comment = @task.comments.find(params[:id])
  end
end
