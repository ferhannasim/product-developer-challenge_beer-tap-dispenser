class Dispenser < ApplicationRecord
    has_many :tap_events

    def self.calculate_total_price
        total_cost = TapEvent.where.not(price: nil).sum(:price)
        closed_events = TapEvent.where.not(closed_at: nil).pluck(:opened_at, :closed_at)

        total_time_spend = 0
        closed_events.each do |opened_at, closed_at|
          time_interval = closed_at - opened_at
          total_time_spend += time_interval
        end
      
        {
          total_cost: total_cost,
          total_time_spend: total_time_spend,
          total_time_spend_formatted: convert_to_time(total_time_spend)
        }
      end
      
    def self.convert_to_time(seconds)
        Time.at(seconds).utc.strftime("%H:%M:%S")
    end
end
