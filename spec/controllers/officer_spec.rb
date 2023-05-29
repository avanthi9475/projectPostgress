require 'rails_helper'

RSpec.describe OfficersController do
    let!(:current_user_login) {create(:user_login, role:'user')}
    let!(:user) {create(:user, email:current_user_login.email)}
    let!(:anotherUser) {create(:user)}
    let!(:current_officer_login) {create(:user_login, role:'officer')}
    let!(:officer) {create(:officer, email:current_officer_login.email)}
    let!(:sub_officer) {create(:user_login, role:'officer')}
    let!(:subofficer) {create(:officer, email:sub_officer.email, role: 'Inspector')}
    let!(:complaint) {create(:complaint, user_id: user.id)}
    let!(:officers_complaint) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}


    describe "get/officers #index" do
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

        context "When signed in as sub officer" do
            it "redirects to sub-officers profile index" do
                sign_in sub_officer
                get :index
                expect(response).to redirect_to subofficer
            end
        end
    end

    describe "get/officers #show" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :show, params:{id: officer.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :show, params:{id: officer.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as officer and renders the other officers profile page" do
            it "redirects to current officer profile page" do
                sign_in sub_officer
                get :show, params:{id: officer.id}
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as head officer" do
            it "redirects to officers profile page" do
                sign_in current_officer_login
                get :show, params:{id: officer.id}
                expect(response).to have_http_status(200)
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
            it "redirects to user profile page" do
                sign_in current_user_login
                get :new
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to sub officer profile page" do
                sign_in sub_officer
                get :new
                expect(response).to redirect_to subofficer
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

    describe "get/officers #edit" do
        context "When user not signed in" do
            it "redirects to login page" do
                put :edit , params:{id: officer.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to users profile page" do
                sign_in current_user_login
                get :edit, params:{id: officer.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "redirects to officers edit page" do
                sign_in current_officer_login
                get :edit, params:{id: officer.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer and try's to edit other officers page" do
            it "redirects to sub-officer profile page" do
                sign_in sub_officer
                get :edit, params:{id: officer.id}
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as sub-officer and try's to edit his details" do
            it "redirects to subofficer edit page" do
                sign_in sub_officer
                get :edit, params:{id: subofficer.id}
                expect(response).to have_http_status(200)
            end
        end
    end

    
    describe "get/officers #viewRequestMsg" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :viewRequestMsg
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :viewRequestMsg
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to request message page" do
                sign_in sub_officer
                 get :viewRequestMsg
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            it "redirects to request message page" do
                sign_in current_officer_login
                 get :viewRequestMsg
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "post/officers #create" do
        context "When user not signed in" do
            it "redirects to login page" do
                post :create, params:{officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                post :create, params:{officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to sub officer profile page" do
                sign_in sub_officer
                post :create, params:{officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as head-officer" do
            it "creates new officer successfully" do
                sign_in current_officer_login
                post :create, params:{officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' }}
                expect(response).to redirect_to Officer.last
            end
        end
    end

    describe "patch/officers #update" do
        context "When user not signed in" do
            it "redirects to login page" do
                patch :update , params:{id: officer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to users profile page" do
                sign_in current_user_login
                patch :update , params:{id: officer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "officer updated successfully" do
                sign_in current_officer_login
                patch :update , params:{id: officer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
                expect(response).to redirect_to officer
            end
        end

        context "When signed in as sub-officer and try's to edit other officers page" do
            it "redirects to sub-officer profile page" do
                sign_in sub_officer
                patch :update , params:{id: officer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as sub-officer and try's to edit his details" do
            it "redirects to subofficer edit page" do
                sign_in sub_officer
                patch :update , params:{id: subofficer.id, officer:{email: 'officer@example.com', name: 'Avanthika', age:23, location:'Coimbatore', password:'123456', role:'Inspector' } }
                expect(response).to redirect_to subofficer
            end
        end
    end


end