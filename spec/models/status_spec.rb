require 'rails_helper'

RSpec.describe Status, type: :model do

    describe "Status - " do
        before(:each) do
            status.validate
        end

        context "When Value is valid" do
            let(:status) {build(:status, status: "Inprogress")}
            it "doesn't throw any error" do
                expect(status.errors).to_not include(:status)
            end
        end

        context "When Value is valid" do
            let(:status) {build(:status, status: "Resolved")}
            it "doesn't throw any error" do
                expect(status.errors).to_not include(:status)
            end
        end

        context "When Value is NIL" do
            let(:status) {build(:status, status: nil)}
            it "throws error" do    
                expect(status.errors).to include(:status)
            end
        end

        context "When value is invalid" do
            let(:status) {build(:status)}
            it "throws error value is invalid'" do
                expect { build(:status, status: 'abcd') }
                .to raise_error(ArgumentError)
            end
        end

        context "When value is invalid" do
            let(:status) {build(:status)}
            it "throws error value is invalid'" do
                expect { build(:status, status: 'abcd123') }
                .to raise_error(ArgumentError)
            end
        end
    end

    describe "Status association" do
        context "belongs_to" do
            let(:user) {create(:user)}
            let(:complaint) {create(:complaint, user_id: user.id)}
            let(:status) {create(:status, :for_complaint)}
            it "complaint is true" do
                expect(status.statusable).to be_an_instance_of(Complaint)
            end
        end

        context "belongs_to" do
            let(:user) {create(:user)}
            let(:complaint) {create(:complaint, user_id: user.id)}
            let(:message) {create(:message, complaint_id:complaint.id)}
            let(:status) {create(:status, :for_message)}
            it "message is true" do
                expect(status.statusable).to be_an_instance_of(Message)
            end
        end
    end
end