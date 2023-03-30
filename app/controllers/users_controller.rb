class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
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
    
    def @user.as_json(options={})
      super(:except => [:password_digest])
    end


    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
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
