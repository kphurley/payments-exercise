require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:loan) { Loan.create!(funded_amount: 100.0) }

  describe '#index' do
    it 'responds with a 200' do
      get :index, params: { loan_id: loan.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:payment) { Payment.create!(amount: 100.0, loan_id: loan.id) }

    it 'responds with a 200' do
      get :show, params: { id: payment.id, loan_id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the payment is not found' do
      it 'responds with null' do
        get :show, params: { id: payment.id + 1, loan_id: loan.id }
        expect(response.body).to eq("null")
      end
    end
  end

  describe '#create' do
    let(:params) { { loan_id: loan.id, amount: 20.0 } }

    it 'responds with a 200' do
      post :create, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'creates a payment for the given loan' do
      post :create, params: params
      expect(response.body).to eq(loan.payments.last.to_json)
      expect(loan.payments.last.amount).to eq(20.0)
    end
  end
end
