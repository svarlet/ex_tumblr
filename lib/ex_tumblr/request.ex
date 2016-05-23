defmodule ExTumblr.Request do
  defmodule URIBuilder do
    @hostname Application.get_env :ex_tumblr, :hostname

    def build_URI(%{auth: :api_key} = request) do
      @hostname
      |> URI.parse
      |> Map.put(:path, "/v2/blog/#{request.blog_identifier}/#{request.endpoint}")
      |> Map.put(:query, URI.encode_query(%{api_key: System.get_env("TUMBLR_API_KEY")}))
      |> URI.to_string
    end

    def build_URI(%{auth: :none} = request) do
      @hostname
      |> URI.parse
      |> Map.put(:path, "/v2/blog/#{request.blog_identifier}/#{request.endpoint}")
      |> URI.to_string
    end
  end
end
