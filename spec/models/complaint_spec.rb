require 'rails_helper'

RSpec.describe Complaint, type: :model do

    describe "Statement - " do
        before(:each) do
            complaint.validate
        end

        context "When Value is valid" do
            let(:complaint) {build(:complaint, statement: "Please update about my complaint status")}
            it "doesn't throw any error" do
                expect(complaint.errors).to_not include(:statement)
            end
        end

        context "When Value is NIL" do
            let(:complaint) {build(:complaint, statement: nil)}
            it "throws error" do    
                expect(complaint.errors).to include(:statement)
            end
        end

        context "When value is too short" do
            let(:complaint) {build(:complaint, statement: "abcd")}
            it "throws error 'complaint is invalid'" do
                expect(complaint.errors).to include(:statement)
            end
        end
    end

    describe "Datetime" do
        before(:each) do
            complaint.validate
        end

        context "When value is valid" do
            let(:complaint) {build(:complaint, dateTime: "2023-05-24 14:49:28")}
            it "doesn't throw any error" do
                expect(complaint.errors).to_not include(:dateTime)
            end
        end

        context "When value is NIL" do
            let(:complaint) {build(:complaint, dateTime: nil)}
            it "throws error" do
                expect(complaint.errors).to include(:dateTime)
            end
        end
    end

    describe "location - " do
        before(:each) do
            complaint.validate
        end

        context "When location is valid" do
            let(:complaint) {build(:complaint, location:"Chennai")}
            it "doesn't throw any error" do
                expect(complaint.errors).to_not include(:location)
            end
        end

        context "When location is NIL" do
            let(:complaint) {build(:complaint, location: nil)}
            it "throws error" do
                expect(complaint.errors).to include(:location)
            end
        end

        context "When location is alphanumeric" do
            let(:complaint) {build(:complaint, location:"Chennai1001")}
            it "throws error" do
                expect(complaint.errors).to include(:location)
            end
        end

        context "When location is numeric" do
            let(:complaint) {build(:complaint, location:"12345")}
            it "throws error" do
                expect(complaint.errors).to include(:location)
            end
        end
    end

    describe "complaint association" do
        context "belongs_to user" do
            let(:user) {create(:user)}
            let(:complaint) {create(:complaint, user_id: user.id)}
            it "is true" do
                expect(complaint.user).to be_an_instance_of(User)
            end
        end

        context "has_many" do
            it "messages" do
                association = Complaint.reflect_on_association(:messages).macro
                expect(association).to be(:has_many)
            end
        end

        context "has_one" do
            [:crime_fir , :status , :lead_officer].each do |each|
                it each.to_s.humanize do
                    association = Complaint.reflect_on_association(each).macro
                    expect(association).to be(:has_one)
                end
            end
        end
    end
end