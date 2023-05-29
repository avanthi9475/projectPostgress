require 'rails_helper'

RSpec.describe User, type: :model do

    describe "Name" do
        before(:each) do
            user.validate
        end

        context "When Value is present" do
            let(:user) {build(:user, name: "Ramya")}
            it "doesn't throw any error" do
                expect(user.errors).to_not include(:name)
            end
        end

        context "When Value is NIL" do
            let(:user) {build(:user, name: nil)}
            it "throws error" do    
                expect(user.errors).to include(:name)
            end
        end

        context "When value is alphanumeric" do
            let(:user) {build(:user, name: "Ramya123")}
            it "throws error 'Name is invalid'" do
                expect(user.errors).to include(:name)
            end
        end

        context "When value is numric" do
            let(:user) {build(:user, name: "1234")}
            it "throws error 'Name is invalid'" do
                expect(user.errors).to include(:name)
            end
        end

        context "When Value is valid" do
            let(:user) {build(:user, name: "Kaviya")}
            it "doesn't throw any error" do
                expect(user.errors).to_not include(:name)
            end
        end
    end

    describe "Email" do
        before(:each) do
            user.validate
        end

        context "When email is present" do
            let(:user) {build(:user, email: "user@gmail.com")}
            it "doesn't throw any error" do
                expect(user.errors).to_not include(:email)
            end
        end

        context "When email is invalid" do
            let(:user) {build(:user, email: "usergmail.com")}
            it "throws error" do
                expect(user.errors).to include(:email)
            end
        end

        context "When email is NIL" do
            let(:user) {build(:user, email: nil)}
            it "throws error" do
                expect(user.errors).to include(:email)
            end
        end
    end

    describe "Age" do
        before(:each) do
            user.validate
        end

        context "When Age is valid" do
            let(:user) {build(:user, age: 21)}
            it "doesn't throw any error" do
                expect(user.errors).to_not include(:age)
            end
        end

        context "When Age is nil" do
            let(:user) {build(:user, age: nil)}
            it "throws error" do
                expect(user.errors).to include(:age)
            end
        end

        context "When Age is alphabetic" do
            let(:user) {build(:user, age: "abc")}
            it "throws error" do
                expect(user.errors).to include(:age)
            end
        end

        context "When Age is less than 18" do
            let(:user) {build(:user, age: 10)}
            it "throws error" do
                expect(user.errors).to include(:age)
            end
        end

        context "When Age is Alphanumric" do
            let(:user) {build(:user, age: "10ab")}
            it "throws error" do
                expect(user.errors).to include(:age)
            end
        end
    end

    describe "location" do
        before(:each) do
            user.validate
        end

        context "When location is valid" do
            let(:user) {build(:user, location:"Chennai")}
            it "doesn't throw any error" do
                expect(user.errors).to_not include(:location)
            end
        end

        context "When location is NIL" do
            let(:user) {build(:user, location: nil)}
            it "throws error" do
                expect(user.errors).to include(:location)
            end
        end

        context "When location is alphanumeric" do
            let(:user) {build(:user, location:"Chennai1001")}
            it "throws error" do
                expect(user.errors).to include(:location)
            end
        end

        context "When location is numeric" do
            let(:user) {build(:user, location:"12345")}
            it "throws error" do
                expect(user.errors).to include(:location)
            end
        end
    end

    describe "Number Of Complaints Made" do
        before(:each) do
            user.validate
        end

        context "When Value is valid" do
            let(:user) {build(:user, noOfComplaintsMade: 2)}
            it "doesn't throw any error" do
                expect(user.errors).to_not include(:noOfComplaintsMade)
            end
        end

        context "When Value is negative" do
            let(:user) {build(:user, noOfComplaintsMade: -2)}
            it "throws error" do
                expect(user.errors).to include(:noOfComplaintsMade)
            end
        end
        
        context "When Value contains alphanumeric" do
            let(:user) {build(:user, noOfComplaintsMade: "2ab")}
            it "throws error" do
                expect(user.errors).to include(:noOfComplaintsMade)
            end
        end

    end

    describe "User association" do
        context "has_many" do
            [:complaints, :response_messages, :crime_firs, :messages].each do |each|
            it each.to_s.humanize do
                association = User.reflect_on_association(each).macro
                expect(association).to be(:has_many)
            end
            end
        end
    end
end