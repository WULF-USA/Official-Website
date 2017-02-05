require_relative './spec_helper'
require_relative '../models/accounts'

describe Account do
    describe "#validation" do
        it "should not allow empty model" do
            account = Account.new()
            expect(account.valid?).to be false
        end
        it "should allow correct model" do
            account = Account.new(username: 'AaZz190_', password: 'validpassword', is_super: true)
            expect(account.valid?).to be true
        end
        it "should not allow short username" do
            account = Account.new(username: 'a', password: 'validpassword', is_super: true)
            expect(account.valid?).to be false
        end
        it "should not allow long username" do
            account = Account.new(username: 'aaaaaaaaaaaaaaaaaaaa', password: 'validpassword', is_super: true)
            expect(account.valid?).to be false
        end
    end
end