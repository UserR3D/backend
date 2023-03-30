class UsersController < ApplicationController
  before_action :set_user, only: %i[ update destroy ]
  # GET /users/1
  def show
    @user = User.find_by(id: session[:user_id])
    if @user
      render json: @user
    else
      render json: { error: "Invalid user" }, status: :unauthorized
    end
  end

  def login
    user = User.find_by(email: params[:email])
    # If login, save in session the login
    session[:user_id] = user.id
    if user && user.authenticate(params[:password])
      render json: user
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # POST /users
  def create
    if user_params[:email].nil?
      render json: { error: "Email is required" }, status: :unprocessable_entity
      return
    end

    if user_params[:password].nil?
      render json: { error: "Password is required" }, status: :unprocessable_entity
      return
    end

    if User.find_by(email: user_params[:email])
      render json: { error: "Email already exists" }, status: :unprocessable_entity
      return
    end

    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.permit(:email, :password)
  end
end
