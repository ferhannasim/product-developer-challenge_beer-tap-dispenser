class Api::V1::UsersController < ApplicationController
    before_action :authenticate_user, except: :create
    def create
        user = User.new(user_params)
        if user.save
          render json: { message: 'User created successfully' }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :role)
    end
end
