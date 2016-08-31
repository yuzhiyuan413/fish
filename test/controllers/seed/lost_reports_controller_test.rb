require 'test_helper'

class Seed::LostReportsControllerTest < ActionController::TestCase
  setup do
    @seed_lost_report = seed_lost_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seed_lost_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create seed_lost_report" do
    assert_difference('Seed::LostReport.count') do
      post :create, seed_lost_report: {  }
    end

    assert_redirected_to seed_lost_report_path(assigns(:seed_lost_report))
  end

  test "should show seed_lost_report" do
    get :show, id: @seed_lost_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @seed_lost_report
    assert_response :success
  end

  test "should update seed_lost_report" do
    patch :update, id: @seed_lost_report, seed_lost_report: {  }
    assert_redirected_to seed_lost_report_path(assigns(:seed_lost_report))
  end

  test "should destroy seed_lost_report" do
    assert_difference('Seed::LostReport.count', -1) do
      delete :destroy, id: @seed_lost_report
    end

    assert_redirected_to seed_lost_reports_path
  end
end
