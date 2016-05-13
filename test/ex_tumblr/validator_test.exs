defmodule ExTumblr.ValidatorTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Validator

  @nil_blog_id Application.get_env :ex_tumblr, :nil_blog_identifier
  @blank_blog_id Application.get_env :ex_tumblr, :blank_blog_identifier
  @nil_api_key Application.get_env :ex_tumblr, :nil_api_key
  @blank_api_key Application.get_env :ex_tumblr, :blank_api_key

  test "A nil blog identifier is invalid" do
    assert {:error, @nil_blog_id} = Validator.validate_blog_identifier nil
  end

  test "A blank blog identifier is invalid" do
    assert {:error, @blank_blog_id} = Validator.validate_blog_identifier("")
    assert {:error, @blank_blog_id} = Validator.validate_blog_identifier(" \t  \r")
  end

  test "A nil api key is invalid" do
    assert {:error, @nil_api_key} = Validator.validate_api_key(nil)
  end

  test "A blank api key is invalid" do
    assert {:error, @blank_api_key} = Validator.validate_api_key("")
    assert {:error, @blank_api_key} = Validator.validate_api_key(" \t \r")
  end
end
