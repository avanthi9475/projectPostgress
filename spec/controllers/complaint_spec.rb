require 'rails_helper'

RSpec.describe ComplaintsController do
    let!(:current_user_login) {create(:user_login, role:'user')}
    let!(:user) {create(:user, email:current_user_login.email)}

    let!(:anotherUser) {create(:user)}

    let!(:current_officer_login) {create(:user_login, role:'officer')}
    let!(:officer) {create(:officer, email:current_officer_login.email)}

    let!(:sub_officer) {create(:user_login, role:'officer')}
    let!(:subofficer) {create(:officer, email:sub_officer.email, role: 'Inspector')}

    let!(:complaint) {create(:complaint, user_id: user.id)}
    let!(:officers_complaint1) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}
    
    let!(:complaint2) {create(:complaint, user_id: anotherUser.id)}
    let!(:officers_complaint2) {create(:officers_complaint, complaint_id:complaint2.id, officer_id:officer.id)}


    describe "get/complaints #index" do
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
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/complaints #show" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :show, params:{id: complaint.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user complaints page" do
                sign_in current_user_login
                get :show, params:{id: complaint.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and tries to access other users complaints" do
            it "redirects to user complaints page" do
                sign_in current_user_login
                get :show, params:{id: complaint2.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "redirects to complaints page" do
                sign_in current_officer_login
                get :show, params:{id: complaint.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer" do
            it "redirects to sub-officers complaints page" do
                sign_in sub_officer
                get :show, params:{id: complaint.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and tries to access others officers complaints" do
            it "redirects to sub-officer profile page" do
                sign_in sub_officer
                get :show, params:{id: complaint2.id}
                expect(response).to redirect_to subofficer
            end
        end
    end

    describe "get/complaints #new" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :new
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to complaints#new page" do
                sign_in current_user_login
                get :new
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to complaints#new page" do
                sign_in sub_officer
                get :new
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            it "redirects to complaints#new page" do
                sign_in current_officer_login
                get :new
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/complaints #edit" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :edit, params:{id: complaint.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user complaints page" do
                sign_in current_user_login
                get :edit, params:{id: complaint.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and tries to edit other users complaints" do
            it "redirects to user complaints page" do
                sign_in current_user_login
                get :edit, params:{id: complaint2.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "redirects to complaints page" do
                sign_in current_officer_login
                get :edit, params:{id: complaint.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer" do
            it "redirects to sub-officers complaints page" do
                sign_in sub_officer
                get :edit, params:{id: complaint.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and tries to edit others officers complaints" do
            it "redirects to sub-officer profile page" do
                sign_in sub_officer
                get :edit, params:{id: complaint2.id}
                expect(response).to redirect_to subofficer
            end
        end
    end

    
    describe "get/complaints #handledByOfficer" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :handledByOfficer, params: {id: complaint.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user and checks for their own complaint" do
            it "redirects to handledByOfficers page" do
                sign_in current_user_login
                get :handledByOfficer, params: {id: complaint.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as user and checks for others complaint" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :handledByOfficer, params: {id: complaint2.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer and checks for his own complaint" do
            it "redirects to handled by officers page" do
                sign_in sub_officer
                 get :handledByOfficer, params: {id: complaint.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer and checks for others complaint" do
            it "redirects to officer profile page" do
                sign_in sub_officer
                 get :handledByOfficer, params: {id: complaint2.id}
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as head-officer" do
            it "redirects tohandled by officers page" do
                sign_in current_officer_login
                 get :handledByOfficer, params: {id: complaint2.id}
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/complaints #mycomplaints" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :mycomplaints
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :mycomplaints
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub-officer" do
            it "redirects to request message page" do
                sign_in sub_officer
                 get :mycomplaints
                expect(response).to redirect_to subofficer
            end
        end

        context "When signed in as head-officer" do
            it "redirects to request message page" do
                sign_in current_officer_login
                 get :mycomplaints
                expect(response).to redirect_to officer
            end
        end
    end

    describe "post/users #create" do
        context "When user not signed in" do
            it "redirects to login page" do
                post :create, params:{complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "creates new complaint successfully" do
                sign_in current_user_login
                post :create, params:{complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to Complaint.last
            end
        end

        context "When signed in as sub-officer" do
            it "creates new complaint successfully" do
                sign_in sub_officer
                post :create, params:{complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to Complaint.last
            end
        end

        context "When signed in as head-officer" do
            it "creates new complaint successfully" do
                sign_in sub_officer
                post :create, params:{complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to Complaint.last
            end
        end
    end

    describe "patch/complaints #update" do
        context "When user not signed in" do
            it "redirects to login page" do
                patch :update, params:{id: complaint.id, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user complaints page" do
                sign_in current_user_login
                patch :update, params:{id: complaint.id, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to complaint
            end
        end

        context "When signed in as user and tries to update other users complaints" do
            it "complaint updated successfully" do
                sign_in current_user_login
                patch :update, params:{id: complaint2.id, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "complaint updated successfully" do
                sign_in current_officer_login
                patch :update, params:{id: complaint.id, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to complaint
            end
        end

        context "When signed in as sub officer" do
            it "complaint updated successfully" do
                sign_in sub_officer
                patch :update, params:{id: complaint.id, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to complaint
            end
        end

        context "When signed in as sub officer and tries to edit others officers complaints" do
            it "redirects to sub-officer profile page" do
                sign_in sub_officer
                patch :update, params:{id: complaint2.id, complaint:{user_id: user.id, statement: 'Please update about my complaint status', location:'Coimbatore', dateTime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to subofficer
            end
        end
    end

end