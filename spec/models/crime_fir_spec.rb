require 'rails_helper'

RSpec.describe CrimeFir, type: :model do

    describe "Under Section - " do
        before(:each) do
            crime_fir.validate
        end

        context "When Value is valid" do
            let(:crime_fir) {build(:crime_fir, under_section: "302")}
            it "doesn't throw any error" do
                expect(crime_fir.errors).to_not include(:under_section)
            end
        end

        context "When Value is NIL" do
            let(:crime_fir) {build(:crime_fir, under_section: nil)}
            it "throws error" do    
                expect(crime_fir.errors).to include(:under_section)
            end
        end

        context "When value is alphabetic" do
            let(:crime_fir) {build(:crime_fir, under_section: "abcd")}
            it "throws error 'crime_fir is invalid'" do
                expect(crime_fir.errors).to include(:under_section)
            end
        end

        context "When value is alphanumeric" do
            let(:crime_fir) {build(:crime_fir, under_section: "abcd123")}
            it "throws error 'crime_fir is invalid'" do
                expect(crime_fir.errors).to include(:under_section)
            end
        end
    end

    describe "Datetime" do
        before(:each) do
            crime_fir.validate
        end

        context "When value is valid" do
            let(:crime_fir) {build(:crime_fir, dateTime_of_crime: "2023-05-24 14:49:28")}
            it "doesn't throw any error" do
                expect(crime_fir.errors).to_not include(:dateTime_of_crime)
            end
        end

        context "When value is invalid" do
            let(:crime_fir) {build(:crime_fir, dateTime_of_crime: "2023-25-24 194:49:28")}
            it "throws error" do
                expect(crime_fir.errors).to include(:dateTime_of_crime)
            end
        end

        context "When value is NIL" do
            let(:crime_fir) {build(:crime_fir, dateTime_of_crime: nil)}
            it "throws error" do
                expect(crime_fir.errors).to include(:dateTime_of_crime)
            end
        end
    end

    describe "Crime Category" do
        before(:each) do
            crime_fir.validate
        end

        context "When crime_category is valid" do
            let(:crime_fir) {build(:crime_fir, crime_category:"Robery")}
            it "doesn't throw any error" do
                expect(crime_fir.errors).to_not include(:crime_category)
            end
        end

        context "When crime_category is NIL" do
            let(:crime_fir) {build(:crime_fir, crime_category: nil)}
            it "throws error" do
                expect(crime_fir.errors).to include(:crime_category)
            end
        end

        context "When crime_category is alphanumeric" do
            let(:crime_fir) {build(:crime_fir, crime_category:"Rober123y")}
            it "throws error" do
                expect(crime_fir.errors).to include(:crime_category)
            end
        end

        context "When crime_category is numeric" do
            let(:crime_fir) {build(:crime_fir, crime_category:"12345")}
            it "throws error" do
                expect(crime_fir.errors).to include(:crime_category)
            end
        end

        context "When crime_category is too long" do
            let(:crime_fir) {build(:crime_fir, crime_category:"The crime category is robery")}
            it "throws error" do
                expect(crime_fir.errors).to include(:crime_category)
            end
        end
    end

    describe "Crime FIR association" do
        context "belongs_to complaint" do
            let(:user) {create(:user)}
            let(:complaint) {create(:complaint, user_id: user.id)}
            let(:crime_fir) {create(:crime_fir, user_id: user.id, complaint_id: complaint.id)}
            it "is true" do
                expect(crime_fir.user).to be_an_instance_of(User)
            end
        end

        context "belongs_to complaint" do
            let(:user) {create(:user)}
            let(:complaint) {create(:complaint, user_id: user.id)}
            let(:crime_fir) {create(:crime_fir, user_id: user.id, complaint_id: complaint.id)}
            it "is true" do
                expect(crime_fir.complaint).to be_an_instance_of(Complaint)
            end
        end

        context "has_one" do
            it "status" do
                association = CrimeFir.reflect_on_association(:status).macro
                expect(association).to be(:has_one)
            end
        end
    end

    describe "callback methods " do
        context "create_status" do
            let(:user) {create(:user)}
            let(:complaint) {create(:complaint, user_id:user.id)}
            let(:crime_fir) {create(:crime_fir, user_id:user.id, complaint_id:complaint.id)}
            it "creates a new record in status model" do
                expect(crime_fir.create_status).to eq(true)
            end
        end
      end

end