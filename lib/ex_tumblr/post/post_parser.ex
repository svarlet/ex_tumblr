defmodule ExTumblr.Post.PostParser do
  alias ExTumblr.Utils.Parsing
  alias ExTumblr.Post.TextPost
  alias ExTumblr.Post.{PhotoPost, PhotoItem}
  alias ExTumblr.Post.QuotePost
  alias ExTumblr.Post.LinkPost
  # alias ExTumblr.Post.ChatPost
  # alias ExTumblr.Post.AudioPost
  # alias ExTumblr.Post.VideoPost
  # alias ExTumblr.Post.AnswerPost

  def parse(%{"type" => "text"} = raw_post) do
    Parsing.to_struct(raw_post, TextPost)
  end

  def parse(%{"type" => "photo"} = raw_post) do
    Parsing.to_struct(raw_post, PhotoPost,
      photos: fn list -> Enum.map(list, &PhotoItem.parse/1) end
    )
  end

  def parse(%{"type" => "quote"} = raw_post) do
    Parsing.to_struct(raw_post, QuotePost)
  end

  def parse(%{"type" => "link"} = raw_post) do
    Parsing.to_struct(raw_post, LinkPost,
      photos: fn list -> Enum.map(list, &PhotoItem.parse/1) end
    )
  end

  # def parse(%{"type" => "chat"} = raw_post) do
  # end

  # def parse(%{"type" => "audio"} = raw_post) do
  # end

  # def parse(%{"type" => "video"} = raw_post) do
  # end

  # def parse(%{"type" => "answer"} = raw_post) do
  # end
end
