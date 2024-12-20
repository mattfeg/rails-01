class UsersController < ApplicationController
  def index
    @users = User.all
    searched_user = params[:name]

    if searched_user.present?
      filtered_users = @users.select { |user| user.name.downcase.include?(searched_user.downcase) }

      if filtered_users.any?
        render json: filtered_users
      else
        render json: { message: 'Not found user' }, status: :not_found
      end
    else
      render json: @users
    end
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
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :cpf, :birthdate)
  end
end
