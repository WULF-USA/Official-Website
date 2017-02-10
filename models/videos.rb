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
    def generate_metadata
        data = Hash.new
        data['id'] = self.id
        data['title'] = self.title
        data['author'] = self.author
        data['updated_at'] = self.updated_at
        data['host'] = self.host
        data['uri'] = self.uri
        return data
    end
end