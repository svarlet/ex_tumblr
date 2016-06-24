defmodule ExTumblr.AuthTest do
  use ExUnit.Case, async: true

  alias ExTumblr.{Auth, Client, Credentials}

  defp set_client(_context) do
    {:ok, client:
            %Client{hostname: "http://hostname",
                    credentials: %Credentials{
                      consumer_key: "abcd",
                      consumer_secret: "efgh",
                      token: "ijkl",
                      token_secret: "mnop"
                    }
            }
    }
  end

  defp set_no_auth_request(_context) do
    {:ok, base_request: {:get, "/path", :no_auth}}
  end

  defp set_api_key_auth_request(_context) do
    {:ok, base_request: {:get, "/path", :api_key_auth}}
  end

  defp set_oauth_request(_context) do
    {:ok, base_request: {:method, "/path", :oauth}}
  end

  defp set_request_parameters(_context) do
    {:ok, params: %{my_param: "my value", my_other_param: "my other value"}}
  end

  describe "no authentication required" do
    setup [:set_client, :set_no_auth_request]

    test "uses the specified the http method", context do
      {:get, _, _, _} = Auth.sign(context.base_request, context.client, nil)
    end

    test "does not append a query to the url", context do
      {_, url, _, _} = Auth.sign(context.base_request, context.client, nil)
      assert url == "http://hostname/path"
    end
  end

  describe "no authentication required with request parameters" do
    setup [:set_client, :set_no_auth_request, :set_request_parameters]

    test "uses the specified http method", context do
      {:get, _, _, _} = Auth.sign(context.base_request, context.client, context.params)
    end

    test "does not set any headers in the request", context do
      {_, _, _, headers} = Auth.sign(context.base_request, context.client, context.params)
      assert headers == nil
    end

    test "does not set a body in the request", context do
      {_, _, body, _} = Auth.sign(context.base_request, context.client, context.params)
      assert body == nil
    end

    test "encode and format the parameters", context do
      {_, url, _, _} = Auth.sign(context.base_request, context.client, context.params)
      assert url == "http://hostname/path?my_other_param=my+other+value&my_param=my+value"
    end
  end

  describe "api key authentication" do
    setup [:set_client, :set_api_key_auth_request]

    test "sends the api key in the query", context do
      {_, url, _, _} = Auth.sign(context.base_request, context.client, nil)
      assert url == "http://hostname/path?api_key=abcd"
    end

    test "does not set a body in the request", context do
      {_, _, nil, _} = Auth.sign(context.base_request, context.client, nil)
    end

    test "does not set any headers in the request", context do
      {_, _, _, nil} = Auth.sign(context.base_request, context.client, nil)
    end
  end

  describe "api key authentication with request parameters" do
    setup [:set_client, :set_api_key_auth_request, :set_request_parameters]

    test "specifies the api key within the query among other params", context do
      {_, url, _, _} = Auth.sign(context.base_request, context.client, context.params)
      assert url == "http://hostname/path?my_other_param=my+other+value&my_param=my+value&api_key=abcd"
    end

    test "does not set the request body", context do
      {_, _, nil, _} = Auth.sign(context.base_request, context.client, context.params)
    end
  end

  describe "oauth authentication" do
    setup [:set_client, :set_oauth_request, :set_request_parameters]

    test "uses the specified http method", context do
      {:method, _, _, _} = Auth.sign(context.base_request, context.client, context.params)
    end

    test "uses the specified url", context do
      {_, "http://hostname/path", _, _} = Auth.sign(context.base_request, context.client, context.params)
    end

    test "creates a body with the shape {:form, body}", context do
      {_, _, {:form, _body}, _} = Auth.sign(context.base_request, context.client, context.params)
    end

    test "creates oauth headers", context do
      {_, _, _, headers} = Auth.sign(context.base_request, context.client, context.params)
      [{"Authorization", oauth_details}] = headers
      # here we must use a regexp because the headers are seeded with a timestamp
      assert String.match? oauth_details, ~r{OAuth oauth_signature=\".*\", oauth_consumer_key=\"abcd\", oauth_nonce=\".*\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\".*\", oauth_version=\"1.0.*\", oauth_token=\"ijkl\"}
    end
  end
end
