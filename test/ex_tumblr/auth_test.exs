defmodule ExTumblr.AuthTest do
  use ShouldI, async: true

  alias ExTumblr.{Auth, Credentials}

  having "A base request not requiring any authentication" do
    setup context do
      context
      |> assign(base_request: {:get, "my_url", :no_auth})
    end

    having "no extra parameters" do
      should "not alter the http method", context do
        {:get, _, _, _} = Auth.sign(context.base_request, nil, nil)
      end

      should "not append a query to the url", context do
        {_, url, _, _} = Auth.sign(context.base_request, nil, nil)
        assert url == "my_url"
      end
    end

    having "extra parameters" do
      setup context do
        context
        |> assign(params: %{my_param: "my value", my_other_param: "my other value"})
      end

      should "not alter the http method", context do
        {:get, _, _, _} = Auth.sign(context.base_request, nil, context.params)
      end

      should "prepare a request with no headers and no body", context do
        {_, _, body, headers} = Auth.sign(context.base_request, nil, context.params)
        assert body == nil
        assert headers == nil
      end

      should "encode and format the parameters", context do
        {_, url, _, _} = Auth.sign(context.base_request, nil, context.params)
        assert url == "my_url?my_other_param=my+other+value&my_param=my+value"
      end
    end
  end

  having "A base request requiring an API key" do
    setup context do
      context
      |> assign(base_request: {:get, "my_url", :api_key_auth})
      |> assign(credentials: %Credentials{consumer_key: "abc"})
    end

    having "no extra parameters" do
      should "specify the api key within the query", context do
        {_, url, _, _} = Auth.sign(context.base_request, context.credentials, nil)
        assert url == "my_url?api_key=abc"
      end

      should "not create a body or headers", context do
        {_, _, nil, nil} = Auth.sign(context.base_request, context.credentials, nil)
      end
    end

    having "extra parameters" do
      setup context do
        context
        |> assign(params: %{my_param: "my value", my_other_param: "my other value"})
      end

      should "specify the api key within the query among other params", context do
        {_, url, _, _} = Auth.sign(context.base_request, context.credentials, context.params)
        assert url == "my_url?my_other_param=my+other+value&my_param=my+value&api_key=abc"
      end

      should "not create a body", context do
        {_, _, nil, _} = Auth.sign(context.base_request, context.credentials, context.params)
      end
    end
  end

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
      |> assign(base_request: {:method, "https://api.tumblr.com/", :oauth})
      |> assign(params: %{my_param: "my value", my_other_param: "my other value"})
      |> assign(credentials: fake_oauth_credentials)
    end

    should "not alter the method type", context do
      {:method, _, _, _} = Auth.sign(context.base_request, context.credentials, context.params)
    end

    should "not alter the url", context do
      {_, "https://api.tumblr.com/", _, _} = Auth.sign(context.base_request, context.credentials, context.params)
    end

    should "create a body with the shape {:form, body}", context do
      {_, _, {:form, _body}, _} = Auth.sign(context.base_request, context.credentials, context.params)
    end

    should "create valid authorization headers", context do
      {_, _, _, headers} = Auth.sign(context.base_request, context.credentials, context.params)
      [{"Authorization", oauth_details}] = headers
      # here we must use a regexp because the headers are seeded with a timestamp
      assert String.match? oauth_details, ~r{OAuth oauth_signature=\".*\", oauth_consumer_key=\"abcd\", oauth_nonce=\".*\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\".*\", oauth_version=\"1.0.*\", oauth_token=\"ijkl\"}
    end
  end
end
