require 'rails_helper'

RSpec.describe User, type: :mode do

    describe "Name" do
        before(:each) do
            user.validate
        end

        context "When Value is present" do
            let(:user) {build(:cart, name: "Ramya")}
            it "doesn't throw any error" do
                expect(user.errors).to_not include(:name)
            end
        end

        context "When Value is NIL" do
            let(:user) {build(:cart, name: "Ramya")}
            it "throws error" do
                expect(user.errors).to include(:name)
            end
        end

        context "When Value contains numeric values" do
            let(:user) {build(:cart, name: "Ramya123")}
            it "throws error 'Name is invalid'" do
                expect(user.errors).to include(:name)
            end
        end

        context "When Value is valid" do
            let(:user) {build(:cart, name: "Kaviya")}
            it "doesn't throw any error" do
                expect(user.errors).to_not include(:name)
            end
        end
    end

end