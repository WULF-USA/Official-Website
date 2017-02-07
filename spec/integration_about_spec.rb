require_relative './spec_helper'

describe WulfApp, :integration do
    it "shows about page" do
        visit "/en/about"
    end
end