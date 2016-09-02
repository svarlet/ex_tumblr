defmodule ExTumblr.Post.PhotoItem do
  alias ExTumblr.Post.PhotoMeta

  @type t :: %__MODULE__{
    caption:       String.t,
    original_size: PhotoMeta.t,
    alt_sizes:     [PhotoMeta.t]
  }

  defstruct ~w(caption original_size alt_sizes)a

  @doc """
  Creates a struct from a map.

  The keys of the map should be of type `String.t`. This function parses the `caption`,
  `original_size` and `alt_sizes` properties.
  It expects the latter to be a list and will transform each item to a
  `PhotoMeta` struct.
  """
  @spec parse(map) :: t
  def parse(map) when is_map(map) do
    %__MODULE__{
      caption:       map["caption"],
      original_size: PhotoMeta.parse(map["original_size"]),
      alt_sizes:     Enum.map(map["alt_sizes"], &PhotoMeta.parse/1)
    }
  end
end
