require 'rails_helper'

RSpec.describe Api::MessagesController , type: :request do
    let!(:current_user_login) {create(:user_login, role:'user')}
    let!(:user) {create(:user, email:current_user_login.email)}
    let(:user_token) {create(:doorkeeper_access_token , resource_owner_id: current_user_login.id)}

    let!(:current_officer_login) {create(:user_login, role:'officer')}
    let!(:officer) {create(:officer, email:current_officer_login.email)}
    let(:officer_token) {create(:doorkeeper_access_token , resource_owner_id: current_officer_login.id)}

    let!(:sub_officer) {create(:user_login, role:'officer')}
    let!(:subofficer) {create(:officer, email:sub_officer.email, role: 'Inspector')}
    let(:sub_officer_token) {create(:doorkeeper_access_token , resource_owner_id: sub_officer.id)}

    let!(:complaint) {create(:complaint, user_id: user.id)}
    let!(:crime_fir1) {create(:crime_fir, user_id: user.id, complaint_id:complaint.id)}
    let!(:officers_complaint1) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}
    let!(:message1) {create(:message , message_id: user.id, message_type:"User", complaint_id:complaint.id)}

    let!(:current_user2_login) {create(:user_login, role:'user')}
    let!(:anotherUser) {create(:user)}
    let(:anotherUser_token) {create(:doorkeeper_access_token , resource_owner_id: current_user2_login.id)}

    let!(:complaint2) {create(:complaint, user_id: anotherUser.id)}
    let!(:officers_complaint2) {create(:officers_complaint, complaint_id:complaint2.id, officer_id:officer.id)}
    let!(:crime_fir2) {create(:crime_fir, user_id: anotherUser.id, complaint_id:complaint2.id)}
    let!(:message2) {create(:message, :for_user, complaint_id:complaint2.id)}
    
    describe "get/messages #index" do
        context "When user not signed in" do
            it "redirects to login page" do
                get "/api/messages"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                get "/api/messages",  params: {access_token: user_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head officer" do
            it "redirects to messages index" do
                get "/api/messages", params: {access_token: officer_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer" do
            it "redirects to messages index" do
                get "/api/messages", params: {access_token: sub_officer_token.token}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/messages #show" do
        context "When user not signed in" do
            it "redirects to login page" do
                get  "/api/messages/#{message1.id}"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user and tries to view their message" do
            it "redirects to show message page" do
                get  "/api/messages/#{message1.id}", params: {access_token: user_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and tries to view others message" do
            it "redirects to user profile page" do
                get  "/api/messages/#{message2.id}",params: {access_token: user_token.token}
                expect(response).to have_http_status(403)
            end
        end
    end
    
    describe "post/messages #create" do
        context "When user not signed in" do
            it "redirects to login page" do
                post "/api/messages", params:{message: {complaint_id:complaint.id, statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(401)
            end
        end

        context "When user signed in" do
            it "message created successfully" do
                post "/api/messages", params:{access_token: user_token.token, message: {complaint_id:complaint.id, statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "patch/messages #update" do
        context "When user not signed in" do
            it "redirects to login page" do
                patch "/api/messages/#{message1.id}", params:{message: {statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user and tries to update message, " do
            it "message updated successfully" do
                patch "/api/messages/#{message1.id}", params:{access_token: user_token.token, message: {statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as officer and tries to update their message," do
            it "message updated successfully" do
                patch "/api/messages/#{message1.id}", params:{access_token: sub_officer_token.token, message: {statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and tries to update others message" do
            it "redirects to officer profile page" do
                patch "/api/messages/#{message2.id}", params:{access_token: sub_officer_token.token, message: {statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to have_http_status(401)
            end
        end
    end
    
    describe "delete/messages #delete" do
        context "When user not signed in" do
            it "redirects to login page" do
                delete "/api/messages/#{message1.id}"
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user and tries to delete message" do
            it "redirect to user profile page" do
                delete "/api/messages/#{message1.id}", params:{access_token: user_token.token}
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as officer and tries to delete their message," do
            it "message deleted successfully" do
                delete "/api/messages/#{message1.id}", params:{access_token: sub_officer_token.token}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and tries to delete others message" do
            it "redirects to officer profile page" do
                delete "/api/messages/#{message2.id}", params:{access_token: sub_officer_token.token}
                expect(response).to have_http_status(401)
            end
        end
    end



end