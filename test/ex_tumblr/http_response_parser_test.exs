defmodule ExTumblr.HTTPResponseParserTest do
  use ShouldI, async: true

  alias ExTumblr.HTTPResponseParser

  having "a HTTP error" do
    setup context do
      assign context, http_response: %HTTPoison.Error{reason: "my fake error"}
    end

    should "return an error tuple containing the reason specified by HTTPoison", context do
      {:error, "my fake error"} = HTTPResponseParser.parse(context.http_response)
    end
  end

  having "a successful http connection" do
    setup context do
      response = %HTTPoison.Response{
        body: Poison.encode!(%{response: %{key: "value"}})
      }
      assign context, http_response: response
    end

    having "a response with a 200 status code" do
      setup context do
        response = %HTTPoison.Response{context.http_response | status_code: 200}
        assign context, http_response: response
      end

      should "return the API results in a :ok tuple", context do
        %{"key" => "value"} = HTTPResponseParser.parse(context.http_response)
      end
    end

    having "a response with a 301 status code" do
      setup context do
        response = %HTTPoison.Response{context.http_response | status_code: 301}
        assign context, http_response: response
      end

      should "parse the body if the Location header is present", context do
        response_with_location_header =
          %HTTPoison.Response{context.http_response | headers: [{"Location", "my_location"}]}
        %{"key" => "value"} = HTTPResponseParser.parse(response_with_location_header)
      end

      should "return an error tuple when the Location header is not present", context do
        {:error, _} = HTTPResponseParser.parse(context.http_response)
      end
    end
  end
end
