class TapEvent < ApplicationRecord
  belongs_to :dispenser
  belongs_to :user

  scope :find_open_tap_dispenser, ->(dispenser_id) { find_by(status: 'open', closed_at: nil, dispenser_id: dispenser_id) }

  scope :find_tap_events_dispenser, ->(dispenser_id) { where(id: dispenser_id) }

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

  def self.get_time_intervals
    total = 0
    where.not(closed_at: nil).map do |event|
      time_interval = event.closed_at - event.opened_at
      total += time_interval
      time_interval
    end
  end
end
