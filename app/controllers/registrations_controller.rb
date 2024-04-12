class RegistrationsController < Devise::RegistrationsController
  def update
    redirect_to user_path(resource)
  end
end