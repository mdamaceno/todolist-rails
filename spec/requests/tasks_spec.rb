require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    let(:user) { create(:user) }

    context 'user is not logged in' do
      it 'returns status 302' do
        get tasks_path
        expect(response).to have_http_status(302)
      end
    end

    context 'user is logged in' do
      before do
        create(:profile, user: user)
      end

      it "can see complete and incomplete tasks" do
        task_complete = create(:task, user: user, status: Task.statuses[:complete])
        task_incomplete = create(:task, user: user, status: Task.statuses[:incomplete])

        login_as(user)
        get tasks_path

        expect(response.body).to include('<strong>Incomplete</strong>')
        expect(response.body).to include('<strong>Complete</strong>')
        expect(response.body).to include(task_complete.title)
        expect(response.body).to include(task_incomplete.title)
        expect(response).to have_http_status(200)
      end

      it 'cannot see tasks created by another user' do
        another_user = create(:user)
        task = create(:task, user: another_user, status: Task.statuses[:complete])

        login_as(user)
        get tasks_path

        expect(response.body).not_to include(task.title)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /tasks/:id' do
    let(:user) { create(:user) }

    context 'user is not logged in' do
      it 'returns status 302' do
        task = create(:task, user: user)
        get task_path(task)
        expect(response).to have_http_status(302)
      end
    end

    context 'user is logged in' do
      before do
        create(:profile, user: user)
      end

      it 'can see the task and its comments' do
        task = create(:task, user: user, status: Task.statuses[:complete])
        comment = create(:comment, task: task, user: user)

        login_as(user)
        get task_path(task)

        expect(response.body).to include(task.title)
        expect(response.body).to include(task_path(task))
        expect(response.body).to include(task.description)
        expect(response.body).to include(task.status.titleize)
        expect(response.body).to include("<p>#{comment.body}</p>")
        expect(response.body).to include(comment.user.profile.nickname)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /tasks/:id/edit' do
    let(:user) { create(:user) }

    context 'user is not logged in' do
      it 'returns status 302' do
        task = create(:task, user: user)
        get edit_task_path(task)
        expect(response).to have_http_status(302)
      end
    end

    context 'user is logged in' do
      before do
        create(:profile, user: user)
      end

      it 'can see a form to edit the task' do
        task = create(:task, user: user, status: Task.statuses[:complete])

        login_as(user)
        get edit_task_path(task)

        expect(response).to have_http_status(200)
        expect(response.body).to include(task.title)
        expect(response.body).to include(task_path(task))
        expect(response.body).to include(task.description)
        expect(response.body).to include(task.status.titleize)
        expect(response.body).to include(task.priority.titleize)
      end
    end
  end
end
