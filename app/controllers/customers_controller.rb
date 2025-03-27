class CustomersController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource
  
    def index
      @customers = Customer.order(created_at: :desc).page(params[:page]).per(10)
      @start_index = (@customers.current_page - 1) * @customers.limit_value + 1
    end


  end