defmodule ExTumblr.Post.ChatPost do
  alias ExTumblr.Post.CommonPostData

  @type t :: %__MODULE__{
    base:     CommonPostData.t,
    title:    String.t,
    body:     String.t,
    dialogue: [reaction]
  }

  @type reaction :: %{
    name:   String.t,
    label:  String.t,
    phrase: String.t
  }

  defstruct ~w(base title body dialogue)a
end
