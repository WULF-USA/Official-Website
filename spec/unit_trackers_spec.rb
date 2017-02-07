require_relative './spec_helper'
require_relative '../models/trackers'

describe Tracker, :unit do
    describe "#validation" do
        it "should not allow empty model" do
            tracker = Tracker.new()
            expect(tracker.valid?).to be false
        end
        it "should allow correct model" do
            tracker = Tracker.new(
                url: 'http://example.org',
                visits: 1)
            expect(tracker.valid?).to be true
        end
        it "should not allow non-numericality" do
            tracker = Tracker.new(
                url: 'http://example.org',
                visits: 'test')
            expect(tracker.valid?).to be false
        end
        it "should allow top-level http URL" do
            tracker = Tracker.new(
                url: 'http://example.org',
                visits: 1)
            expect(tracker.valid?).to be true
        end
        it "should allow top-level https URL" do
            tracker = Tracker.new(
                url: 'https://example.org',
                visits: 1)
            expect(tracker.valid?).to be true
        end
        it "should allow site-local URL" do
            tracker = Tracker.new(
                url: '/test',
                visits: 1)
            expect(tracker.valid?).to be true
        end
        it "should allow routed http URL" do
            tracker = Tracker.new(
                url: 'https://example.org/test',
                visits: 1)
            expect(tracker.valid?).to be true
        end
        it "should allow static routed http URL" do
            tracker = Tracker.new(
                url: 'https://example.org/test.html',
                visits: 1)
            expect(tracker.valid?).to be true
        end
    end
end