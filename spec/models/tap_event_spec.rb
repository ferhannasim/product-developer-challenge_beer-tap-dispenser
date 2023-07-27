# spec/models/tap_event_spec.rb

require 'rails_helper'

RSpec.describe TapEvent, type: :model do
    let(:dispenser) { Dispenser.create(flow_volume: 50) }
    let(:user) { create_user(role: 'admin') }
    let(:tap_event) { TapEvent.create(status: 'open', opened_at: Time.now ,user_id: user.id, dispenser_id: dispenser.id) }


    def create_user(role: 'attendee')
        User.create(email: 'user@example.com', password: 'password', role: role)
    end

  describe "scopes" do
    describe ".find_open_tap_dispenser" do
      it "returns open tap event for a given dispenser" do
        open_tap_event = TapEvent.create(dispenser: dispenser, user: user, status: "open", closed_at: nil)
        closed_tap_event = TapEvent.create(dispenser: dispenser, user: user, status: "closed", closed_at: Time.now)

        result = TapEvent.find_open_tap_dispenser(dispenser.id)

        expect(result).to eq(open_tap_event)
      end
    end

    describe ".find_tap_events_dispenser" do
      it "returns tap events for a given dispenser" do
        dispenser_2 = Dispenser.create(flow_volume: 90)
        tap_event_1 = TapEvent.create(dispenser: dispenser, user: user)
        tap_event_2 = TapEvent.create(dispenser: dispenser_2, user: user)

        result = TapEvent.find_tap_events_dispenser(dispenser.id)

        expect(result).to include(tap_event_1)
        expect(result).not_to include(tap_event_2)
      end
    end
  end

  describe ".convert_to_time" do
    it "converts seconds to formatted time" do
      seconds = 3600
      formatted_time = TapEvent.convert_to_time(seconds)

      expect(formatted_time).to eq("01:00:00")
    end
  end

  describe "#calculate_price" do
    it "calculates the price based on start time, end time, and flow volume" do
      start_time = Time.now
      end_time = Time.now + 3600
      flow_volume = 0.5
      expected_price = 10 * (end_time - start_time) * flow_volume

      price = tap_event.calculate_price(start_time, end_time, flow_volume)

      expect(price).to eq(expected_price)
    end
  end
end
