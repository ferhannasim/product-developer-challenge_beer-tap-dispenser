# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'methods' do
    let(:admin_user) { User.new(role: 'admin') }
    let(:attendee_user) { User.new(role: 'attendee') }

    describe 'validate user' do
        let(:user) { User.new(role: nil) }
        it 'role not exist' do
            expect(user.valid?).to be false
        end
    end

    describe '#admin?' do
      it 'returns true for admin role' do
        expect(admin_user.admin?).to be true
        expect(attendee_user.admin?).to be false
      end
    end

    describe '#attendee?' do
      it 'returns true for attendee role' do
        expect(admin_user.attendee?).to be false
        expect(attendee_user.attendee?).to be true
      end
    end
  end
end
