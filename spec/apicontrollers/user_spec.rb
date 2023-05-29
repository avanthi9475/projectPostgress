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
            it "redirects to login page" do
                get "/api/users"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                get "/api/users", params: {access_token: user_token.token}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as head officer" do
            it "redirects to users index" do
                get "/api/users", params: {access_token: officer_token.token}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/users #show" do
        context "When user not signed in" do
            it "redirects to login page" do
                get "/api/users/#{user.id}"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                get "/api/users/#{user.id}", params: {access_token: user_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and renders the other user profile page" do
            it "redirects to current user profile page" do
                get "/api/users/#{anotherUser.id}", params: {access_token: user_token.token}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as head officer" do
            it "redirects to user profile page" do
                get "/api/users/#{user.id}", params: {access_token: officer_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            it "redirects to user profile page" do
                get "/api/users/#{user.id}", params: {access_token: sub_officer_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            it "redirects to user profile page" do
                get "/api/users/#{anotherUser.id}", params: {access_token: sub_officer_token.token}
                expect(response).to have_http_status(401)
            end
        end
    end
    
    describe "get/users #viewResponse" do
        context "When user not signed in" do
            it "redirects to login page" do
                get "/api/viewResponse"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user and user has not received any messages" do
            it "redirects to response messages page" do
                get "/api/viewResponse", params: {access_token: user_token.token}
                expect(response).to have_http_status(204)
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to sub-officer profile page" do
                 get "/api/viewResponse", params: {access_token: sub_officer_token.token}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as head-officer" do
            it "redirects to head officer profile page" do
                 get "/api/viewResponse", params: {access_token: officer_token.token}
                expect(response).to have_http_status(401)
            end
        end
    end

    describe "post/users #create" do
        context "When user not signed in" do
            it "redirects to login page" do
                post "/api/users", params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456'}}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "creates new user successfully" do
                post "/api/users", params:{access_token: user_token.token,email: 'user@example.com', role:'user' , password:'123456', user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456'}}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            it "creates new user successfully" do
                post "/api/users", params:{access_token: sub_officer_token.token,email: 'user@example.com', role:'user' , password:'123456', user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456'}}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            it "creates new user successfully" do
                post "/api/users", params:{access_token: officer_token.token,email: 'user@example.com',  role:'user' ,password:'123456',  user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456'}}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "patch/users #update" do
        context "When user not signed in" do
            it "redirects to login page" do
                patch "/api/users/#{user.id}" , params:{user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "redirects to users edit page" do
                patch "/api/users/#{user.id}" , params:{access_token: user_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and trying to edit another user profile" do
            it "redirects to current user profile page" do
                patch "/api/users/#{anotherUser.id}" , params:{access_token: user_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as head officer" do
            it "redirects to user edit page" do
                patch "/api/users/#{user.id}" , params:{access_token: officer_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            it "redirects to user edit page" do
                patch "/api/users/#{user.id}" , params:{access_token: officer_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            it "redirects to subofficer profile page" do
                patch "/api/users/#{anotherUser.id}" , params:{access_token: sub_officer_token.token, user: {name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to have_http_status(401)
            end
        end
    end

    describe "deleter/users #delete" do
        context "When user not signed in" do
            it "redirects to login page" do
                delete "/api/users/#{user.id}"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                delete "/api/users/#{user.id}", params: {access_token: user_token.token}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as head officer" do
            it "redirects to user profile page" do
                delete "/api/users/#{user.id}", params: {access_token: officer_token.token}
                expect(response).to have_http_status(200)
            end
        end
    end

end