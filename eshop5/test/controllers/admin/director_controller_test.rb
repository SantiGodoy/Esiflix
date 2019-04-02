require 'test_helper'

class Admin::DirectorControllerTest < ActionDispatch::IntegrationTest
fixtures :directors

  test "new" do
    get '/admin/director/new'
    assert_template 'admin/director/new'
    assert_select 'div#content' do
      assert_select 'h1', 'Crear nuevo director'
      assert_select "form[action=\"/admin/director/create\"]"
    end
  end

  test "create" do
    get '/admin/director/new'
    assert_template 'admin/director/new'
    assert_difference(Director, :count) do
      post '/admin/director/create', :params => { :director => { :first_name => 'Jon', :last_name => 'Anderson' }}
      assert_response :redirect
      assert_redirected_to :action => 'index'      
    end
    assert_equal 'Director Jon Anderson creado correctamente.', flash[:notice]
  end

  test "failing_create" do
    assert_no_difference(Director, :count) do
      post '/admin/director/create', :params => { :director => { :first_name => 'Jon' }}
      assert_response :success
      assert_template 'admin/director/new'
      assert_select "div[class=\"field_with_errors\"]"
    end
  end

  test "edit" do
    get '/admin/director/edit', :params => { :id => 1 }
    assert_select 'input' do
      assert_select '[type=?]', 'text'
      assert_select '[name=?]', 'director[first_name]'
      assert_select '[value=?]', 'Joel'
    end
    assert_select 'input' do
      assert_select '[type=?]', 'text'
      assert_select '[name=?]', 'director[last_name]'
      assert_select '[value=?]', 'Spolsky'
    end
  end

  test "update" do
    post '/admin/director/update', :params => { :id => 1, :director => { :first_name => 'Joseph', :last_name => 'Anderson' }}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
    director = Director.find(1)
    assert_equal 'Joseph', director.first_name
    assert_equal 'Anderson', director.last_name
  end

  test "test_destroy" do
    assert_difference(Director, :count, -1) do
      post '/admin/director/destroy', :params => { :id => 1 }
      assert_equal flash[:notice], 'Director Joel Spolsky eliminado correctamente.'
      assert_response :redirect
      assert_redirected_to :action => 'index'
      get '/admin/director/index'
      assert_response :success
      assert_select 'div#notice', 'Director Joel Spolsky eliminado correctamente.'
    end
  end

  test "show" do
    get '/admin/director/show', :params => { :id => 1 }
    assert_template 'admin/director/show'
    assert_equal 'Joel', assigns(:director).first_name
    assert_equal 'Spolsky', assigns(:director).last_name
    assert_select 'div#content' do
      assert_select 'h1', Director.find(1).name
    end
  end

  test "index" do
    get '/admin/director/index'
    assert_response :success
    assert_select 'table' do
      assert_select 'tr', Director.count + 1
    end
    Director.find_each do |a|
      assert_select 'td', a.name
    end
  end
end
