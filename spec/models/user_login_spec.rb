require 'rails_helper'

RSpec.describe UserLogin, type: :model do
  
    describe "Role - " do
        before(:each) do
            user_login.validate
        end

        context "When Value is valid" do
            let(:user_login) {build(:user_login, role: "user")}
            it "doesn't throw any error" do
                expect(user_login.errors).to_not include(:role)
            end
        end

        context "When Value is valid" do
            let(:user_login) {build(:user_login, role: "officer")}
            it "doesn't throw any error" do
                expect(user_login.errors).to_not include(:role)
            end
        end

        context "When Value is NIL" do
            let(:user_login) {build(:user_login, role: nil)}
            it "throws error" do    
                expect(user_login.errors).to include(:role)
            end
        end

        context "When value is invalid" do
            let(:user_login) {build(:user_login)}
            it "throws error value is invalid'" do
                expect { build(:user_login, role: 'abcd') }
                .to raise_error(ArgumentError)
            end
        end

        context "When value is invalid" do
            let(:user_login) {build(:user_login)}
            it "throws error value is invalid'" do
                expect { build(:user_login, role: 'abcd123') }
                .to raise_error(ArgumentError)
            end
        end
    end

    describe "Customized Methods" do
        context "when user is created" do
            let(:user_login) {create(:user_login, role: 'user')}
            it 'Is User return true' do
                expect(user_login.isUser?).to eq(true)
            end 
        end

        context "when user is created" do
            let(:user_login) {create(:user_login, role: 'officer')}
            it 'Is User return true' do
                expect(user_login.isUser?).to eq(false)
            end 
        end

        context "when user is created" do
            let(:user_login) {create(:user_login, role: 'officer')}
            it 'Is User return true' do
                expect(user_login.isOfficer?).to eq(true)
            end 
        end

        context "when user is created" do
            let(:user_login) {create(:user_login, role: 'user')}
            it 'Is User return true' do
                expect(user_login.isOfficer?).to eq(false)
            end 
        end
    end
end
