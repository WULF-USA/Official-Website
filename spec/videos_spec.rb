require_relative './spec_helper'

describe WulfApp do
    it "shows empty videos list" do
        visit "/"
    end
    
    it "creates new video link item" do
        sso_super_login
        # Perform test
        within(".nav-sidebar") do
            click_on 'Videos'
        end
        expect(page).to have_current_path "/author/videos"
        fill_in 'create-title', with: 'Testing Title'
        select 'YouTube', from: 'create-host'
        fill_in 'create-uri', with: '5kIe6UZHSXw'
        fill_in 'create-description', with: 'Testing description.'
        click_on 'Create'
        visit "/"
        expect(page).to have_content 'Testing Title'
        visit "/videos"
        expect(page).to have_content 'Testing Title'
        expect(page).to have_content 'Testing description.'
        sso_super_logout
    end
    
    it "edits a video link item" do
        sso_super_login
        # Perform test
        within(".nav-sidebar") do
            click_on 'Videos'
        end
        expect(page).to have_current_path "/author/videos"
        fill_in 'edit-title', with: 'Testing Title Edited'
        fill_in 'edit-description', with: 'Testing description extended.'
        click_on 'Edit', match: :first
        visit "/"
        expect(page).to have_content 'Testing Title Edited'
        visit "/videos"
        expect(page).to have_content 'Testing Title Edited'
        expect(page).to have_content 'Testing description extended.'
        sso_super_logout
    end
    
    it "deletes video link item" do
        sso_super_login
        # Perform test
        within(".nav-sidebar") do
            click_on 'Videos'
        end
        expect(page).to have_current_path "/author/videos"
        click_on 'Delete', match: :first
        visit "/"
        expect(page).to have_no_content 'Testing Title Edited'
        visit "/videos"
        expect(page).to have_no_content 'Testing Title Edited'
        expect(page).to have_no_content 'Testing description extended.'
        sso_super_logout
    end
end