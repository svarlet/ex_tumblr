defmodule ExTumblr.Post.AudioPost do
  alias ExTumblr.Post.CommonPostData

  @type t :: %__MODULE__{
    base:         CommonPostData.t,
    caption:      String.t,
    player:       String.t,
    plays:        non_neg_integer,
    album_art:    String.t,
    artist:       String.t,
    album:        String.t,
    track_name:   String.t,
    track_number: non_neg_integer,
    year:         non_neg_integer
  }

  defstruct ~w(base caption player plays album_art artist album track_name track_number year)a
end
