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

  test "add_xhr" do
    assert_difference(CartItem, :count) do
      post '/cart/add', :params => { :id => 4 }, :xhr => true
    end
    assert_response :success
    assert_select_jquery :html, '#shopping_cart' do
      assert_select 'li#cart_item_4', /Pro Rails E-Commerce 4th Edition/
    end
    assert_equal 1, Cart.find(@request.session[:cart_id]).cart_items.size
  end
  
  test "remove" do
    post '/cart/add', :params => { :id => 4 }
    assert_equal [Film.find(4)], Cart.find(@request.session[:cart_id]).films

    post '/cart/remove', :params => { :id => 4 }
    assert_equal [], Cart.find(@request.session[:cart_id]).films
  end

  test "remove_xhr" do
    post '/cart/add', :params => { :id => 4 }
    assert_equal [Film.find(4)], Cart.find(@request.session[:cart_id]).films
    
    post '/cart/remove', :params => { :id => 4 }, :xhr => true
    assert_select_jquery :html, '#shopping_cart' do
      assert_select 'li#cart_item_4', false, /Pro Rails E-Commerce 4th Edition/
    end
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

  test "clear_xhr" do
    post '/cart/add', :params => { :id => 4 }
    assert_equal [Film.find(4)], Cart.find(@request.session[:cart_id]).films
    
    post '/cart/clear', :xhr => true
    assert_response :success
    assert_select_jquery :html, '#shopping_cart' do
      assert_select 'li#cart_item_4', false, /Pro Rails E-Commerce 4th Edition/
    end
    assert_equal [], Cart.find(@request.session[:cart_id]).films
  end
end
