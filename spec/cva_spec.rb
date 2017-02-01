require_relative './spec_helper'

describe WulfApp do
    it "CVA-001: CSRF in SSO authentication" do
        Capybara.using_session("CSRF sandbox") do
            visit "/sso/author/login"
        end
        fill_in 'Username', with: 'testuser'
        fill_in 'Password', with: 'testpassword'
        click_on 'Sign in'
        expect(page).to have_current_path "/sso/author/login"
    end
end