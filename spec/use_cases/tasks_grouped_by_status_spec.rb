require 'rails_helper'

RSpec.describe UseCases::TasksGroupedByStatus do
  describe '.call' do
    it 'returns complete and incomplete tasks in group ordered by priority' do
      user = create(:user)
      task1 = create(:task, user: user, priority: Task.priorities[:medium], status: Task.statuses[:incomplete])
      task2 = create(:task, user: user, priority: Task.priorities[:high], status: Task.statuses[:incomplete])
      task3 = create(:task, user: user, priority: Task.priorities[:low], status: Task.statuses[:complete])
      result = described_class.new(user: user).call

      expect(result[:complete]).to eq([task3])
      expect(result[:incomplete]).to eq([task2, task1])
    end
  end
end
