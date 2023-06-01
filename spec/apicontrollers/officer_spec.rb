require 'rails_helper'

RSpec.describe Api::OfficersController , type: :request do
    let!(:current_user_login) {create(:user_login, role:'user')}
    let!(:user) {create(:user, email:current_user_login.email)}
    let!(:user_token) {create(:doorkeeper_access_token , resource_owner_id: current_user_login.id)}

    let!(:current_user2_login) {create(:user_login, role:'user')}
    let!(:anotherUser) {create(:user)}
    let!(:anotherUser_token) {create(:doorkeeper_access_token , resource_owner_id: current_user2_login.id)}

    let!(:current_officer_login) {create(:user_login, role:'officer')}
    let!(:officer) {create(:officer, email:current_officer_login.email)}
    let!(:officer_token) {create(:doorkeeper_access_token , resource_owner_id: current_officer_login.id)}

    let!(:message1) {create(:message , message_id: user.id, message_type:"User", complaint_id:complaint.id)}
    let!(:status1) {create(:status, statusable_id:message1.id, statusable_type: 'Message', status: 'Pending')}

    let!(:sub_officer) {create(:user_login, role:'officer')}
    let!(:subofficer) {create(:officer, email:sub_officer.email, role: 'Inspector')}
    let!(:sub_officer_token) {create(:doorkeeper_access_token , resource_owner_id: sub_officer.id)}

    let!(:complaint) {create(:complaint, user_id: user.id)}
    let!(:officers_complaint) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}
    
    let!(:complaint2) {create(:complaint, user_id: anotherUser.id)}
    let!(:officers_complaint2) {create(:officers_complaint, complaint_id:complaint2.id, officer_id:officer.id)}
    
    let!(:message2) {create(:message, :for_user, complaint_id:complaint2.id)}
    let!(:status2) {create(:status, statusable_id:message2.id, statusable_type: 'Message', status: 'Pending')}


    describe "get/officers #index" do
        context "When user not signed in" do
            before do
                get "/api/officers"                
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do
                get "/api/officers", params: {access_token: user_token.token}                
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as head officer" do
            before do
                get "/api/officers", params: {access_token: officer_token.token}                
            end
            it "redirects to users index" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer" do
            before do
                get "/api/officers", params: {access_token: sub_officer_token.token}                
            end
            it "redirects to sub-officers profile index" do
                expect(response).to have_http_status(401)
            end
        end
    end

    describe "get/officers #show" do
        context "When user not signed in" do
            before do
                get "/api/officers/#{officer.id}"                
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do
                get "/api/officers/#{officer.id}", params:{access_token: user_token.token}                
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as officer and renders the other officers profile page" do
            before do
                get "/api/officers/#{officer.id}", params:{access_token: sub_officer_token.token}                
            end
            it "redirects to current officer profile page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as head officer" do
            before do
                get "/api/officers/#{officer.id}", params:{access_token: officer_token.token}                
            end
            it "redirects to officers profile page" do
                expect(response).to have_http_status(200)
            end
        end
    end
    
    describe "get/officers #viewRequestMsg" do
        context "When user not signed in" do
            before do
                get "/api/viewRequestMsg"                
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do
                get "/api/viewRequestMsg", params:{access_token: user_token.token}                
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(401)
        end
    end

        context "When signed in as sub-officer" do
            before do
                get "/api/viewRequestMsg", params:{access_token: sub_officer_token.token}                
            end
            it "redirects to request message page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            before do
                get "/api/viewRequestMsg", params:{access_token: officer_token.token}                
            end
            it "redirects to request message page" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "post/officers #create" do
        context "When user not signed in" do
            before do
                post "/api/officers", params:{officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}                
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do
                post "/api/officers", params:{access_token: user_token.token, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}                
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as sub-officer" do
            before do
                post "/api/officers", params:{access_token: sub_officer_token.token, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}                
            end
            it "redirects to sub officer profile page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as head-officer" do
            before do
                post "/api/officers", params:{access_token: officer_token.token,email: 'officer@example.com', password:'123456', officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}                
            end
            it "creates new officer successfully" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "patch/officers #update" do
        context "When user not signed in" do
            before do
                patch "/api/officers/#{officer.id}", params:{officer:{name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }                
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do
                patch "/api/officers/#{officer.id}", params:{access_token: user_token.token,  officer:{name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }                
            end
            it "redirects to users profile page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as head officer" do
            before do
                patch "/api/officers/#{officer.id}", params:{access_token: officer_token.token,  officer:{name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }                
            end
            it "officer updated successfully" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer and try's to edit other officers page" do
            before do
                patch "/api/officers/#{officer.id}", params:{access_token: sub_officer_token.token, officer:{name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }                
            end
            it "redirects to sub-officer profile page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as sub-officer and try's to edit his details" do
            before do
                patch "/api/officers/#{subofficer.id}", params:{access_token: sub_officer_token.token, officer:{name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }                
            end
            it "redirects to subofficer edit page" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "deleter/officers #delete" do
        context "When user not signed in" do
            before do
                delete "/api/officers/#{officer.id}"                
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do
                delete "/api/officers/#{officer.id}", params: {access_token: user_token.token}                
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as officer" do
            before do
                delete "/api/officers/#{subofficer.id}", params: {access_token: sub_officer_token.token}                
            end
            it "redirects to sub-officers profile page" do
                expect(response).to have_http_status(401)
            end
        end
    end


end