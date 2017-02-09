require_relative './spec_helper'

describe WulfApp, :integration do
    it "shows empty news feeds" do
        visit "/en/"
    end
    
    it "creates new news post" do
        sso_super_login
        # Perform test
        click_on 'News'
        expect(page).to have_current_path "/en/author/news"
        click_on 'New News Feed Item'
        expect(page).to have_current_path "/en/author/news/create"
        fill_in 'Title', with: 'Testing Title'
        fill_in 'Content', with: 'Testing post content.'
        click_on 'Submit'
        # Wait for cache to reload
        sleep 5
        visit "/en/"
        expect(page).to have_content 'Testing Title'
        click_on 'Testing Title'
        expect(page).to have_content 'Testing Title'
        expect(page).to have_content 'Testing post content.'
        sso_super_logout
    end
    
    it "edits a news post" do
        sso_super_login
        # Perform test
        click_on 'News'
        expect(page).to have_current_path "/en/author/news"
        click_on 'Edit', match: :first
        fill_in 'Title', with: 'Testing Title Edited'
        fill_in 'Content', with: 'Testing post content edited.'
        click_on 'Submit'
        # Wait for cache to reload
        sleep 5
        visit "/en/"
        expect(page).to have_content 'Testing Title Edited'
        click_on 'Testing Title Edited'
        expect(page).to have_content 'Testing Title Edited'
        expect(page).to have_content 'Testing post content edited.'
        sso_super_logout
    end
    
    it "deletes news post" do
        sso_super_login
        # Perform test
        click_on 'News'
        expect(page).to have_current_path "/en/author/news"
        click_on 'Delete', match: :first
        # Wait for cache to reload
        sleep 5
        visit "/en/"
        expect(page).to have_no_content 'Testing Title Edited'
        sso_super_logout
    end
end