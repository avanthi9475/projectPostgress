require 'rails_helper'

RSpec.describe UsersController do
    let!(:current_user_login) {create(:user_login, role:'user')}
    let!(:user) {create(:user, email:current_user_login.email)}
    let!(:anotherUser) {create(:user)}
    let!(:current_officer_login) {create(:user_login, role:'officer')}
    let!(:officer) {create(:officer, email:current_officer_login.email)}
    let!(:sub_officer) {create(:user_login, role:'officer')}
    let!(:subofficer) {create(:officer, email:sub_officer.email, role: 'Inspector')}
    let!(:complaint) {create(:complaint, user_id: user.id)}
    let!(:officers_complaint) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}


    describe "get/users #index" do
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
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "redirects to users index" do
                sign_in current_officer_login
                get :index
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/users #show" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :show, params:{id: user.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :show, params:{id: user.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and renders the other user profile page" do
            it "redirects to current user profile page" do
                sign_in current_user_login
                get :show, params:{id: anotherUser.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "redirects to user profile page" do
                sign_in current_officer_login
                get :show, params:{id: user.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            it "redirects to user profile page" do
                sign_in sub_officer
                get :show, params:{id: user.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            it "redirects to user profile page" do
                sign_in sub_officer
                get :show, params:{id: anotherUser.id}
                expect(response).to redirect_to subofficer
            end
        end
    end

    describe "get/users #new" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :new
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :new
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to user profile page" do
                sign_in sub_officer
                get :new
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            it "redirects to user profile page" do
                sign_in current_officer_login
                get :new
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/users #edit" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :edit , params:{id: user.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to users edit page" do
                sign_in current_user_login
                get :edit, params:{id: user.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and trying to edit another user profile" do
            it "redirects to current user profile page" do
                sign_in current_user_login
                put :edit , params:{id: anotherUser.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "redirects to user edit page" do
                sign_in current_officer_login
                get :edit, params:{id: user.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            it "redirects to user edit page" do
                sign_in current_officer_login
                get :edit, params:{id: user.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            it "redirects to subofficer profile page" do
                sign_in sub_officer
                get :edit, params:{id: anotherUser.id}
                expect(response).to redirect_to subofficer
            end
        end
    end

    
    describe "get/users #viewResponse" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :viewResponse
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to response messages page" do
                sign_in current_user_login
                get :viewResponse
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to sub-officer profile page" do
                sign_in sub_officer
                 get :viewResponse
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as head-officer" do
            it "redirects to head officer profile page" do
                sign_in current_officer_login
                 get :viewResponse
                expect(response).to redirect_to officer
            end
        end
    end

    describe "post/users #create" do
        context "When user not signed in" do
            it "redirects to login page" do
                post :create, params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456', role:'user' }}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "creates new user successfully" do
                sign_in current_user_login
                post :create, params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456', role:'user' }}
                expect(response).to redirect_to User.last
            end
        end

        context "When signed in as sub-officer" do
            it "creates new user successfully" do
                sign_in sub_officer
                post :create, params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456', role:'user' }}
                expect(response).to redirect_to User.last
            end
        end

        context "When signed in as head-officer" do
            it "creates new user successfully" do
                sign_in current_officer_login
                post :create, params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456', role:'user' }}
                expect(response).to redirect_to User.last
            end
        end
    end

    describe "patch/users #update" do
        context "When user not signed in" do
            it "redirects to login page" do
                patch :update , params:{id: user.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to users edit page" do
                sign_in current_user_login
                patch :update , params:{id: user.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as user and trying to edit another user profile" do
            it "redirects to current user profile page" do
                sign_in current_user_login
                patch :update , params:{id: anotherUser.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "redirects to user edit page" do
                sign_in current_officer_login
                patch :update , params:{id: user.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            it "redirects to user edit page" do
                sign_in current_officer_login
                patch :update , params:{id: user.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            it "redirects to subofficer profile page" do
                sign_in sub_officer
                patch :update , params:{id: anotherUser.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
                expect(response).to redirect_to subofficer
            end
        end
    end


end