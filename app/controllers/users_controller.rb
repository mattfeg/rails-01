class UsersController < ApplicationController
  before_action :set_user, only: [ :update, :destroy ]
  def index
    filter_users_params = params[:name]

    if filter_users_params.present?
      @users = User.filter_by_name(filter_users_params)
    else
      @users = User.all
    end
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: {}, status: :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: "User not found." }, status: :not_found unless @user
  end

  def user_params
    params.require(:user).permit(:name, :cpf, :birthdate)
  end
end
