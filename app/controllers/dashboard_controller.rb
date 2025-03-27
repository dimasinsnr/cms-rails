class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @leads = Lead.all
    @customers = Customer.all
  end
end