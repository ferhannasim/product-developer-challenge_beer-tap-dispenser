class Api::V1::AuthenticationController < ApplicationController
    def login
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
          token = generate_token(user.id)
          render json: { token: token }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end

      private

      def generate_token(user_id)
        # You can customize this method based on your needs
        JWT.encode({ user_id: user_id }, Rails.application.secret_key_base)
      end
end
