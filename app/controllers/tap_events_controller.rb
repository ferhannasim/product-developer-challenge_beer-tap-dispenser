# app/controllers/tap_events_controller.rb
class TapEventsController < ApplicationController
    before_action :authenticate_user
    before_action :set_dispenser
  
    def create
      @tap_event = @dispenser.tap_events.build(status: 'open', opened_at: Time.now ,user_id: @current_user.id)
      if @tap_event.save
        render json: @tap_event, status: :created
      else
        render json: @tap_event.errors, status: :unprocessable_entity
      end
    end
  
    def update
      @tap_event = @dispenser.tap_events.find_by(status: 'open', closed_at: nil)
      if @tap_event.update(closed_at: Time.now)
        calculated_price = calculate_price(@tap_event.opened_at, @tap_event.closed_at, @dispenser.flow_volume)
        @tap_event.update(price: calculated_price)
        render json: @tap_event
      else
        render json: @tap_event.errors, status: :unprocessable_entity
      end
    end
  
    def usage_details
      @tap_events = @dispenser.tap_events.where(id: @dispenser.id)
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
  
    def set_dispenser
      @dispenser = Dispenser.find(params[:dispenser_id])
    end
  
    def calculate_price(start_time, end_time, flow_volume)
      price_per_liter = 10  
      liters_poured = (end_time - start_time) * flow_volume
      price = liters_poured * price_per_liter
      return price
    end
  end
  