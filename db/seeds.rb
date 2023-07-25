# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# db/seeds.rb

# Create Dispensers
dispensers = Dispenser.create([
    { flow_volume: 0.05 }, # Example flow_volume in liters per second
    { flow_volume: 0.03 },
    # Add more dispenser records as needed
  ])
  
  # Create Users
  users = User.create([
    { email: 'admin@example.com', password: 'admin_password', role: 'admin' },
    { email: 'attendee1@example.com', password: 'attendee_password', role: 'attendee' },
    { email: 'attendee2@example.com', password: 'attendee_password', role: 'attendee' },
    # Add more user records as needed
  ])
  
  # Create Tap Events
  # Let's assume the first dispenser is used by attendee1 and the second dispenser is used by attendee2
  tap_events = TapEvent.create([
    { dispenser: dispensers.first, status: 'open', opened_at: Time.now - 10.minutes, closed_at: Time.now, price: 2.5, user_id: 1 }, # Example price in USD
    { dispenser: dispensers.second, status: 'open', opened_at: Time.now - 15.minutes, user_id: 2 },
    # Add more tap event records as needed
  ])
  