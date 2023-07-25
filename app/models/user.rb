class User < ApplicationRecord
    has_secure_password
    has_many :tap_events
    enum role: { admin: 'admin', attendee: 'attendee' }
  
    def admin?
      role == 'admin'
    end
  
    def attendee?
      role == 'attendee'
    end
  end