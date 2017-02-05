require_relative './spec_helper'
require_relative '../models/videos'

describe Video do
    describe "#validation" do
        it "should not allow empty model" do
            video = Video.new()
            expect(video.valid?).to be false
        end
        it "should allow correct model" do
            video = Video.new(
                title: 'Testing title',
                author: 'test_author',
                host: 'youtube',
                uri: 'AZaz09',
                description: 'Testing description.')
            expect(video.valid?).to be true
        end
        it "should allow the host youtube" do
            video = Video.new(
                title: 'Testing title',
                author: 'test_author',
                host: 'youtube',
                uri: 'AZaz09',
                description: 'Testing description.')
            expect(video.valid?).to be true
        end
        it "should allow the host vimeo" do
            video = Video.new(
                title: 'Testing title',
                author: 'test_author',
                host: 'vimeo',
                uri: 'AZaz09',
                description: 'Testing description.')
            expect(video.valid?).to be true
        end
        it "should not allow an invalid host" do
            video = Video.new(
                title: 'Testing title',
                author: 'test_author',
                host: 'invalid',
                uri: 'AZaz09',
                description: 'Testing description.')
            expect(video.valid?).to be false
        end
        it "should not allow a URI with symbols" do
            video = Video.new(
                title: 'Testing title',
                author: 'test_author',
                host: 'youtube',
                uri: '+=_-)(*&^%$#@!{}[],./',
                description: 'Testing description.')
            expect(video.valid?).to be false
        end
        it "should not allow a URL as a URI" do
            video = Video.new(
                title: 'Testing title',
                author: 'test_author',
                host: 'youtube',
                uri: 'https://www.youtube.com/watch?v=5kIe6UZHSXw',
                description: 'Testing description.')
            expect(video.valid?).to be false
        end
    end
end