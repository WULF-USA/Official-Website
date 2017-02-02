require_relative './spec_helper'

describe WulfApp do
    it "renders empty home page" do
        visit "/en/"
    end
end