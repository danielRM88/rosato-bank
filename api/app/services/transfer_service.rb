class TransferService
  def self.transfer(from, to, balance)
    ActiveRecord::Base.transaction do
      from.update!(balance: from.balance-balance)
      from.transactions.create!(amount: balance*-1, description: "Transfer to #{to.number}")
      to.update!(balance: to.balance+balance)
      to.transactions.create!(amount: balance, description: "Transfer from #{from.number}")
    end
  rescue StandardError => ex
    Rails.logger.error(ex.message)
  end
end
