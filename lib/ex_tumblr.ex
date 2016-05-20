defmodule ExTumblr do
  defmodule Credentials do
    defstruct consumer_key: nil, consumer_secret: nil, token: nil, token_secret: nil
  end

  defmodule Blog do
    @hostname Application.get_env :ex_tumblr, :hostname

    def info(blog_identifier, credentials) do
      {:get, "#{@hostname}/v2/blog/#{identifier}/info", %{}, :api_key_auth, credentials}
    end

    def avatar(blog_identifier, size \\ 64) when size in [16, 24, 30, 40, 48, 64, 96, 128, 512] do
      {:get, "#{@hostname}/v2/blog/#{identifier}/avatar/size", %{size: size}, :no_auth, nil}
    end

    def followers(blog_identifier, credentials) do
      {:get, "#{@hostname}/v2/blog/#{identifier}/followers", %{}, :oauth, credentials}
    end

    def likes(blog_identifier, credentials) do
      {:get, "#{@hostname}/v2/blog/#{identifier}/likes", %{}, :api_key_auth, credentials}
    end

    def posts(blog_identifier, credentials) do
      {:get, "#{@hostname}/v2/blog/#{identifier}/posts", %{}, :api_key_auth, credentials}
    end

    def queued_posts(blog_identifier, credentials) do
      {:get, "#{@hostname}/v2/blog/#{identifier}/posts/queue", %{}, :oauth, credentials}
    end

    def drafts(blog_identifier, credentials) do
      {:get, "#{@hostname}/v2/blog/#{identifier}/posts/drafts", %{}, :oauth, credentials}
    end

    def submissions(blog_identifier, credentials) do
      {:get, "#{@hostname}/v2/blog/#{blog_identifier}/posts/submission", %{}, :oauth, credentials}
    end

    def create(blog_identifier, credentials) do
      {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post", %{}, :oauth, credentials}
    end

    def edit(blog_identifier, credentials) do
      {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post/edit", %{}, :oauth, credentials}
    end

    def reblog(blog_identifier, credentials) do
      {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post/reblog", %{}, :oauth, credentials}
    end

    def delete(blog_identifier, credentials) do
      {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post/delete", %{}, :oauth, credentials}
    end
  end

  defmodule User do
    @hostname Application.get_env :ex_tumblr, :hostname

    def info(credentials) do
      {:get, "#{@hostname}/v2/user/info", %{}, :oauth, credentials}
    end

    def dashboard(credentials) do
      {:get, "#{@hostname}/v2/user/dashboard", %{}, :oauth, credentials}
    end

    def likes(credentials) do
      {:get, "#{@hostname}/v2/user/likes", %{}, :oauth, credentials}
    end

    def following(credentials) do
      {:get, "#{@hostname}/v2/user/following", %{}, :oauth, credentials}
    end
  end

  def request({method, uri, params, auth_type, credentials}) do
  end
end
