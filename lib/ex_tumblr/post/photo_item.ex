defmodule ExTumblr.Post.PhotoItem do
  alias ExTumblr.Post.PhotoMeta

  @type t :: %__MODULE__{
    caption:       String.t,
    original_size: PhotoMeta.t,
    alt_sizes:     [PhotoMeta.t]
  }

  defstruct ~w(caption original_size alt_sizes)a

  @spec parse(map) :: t
  def parse(map) when is_map(map) do
    %__MODULE__{
      caption:       map["caption"],
      original_size: PhotoMeta.parse(map["original_size"]),
      alt_sizes:     Enum.map(map["alt_sizes"], &PhotoMeta.parse/1)
    }
  end
end
