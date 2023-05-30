require 'rails_helper'

RSpec.describe Officer, type: :model do

    describe "Name" do
        before(:each) do
            officer.validate
        end

        context "When Value is present" do
            let(:officer) {build(:officer, name: "Ramya")}
            it "doesn't throw any error" do
                expect(officer.errors).to_not include(:name)
            end
        end

        context "When Value is NIL" do
            let(:officer) {build(:officer, name: nil)}
            it "throws error" do    
                expect(officer.errors).to include(:name)
            end
        end

        context "When value is alphanumeric" do
            let(:officer) {build(:officer, name: "Ramya123")}
            it "throws error 'Name is invalid'" do
                expect(officer.errors).to include(:name)
            end
        end

        context "When value is numric" do
            let(:officer) {build(:officer, name: "1234")}
            it "throws error 'Name is invalid'" do
                expect(officer.errors).to include(:name)
            end
        end

        context "When Value is valid" do
            let(:officer) {build(:officer, name: "Kaviya")}
            it "doesn't throw any error" do
                expect(officer.errors).to_not include(:name)
            end
        end
    end

    describe "Email" do
        before(:each) do
            officer.validate
        end

        context "When email is present" do
            let(:officer) {build(:officer, email: "officer@gmail.com")}
            it "doesn't throw any error" do
                expect(officer.errors).to_not include(:email)
            end
        end

        context "When email is invalid" do
            let(:officer) {build(:officer, email: "officer.com")}
            it "throws error" do
                expect(officer.errors).to include(:email)
            end
        end

        context "When email is NIL" do
            let(:officer) {build(:officer, email: nil)}
            it "throws error" do
                expect(officer.errors).to include(:email)
            end
        end
    end

    describe "When Age" do
        before(:each) do
            officer.validate
        end

        context "Age is valid" do
            let(:officer) {build(:officer, age: 21)}
            it "doesn't throw any error" do
                expect(officer.errors).to_not include(:age)
            end
        end

        context "Age is nil" do
            let(:officer) {build(:officer, age: nil)}
            it "throws error" do
                expect(officer.errors).to include(:age)
            end
        end

        context "Age is alphabetic" do
            let(:officer) {build(:officer, age: "abc")}
            it "throws error" do
                expect(officer.errors).to include(:age)
            end
        end

        context "When Age is less than 18" do
            let(:officer) {build(:officer, age: 10)}
            it "throws error" do
                expect(officer.errors).to include(:age)
            end
        end

        context "Age is Alphanumric" do
            let(:officer) {build(:officer, age: "10ab")}
            it "throws error" do
                expect(officer.errors).to include(:age)
            end
        end
    end

    describe "location - " do
        before(:each) do
            officer.validate
        end

        context "When location is valid" do
            let(:officer) {build(:officer, location:"Chennai")}
            it "doesn't throw any error" do
                expect(officer.errors).to_not include(:location)
            end
        end

        context "When location is NIL" do
            let(:officer) {build(:officer, location: nil)}
            it "throws error" do
                expect(officer.errors).to include(:location)
            end
        end

        context "When location is alphanumeric" do
            let(:officer) {build(:officer, location:"Chennai1001")}
            it "throws error" do
                expect(officer.errors).to include(:location)
            end
        end

        context "When location is numeric" do
            let(:officer) {build(:officer, location:"12345")}
            it "throws error" do
                expect(officer.errors).to include(:location)
            end
        end
    end

    describe "Role - " do
        before(:each) do
            officer.validate
        end

        context "When Value is valid" do
            let(:officer) {build(:officer, role: "Inspector")}
            it "doesn't throw any error" do
                expect(officer.errors).to_not include(:role)
            end
        end

        context "When Value is nil" do
            let(:officer) {build(:officer, role: nil)}
            it "throws error" do
                expect(officer.errors).to include(:role)
            end
        end
        
        context "When Value contains alphanumeric" do
            let(:officer) {build(:officer)}
            it "throws error" do
                expect { build(:officer, role: 'Doctor') }
                .to raise_error(ArgumentError, "'Doctor' is not a valid role")
            end
        end

        context "When value is invalid" do
            let(:officer) {build(:officer)}
            it "throws error" do
                expect { build(:officer, role: 'Doctor') }
                .to raise_error(ArgumentError, "'Doctor' is not a valid role")
            end
        end
    end

    describe "Officer association" do
        context "has_many" do
            [:messages, :request_messages, :crime_firs, :users].each do |each|
            it each.to_s.humanize do
                association = Officer.reflect_on_association(each).macro
                expect(association).to be(:has_many)
            end
            end
        end

        context "has_and_belongs_to_many" do
            it "complaints" do
                association = Officer.reflect_on_association(:complaints).macro
                expect(association).to be(:has_and_belongs_to_many)
            end
        end
    end

    describe "Customized Methods" do
        context "When Complaint is assigned to a officer"
        let(:user) {create(:user)}
        let(:officer) {create(:officer)}
        let(:complaint) {create(:complaint, user_id:user.id)}
        let!(:officers_complaint) {create(:officers_complaint, complaint_id: complaint.id, officer_id: officer.id, IsHead: 'No')}
        it 'is officer the lead of the complaint' do
            expect(officer.is_head_for_complaint(complaint.id, officer.id)).to eq("No")
        end
    end

    describe "Customized Methods" do
        context "When Complaint is assigned to a officer"
        let(:user) {create(:user)}
        let(:officer) {create(:officer)}
        let(:complaint) {create(:complaint, user_id:user.id)}
        let!(:officers_complaint) {create(:officers_complaint, complaint_id: complaint.id, officer_id: officer.id, IsHead: 'Yes')}
        it 'is officer the lead of the complaint' do
            expect(officer.is_head_for_complaint(complaint.id, officer.id)).to eq("Yes")
        end
    end
end