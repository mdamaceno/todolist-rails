# frozen_string_literal: true

module UseCases
  class TasksGroupedByStatus
    attr_reader :user

    def initialize(user:)
      @user = user
    end

    def call(search: nil)
      tasks = @user.tasks.order(priority: :desc)

      tasks = tasks.search_title_or_description(search) unless search.nil?

      { complete: tasks.complete, incomplete: tasks.incomplete }
    end
  end
end
