require 'test_helper'

class TweetControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tweet_index_url
    assert_response :success
  end

  test "should get show" do
    get tweet_show_url
    assert_response :success
  end

  test "should get new" do
    get tweet_new_url
    assert_response :success
  end

  test "should get edit" do
    get tweet_edit_url
    assert_response :success
  end

end
