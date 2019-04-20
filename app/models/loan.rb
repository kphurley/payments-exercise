class Loan < ActiveRecord::Base
  has_many :payments

  def outstanding_balance
    funded_amount - payments.map(&:amount).sum
  end

  def as_json(params)
    super.merge({ outstanding_balance: outstanding_balance })
  end
end
