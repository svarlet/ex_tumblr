defmodule ExTumblr.Validator do
  import ExTumblr.Utils.StringExtras, only: [blank?: 1]

  @nil_blog_id Application.get_env :ex_tumblr, :nil_blog_identifier
  @blank_blog_id Application.get_env :ex_tumblr, :blank_blog_identifier
  @nil_api_key Application.get_env :ex_tumblr, :nil_api_key
  @blank_api_key Application.get_env :ex_tumblr, :blank_api_key

  def validate_blog_identifier(blog_identifier) do
    cond do
      is_nil blog_identifier -> {:error, @nil_blog_id}
      blank? blog_identifier -> {:error, @blank_blog_id}
      true -> {:ok, blog_identifier}
    end
  end

  def validate_api_key(api_key) do
    cond do
      is_nil api_key -> {:error, @nil_api_key}
      blank? api_key -> {:error, @blank_api_key}
      true -> {:ok, api_key}
    end
  end
end
