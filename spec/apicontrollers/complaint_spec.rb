require 'rails_helper'

RSpec.describe Api::ComplaintsController , type: :request do

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
    let!(:officers_complaint1) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}
    
    let!(:complaint2) {create(:complaint, user_id: anotherUser.id)}
    let!(:officers_complaint2) {create(:officers_complaint, complaint_id:complaint2.id, officer_id:officer.id)}


    describe "get/complaints #index" do
        context "When user not signed in" do
            it "redirects to login page" do
                get "/api/complaints"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                get "/api/complaints", params: {access_token: user_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head officer" do
            it "redirects to users index" do
                get "/api/complaints", params: {access_token: officer_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer" do
            it "redirects to sub-officers profile index" do
                get "/api/complaints", params: {access_token: sub_officer_token.token}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/complaints #show" do
        context "When user not signed in" do
            it "redirects to login page" do
                get "/api/complaints/#{complaint.id}"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "redirects to user complaints page" do
                get "/api/complaints/#{complaint.id}", params:{access_token: user_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and tries to access other users complaints" do
            it "redirects to user complaints page" do
                get "/api/complaints/#{complaint2.id}", params:{access_token: user_token.token}
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head officer" do
            it "redirects to complaints page" do
                get "/api/complaints/#{complaint.id}", params:{access_token: officer_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer" do
            it "redirects to sub-officers complaints page" do
                get "/api/complaints/#{complaint.id}", params:{access_token: sub_officer_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and tries to access others officers complaints" do
            it "redirects to sub-officer profile page" do
                get "/api/complaints/#{complaint2.id}", params:{access_token: user_token.token}
                expect(response).to have_http_status(403)
            end
        end
    end
    
    describe "get/complaints #handledByOfficer" do
        context "When user not signed in" do
            it "redirects to login page" do
                get "/api/handledByOfficer/#{complaint.id}"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user and checks for their own complaint" do
            it "redirects to handledByOfficers page" do
                get "/api/handledByOfficer/#{complaint.id}", params: {access_token: user_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and checks for others complaint" do
            it "redirects to user profile page" do
                get "/api/handledByOfficer/#{complaint2.id}", params: {access_token: user_token.token}
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as sub-officer and checks for his own complaint" do
            it "redirects to handled by officers page" do
                 get "/api/handledByOfficer/#{complaint.id}", params: {access_token: sub_officer_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer and checks for others complaint" do
            it "redirects to officer profile page" do
                 get "/api/handledByOfficer/#{complaint2.id}", params: {access_token: sub_officer_token.token}
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head-officer" do
            it "redirects tohandled by officers page" do
                 get "/api/handledByOfficer/#{complaint2.id}", params: {access_token: officer_token.token}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/complaints #mycomplaints" do
        context "When user not signed in" do
            it "redirects to login page" do
                get "/api/viewMyComplaints"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                get "/api/viewMyComplaints", params: {access_token: user_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to request message page" do
                 get "/api/viewMyComplaints", params: {access_token: sub_officer_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            it "redirects to request message page" do
                 get "/api/viewMyComplaints", params: {access_token: officer_token.token}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "post/users #create" do
        context "When user not signed in" do
            it "redirects to login page" do
                post "/api/complaints", params:{complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "creates new complaint successfully" do
                post "/api/complaints", params:{access_token: user_token.token, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            it "creates new complaint successfully" do
                post "/api/complaints", params:{access_token: sub_officer_token.token, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            it "creates new complaint successfully" do
                post "/api/complaints", params:{access_token: sub_officer_token.token, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "patch/complaints #update" do
        context "When user not signed in" do
            it "redirects to login page" do
                patch "/api/complaints/#{complaint.id}", params:{complaint:{statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "redirects to user complaints page" do
                patch "/api/complaints/#{complaint.id}", params:{access_token: user_token.token, complaint:{statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and tries to update other users complaints" do
            it "complaint updated successfully" do
                patch "/api/complaints/#{complaint2.id}", params:{access_token: user_token.token, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head officer" do
            it "complaint updated successfully" do
                patch "/api/complaints/#{complaint.id}", params:{access_token: officer_token.token, complaint:{statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer" do
            it "complaint updated successfully" do
                patch "/api/complaints/#{complaint.id}", params:{access_token: sub_officer_token.token, complaint:{statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and tries to edit others officers complaints" do
            it "redirects to sub-officer profile page" do
                patch "/api/complaints/#{complaint2.id}", params:{access_token: sub_officer_token.token, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(403)
            end
        end
    end

end