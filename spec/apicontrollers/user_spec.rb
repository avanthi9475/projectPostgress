require 'rails_helper'

RSpec.describe Api::UsersController , type: :request do
    let!(:current_user_login) {create(:user_login, role:'user')}
    let!(:user) {create(:user, email:current_user_login.email)}
    let(:user_token) {create(:doorkeeper_access_token , resource_owner_id: current_user_login.id)}

    let!(:current_user2_login) {create(:user_login, role:'user')}
    let!(:anotherUser) {create(:user)}
    let(:anotherUser_token) {create(:doorkeeper_access_token , resource_owner_id: current_user2_login.id)}

    let!(:current_officer_login) {create(:user_login, role:'officer')}
    let!(:officer) {create(:officer, email:current_officer_login.email)}
    let(:officer_token) {create(:doorkeeper_access_token , resource_owner_id: current_officer_login.id)}

    let!(:sub_officer) {create(:user_login, role:'officer')}
    let!(:subofficer) {create(:officer, email:sub_officer.email, role: 'Inspector')}
    let(:sub_officer_token) {create(:doorkeeper_access_token , resource_owner_id: sub_officer.id)}

    let!(:complaint) {create(:complaint, user_id: user.id)}
    let!(:officers_complaint) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}


    describe "get/users #index" do
        context "When user not signed in" do
            before do
                get "/api/users"
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do
                get "/api/users", params: {access_token: user_token.token}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head officer" do
            before do
                get "/api/users", params: {access_token: officer_token.token}
            end
            it "redirects to users index" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/users #show" do
        context "When user not signed in" do
            before do
                get "/api/users/#{user.id}"
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When redirects to invalid id" do
            before do 
                get "/api/users/0", params: {access_token: user_token.token}
            end
            it "notices 'invalid id'" do
                expect(response).to have_http_status(404)
            end
        end

        context "When signed in as user" do
            before do
                get "/api/users/#{user.id}", params: {access_token: user_token.token}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and renders the other user profile page" do
            before do
                get "/api/users/#{anotherUser.id}", params: {access_token: user_token.token}
            end
            it "redirects to current user profile page" do
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head officer" do
            before do
                get "/api/users/#{user.id}", params: {access_token: officer_token.token}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            before do
                get "/api/users/#{user.id}", params: {access_token: sub_officer_token.token}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            before do
                get "/api/users/#{anotherUser.id}", params: {access_token: sub_officer_token.token}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(403)
            end
        end
    end
    
    describe "get/users #viewResponse" do
        context "When user not signed in" do
            before do
                get "/api/viewResponse"
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user and user has not received any messages" do
            before do
                get "/api/viewResponse", params: {access_token: user_token.token}
            end
            it "redirects to response messages page" do
                expect(response).to have_http_status(204)
            end
        end

        context "When signed in as sub-officer" do
            before do
                get "/api/viewResponse", params: {access_token: sub_officer_token.token}
            end
            it "redirects to sub-officer profile page" do
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head-officer" do
            before do
                get "/api/viewResponse", params: {access_token: officer_token.token}
            end
            it "redirects to head officer profile page" do
                expect(response).to have_http_status(403)
            end
        end
    end

    describe "post/users #create" do
        context "When user not signed in" do
            before do
                post "/api/users", params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456'}}
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do
                post "/api/users", params:{access_token: user_token.token,email: 'user@example.com', role:'user' , password:'123456', user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456'}}
            end
            it "creates new user successfully" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            before do
                post "/api/users", params:{access_token: sub_officer_token.token,email: 'user@example.com', role:'user' , password:'123456', user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456'}}
            end
            it "creates new user successfully" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            before do
                post "/api/users", params:{access_token: officer_token.token,email: 'user@example.com',  role:'user' ,password:'123456',  user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456'}}
            end
            it "creates new user successfully" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "patch/users #update" do
        context "When user not signed in" do
            before do
                patch "/api/users/#{user.id}" , params:{user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When redirects to invalid id" do
            before do 
                patch "/api/users/0" , params:{access_token: user_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "notices 'invalid id'" do
                expect(response).to have_http_status(404)
            end
        end

        context "When signed in as user" do
            before do
                patch "/api/users/#{user.id}" , params:{access_token: user_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to users edit page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and trying to edit another user profile" do
            before do
                patch "/api/users/#{anotherUser.id}" , params:{access_token: user_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to current user profile page" do
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head officer" do
            before do
                patch "/api/users/#{user.id}" , params:{access_token: officer_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to user edit page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            before do
                patch "/api/users/#{user.id}" , params:{access_token: officer_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to user edit page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            before do
                patch "/api/users/#{anotherUser.id}" , params:{access_token: sub_officer_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to subofficer profile page" do
                expect(response).to have_http_status(403)
            end
        end
    end

    describe "deleter/users #delete" do
        context "When user not signed in" do
            before do
                delete "/api/users/#{user.id}"
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When redirects to invalid id" do
            before do 
                delete "/api/users/0", params: {access_token: user_token.token}
            end
            it "notices 'invalid id'" do
                expect(response).to have_http_status(404)
            end
        end

        context "When signed in as user" do
            before do
                delete "/api/users/#{user.id}", params: {access_token: user_token.token}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head officer" do
            before do
                delete "/api/users/#{user.id}", params: {access_token: officer_token.token}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end
    end

end