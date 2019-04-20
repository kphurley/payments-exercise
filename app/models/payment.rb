class Payment < ActiveRecord::Base
  belongs_to :loan

  validate :amount_does_not_exceed_loan_outstanding_balance

  def amount_does_not_exceed_loan_outstanding_balance
    errors.add(
      :amount, "cannot exceed loan outstanding balance"
    ) unless amount <= loan.outstanding_balance.to_f
  end
end
