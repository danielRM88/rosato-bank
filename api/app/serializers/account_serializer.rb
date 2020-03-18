class AccountSerializer < ActiveModel::Serializer
  attributes :id, :balance, :number

  attribute :transactions do
    object.transactions.order(created_at: :desc).limit(10)
  end
end