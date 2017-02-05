class Resource < ActiveRecord::Base
    validates :title,
        presence: true
    validates :author,
        presence: true
    validates :url,
        url: {no_local: true},
        presence: true
    validates :description,
        presence: true
end