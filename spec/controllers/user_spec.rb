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
            before do 
                get :index
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                get :index
            end
            it "redirects to user profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            before do 
                sign_in current_officer_login
                get :index
            end
            it "redirects to users index" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/users #show" do
        context "When user not signed in" do
            before do 
                get :show, params:{id: user.id}
                expect(response).to redirect_to new_user_login_session_path
            end
            it "redirects to login page" do
            end
        end

        context "When redirects to invalid id" do
            before do 
                sign_in current_user_login
                get :show, params:{id: 0}
            end
            it "notices 'invalid id'" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                get :show, params:{id: user.id}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and renders the other user profile page" do
            before do 
                sign_in current_user_login
                get :show, params:{id: anotherUser.id}
            end
            it "redirects to current user profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            before do 
                sign_in current_officer_login
                get :show, params:{id: user.id}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            before do 
                sign_in sub_officer
                get :show, params:{id: user.id}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            before do 
                sign_in sub_officer
                get :show, params:{id: anotherUser.id}
            end
            it "redirects to user profile page" do
                expect(response).to redirect_to subofficer
            end
        end
    end

    describe "get/users #new" do
        context "When user not signed in" do
            before do 
                get :new
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                get :new
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            before do 
                sign_in sub_officer
                get :new
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            before do 
                sign_in current_officer_login
                get :new
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/users #edit" do
        context "When user not signed in" do
            before do 
                get :edit , params:{id: user.id}
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When redirects to invalid id" do
            before do 
                sign_in current_user_login
                get :edit, params:{id: 0}
            end
            it "notices 'invalid id'" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                get :edit, params:{id: user.id}
            end
            it "redirects to users edit page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and trying to edit another user profile" do
            before do 
                sign_in current_user_login
                put :edit , params:{id: anotherUser.id}
            end
            it "redirects to current user profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            before do 
                sign_in current_officer_login
                get :edit, params:{id: user.id}
            end
            it "redirects to user edit page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            before do 
                sign_in current_officer_login
                get :edit, params:{id: user.id}
            end
            it "redirects to user edit page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            before do 
                sign_in sub_officer
                get :edit, params:{id: anotherUser.id}
            end
            it "redirects to subofficer profile page" do
                expect(response).to redirect_to subofficer
            end
        end
    end

    
    describe "get/users #viewResponse" do
        context "When user not signed in" do
            before do 
                get :viewResponse
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                get :viewResponse
            end
            it "redirects to response messages page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            before do 
                sign_in sub_officer
                get :viewResponse
            end
            it "redirects to sub-officer profile page" do
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as head-officer" do
            before do 
                sign_in current_officer_login
                get :viewResponse
            end
            it "redirects to head officer profile page" do
                expect(response).to redirect_to officer
            end
        end
    end

    describe "post/users #create" do
        context "When user not signed in" do
            before do 
                post :create, params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456', role:'user' }}
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                post :create, params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456', role:'user' }}
            end
            it "creates new user successfully" do
                expect(response).to redirect_to User.last
            end
        end

        context "When signed in as sub-officer" do
            before do 
                sign_in sub_officer
                post :create, params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456', role:'user' }}
            end
            it "creates new user successfully" do
                expect(response).to redirect_to User.last
            end
        end

        context "When signed in as head-officer" do
            before do 
                sign_in current_officer_login
                post :create, params:{user:{email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0, password:'123456', role:'user' }}
            end
            it "creates new user successfully" do
                expect(response).to redirect_to User.last
            end
        end
    end

    describe "patch/users #update" do
        context "When user not signed in" do
            before do 
                patch :update , params:{id: user.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When redirects to invalid id" do
            before do 
                sign_in current_user_login
                patch :update , params:{id: 0, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "notices 'invalid id'" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                patch :update , params:{id: user.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to users edit page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as user and trying to edit another user profile" do
            before do 
                sign_in current_user_login
                patch :update , params:{id: anotherUser.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to current user profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            before do 
                sign_in current_officer_login
                patch :update , params:{id: user.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to user edit page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as officer and if the user belongs to the officer" do
            before do 
                sign_in current_officer_login
                patch :update , params:{id: user.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to user edit page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as officer and if the user does not belongs to the officer" do
            before do 
                sign_in sub_officer
                patch :update , params:{id: anotherUser.id, user: {email: 'user@example.com', name: 'Avanthika', age:23, location:'Coimbatore', noOfComplaintsMade: 0}}
            end
            it "redirects to subofficer profile page" do
                expect(response).to redirect_to subofficer
            end
        end
    end

    describe "delete/users #delete" do
        context "When user not signed in" do
            before do 
                delete :destroy, params:{id: user.id}
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When redirects to invalid id" do
            before do 
                sign_in current_user_login
                delete :destroy, params:{id: 0}
            end
            it "notices 'invalid id'" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                delete :destroy, params: {id: user.id}
            end
            it "redirects to user profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer" do
            before do 
                sign_in sub_officer
                delete :destroy, params: {id: user.id}
            end
            it "redirects to sub-officer profile page" do
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as officer" do
            before do 
                sign_in current_officer_login
                delete :destroy, params: {id: anotherUser.id}
            end
            it "user deleted successfully" do
                expect(response).to have_http_status(302)
            end
        end
    end



end