require_relative './spec_helper'

describe WulfApp, :integration do
    it "displays traffic data" do
        sso_super_login
        # Perform test
        within(".nav-sidebar") do
            click_on 'Traffic'
        end
        expect(page).to have_current_path "/en/author/traffic"
        sso_super_logout
    end
end