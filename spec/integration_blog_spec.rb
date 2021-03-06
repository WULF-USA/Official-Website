require_relative './spec_helper'

describe WulfApp, :integration do
    it "shows empty feeds" do
        visit "/en/"
        visit "/en/blog"
    end
    
    it "creates new blog post" do
        sso_super_login
        # Perform test
        click_on 'Articles'
        expect(page).to have_current_path "/en/author/articles"
        click_on 'New Blog Post'
        expect(page).to have_current_path "/en/author/articles/create"
        fill_in 'Title', with: 'Testing Title'
        fill_in 'Content', with: 'Testing post content. <b>tag test.</b>'
        click_on 'Submit'
        expect(page).to have_content 'successfully saved to the database. Click to refresh.'
        visit "/en/"
        expect(page).to have_content 'Testing Title'
        visit "/en/blog"
        expect(page).to have_content 'Testing Title'
        click_on 'Testing Title'
        expect(page).to have_content 'Testing Title'
        expect(page).to have_content 'Testing post content.'
        expect(page).to have_css 'b', text: 'tag test.'
        sso_super_logout
    end
    
    it "edits a blog post" do
        sso_super_login
        # Perform test
        click_on 'Articles'
        expect(page).to have_current_path "/en/author/articles"
        click_on 'Edit', match: :first
        fill_in 'Title', with: 'Testing Title Edited'
        fill_in 'Content', with: 'Testing post content edited. <i>tag test.</i>'
        click_on 'Submit'
        expect(page).to have_content 'successfully saved to the database. Click to refresh.'
        visit "/en/"
        expect(page).to have_content 'Testing Title Edited'
        visit "/en/blog"
        expect(page).to have_content 'Testing Title Edited'
        click_on 'Testing Title Edited'
        expect(page).to have_content 'Testing Title Edited'
        expect(page).to have_content 'Testing post content edited.'
        expect(page).to have_css 'i', text: 'tag test.'
        sso_super_logout
    end
    
    it "deletes blog post" do
        sso_super_login
        # Perform test
        click_on 'Articles'
        expect(page).to have_current_path "/en/author/articles"
        click_on 'Delete', match: :first
        expect(page).to have_content 'successfully deleted from the database. Click to refresh.'
        visit "/en/"
        expect(page).to have_no_content 'Testing Title Edited'
        visit "/en/blog"
        expect(page).to have_no_content 'Testing Title Edited'
        sso_super_logout
    end
end