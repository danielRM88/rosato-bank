require 'rails_helper'

describe TransferService do
  let(:service) { described_class }
  let(:user) { create(:user, email: 'service@test.com') }
  let(:from_account) { create(:account, balance: 250.50, user: user) }
  let(:to_account) { create(:account, balance: 100, user: user) }

  it 'transfers balance between accounts' do
    start_balance_from = from_account.balance
    start_balance_to = to_account.balance
    result = service.transfer(from_account, to_account, 20.0)
    from_account.reload
    to_account.reload
    expect(result).to be_truthy
    expect(from_account.balance).to eq(start_balance_from - 20.0)
    expect(to_account.balance).to eq(start_balance_to + 20.0)
    expect(from_account.transactions.count).to eq(1)
    expect(to_account.transactions.count).to eq(1)
  end

  it 'rollbacks any changes in case of error' do
    allow(from_account.transactions).to receive(:create!).and_raise(StandardError.new("problem updating"))
    result = service.transfer(from_account, to_account, 20.0)
    expect(result).to be_falsy
    expect(from_account.transactions.count).to eq(0)
    expect(to_account.transactions.count).to eq(0)
  end
end
