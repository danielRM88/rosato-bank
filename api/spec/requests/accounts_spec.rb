require 'rails_helper'

describe 'Requests for Account', type: :request do
  let!(:user) { create(:user) }
  let(:token) { JsonWebToken.encode({ user_id: user.id }) }

  describe 'GET /accounts' do
    context 'not authenticated' do
      it 'returns 401' do
        get accounts_path

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      let!(:account1) { create(:account, user: user) }
      let!(:account2) { create(:account, user: user) }

      it 'returns list of accounts' do
        get accounts_path, headers: { 'Authorization' => "Bearer #{token}" }

        json = JSON.parse(response.body)
        expect(response).to be_ok
        expect(json.count).to eq(2)
        expect(json[0]['number']).to eq(account1.number)
        expect(json[1]['number']).to eq(account2.number)
      end
    end
  end

  describe 'POST /accounts' do
    context 'not authenticated' do
      it 'returns 401' do
        post accounts_path

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      it 'creates the user' do
        post accounts_path, headers: { 'Authorization' => "Bearer #{token}" }, params: {
          account: {
            balance: 200.5,
            user_id: user.id,
            number: '1111111111'
          }
        }, as: :json

        expect(response).to be_created
        account = Account.last
        expect(account.balance).to eq(200.5)
        expect(account.number).to eq('1111111111')
      end

      it 'validates required fields' do
        post accounts_path, headers: { 'Authorization' => "Bearer #{token}" }, params: {
          account: {
            balance: 200
          }
        }, as: :json

        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /accounts/:id' do
    let!(:account) { create(:account, user: user) }

    context 'not authenticated' do
      it 'returns 401' do
        patch account_path(account.id)

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      it 'updates the account' do
        patch account_path(account.id), headers: { 'Authorization' => "Bearer #{token}" }, params: {
          account: {
            balance: 7.0
          }
        }, as: :json

        expect(response).to be_no_content
        updated = Account.find(account.id)
        expect(updated.balance).to eq(7.0)
      end
    end
  end

  describe 'DELETE /accounts/:id' do
    let!(:account) { create(:account, user: user) }

    context 'not authenticated' do
      it 'returns 401' do
        patch account_path(account.id)

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      it 'deletes the account' do
        delete account_path(account.id), headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to be_no_content
        expect(Account.where(id: account.id).first).to be_nil
      end
    end
  end

  describe 'GET /accounts/:id' do
    let!(:account) { create(:account, user: user) }

    context 'not authenticated' do
      it 'returns 401' do
        patch account_path(account.id)

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      it 'returns account' do
        get account_path(account.id), headers: { 'Authorization' => "Bearer #{token}" }

        json = JSON.parse(response.body)
        expect(response).to be_ok
        expect(json['number']).to eq(account.number)
      end
    end
  end

  describe 'POST /accounts/:id/transfer' do
    let(:recipient_start_balance) { 230.5 }
    let(:account_start_balance) { 500 }
    let(:account) { create(:account, user: user, balance: account_start_balance) }
    let(:recipient_account) { create(:account, user: user, balance: recipient_start_balance) }
    let(:amount) { 475.5 }

    context 'not authenticated' do
      it 'returns 401' do
        post account_transfer_path(account.id)

        expect(response).to be_unauthorized
      end
    end

    context 'authenticated' do
      it 'transfers amount between accounts' do
        post account_transfer_path(account.id), headers: { 'Authorization' => "Bearer #{token}" }, params: {
          recipient_account_id: recipient_account.id,
          amount: amount
        }, as: :json

        expect(response).to be_ok
        recipient_account.reload
        account.reload
        expect(account_start_balance - amount).to eq(account.balance)
        expect(amount + recipient_start_balance).to eq(recipient_account.balance)
      end

      it 'returns any errors' do
        post account_transfer_path(account.id), headers: { 'Authorization' => "Bearer #{token}" }, params: {
          recipient_account_id: 30,
          amount: 600
        }, as: :json

        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json).to match("balance"=>["must be greater than or equal to 0"])
      end
    end
  end
end
