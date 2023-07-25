# app/controllers/dispensers_controller.rb
class DispensersController < ApplicationController
    before_action :authenticate_user
    before_action :set_dispenser, only: [:show, :update]
  
    def index
        byebug
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
  
    private
  
    def set_dispenser
      @dispenser = Dispenser.find(params[:id])
    end
  
    def dispenser_params
      params.require(:dispenser).permit(:flow_volume)
    end
  end
  