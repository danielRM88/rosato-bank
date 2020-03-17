require 'rails_helper'

describe 'Requests for Users', type: :request do
  describe 'GET /users' do
    context 'not authenticated' do
      it 'returns 401' do
        get users_path

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      let!(:user) { create(:user) }
      let!(:user2) { create(:user, email: 'new@test.com') }
      let(:token) { JsonWebToken.encode({ user_id: user.id }) }

      it 'returns list of users' do
        get users_path, headers: { 'Authorization' => "Bearer #{token}" }

        json = JSON.parse(response.body)
        expect(response).to be_ok
        expect(json.count).to eq(2)
        expect(json[0]['user_name']).to eq(user.user_name)
        expect(json[1]['user_name']).to eq(user2.user_name)
      end
    end
  end

  describe 'POST /users' do
    context 'not authenticated' do
      it 'returns 401' do
        post users_path

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      let!(:user) { create(:user) }
      let(:token) { JsonWebToken.encode({ user_id: user.id }) }

      it 'creates the user' do
        post users_path, headers: { 'Authorization' => "Bearer #{token}" }, params: {
          user: {
            user_name: 'Daniel',
            user_lastname: 'Rosato',
            password: 'password',
            email: 'new-user@test.com'
          }
        }, as: :json

        expect(response).to be_created
        created = User.last
        expect(created.user_name).to eq('Daniel')
        expect(created.user_lastname).to eq('Rosato')
        expect(created.email).to eq('new-user@test.com')
      end

      it 'validates required fields' do
        post users_path, headers: { 'Authorization' => "Bearer #{token}" }, params: {
          user: {
            user_name: 'Daniel',
            user_lastname: 'Rosato',
            email: 'new-user@test.com'
          }
        }, as: :json

        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /users/:id' do
    let!(:user) { create(:user, email: 'update@test.com') }

    context 'not authenticated' do
      it 'returns 401' do
        patch user_path(user.id)

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      let(:token) { JsonWebToken.encode({ user_id: user.id }) }

      it 'updates the user' do
        patch user_path(user.id), headers: { 'Authorization' => "Bearer #{token}" }, params: {
          user: {
            user_lastname: 'Monaco'
          }
        }, as: :json

        expect(response).to be_no_content
        created = User.find(user.id)
        expect(created.user_name).to eq(user.user_name)
        expect(created.user_lastname).to eq('Monaco')
        expect(created.email).to eq(user.email)
      end
    end
  end

  describe 'DELETE /users/:id' do
    let!(:user) { create(:user, email: 'delete@test.com') }

    context 'not authenticated' do
      it 'returns 401' do
        patch user_path(user.id)

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      let(:token) { JsonWebToken.encode({ user_id: user.id }) }

      it 'deletes the user' do
        delete user_path(user.id), headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to be_no_content
        expect(User.where(id: user.id).first).to be_nil
      end
    end
  end

  describe 'GET /users/:id' do
    let!(:user) { create(:user, email: 'show@test.com') }

    context 'not authenticated' do
      it 'returns 401' do
        patch user_path(user.id)

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      let(:token) { JsonWebToken.encode({ user_id: user.id }) }

      it 'returns user' do
        get user_path(user.id), headers: { 'Authorization' => "Bearer #{token}" }

        json = JSON.parse(response.body)
        expect(response).to be_ok
        expect(json['user_name']).to eq(user.user_name)
      end
    end
  end
end
