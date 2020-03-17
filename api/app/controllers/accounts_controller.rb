class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all.order(id: :asc)

    render json: @accounts
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    render json: @account
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    if @account.save
      render json: @account, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    @account = Account.find(params[:id])

    if @account.update(account_params)
      head :no_content
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy

    head :no_content
  end

  # POST /accounts/1/transfer
  def transfer
    amount = params[:amount]
    account = Account.find(params[:account_id])
    recipient_account = Account.find(params[:recipient_account_id])

    if TransferService.transfer(account, recipient_account, amount)
      render json: { message: 'transfer successful' }, status: :ok
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:balance, :user_id, :number)
  end
end