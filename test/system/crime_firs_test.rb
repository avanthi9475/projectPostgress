require "application_system_test_case"

class CrimeFirsTest < ApplicationSystemTestCase
  setup do
    @crime_fir = crime_firs(:one)
  end

  test "visiting the index" do
    visit crime_firs_url
    assert_selector "h1", text: "Crime Firs"
  end

  test "creating a Crime fir" do
    visit crime_firs_url
    click_on "New Crime Fir"

    fill_in "Crime category", with: @crime_fir.crime_category
    fill_in "Datetime of crime", with: @crime_fir.dateTime_of_crime
    fill_in "Under section", with: @crime_fir.under_section
    fill_in "User", with: @crime_fir.user_id
    click_on "Create Crime fir"

    assert_text "Crime fir was successfully created"
    click_on "Back"
  end

  test "updating a Crime fir" do
    visit crime_firs_url
    click_on "Edit", match: :first

    fill_in "Crime category", with: @crime_fir.crime_category
    fill_in "Datetime of crime", with: @crime_fir.dateTime_of_crime
    fill_in "Under section", with: @crime_fir.under_section
    fill_in "User", with: @crime_fir.user_id
    click_on "Update Crime fir"

    assert_text "Crime fir was successfully updated"
    click_on "Back"
  end

  test "destroying a Crime fir" do
    visit crime_firs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Crime fir was successfully destroyed"
  end
end
