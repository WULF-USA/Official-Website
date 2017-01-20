require_relative './spec_helper'

describe WulfApp do
    it "shows empty feeds" do
        visit "/"
        visit "/blog"
    end
    
    it "creates new blog post" do
        # Log in
        visit "/sso/author/login"
        fill_in 'Username', with: 'testuser'
        fill_in 'Password', with: 'testpassword'
        click_on 'Sign in'
        expect(page).to have_current_path "/author/home"
        # Perform test
        click_on 'Articles'
        expect(page).to have_current_path "/author/articles"
        click_on 'New Blog Post'
        expect(page).to have_current_path "/author/articles/create"
        fill_in 'Title', with: 'Testing Title'
        fill_in 'Post', with: 'Testing post content. <b>tag test.</b>'
        click_on 'Post'
        visit "/"
        expect(page).to have_content 'Testing Title'
        visit "/blog"
        expect(page).to have_content 'Testing Title'
        click_on 'Testing Title'
        expect(page).to have_content 'Testing Title'
        expect(page).to have_content 'Testing post content.'
        expect(page).to have_css 'b', text: 'tag test.'
        # Log out
        click_on "Log Out"
        expect(page).to have_no_content 'Log Out'
        visit "/author/home"
        expect(page).to have_current_path "/sso/author/login"
    end
    
    it "edits a blog post" do
        # Log in
        visit "/sso/author/login"
        fill_in 'Username', with: 'testuser'
        fill_in 'Password', with: 'testpassword'
        click_on 'Sign in'
        expect(page).to have_current_path "/author/home"
        # Perform test
        click_on 'Articles'
        expect(page).to have_current_path "/author/articles"
        click_on 'Edit', match: :first
        fill_in 'Title', with: 'Testing Title Edited'
        fill_in 'Post', with: 'Testing post content edited. <i>tag test.</i>'
        click_on 'Post'
        visit "/"
        expect(page).to have_content 'Testing Title Edited'
        visit "/blog"
        expect(page).to have_content 'Testing Title Edited'
        click_on 'Testing Title'
        expect(page).to have_content 'Testing Title Edited'
        expect(page).to have_content 'Testing post content edited.'
        expect(page).to have_css 'i', text: 'tag test.'
        # Log out
        click_on "Log Out"
        expect(page).to have_no_content 'Log Out'
        visit "/author/home"
        expect(page).to have_current_path "/sso/author/login"
    end
    
    it "deletes blog post" do
        # Log in
        visit "/sso/author/login"
        fill_in 'Username', with: 'testuser'
        fill_in 'Password', with: 'testpassword'
        click_on 'Sign in'
        expect(page).to have_current_path "/author/home"
        # Perform test
        click_on 'Articles'
        expect(page).to have_current_path "/author/articles"
        click_on 'Delete', match: :first
        visit "/"
        expect(page).to have_no_content 'Testing Title Edited'
        visit "/blog"
        expect(page).to have_no_content 'Testing Title Edited'
        # Log out
        click_on "Log Out"
        expect(page).to have_no_content 'Log Out'
        visit "/author/home"
        expect(page).to have_current_path "/sso/author/login"
    end
end