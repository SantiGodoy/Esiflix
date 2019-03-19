require 'test_helper'

class Admin::ProducerControllerTest < ActionDispatch::IntegrationTest
  fixtures :producers

  test "new" do
    get '/admin/producer/new'
    assert_response :success
  end

  test "create" do
    num_producers = Producer.count
    post '/admin/producer/create', :params => { :producer => { :name => 'Marvel Comics' }}
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert_equal num_producers + 1, Producer.count
  end

  test "edit" do
    get '/admin/producer/edit', :params => { :id => 1 }
    assert_select 'input' do
      assert_select '[type=?]', 'text'
      assert_select '[name=?]', 'producer[name]'
      assert_select '[value=?]', 'Apress'
    end
  end

  test "update" do
    post '/admin/producer/update', :params => { :id => 1, :producer => { :name => 'Apress.com' }}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
    assert_equal 'Apress.com', Producer.find(1).name
  end

  test "destroy" do
    assert_difference(Producer, :count, -1) do
      post '/admin/producer/destroy', :params => { :id => 1 }
      assert_equal flash[:notice], 'Productora Apress eliminada correctamente.'
      assert_response :redirect
      assert_redirected_to :action => 'index'
      get '/admin/producer/index'
      assert_response :success
      assert_select 'div#notice', 'Productora Apress eliminada correctamente.'
    end
  end

  test "show" do
    get '/admin/producer/show', :params => { :id => 1 }
    assert_response :success
    assert_template 'admin/producer/show'
    assert_not_nil assigns(:producer)
    assert assigns(:producer).valid?
    assert_select 'div#content' do
      assert_select 'h1', Producer.find(1).name
    end
  end

  test "index" do
    get '/admin/producer/index'
    assert_response :success
    assert_select 'table' do
      assert_select 'tr', Producer.count + 1
    end
    Producer.find_each do |a|
      assert_select 'td', a.name
    end
  end
end
