require 'rails_helper'

RSpec.describe Api::SessionsController , type: :request do

    let!(:application) {create(:doorkeeper_application)}

    let!(:user_token) {create(:doorkeeper_access_token, application: application)}

    describe "get/index #index" do
        context "When user signed in" do
            before do
                get "/api", params:{access_token: user_token.token}
            end
            it "Restricted Access" do
                expect(response).to have_http_status(200)
            end
        end

        context "When user not signed in" do
            before do
                get "/api"
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end
    end
end