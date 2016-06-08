defmodule ExTumblr.Transport do
  defmacro __using__(_opts) do
    quote do
      require Logger

      defp emit({method, endpoint, body, headers}) do
        url = hostname <> endpoint
        Logger.info "#{__MODULE__}: Sending #{method} request to #{url}"
        HTTPoison.request(method, url, body || "", headers || [])
      end

      defp hostname do
        Application.get_env(:ex_tumblr, :hostname) || "https://api.tumblr.com"
      end
    end
  end
end
