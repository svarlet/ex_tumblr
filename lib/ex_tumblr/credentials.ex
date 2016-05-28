defmodule ExTumblr.Credentials do
  @moduledoc """
  Defines a structure to represent API credentials
  """

  @type t :: %ExTumblr.Credentials{}
  defstruct consumer_key: nil, consumer_secret: nil, token: nil, token_secret: nil
end
