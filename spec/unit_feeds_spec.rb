require_relative './spec_helper'
require_relative '../models/feeds'

describe Feed, :unit do
    describe "#validation" do
        it "should not allow empty model" do
            feed = Feed.new()
            expect(feed.valid?).to be false
        end
        it "should allow correct model" do
            feed = Feed.new(title: 'Testing title', author: 'test_author', content: 'Testing content.')
            expect(feed.valid?).to be true
        end
    end
end