class ProfilesController < ApplicationController
  before_action :set_profile, only: [ :update, :destroy ]

  def index
    @profiles = Profile.all
    render json: @profiles
  end

  def show
    render json: @profile
  end

  def update
    if @profile.update(profile_params)
      render json: @profile
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @profile.destroy
      render json: {}, status: :no_content
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  def set_profile
    @profile = Profile.find_by(id: params[:id])
    render json: { error: "Profile not found." }, status: :not_found unless @profile
  end

  def profile_params
    params.require(:profile).permit(:user, :image, :is_active)
  end
end
