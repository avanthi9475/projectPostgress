require 'rails_helper'

RSpec.describe OfficersComplaint, type: :model do

    describe "IsHead - " do
        before(:each) do
            officers_complaint.validate
        end

        context "When Value is valid" do
            let(:officers_complaint) {build(:officers_complaint, IsHead: "Yes")}
            it "doesn't throw any error" do
                expect(officers_complaint.errors).to_not include(:IsHead)
            end
        end

        context "When Value is valid" do
            let(:officers_complaint) {build(:officers_complaint, IsHead: "No")}
            it "doesn't throw any error" do
                expect(officers_complaint.errors).to_not include(:IsHead)
            end
        end

        context "When Value is NIL" do
            let(:officers_complaint) {build(:officers_complaint, IsHead: nil)}
            it "throws error" do    
                expect(officers_complaint.errors).to include(:IsHead)
            end
        end

        context "When value is invalid" do
            let(:officers_complaint) {build(:officers_complaint)}
            it "throws error value is invalid'" do
                expect { build(:officers_complaint, IsHead: 'abcd') }
                .to raise_error(ArgumentError)
            end
        end

        context "When value is invalid" do
            let(:officers_complaint) {build(:officers_complaint)}
            it "throws error value is invalid'" do
                expect { build(:officers_complaint, IsHead: 'abcd123') }
                .to raise_error(ArgumentError)
            end
        end
    end

    describe "Officer association" do

        context "belongs_to complaint" do
            let(:user) {create(:user)}
            let(:officer) {create(:officer)}
            let(:complaint) {create(:complaint, user_id:user.id)}
            let(:officers_complaint) {create(:officers_complaint, complaint_id: complaint.id, officer_id: officer.id)}
            it "is true" do
                expect(officers_complaint.complaint).to be_an_instance_of(Complaint)
            end
        end

        context "belongs_to officer" do
            let(:user) {create(:user)}
            let(:officer) {create(:officer)}
            let(:complaint) {create(:complaint, user_id:user.id)}
            let(:officers_complaint) {create(:officers_complaint, complaint_id: complaint.id, officer_id: officer.id)}
            it "is true" do
                expect(officers_complaint.officer).to be_an_instance_of(Officer)
            end
        end 
    end
end