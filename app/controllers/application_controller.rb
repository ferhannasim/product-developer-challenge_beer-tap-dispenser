class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }
    
    def authenticate_user
        token = request.headers['Authorization']&.split(' ')&.last
        decoded_token = JwtAuth.decode(token)
    
        if decoded_token && decoded_token[0]['user_id']
          @current_user = User.find(decoded_token[0]['user_id'])
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end
end
