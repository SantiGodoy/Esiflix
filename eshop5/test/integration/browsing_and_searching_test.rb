require 'test_helper'

class BrowsingAndSearchingTest < ActionDispatch::IntegrationTest
  fixtures :producers, :directors, :films, :directors_films

  test "browse" do
    jill = new_session_as :jill
    jill.index
    jill.second_page
    jill.film_details 'Pride and Prejudice'
    jill.latest_films
    jill.reads_rss
  end

  module BrowsingTestDSL
    include ERB::Util
    attr_writer :name

    def index
      get '/catalog/index'
      assert_response :success
      assert_select 'dl#films' do
        assert_select 'dt', :count => 5
      end
      assert_select 'dt' do
        assert_select 'a', 'The Idiot'
      end
      check_film_links
    end

    def second_page
      get '/catalog/index?page=2'
      assert_response :success
      assert_template 'catalog/index'
      assert_equal Film.find_by_title('Pro Rails E-Commerce'),
                   assigns(:films).last
      check_film_links
    end

    def film_details(title)
      @film = Film.where(:title => title).first
      get "/catalog/show/#{@film.id}"
      assert_response :success
      assert_template 'catalog/show'
      assert_select 'div#content' do
        assert_select 'h1', @film.title
        assert_select 'h2', "por #{@film.directors.map{|a| a.name}.join(", ")}"
      end
    end

    def latest_films
      get '/catalog/latest'
      assert_response :success
      assert_template 'catalog/latest'
      assert_select 'dl#films' do
        assert_select 'dt', :count => 5
      end
      @films = Film.latest(5)
      @films.each do |a|
        assert_select 'dt' do
          assert_select 'a', a.title
        end
      end
    end
  end

  def check_film_links
    for film in assigns :films
      assert_select 'a' do
        assert_select '[href=?]', "/catalog/show/#{film.id}"
      end
    end
  end

  def new_session_as(name)
    open_session do |session|
      session.extend(BrowsingTestDSL)
      session.name = name
      yield session if block_given?
    end
  end

  def reads_rss
    get "/catalog/rss"
    assert_response :success
    assert_template "catalog/rss"
    assert_match "application/xml", response.headers["Content-Type"]

    assert_select 'channel' do
      assert_select 'item', :count => 5
    end

    @films = Film.latest(5)
    @films.each do |film|
      assert_select 'item' do
        assert_select 'title', film.title
      end
    end
  end
end
