class Video < ActiveRecord::Base
    validates :title,
        presence: true
    validates :author,
        presence: true
    validates :host,
        inclusion: { in: ['youtube', 'vimeo'] },
        presence: true
    validates :uri,
        format: { with: /\A[\w]+\Z/ },
        presence: true
    validates :description,
        presence: true
end