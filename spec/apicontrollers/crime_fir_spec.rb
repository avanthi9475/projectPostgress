require 'rails_helper'

RSpec.describe Api::CrimeFirsController , type: :request do
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
    let!(:crime_fir1) {create(:crime_fir, user_id: user.id, complaint_id:complaint.id)}
    let!(:status1) {create(:status, statusable_id:crime_fir1.id, statusable_type: 'CrimeFir', status: 'Inprogress')}
    let!(:officers_complaint1) {create(:officers_complaint, complaint_id:complaint.id, officer_id:subofficer.id)}

    let!(:complaint2) {create(:complaint, user_id: anotherUser.id)}
    let!(:officers_complaint2) {create(:officers_complaint, complaint_id:complaint2.id, officer_id:officer.id)}
    let!(:crime_fir2) {create(:crime_fir, user_id: anotherUser.id, complaint_id:complaint2.id)}
    let!(:status2) {create(:status, statusable_id:crime_fir2.id, statusable_type: 'CrimeFir', status: 'Inprogress')}

    describe "get/crime_firs #index" do
        context "When user not signed in" do
            before do 
                get "/api/crime_firs"
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do 
                get "/api/crime_firs", params: {access_token: user_token.token}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head officer" do
            before do 
                get "/api/crime_firs", params: {access_token: officer_token.token}
            end
            it "redirects to users index" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer" do
            before do 
                get "/api/crime_firs", params: {access_token: sub_officer_token.token}
            end
            it "redirects to sub-officers profile index" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "get/crime_firs #show" do
        context "When user not signed in" do
            before do 
                get "/api/crime_firs/#{crime_fir1.id}"
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do 
                get "/api/crime_firs/#{crime_fir1.id}", params: {access_token: user_token.token}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head officer" do
            before do 
                get "/api/crime_firs/#{crime_fir1.id}", params: {access_token: officer_token.token}
            end
            it "redirects to crime fir page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and trie to access their crime_fir" do
            before do 
                get "/api/crime_firs/#{crime_fir1.id}", params: {access_token: sub_officer_token.token}
            end
            it "redirects to sub-officers complaints page" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and tries to access others officers crime_fir" do
            before do 
                get "/api/crime_firs/#{crime_fir2.id}", params: {access_token: sub_officer_token.token}
            end
            it "redirects to sub-officer profile page" do
                expect(response).to have_http_status(403)
            end
        end
    end

    describe "get/crime_fir #create" do
        context "When user not signed in" do
            before do 
                post "/api/crime_firs"
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do 
                post "/api/crime_firs", params: {access_token: officer_token.token, crime_fir: {user_id:user.id, complaint_id:complaint.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as sub-officer" do
            let(:complaint_sub_officer) {create(:complaint, user_id:user.id)}
            before do 
                post "/api/crime_firs", params: {access_token: sub_officer_token.token, crime_fir: {user_id:user.id, complaint_id:complaint_sub_officer.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
            end
            it "crime fir created successfully" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as head-officer" do
            let(:head_officer) {create(:complaint, user_id:user.id)}
            before do 
                post "/api/crime_firs", params: {access_token: officer_token.token, crime_fir: {user_id:anotherUser.id, complaint_id:head_officer.id, under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
            end
            it "crime fir created successfully" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "patch/crime_fir #update" do
        context "When user not signed in" do
            before do 
                patch "/api/crime_firs/#{crime_fir1.id}", params:{crime_fir: {under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
            end
            it "redirects to login page" do
                expect(response).to have_http_status(401)
            end
        end

        context "When signed in as user" do
            before do 
                patch "/api/crime_firs/#{crime_fir1.id}", params:{access_token: user_token.token, crime_fir: {under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
            end
            it "redirects to user profile page" do
                expect(response).to have_http_status(403)
            end
        end

        context "When signed in as head officer" do
            before do 
                patch "/api/crime_firs/#{crime_fir1.id}", params:{access_token: officer_token.token, crime_fir: {under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08", status: "Inprogress" }}
            end
            it "crime fir updated successfully" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and access their own FIR" do
            before do 
                patch "/api/crime_firs/#{crime_fir1.id}", params:{access_token: sub_officer_token.token, crime_fir: { under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" , status: "Inprogress"}}
            end
            it "crime fir updated successfully" do
                expect(response).to have_http_status(200)
            end
        end

        context "When signed in as sub officer and tries to update others officers FIR" do
            before do 
                patch "/api/crime_firs/#{crime_fir2.id}", params:{access_token: sub_officer_token.token, crime_fir: { under_section:302, crime_category:'Robery', dateTime_of_crime: "2023-05-24 16:03:08" }}
            end
            it "redirects to sub-officer profile page" do
                expect(response).to have_http_status(403)
            end
        end
    end

end