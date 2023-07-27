class TapEvent < ApplicationRecord
  belongs_to :dispenser
  belongs_to :user

  scope :find_open_tap_dispenser, ->(dispenser_id) { find_by(status: 'open', closed_at: nil, dispenser_id: dispenser_id) }

  scope :find_tap_events_dispenser, ->(dispenser_id) { where(dispenser_id: dispenser_id) }

  def self.convert_to_time(seconds)
    time = Time.at(seconds).utc
    time.strftime("%H:%M:%S")
  end
  
  def calculate_price(start_time, end_time, flow_volume)
    price_per_liter = 10  
    liters_poured = (end_time - start_time) * flow_volume
    price = liters_poured * price_per_liter
    return price
  end

  def self.dispenser_usage_details(dispenser_id)
    tap_events = find_tap_events_dispenser(dispenser_id)
    total_cost = tap_events.pluck(:price).compact.sum

    total = 0
    total_time_spend = tap_events.where.not(closed_at: nil).map do |event|
      total += event.closed_at - event.opened_at
      total
    end

    {
      total_cost: total_cost,
      dispenser_used: tap_events.count,
      total_time_spend: total_time_spend.sum,
      total_time_spend_formatted: convert_to_time(total_time_spend.sum)
    }
  end
end