require 'validate_url'

class Feed < ActiveRecord::Base
    validates :title,
        presence: true
    validates :author,
        presence: true
    validates :content,
        presence: true
    
    ##
    # Generates cache hash of object.
    def generate_metadata
        data = Hash.new
        data['id'] = self.id
        data['title'] = self.title
        data['author'] = self.author
        data['updated_at'] = self.updated_at
        data['content'] = self.content
        return data
    end
end