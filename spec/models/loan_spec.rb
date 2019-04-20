require 'rails_helper'

RSpec.describe Loan, type: :model do
  let!(:loan) { Loan.create({ funded_amount: 200.00 }) }

  describe '#outstanding_balance' do
    let!(:payments) do
      [10.0, 20.0].map do |amt|
        Payment.create!({ amount: amt, loan_id: loan.id })
      end
    end

    it 'returns the funded amount minus the sum of the payment amounts' do
      expect(loan.outstanding_balance).to eq(170.00)
    end
  end
end