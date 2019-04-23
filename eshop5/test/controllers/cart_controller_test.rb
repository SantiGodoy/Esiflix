require 'test_helper'

class CartControllerTest < ActionDispatch::IntegrationTest
  fixtures :directors, :producers, :films

  test "add" do
    assert_difference(CartItem, :count) do
      post '/cart/add', :params => { :id => 4 }
    end
    assert_response :redirect
    assert_redirected_to :controller => 'catalog'
    assert_equal 1, Cart.find(@request.session[:cart_id]).cart_items.size
  end

  test "remove" do
    post '/cart/add', :params => { :id => 4 }
    assert_equal [Film.find(4)], Cart.find(@request.session[:cart_id]).films

    post '/cart/remove', :params => { :id => 4 }
    assert_equal [], Cart.find(@request.session[:cart_id]).films
  end

  test "clear" do
    post '/cart/add', :params => { :id => 4 }
    assert_equal [Film.find(4)], Cart.find(@request.session[:cart_id]).films

    post '/cart/clear'
    assert_response :redirect
    assert_redirected_to :controller => 'catalog'
    assert_equal [], Cart.find(@request.session[:cart_id]).films
  end
end
