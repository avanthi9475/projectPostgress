require 'rails_helper'

RSpec.describe OfficersController do
    let!(:current_user_login) {create(:user_login, role:'user')}
    let!(:user) {create(:user, email:current_user_login.email)}
    let!(:anotherUser) {create(:user)}
    let!(:current_officer_login) {create(:user_login, role:'officer')}
    let!(:officer) {create(:officer, email:current_officer_login.email)}
    let!(:sub_officer) {create(:user_login, role:'officer')}
    let!(:subofficer) {create(:officer, email:sub_officer.email, role: 'Inspector')}


    describe "get/officers #index" do
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

        context "When signed in as sub officer" do
            before do 
                sign_in sub_officer
                get :index
            end
            it "redirects to sub-officers profile index" do
                expect(response).to redirect_to subofficer
            end
        end
    end

    describe "get/officers #show" do
        context "When user not signed in" do
            before do 
                get :show, params:{id: officer.id}
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
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
                get :show, params:{id: officer.id}
            end
            it "redirects to user profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as officer and renders the other officers profile page" do
            before do 
                sign_in sub_officer
                get :show, params:{id: officer.id}
            end
            it "redirects to current officer profile page" do
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as head officer" do
            before do 
                sign_in current_officer_login
                get :show, params:{id: officer.id}
            end
            it "redirects to officers profile page" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/officers #new" do
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
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer" do
            before do 
                sign_in sub_officer
                get :new
            end
            it "redirects to sub officer profile page" do
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as head-officer" do
            before do 
                sign_in current_officer_login
                get :new
            end
            it "redirects to new officer page" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/officers #edit" do
        context "When user not signed in" do
            before do 
                put :edit , params:{id: officer.id}
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
                get :edit, params:{id: officer.id}
            end
            it "redirects to users profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            before do 
                sign_in current_officer_login
                get :edit, params:{id: officer.id}
            end
            it "redirects to officers edit page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer and try's to edit other officers page" do
            before do 
                sign_in sub_officer
                get :edit, params:{id: officer.id}
            end
            it "redirects to sub-officer profile page" do
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as sub-officer and try's to edit his details" do
            before do 
                sign_in sub_officer
                get :edit, params:{id: subofficer.id}
            end
            it "redirects to subofficer edit page" do
                expect(response).to have_http_status(200)
            end
        end
    end

    
    describe "get/officers #viewRequestMsg" do
        context "When user not signed in" do
            before do 
                get :viewRequestMsg
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                get :viewRequestMsg
            end
            it "redirects to user profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer" do
            before do 
                sign_in sub_officer
                get :viewRequestMsg
            end
            it "redirects to request message page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            before do 
                sign_in current_officer_login
                get :viewRequestMsg
            end
            it "redirects to request message page" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "post/officers #create" do
        context "When user not signed in" do
            before do 
                post :create, params:{officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}
                expect(response).to redirect_to new_user_login_session_path
            end
            it "redirects to login page" do
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                post :create, params:{officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}
            end
            it "redirects to user profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer" do
            before do 
                sign_in sub_officer
                post :create, params:{officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}
            end
            it "redirects to sub officer profile page" do
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as head-officer" do
            before do 
                sign_in current_officer_login
                post :create, params:{officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}
            end
            it "creates new officer successfully" do
                expect(response).to redirect_to Officer.last
            end
        end
    end

    describe "patch/officers #update" do
        context "When user not signed in" do
            before do 
                patch :update , params:{id: officer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
            end
            it "redirects to login page" do
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When redirects to invalid id" do
            before do 
                sign_in current_user_login
                patch :update , params:{id: 0, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
            end
            it "notices 'invalid id'" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as user" do
            before do 
                sign_in current_user_login
                patch :update , params:{id: officer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
            end
            it "redirects to users profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            before do 
                sign_in current_officer_login
                patch :update , params:{id: officer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
            end
            it "officer updated succeallow(user).to receive(:confirmed_at).and_return(nil)ssfully" do
                expect(response).to redirect_to officer
            end
        end

        context "When signed in as sub-officer and try's to edit other officers page" do
            before do 
                sign_in sub_officer
                patch :update , params:{id: officer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
            end
            it "redirects to sub-officer profile page" do
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as sub-officer and try's to edit his details" do
            before do 
                sign_in sub_officer
                patch :update , params:{id: subofficer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
            end
            it "redirects to subofficer edit page" do
                expect(response).to redirect_to subofficer
            end
        end
    end

    describe "delete/officers #delete" do
        context "When user not signed in" do
            before do 
                delete :destroy, params:{id: subofficer.id}
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
                delete :destroy, params: {id: officer.id}
            end
            it "redirects to user profile page" do
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer" do
            before do 
                sign_in sub_officer
                delete :destroy, params: {id: officer.id}
            end
            it "redirects to sub-officer profile page" do
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as officer" do
            before do 
                sign_in current_officer_login
                delete :destroy, params: {id: subofficer.id}
            end
            it "officer deleted successfully" do
                expect(response).to have_http_status(302)
            end
        end
    end


end