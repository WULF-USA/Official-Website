require_relative './spec_helper'

describe WulfApp, :unit do
    it "CVA-001: CSRF in SSO authentication" do
        visit "/en/sso/author/login"
        page.driver.clear_cookies
        fill_in 'Username', with: 'testuser'
        fill_in 'Password', with: 'testpassword'
        click_on 'Sign in'
        expect(page).to have_current_path "/en/sso/author/login"
        #expect(page).to have_content("You have been subjected to XSRF attack. Contact the site administrators immediately.")
    end
end