require 'rails_helper'

RSpec.describe Payment, type: :request do
  let!(:loan) { Loan.create!(funded_amount: 100.0) }
  let!(:payments) do
    [10.0, 20.0].map do |amt|
      Payment.create!({ amount: amt, loan_id: loan.id })
    end
  end

  describe 'POST /loans/:loan_id/payments' do
    it 'creates a payment for the given loan' do
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/loans/#{loan.id}/payments", :params => { "amount" => 20.00 }

      last_payment = Payment.last
      expect(response.body).to eq(last_payment.to_json)

      expect(last_payment.amount).to eq(20.00)
      expect(last_payment.loan).to eq(loan)
      expect(loan.payments).to include(last_payment)
    end
  end

  describe 'GET /loans/:loan_id/payments' do
    it 'lists the payments for the given loan' do
      headers = { "CONTENT_TYPE" => "application/json" }
      get "/loans/#{loan.id}/payments"

      expect(response.body).to eq(payments.to_json)
    end
  end

  describe 'GET /loans/:loan_id/payments/:id' do
    let(:expected_payment) { payments.last }

    it 'sends the indicated payment for the given loan' do
      headers = { "CONTENT_TYPE" => "application/json" }
      get "/loans/#{loan.id}/payments/#{expected_payment.id}"

      expect(response.body).to eq(expected_payment.to_json)
    end

    context 'when the loan does not contain a payment with the given id' do
      let!(:other_loan) { Loan.create!(funded_amount: 200.0) }
      let!(:other_payment) { Payment.create!({ amount: 50.0, loan_id: other_loan.id }) }

      it 'returns null' do
        headers = { "CONTENT_TYPE" => "application/json" }
        get "/loans/#{loan.id}/payments/#{other_payment.id}"

        expect(response.body).to eq("null")
      end
    end
  end
end