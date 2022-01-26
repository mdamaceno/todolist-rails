require 'rails_helper'

RSpec.describe "TaskReports", type: :request do
  describe "GET /tasks/reports" do
    let(:user) { create(:user) }

    before do
    end

    it "returns 200 status" do
      login_as(user)
      get reports_path

      expect(response.body).to include('<h2>Tarefas completas</h2>')
      expect(response).to have_http_status(200)
    end

    it 'show only completed tasks by user' do
      completed_tasks = create_list(:task, 2,
                                    title: 'abcd',
                                    description: 'lorem',
                                    user: user,
                                    status: Task.statuses[:complete])

      not_completed_tasks = create_list(:task, 2,
                                   title: 'abcd',
                                   description: 'lorem',
                                   user: user,
                                   status: Task.statuses[:incomplete])

      login_as(user)
      get reports_path

      completed_tasks.each do |t|
        expect(response.body).to include("<td>#{t.id}</td>")
        expect(t.status).to eq('complete')
      end

      not_completed_tasks.each do |t|
        expect(response.body).not_to include("<td>#{t.id}</td>")
        expect(t.status).to eq('incomplete')
      end
    end

    it 'show completed tasks with their comments body' do
      another_user = create(:user)
      task1 = create(:task, title: 'abcd', description: 'lorem', user: user, status: Task.statuses[:complete])
      task2 = create(:task, title: 'abcd', description: 'lorem', user: user, status: Task.statuses[:complete])

      comments = [
        create(:comment, body: 'goku', task: task1, user: another_user),
        create(:comment, body: 'vegeta', task: task2, user: another_user),
        create(:comment, body: 'trunks', task: task2, user: another_user)
      ]

      login_as(user)
      get reports_path

      comments.each do |c|
        expect(response.body).to include("<td>#{c.task.id}</td>")
        expect(response.body).to include("<td>#{c.body}</td>")
        expect(response.body).to include("<td>complete</td>")
      end
    end
  end
end
