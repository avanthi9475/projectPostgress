require "test_helper"

class CrimeFirsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crime_fir = crime_firs(:one)
  end

  test "should get index" do
    get crime_firs_url
    assert_response :success
  end

  test "should get new" do
    get new_crime_fir_url
    assert_response :success
  end

  test "should create crime_fir" do
    assert_difference('CrimeFir.count') do
      post crime_firs_url, params: { crime_fir: { crime_category: @crime_fir.crime_category, dateTime_of_crime: @crime_fir.dateTime_of_crime, under_section: @crime_fir.under_section, user_id: @crime_fir.user_id } }
    end

    assert_redirected_to crime_fir_url(CrimeFir.last)
  end

  test "should show crime_fir" do
    get crime_fir_url(@crime_fir)
    assert_response :success
  end

  test "should get edit" do
    get edit_crime_fir_url(@crime_fir)
    assert_response :success
  end

  test "should update crime_fir" do
    patch crime_fir_url(@crime_fir), params: { crime_fir: { crime_category: @crime_fir.crime_category, dateTime_of_crime: @crime_fir.dateTime_of_crime, under_section: @crime_fir.under_section, user_id: @crime_fir.user_id } }
    assert_redirected_to crime_fir_url(@crime_fir)
  end

  test "should destroy crime_fir" do
    assert_difference('CrimeFir.count', -1) do
      delete crime_fir_url(@crime_fir)
    end

    assert_redirected_to crime_firs_url
  end
end
