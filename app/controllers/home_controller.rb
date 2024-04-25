class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  skip_after_action :verify_authorized
  def index
  end 
end