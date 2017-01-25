require_relative './spec_helper'

describe WulfApp do
    it "shows about page" do
        visit "/about"
    end
end