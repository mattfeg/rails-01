class ProfilesController < ApplicationController
  before_action :set_profile, only: [ :update, :destroy, :show ]

  def index
    @profiles = Profile.includes([ :user ]).all
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

  private

  def set_profile
    render json: { error: "Profile not found." }, status: :not_found unless
    @profile = Profile.find_by(id: params[:id])
  end

  def profile_params
    params.require(:profile).permit(:image, :is_active)
  end
end
