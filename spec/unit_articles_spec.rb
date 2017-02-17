require_relative './spec_helper'
require_relative '../models/articles'

describe Article, :unit do
    describe "#validation" do
        it "should not allow empty model" do
            article = Article.new()
            expect(article.valid?).to be false
        end
        it "should allow correct model" do
            article = Article.new(title: 'Testing title', author: 'test_author', content: 'Testing content. <a href="/">Home</a>.')
            expect(article.valid?).to be true
        end
    end
end