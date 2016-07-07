defmodule ExTumblr.Post.PhotoItem do
  alias ExTumblr.Post.PhotoMeta

  @type t :: %__MODULE__{
    caption:       String.t,
    original_size: PhotoMeta.t,
    alt_sizes:     [PhotoMeta.t],
  }

  defstruct ~w(caption original_size alt_sizes)a

  @doc """
  Creates a struct from a `String.t` to `any` map.

  It reads the values from the `"caption"` and `"alt_sizes"` properties.
  It expects the latter to be a list and will transform each item to a
  `PhotoMeta` struct.

      iex> original_size = %{"width" => 1200, "height" => 1600, url: "http://a.url.com/pic.jpg"}
      iex> alt_sizes = [
      ...>   %{"width" => 600, "height" => 800, url: "http://a.url.com/pic1.jpg"},
      ...>   %{"width" => 300, "height" => 400, url: "http://a.url.com/pic2.jpg"}
      ...> ]
      iex> map = %{"caption" => "Las Vegas 2014", "original_size" => original_size, "alt_sizes" => alt_sizes}
      iex> ExTumblr.Post.PhotoItem.parse(map)
      %ExTumblr.Post.PhotoItem{caption: "Las Vegas 2014", alt_sizes: [%ExTumblr.Post.PhotoMeta{width: 600, height: 800, url: "http://a.url.com/pic1.jpg"}, %ExTumblr.Post.PhotoMeta{width: 300, height: 400, url: "http://a.url.com/pic2.jpg"}]}
  """
  @spec parse(map) :: t
  def parse(map) when is_map(map) do
    %__MODULE__{
      caption:       Map.get(map, "caption"),
      original_size: Map.get(map, "original_size")
                     |> PhotoMeta.parse,
      alt_sizes:     Map.get(map, "alt_sizes")
                     |> Enum.map(&PhotoMeta.parse/1)
    }
  end
end
