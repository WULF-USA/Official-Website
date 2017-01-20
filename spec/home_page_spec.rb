require_relative './spec_helper'

describe WulfApp do
    it "render empty home page" do
        visit "/"
        puts page.html
    end
end