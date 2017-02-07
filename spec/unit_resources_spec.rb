require_relative './spec_helper'
require_relative '../models/resources'

describe Resource, :unit do
    describe "#validation" do
        it "should not allow empty model" do
            resource = Resource.new()
            expect(resource.valid?).to be false
        end
        it "should allow correct model" do
            resource = Resource.new(
                title: 'Testing title',
                author: 'test_author',
                url: 'http://example.org',
                description: 'Testing description.')
            expect(resource.valid?).to be true
        end
        it "should allow top-level http URL" do
            resource = Resource.new(
                title: 'Testing title',
                author: 'test_author',
                url: 'http://example.org',
                description: 'Testing description.')
            expect(resource.valid?).to be true
        end
        it "should allow top-level https URL" do
            resource = Resource.new(
                title: 'Testing title',
                author: 'test_author',
                url: 'https://example.org',
                description: 'Testing description.')
            expect(resource.valid?).to be true
        end
        it "should not allow site-local URL" do
            resource = Resource.new(
                title: 'Testing title',
                author: 'test_author',
                url: '/test',
                description: 'Testing description.')
            expect(resource.valid?).to be false
        end
        it "should not allow machine-local URL" do
            resource = Resource.new(
                title: 'Testing title',
                author: 'test_author',
                url: 'C://test',
                description: 'Testing description.')
            expect(resource.valid?).to be false
        end
        it "should allow routed http URL" do
            resource = Resource.new(
                title: 'Testing title',
                author: 'test_author',
                url: 'https://example.org/test',
                description: 'Testing description.')
            expect(resource.valid?).to be true
        end
        it "should allow static routed http URL" do
            resource = Resource.new(
                title: 'Testing title',
                author: 'test_author',
                url: 'https://example.org/test.html',
                description: 'Testing description.')
            expect(resource.valid?).to be true
        end
    end
end