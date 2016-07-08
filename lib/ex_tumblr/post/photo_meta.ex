defmodule ExTumblr.Post.PhotoMeta do
  @type t :: %__MODULE__{
    width:  number(),
    height: number(),
    url:    String.t
  }

  defstruct ~w(width height url)a

  @doc """
  Create a struct from a `String.t` to `any` map.

  This function reads the value of the `"width"`, `"height"` and `"url"` keys to
  create the struct.

      iex> generic_map = %{"width" => 8, "height" => 12, "url" => "http://localhost/pic.jpg" }
      iex> ExTumblr.Post.PhotoMeta.parse(generic_map)
      %ExTumblr.Post.PhotoMeta{width: 8, height: 12, url: "http://localhost/pic.jpg"}
  """
  @spec parse(%{String.t => any}) :: t
  def parse(map) when is_map(map) do
    %__MODULE__{
      width:  map["width"],
      height: map["height"],
      url:    map["url"]
    }
  end
end
