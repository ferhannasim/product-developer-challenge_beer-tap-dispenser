# app/controllers/tap_events_controller.rb
class TapEventsController < ApplicationController
    before_action :authenticate_user
    before_action :set_dispenser
  
    def create
        byebug
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
        @tap_event.update(price: calculate_price(@tap_event.opened_at, @tap_event.closed_at, @dispenser.flow_volume))
        render json: @tap_event
      else
        render json: @tap_event.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_dispenser
      @dispenser = Dispenser.find(params[:dispenser_id])
    end
  
    def calculate_price(start_time, end_time, flow_volume)
    price_per_liter = 10  
      lit ers_poured = (end_time - start_time) * flow_volume
      price = liters_poured * price_per_liter
      return price
    end
  end
  