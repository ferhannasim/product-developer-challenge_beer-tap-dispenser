class TapEvent < ApplicationRecord
  belongs_to :dispenser
  belongs_to :user
end
