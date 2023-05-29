require 'rails_helper'

RSpec.describe MessagesController do
    let!(:current_user_login) {create(:user_login, role:'user')}
    let!(:user) {create(:user, email:current_user_login.email)}

    let!(:current_officer_login) {create(:user_login, role:'officer')}
    let!(:officer) {create(:officer, email:current_officer_login.email)}

    let!(:sub_officer) {create(:user_login, role:'officer')}
    let!(:subofficer) {create(:officer, email:sub_officer.email, role: 'Inspector')}

    let!(:complaint) {create(:complaint, user_id: user.id)}
    let!(:crime_fir1) {create(:crime_fir, user_id: user.id, complaint_id:complaint.id)}
    let!(:officers_complaint1) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}
    let!(:message1) {create(:message , message_id: user.id, message_type:"User", complaint_id:complaint.id)}

    let!(:anotherUser) {create(:user)}
    let!(:complaint2) {create(:complaint, user_id: anotherUser.id)}
    let!(:officers_complaint2) {create(:officers_complaint, complaint_id:complaint2.id, officer_id:officer.id)}
    let!(:crime_fir2) {create(:crime_fir, user_id: anotherUser.id, complaint_id:complaint2.id)}
    let!(:message2) {create(:message, :for_user, complaint_id:complaint2.id)}



    describe "get/messages #index" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :index
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :index
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head officer" do
            it "redirects to messages index" do
                sign_in current_officer_login
                get :index
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer" do
            it "redirects to messages index" do
                sign_in sub_officer
                get :index
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/messages #show" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :show, params:{id: message1.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user and tries to view their message" do
            it "redirects to show message page" do
                sign_in current_user_login
                get :show, params:{id: message1.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and tries to view others message" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :show, params:{id: message2.id}
                expect(response).to redirect_to user
            end
        end
    end

    describe "get/officers #new" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :new
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to new message page" do
                sign_in current_user_login
                get :new
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to new message page" do
                sign_in sub_officer
                get :new
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            it "redirects to new officer page" do
                sign_in current_officer_login
                get :new
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/messages #edit" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :edit, params:{id: message1.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user and tries to view their message" do
            it "redirects to edit message page" do
                sign_in current_user_login
                get :edit, params:{id: message1.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and tries to view others message" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :edit, params:{id: message2.id}
                expect(response).to redirect_to user
            end
        end
    end

    
    describe "get/messages #respondMsg" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :respondMsg, params:{id: message1.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :respondMsg, params:{id: message1.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as officer and responds to his message" do
            it "redirects to request message page" do
                sign_in sub_officer
                 get :respondMsg, params:{id: message1.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and responds to others messages" do
            it "redirects to request message page" do
                sign_in current_officer_login
                 get :respondMsg, params:{id: message1.id}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "post/messages #create" do
        context "When user not signed in" do
            it "redirects to login page" do
                post :create, params:{message: {complaint_id:complaint.id, statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When user signed in" do
            it "message created successfully" do
                sign_in current_user_login
                post :create, params:{message: {complaint_id:complaint.id, statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to Message.last
            end
        end
    end

    describe "patch/messages #update" do
        context "When user not signed in" do
            it "redirects to login page" do
                patch :update, params:{id: message1.id, message: {complaint_id:complaint.id, statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user and tries to update their message" do
            it "message updated successfully" do
                sign_in current_user_login
                patch :update, params:{id: message1.id, message: {complaint_id:complaint.id, statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to message1
            end
        end

        context "When signed in as user and tries to update others message" do
            it "message updated successfully" do
                sign_in current_user_login
                patch :update, params:{id: message2.id, message: {complaint_id:complaint2.id, statement:'Please update about my complaint status', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to user
            end
        end
    end


end