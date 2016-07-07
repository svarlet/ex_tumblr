defmodule ExTumblr.Post.AnswerPost do
  alias ExTumblr.Post.CommonPostData

  @type t :: %__MODULE__{
    base:        CommonPostData.t,
    asking_name: String.t,
    asking_url:  String.t,
    question:    String.t,
    answer:      String.t
  }

  defstruct ~w(base asking_name asking_url question answer)a
end
