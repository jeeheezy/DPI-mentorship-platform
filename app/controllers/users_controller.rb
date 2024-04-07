class UsersController < ApplicationController
  before_action :set_user, only: %i[ show liked feed discover ]

  private

    def set_user
      if params[:user_id]
        @user = User.find(params.fetch(:user_id))
      else
        @user = current_user
      end
    end
end