class SessionsController < ApplicationController
  before_action :require_logged_in, only: [:destroy]
  before_action :require_logged_out, only: [:new, :create]


  def new; end

  def create
    @user = User.find_by_credentials(params[:user][:email], params[:user][:password])

    if @user
      login(@user)
      redirect_to user_url(@user)
      # flash.alert = "Successfully Logged In"
    else
      redirect_to new_session_url
      flash.now[:errors] = ["Login Failed"]
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end
end