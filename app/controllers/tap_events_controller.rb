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
      @tap_event = TapEvent.find_open_tap_dispenser(@dispenser.id)
      if @tap_event.update(closed_at: Time.now, status: 'closed')
        calculated_price = @tap_event.calculate_price(@tap_event.opened_at, @tap_event.closed_at, @dispenser.flow_volume)
        @tap_event.update(price: calculated_price)
        render json: @tap_event
      else
        render json: @tap_event.errors, status: :unprocessable_entity
      end
    end
  
    def usage_details
      result = TapEvent.dispenser_usage_details(@dispenser.id)

      render json: {
        total_cost: result[:total_cost],
        dispenser_used: result[:dispenser_used],
        total_time_spend: result[:total_time_spend],
        total_time_spend_formatted: result[:total_time_spend_formatted]
      }
    end
  
    private

    def set_dispenser
      @dispenser = Dispenser.find(params[:dispenser_id])
    end 
  end
  