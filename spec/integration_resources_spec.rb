require_relative './spec_helper'

describe WulfApp, :integration do
    it "shows empty resources list" do
        visit "/en/resources"
    end
    
    it "creates new resource item" do
        sso_super_login
        # Perform test
        within(".nav-sidebar") do
            click_on 'Resources'
        end
        expect(page).to have_current_path "/en/author/resources"
        fill_in 'create-title', with: 'Testing Title'
        fill_in 'create-hyperlink', with: 'http://example.com'
        fill_in 'create-description', with: 'Testing description.'
        click_on 'Create'
        expect(page).to have_content 'Completed at'
        visit "/en/resources"
        expect(page).to have_content 'Testing Title'
        expect(page).to have_css 'a', text: 'Visit resource >>'
        expect(page).to have_content 'Testing description.'
        sso_super_logout
    end
    
    it "edits a resource item" do
        sso_super_login
        # Perform test
        within(".nav-sidebar") do
            click_on 'Resources'
        end
        expect(page).to have_current_path "/en/author/resources"
        fill_in 'edit-title', with: 'Testing Title Edited'
        fill_in 'edit-hyperlink', with: 'http://example.org'
        fill_in 'edit-description', with: 'Testing description extended.'
        click_on 'Edit', match: :first
        expect(page).to have_content 'Completed at'
        visit "/en/resources"
        expect(page).to have_content 'Testing Title Edited'
        expect(page).to have_css 'a', text: 'Visit resource >>'
        expect(page).to have_content 'Testing description extended.'
        sso_super_logout
    end
    
    it "deletes resource item" do
        sso_super_login
        # Perform test
        within(".nav-sidebar") do
            click_on 'Resources'
        end
        expect(page).to have_current_path "/en/author/resources"
        click_on 'Delete', match: :first
        expect(page).to have_content 'Completed at'
        visit "/en/resources"
        expect(page).to have_no_content 'Testing Title Edited'
        sso_super_logout
    end
end