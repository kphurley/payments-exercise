class PaymentsController < ActionController::API
  
  def index
    render json: Payment.where(loan_id: params[:loan_id])
  end

  def show
    render json: Payment.find_by(loan_id: params[:loan_id], id: params[:id])
  end
  
  def create
    render json: Payment.create!({ amount: params[:amount], loan_id: params[:loan_id] })
  end
end
