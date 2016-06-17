defmodule ExTumblr.AuthTest do
  use ShouldI, async: true

  alias ExTumblr.{Auth, Client, Credentials}

  setup context do
    assign context, client: %Client{hostname: "http://hostname"}
  end

  # NO AUTHENTICATION REQUIRED

  having "A base request not requiring any authentication" do
    setup context do
      context
      |> assign(base_request: {:get, "/path", :no_auth})
    end

    having "no extra parameters" do
      should "not alter the http method", context do
        {:get, _, _, _} = Auth.sign(context.base_request, context.client, nil)
      end

      should "not append a query to the url", context do
        {_, url, _, _} = Auth.sign(context.base_request, context.client, nil)
        assert url == "http://hostname/path"
      end
    end

    having "extra parameters" do
      setup context do
        context
        |> assign(params: %{my_param: "my value", my_other_param: "my other value"})
      end

      should "not alter the http method", context do
        {:get, _, _, _} = Auth.sign(context.base_request, context.client, context.params)
      end

      should "prepare a request with no headers and no body", context do
        {_, _, body, headers} = Auth.sign(context.base_request, context.client, context.params)
        assert body == nil
        assert headers == nil
      end

      should "encode and format the parameters", context do
        {_, url, _, _} = Auth.sign(context.base_request, context.client, context.params)
        assert url == "http://hostname/path?my_other_param=my+other+value&my_param=my+value"
      end
    end
  end

  # API KEY AUTHENTICATION REQUIRED

  having "A base request requiring an API key" do
    setup context do
      context
      |> assign(base_request: {:get, "/path", :api_key_auth})
      |> assign(client: %Client{context.client | credentials: %Credentials{consumer_key: "abc"}})
    end

    having "no extra parameters" do
      should "specify the api key within the query", context do
        {_, url, _, _} = Auth.sign(context.base_request, context.client, nil)
        assert url == "http://hostname/path?api_key=abc"
      end

      should "not create a body or headers", context do
        {_, _, nil, nil} = Auth.sign(context.base_request, context.client, nil)
      end
    end

    having "extra parameters" do
      setup context do
        context
        |> assign(params: %{my_param: "my value", my_other_param: "my other value"})
      end

      should "specify the api key within the query among other params", context do
        {_, url, _, _} = Auth.sign(context.base_request, context.client, context.params)
        assert url == "http://hostname/path?my_other_param=my+other+value&my_param=my+value&api_key=abc"
      end

      should "not create a body", context do
        {_, _, nil, _} = Auth.sign(context.base_request, context.client, context.params)
      end
    end
  end

  # OAUTH AUTHENTICATION REQUIRED

  having "A base request requiring an OAuth authentication" do
    setup context do
      fake_oauth_credentials =
        %Credentials{
          consumer_key: "abcd",
          consumer_secret: "efgh",
          token: "ijkl",
          token_secret: "mnop"
        }

      context
      |> assign(base_request: {:method, "/path", :oauth})
      |> assign(params: %{my_param: "my value", my_other_param: "my other value"})
      |> assign(client: %Client{context.client | credentials: fake_oauth_credentials})
    end

    should "not alter the method type", context do
      {:method, _, _, _} = Auth.sign(context.base_request, context.client, context.params)
    end

    should "not alter the url", context do
      {_, "http://hostname/path", _, _} = Auth.sign(context.base_request, context.client, context.params)
    end

    should "create a body with the shape {:form, body}", context do
      {_, _, {:form, _body}, _} = Auth.sign(context.base_request, context.client, context.params)
    end

    should "create valid authorization headers", context do
      {_, _, _, headers} = Auth.sign(context.base_request, context.client, context.params)
      [{"Authorization", oauth_details}] = headers
      # here we must use a regexp because the headers are seeded with a timestamp
      assert String.match? oauth_details, ~r{OAuth oauth_signature=\".*\", oauth_consumer_key=\"abcd\", oauth_nonce=\".*\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\".*\", oauth_version=\"1.0.*\", oauth_token=\"ijkl\"}
    end
  end
end
