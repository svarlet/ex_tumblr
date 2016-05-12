defmodule ExTumblr.BlogTest do
  use ExUnit.Case
  alias ExTumblr.Blog

  test "A string containing only whitespace characters is blank" do
    assert Blog.blank?("") == true
    assert Blog.blank?(" ") == true
    assert Blog.blank?("\t") == true
    assert Blog.blank?("\r") == true
    assert Blog.blank?("\r\n") == true
    assert Blog.blank?("\ ") == true
    assert Blog.blank?("\n") == true
    assert Blog.blank?("    ") == true
  end

  test "A string containing one non whitespace character is not blank" do
    assert Blog.blank?("a") == false
    assert Blog.blank?(" a ") == false
    assert Blog.blank?(" a") == false
    assert Blog.blank?("a ") == false
    assert Blog.blank?("1") == false
    assert Blog.blank?(" 1") == false
    assert Blog.blank?("1 ") == false
    assert Blog.blank?(" 1 ") == false
  end

  test "A nil blog identifier causes an error" do
    assert_failure_with nil, "api-key", "Nil is not a valid blog identifier."
  end

  defp assert_failure_with(blog_identifier, api_key, expected_reason) do
    assert {:error, reason} = Blog.info blog_identifier, api_key
    assert reason == expected_reason
  end

  test "A blank blog identifier causes an error" do
    assert_failure_with "", "api-key", "A blog identifier cannot be blank."
    assert_failure_with " \t  \r", "api-key", "A blog identifier cannot be blank."
  end

  test "A blank api key causes an error" do
    assert_failure_with "blog_identifier", "", "An api key cannot be blank."
    assert_failure_with "blog_identifier", " \t \r", "An api key cannot be blank."
  end

  test "A nil api key causes an error" do
    assert_failure_with "fake-blog-id", nil, "Nil is not a valid api key."
  end

  test "send_request/2 sends the specified request through the specified http client" do
    http_get_client = fn url -> send self(), {:request_sent, url} end
    Blog.send_request "dummy url", http_get_client
    assert_received {:request_sent, "dummy url"}
  end
end
