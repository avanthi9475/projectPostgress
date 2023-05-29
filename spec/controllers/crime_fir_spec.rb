require 'rails_helper'

RSpec.describe CrimeFirsController do
    let!(:current_user_login) {create(:user_login, role:'user')}
    let!(:user) {create(:user, email:current_user_login.email)}

    let!(:anotherUser) {create(:user)}

    let!(:current_officer_login) {create(:user_login, role:'officer')}
    let!(:officer) {create(:officer, email:current_officer_login.email)}

    let!(:sub_officer) {create(:user_login, role:'officer')}
    let!(:subofficer) {create(:officer, email:sub_officer.email, role: 'Inspector')}

    let!(:complaint) {create(:complaint, user_id: user.id)}
    let!(:crime_fir1) {create(:crime_fir, user_id: user.id, complaint_id:complaint.id)}
    let!(:status1) {create(:status, statusable_id:crime_fir1.id, statusable_type: 'CrimeFir', status: 'Inprogress')}
    let!(:officers_complaint1) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}

    let!(:complaint2) {create(:complaint, user_id: anotherUser.id)}
    let!(:officers_complaint2) {create(:officers_complaint, complaint_id:complaint2.id, officer_id:officer.id)}
    let!(:crime_fir2) {create(:crime_fir, user_id: anotherUser.id, complaint_id:complaint2.id)}
    let!(:status2) {create(:status, statusable_id:crime_fir2.id, statusable_type: 'CrimeFir', status: 'Inprogress')}

    describe "get/crime_firs #index" do
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

    describe "get/crime_firs #show" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :show, params:{id: crime_fir1.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :show, params:{id: crime_fir1.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "redirects to crime fir page" do
                sign_in current_officer_login
                get :show, params:{id: crime_fir1.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and trie to access their crime_fir" do
            it "redirects to sub-officers complaints page" do
                sign_in sub_officer
                get :show, params:{id: crime_fir1.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and tries to access others officers complaints" do
            it "redirects to sub-officer profile page" do
                sign_in sub_officer
                get :show, params:{id: crime_fir2.id}
                expect(response).to redirect_to subofficer
            end
        end
    end

    describe "get/crime_fir #new" do
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
            it "redirects to crime_fir#new page" do
                sign_in sub_officer
                get :new
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            it "redirects to crime_fir#new page" do
                sign_in current_officer_login
                get :new
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/crime_fir #edit" do
        context "When user not signed in" do
            it "redirects to login page" do
                get :edit, params:{id: crime_fir1.id}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                get :edit, params:{id: crime_fir1.id}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "redirects to crime fir edit page" do
                sign_in current_officer_login
                get :edit, params:{id: crime_fir1.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and access their own FIR" do
            it "redirects to crime fir edit page" do
                sign_in sub_officer
                get :edit, params:{id: crime_fir1.id}
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and tries to edit others officers FIR" do
            it "redirects to sub-officer profile page" do
                sign_in sub_officer
                get :show, params:{id: crime_fir2.id}
                expect(response).to redirect_to subofficer
            end
        end
    end

    describe "get/crime_fir #create" do
        context "When user not signed in" do
            it "redirects to login page" do
                post :create, params: {crime_fir: {user_id:user.id, complaint_id:complaint.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                post :create, params: {crime_fir: {user_id:user.id, complaint_id:complaint.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as sub-officer" do
            let(:complaint_sub_officer) {create(:complaint, user_id:user.id)}
            it "crime fir created successfully" do
                sign_in sub_officer
                post :create, params: {crime_fir: {user_id:user.id, complaint_id:complaint_sub_officer.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to CrimeFir.last
            end
        end

        context "When signed in as head-officer" do
            let(:head_officer) {create(:complaint, user_id:user.id)}
            it "crime fir created successfully" do
                sign_in current_officer_login
                post :create, params: {crime_fir: {user_id:anotherUser.id, complaint_id:head_officer.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to CrimeFir.last
            end
        end
    end

    describe "patch/crime_fir #update" do
        context "When user not signed in" do
            it "redirects to login page" do
                patch :update, params:{id: crime_fir1.id, crime_fir: {user_id:user.id, complaint_id:complaint.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to new_user_login_session_path
            end
        end

        context "When signed in as user" do
            it "redirects to user profile page" do
                sign_in current_user_login
                patch :update, params:{id: crime_fir1.id, crime_fir: {user_id:user.id, complaint_id:complaint.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to user
            end
        end

        context "When signed in as head officer" do
            it "crime fir updated successfully" do
                sign_in current_officer_login
                patch :update, params:{id: crime_fir1.id, crime_fir: {user_id:user.id, complaint_id:complaint.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08", status: "Inprogress" }}
                expect(response).to redirect_to crime_fir1
            end
        end

        context "When signed in as sub officer and access their own FIR" do
            it "crime fir updated successfully" do
                sign_in sub_officer
                patch :update, params:{id: crime_fir1.id, crime_fir: {user_id:user.id, complaint_id:complaint.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" , status: "Inprogress"}}
                expect(response).to redirect_to crime_fir1
            end
        end

        context "When signed in as sub officer and tries to update others officers FIR" do
            it "redirects to sub-officer profile page" do
                sign_in sub_officer
                patch :update, params:{id: crime_fir2.id, crime_fir: {user_id:anotherUser.id, complaint_id:complaint2.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
                expect(response).to redirect_to subofficer
            end
        end
    end

end