require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = users(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post products_url, params: {product: {avatar: @product.avatar, name: @product.name } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show user" do
    get product_url(@product)
    assert_response :success
  end

  test "should get TempNULLedit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update user" do
    patch product_url(@product), params: {product: {avatar: @product.avatar, name: @product.name } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
