require 'test_helper'

class IncompatiblesControllerTest < ActionController::TestCase
  setup do
    @incompatible = incompatibles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incompatibles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incompatible" do
    assert_difference('Incompatible.count') do
      post :create, incompatible: { incompatibility_id: @incompatible.incompatibility_id, mate_id: @incompatible.mate_id }
    end

    assert_redirected_to incompatible_path(assigns(:incompatible))
  end

  test "should show incompatible" do
    get :show, id: @incompatible
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @incompatible
    assert_response :success
  end

  test "should update incompatible" do
    patch :update, id: @incompatible, incompatible: { incompatibility_id: @incompatible.incompatibility_id, mate_id: @incompatible.mate_id }
    assert_redirected_to incompatible_path(assigns(:incompatible))
  end

  test "should destroy incompatible" do
    assert_difference('Incompatible.count', -1) do
      delete :destroy, id: @incompatible
    end

    assert_redirected_to incompatibles_path
  end
end
