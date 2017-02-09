class Article < ActiveRecord::Base
    validates :title,
        presence: true
    validates :author,
        presence: true
    validates :content,
        presence: true
    def generate_metadata
        data = Hash.new
        data['id'] = self.id
        data['title'] = self.title
        data['author'] = self.author
        data['updated_at'] = self.updated_at
        return data
    end
end