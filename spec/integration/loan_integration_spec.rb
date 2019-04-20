require 'rails_helper'
require 'json'

RSpec.describe Loan, type: :request do
  let!(:loans) do
    [1500.0, 1000.0, 400.0].map do |amt|
      Loan.create!(funded_amount: amt)
    end
  end

  let!(:payments) do
    [10.0, 20.0].map do |amt|
      Payment.create!({ amount: amt, loan_id: loans[0].id })
    end
  end

  describe 'GET /loans' do
    it 'gets all of the loans with the outstanding balance' do
      get "/loans"

      expect(response.body).to eq(loans.to_json)
      JSON.parse(response.body).each_with_index do |parsed_loan, idx|
        expect(parsed_loan["outstanding_balance"].to_f).to eq(loans[idx].outstanding_balance)
      end
    end
  end

  describe 'GET /loans/:id' do
    let!(:loan) { loans[0] }

    it 'gets the indicated loan with the outstanding balance' do
      get "/loans/#{loan.id}"

      expect(response.body).to eq(loan.to_json)
      expect(JSON.parse(response.body)["outstanding_balance"].to_f).to eq(loan.outstanding_balance)
    end
  end
end