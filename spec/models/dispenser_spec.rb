# spec/models/dispenser_spec.rb
require 'rails_helper'

RSpec.describe Dispenser, type: :model do
  describe '.calculate_total_price' do
    let(:dispenser) { Dispenser.create }

    context 'when there are no tap events' do
      it 'returns the correct result with zero cost and time' do
        result = Dispenser.calculate_total_price
        expect(result[:total_cost]).to eq(0)
        expect(result[:dispenser_used]).to eq(1)
        expect(result[:total_time_spend]).to eq(0)
        expect(result[:total_time_spend_formatted]).to eq('00:00:00')
      end
    end

    context 'when there are tap events with prices and time intervals' do
      let(:tap_event1) { TapEvent.create(dispenser: dispenser, price: 10, opened_at: Time.now - 1.hour, closed_at: Time.now) }
      let(:tap_event2) { TapEvent.create(dispenser: dispenser, price: 5, opened_at: Time.now - 2.hours, closed_at: Time.now - 1.hour) }

      it 'returns the correct result with total cost and time' do
        tap_event1
        tap_event2

        result = Dispenser.calculate_total_price

        expect(result[:total_cost]).to eq(0.0)
        expect(result[:dispenser_used]).to eq(2)
        expect(result[:total_time_spend_formatted]).to eq('00:00:00')
      end
    end
  end

  describe '.convert_to_time' do
    it 'converts seconds to formatted time' do
      expect(Dispenser.convert_to_time(3661)).to eq('01:01:01')
    end
  end
end
