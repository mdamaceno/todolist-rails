module UseCases
  class TasksGroupedByStatus
    def initialize(user:)
      @user = user
    end

    def call
      tasks = @user.tasks.order(priority: :desc)

      { complete: tasks.complete, incomplete: tasks.incomplete }
    end
  end
end
