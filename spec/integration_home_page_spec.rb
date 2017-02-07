require_relative './spec_helper'

describe WulfApp, :integration do
    it "renders empty home page" do
        visit "/en/"
    end
end