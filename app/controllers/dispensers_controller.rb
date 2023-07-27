# app/controllers/dispensers_controller.rb
class DispensersController < ApplicationController
    # before_action :authenticate_user, except: [:usage_details]
    before_action :set_dispenser, only: [:show, :update]
    before_action :check_admin, only: [:create]
  
    def index
      @dispensers = Dispenser.all
      render json: @dispensers
    end
  
    def show
      render json: @dispenser
    end
  
    def create
      @dispenser = Dispenser.new(dispenser_params)
      if @dispenser.save
        render json: @dispenser, status: :created
      else
        render json: @dispenser.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @dispenser.update(dispenser_params)
        render json: @dispenser
      else
        render json: @dispenser.errors, status: :unprocessable_entity
      end
    end

    def usage_details
      result = Dispenser.calculate_total_price

      render json: {
        total_cost: result[:total_cost],
        total_time_spend: result[:total_time_spend],
        total_time_spend_formatted: result[:total_time_spend_formatted]
      }
    end
  
    private

    def check_admin
      if !@current_user.admin?
        render json: {message: "You are not authorized. Only for Admin"}
      end 
    end
  
    def set_dispenser
      @dispenser = Dispenser.find(params[:id])
    end
  
    def dispenser_params
      params.require(:dispenser).permit(:flow_volume)
    end

  end
  