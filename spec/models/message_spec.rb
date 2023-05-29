require 'rails_helper'

RSpec.describe Message, type: :model do

    describe "Statement" do
        before(:each) do
            message.validate
        end

        context "When Value is valid" do
            let(:message) {build(:message, statement: "Please update about my complaint status")}
            it "doesn't throw any error" do
                expect(message.errors).to_not include(:statement)
            end
        end

        context "When Value is NIL" do
            let(:message) {build(:message, statement: nil)}
            it "throws error" do    
                expect(message.errors).to include(:statement)
            end
        end

        context "When value is too short" do
            let(:message) {build(:message, statement: "abcd")}
            it "throws error 'Message is invalid'" do
                expect(message.errors).to include(:statement)
            end
        end
    end

    describe "Datetime" do
        before(:each) do
            message.validate
        end

        context "When value is valid" do
            let(:message) {build(:message, dateTime: "2023-05-24 14:49:28")}
            it "doesn't throw any error" do
                expect(message.errors).to_not include(:dateTime)
            end
        end

        context "When value is NIL" do
            let(:message) {build(:message, dateTime: nil)}
            it "throws error" do
                expect(message.errors).to include(:dateTime)
            end
        end
    end

    describe "Message association" do
        context "belongs_to" do
            let(:user) {create(:user)}
            let(:complaint) {create(:complaint, user_id: user.id)}
            let(:message) {create(:message , :for_user, complaint_id: complaint.id)}
            it "message is true" do
                expect(message.message).to be_an_instance_of(User)
            end
        end

        context "belongs_to" do
            let(:user) {create(:user)}
            let(:complaint) {create(:complaint, user_id: user.id)}
            let(:usermessage) {create(:message , :for_user, complaint_id: complaint.id)}
            let(:message) {create(:message , :for_officer, complaint_id: complaint.id, parent_id: usermessage.id)}
            it "message is true" do
                expect(message.message).to be_an_instance_of(Officer)
            end
        end

        context "has_one" do
            it "status" do
                association = Message.reflect_on_association(:status).macro
                expect(association).to be(:has_one)
            end
        end

        context "has_one" do
            it "response" do
                association = Message.reflect_on_association(:response).macro
                expect(association).to be(:has_one)
            end
        end
    end
end