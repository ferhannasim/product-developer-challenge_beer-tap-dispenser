# app/controllers/dispensers_controller.rb
class DispensersController < ApplicationController
    before_action :authenticate_user, except: [:usage_details]
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
      @tap_events = TapEvent.all
      total_cost = @tap_events.pluck(:price).compact.sum

      total = 0
      time_intervals = @tap_events.where.not(closed_at: nil).map do |event|
        time_interval = event.closed_at - event.opened_at
        total += time_interval
        time_interval
      end

      render json: {
        total_cost: total_cost,
        Dispenser_used: @tap_events.count,
        "Total_time_spend(Hours, Min)": convert_to_time(time_intervals.sum),
        "Total_time_spend(Seconds)": time_intervals.sum,
      }
    end
  
    private

    def convert_to_time(seconds)
      time = Time.at(seconds).utc
      time.strftime("%H:%M:%S")
    end

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
  