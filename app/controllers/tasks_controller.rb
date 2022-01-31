# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :user_profile?
  before_action :find_task, only: %i[edit update show confirm_delete destroy delete_comment]
  skip_before_action :verify_authenticity_token, only: %i[search]

  include UseCases

  def index
    search = sanitize_sql_like(params[:search]) if params[:search].present?
    tasks_grouped_by_status = TasksGroupedByStatus.new(user: current_user).call(search: search)
    @completed_tasks = tasks_grouped_by_status[:complete]
    @not_completed_tasks = tasks_grouped_by_status[:incomplete]
  end

  def show
    @comment = Comment.new
    @comments = @task.comments.order(created_at: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html do
          redirect_to new_task_url, notice: 'Task was successfully created.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_url, notice: 'Task was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully deleted' }
    end
  end

  def complete; end

  def incomplete; end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority)
  end

  def comment_params; end

  def sanitize_sql_like(string, escape_character = '\\')
    pattern = Regexp.union(escape_character, '%', '_')
    string.gsub(pattern) { |x| [escape_character, x].join }
  end

  def find_task
    @task = current_user.tasks.find(params[:id])
  end
end
