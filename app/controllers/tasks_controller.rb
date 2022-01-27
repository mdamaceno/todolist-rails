class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create destroy search]
  before_action :user_profile?
  before_action :find_task, only: %i[edit update show confirm_delete destroy delete_comment]
  skip_before_action :verify_authenticity_token, only: %i[search]
    
  def index
    @tasks = current_user.tasks.order(priority: :desc, status: :desc, created_at: :desc)
  end

  def show 
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

  def edit
  end

  def update 
  end

  def destroy
  end

  def complete
  end

  def incomplete
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority)
  end  

  def comment_params
  end 

  def sanitize_sql_like(string, escape_character = "\\")
    pattern = Regexp.union(escape_character, "%", "_")
    string.gsub(pattern) { |x| [escape_character, x].join }
  end
end

