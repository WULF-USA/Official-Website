class Tracker < ActiveRecord::Base
    validates :url,
        presence: true
    validates :visits,
        numericality: { only_integer: true },
        presence: true
end