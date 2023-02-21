class UsersController < ApplicationController
  # before_action :require_logged_in, only: [:index, :edit, :update, :show, :destroy]
  # before_action :require_logged_out, only: [:new, :create]

  def index
    
    @users = Users.allow_nil
    render :index
  end

  def new

  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def create
    
    @user = User.new(user_params)
    # password=(user_params[:password])

    if @user.save!
      login(@user)
      flash[:messages] = ["Successfully Created"]
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    
    @user = User.find(params[:id])
    render :edit
  end

  def update
    
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      puts @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    
    user = User.find(params[:id])
    user.destroy
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end