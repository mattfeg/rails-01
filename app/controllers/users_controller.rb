class UsersController < ApplicationController
  def index
    @users = User.all
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
    @user = User.find(params[:id])
    if @user
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: @user.errors, status: :not_found
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user
      if @user.destroy
        render json: @user, status: :no_content
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: @user.errors, status: :not_found
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :cpf, :birthdate)
  end
end
