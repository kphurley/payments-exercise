require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:loan) { Loan.create({ funded_amount: 200.00 }) }
  let(:payment_amount) { 100.00 }
  let(:payment) { Payment.create!({ amount: payment_amount, loan_id: loan.id })}

  it 'has amount' do
    expect(payment.amount).to eq(payment_amount)
  end

  context 'when attempting to create a payment that exceeds the outstanding balance' do
    it 'raises a validation error' do
      expect { 
        Payment.create!({ amount: loan.outstanding_balance + 1, loan_id: loan.id })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
