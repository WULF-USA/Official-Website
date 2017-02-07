require_relative './spec_helper'

describe WulfApp, :performance do
    it "renders empty home page in under 100 ms" do
        expect { visit "/en/" }.to perform_under(100).ms.and_sample(30)
    end
    
    it "renders empty home page 10 times per second" do
        expect { visit "/en/" }.to perform_at_least(10).ips
    end
    
    it "logs in and out as the super user in under 200 ms" do
        expect {
            sso_super_login
            sso_super_logout
        }.to perform_under(200).ms.and_sample(30)
    end
    
    it "posts 100 news stories in under 100 ms each iteration" do
        sso_super_login
        expect {
            visit "/en/author/news/create"
            fill_in 'Title', with: 'Testing Title'
            fill_in 'Content', with: 'Testing post content.'
            click_on 'Submit'
        }.to perform_under(100).ms.and_sample(100)
        sso_super_logout
    end
    
    it "loads the news author dashboard in under 100 ms each iteration" do
        sso_super_login
        expect { visit "/en/author/news" }.to perform_under(100).ms.and_sample(30)
        sso_super_logout
    end
    
    it "posts 100 video links in under 100 ms each iteration" do
        sso_super_login
        expect {
            visit "/en/author/videos"
            fill_in 'create-title', with: 'Testing Title'
            select 'YouTube', from: 'create-host'
            fill_in 'create-uri', with: '5kIe6UZHSXw'
            fill_in 'create-description', with: 'Testing description.'
            click_on 'Create'
        }.to perform_under(100).ms.and_sample(100)
        sso_super_logout
    end
    
    it "loads the video link author dashboard in under 100 ms each iteration" do
        sso_super_login
        expect { visit "/en/author/videos" }.to perform_under(100).ms.and_sample(30)
        sso_super_logout
    end
    
    it "posts 100 articles in under 100 ms each iteration" do
        sso_super_login
        expect {
            visit "/en/author/articles/create"
            fill_in 'Title', with: 'Testing Title'
            fill_in 'Content', with: 'Testing post content.'
            click_on 'Submit'
        }.to perform_under(100).ms.and_sample(100)
        sso_super_logout
    end
    
    it "loads the articles author dashboard in under 100 ms each iteration" do
        sso_super_login
        expect { visit "/en/author/articles" }.to perform_under(100).ms.and_sample(30)
        sso_super_logout
    end
    
    it "loads the loaded home page in under 100 ms each iteration" do
        expect { visit "/en/" }.to perform_under(100).ms.and_sample(30)
    end
    
    it "renders loaded home page 10 times per second" do
        expect { visit "/en/" }.to perform_at_least(10).ips
    end
    
    it "loads the loaded blog in under 100 ms each iteration" do
        expect { visit "/en/blog" }.to perform_under(100).ms.and_sample(30)
    end
    
    it "renders loaded blog 10 times per second" do
        expect { visit "/en/blog" }.to perform_at_least(10).ips
    end
    
    it "deletes 100 news stories in under 100 ms each iteration" do
        sso_super_login
        expect {
            visit "/en/author/news"
            click_on 'Delete', match: :first
        }.to perform_under(100).ms.and_sample(100)
        sso_super_logout
    end
    
    it "deletes 100 blog posts in under 100 ms each iteration" do
        sso_super_login
        expect {
            visit "/en/author/articles"
            click_on 'Delete', match: :first
        }.to perform_under(100).ms.and_sample(100)
        sso_super_logout
    end
end