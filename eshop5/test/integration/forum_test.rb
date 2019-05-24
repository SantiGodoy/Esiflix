require File.dirname(__FILE__) + '/../test_helper'

class ForumTest < ActionDispatch::IntegrationTest

  test "forum" do
    jill = new_session_as(:jill)
    george = new_session_as(:george)
    post = jill.post_to_forum :post => {
      :name => 'Bookworm',
      :subject => 'Downtime',
      :body => 'Emporium is down again!'
    }
    george.view_forum
    jill.view_forum
    george.view_post post
    george.reply_to_post(post, :post => {
      :name => 'George',
      :subject => 'Rats!',
      :body => 'Rats!!!!!!!!'
    })
    george.delete_post(post)
  end

  private

  module ForumTestDSL
    attr_writer :name

    def post_to_forum(parameters)
      get '/forum/post'
      assert_response :success
      assert_template 'forum/post'
      post '/forum/create', :params => parameters
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert_template 'forum/index'
      return ForumPost.find_by_subject(parameters[:post][:subject])
    end

    def view_forum
      get '/forum'
      assert_response :success
      assert_template 'forum/index'
      assert_select 'div#content' do
        assert_select 'h1', 'Foro'
        assert_select 'a', 'Nuevo post'
      end
    end

    def view_post(post)
      get "/forum/show/?id=#{post.id}"
      assert_response :success
      assert_template 'forum/show'
      assert_select 'div#content' do
        assert_select 'h1', "\'#{post.subject}\'"
      end
    end

    def reply_to_post(post, parameters)
      get "/forum/reply/?id=#{post.id}"
      assert_response :success
      assert_select 'div#content' do
        assert_select 'h1', "Responder a \'#{post.subject}\'"
      end
      post '/forum/create', :params => { :post => { :name => parameters[:post][:name],
                                                    :subject => parameters[:post][:subject],
                                                    :body => parameters[:post][:body], :parent_id => post.id }}
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert_template 'forum/index'
      assert_select 'table' do
        assert_select 'a', parameters[:post][:subject]
      end
    end

    def delete_post(post)
      num_posts = ForumPost.count
      post "/forum/destroy/?id=#{post.id}"
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert_template 'forum/index'
      assert_select 'div#notice', "El post \'#{post.subject}\' fue borrado al completo correctamente."
      assert_equal ForumPost.count, num_posts - 1
    end
  end

  def new_session_as(name)
    open_session do |session|
      session.extend(ForumTestDSL)
      session.name = name
      yield session if block_given?
    end
  end
end
