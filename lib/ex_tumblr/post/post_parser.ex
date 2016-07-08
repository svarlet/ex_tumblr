defmodule ExTumblr.Post.PostParser do
  alias ExTumblr.Utils.Parsing
  alias ExTumblr.Post.CommonPostData
  alias ExTumblr.Post.TextPost
  alias ExTumblr.Post.{PhotoPost, PhotoItem}
  alias ExTumblr.Post.QuotePost
  alias ExTumblr.Post.LinkPost
  # alias ExTumblr.Post.ChatPost
  # alias ExTumblr.Post.AudioPost
  # alias ExTumblr.Post.VideoPost
  # alias ExTumblr.Post.AnswerPost

  defp parse_common_keys(raw_post) do
    raw_post
    |> Parsing.to_struct(CommonPostData)
  end

  def parse(%{"type" => "text"} = raw_post) do
    %TextPost{
      base:  parse_common_keys(raw_post),
      title: Map.get(raw_post, "title"),
      body:  Map.get(raw_post, "body")
    }
  end

  def parse(%{"type" => "photo"} = raw_post) do
    %PhotoPost{
      base:    parse_common_keys(raw_post),
      caption: Map.get(raw_post, "caption"),
      width:   Map.get(raw_post, "width"),
      height:  Map.get(raw_post, "height"),
      photos:  raw_post
               |> Map.get("photos")
               |> Enum.map(&PhotoItem.parse/1)
    }
  end

  def parse(%{"type" => "quote"} = raw_post) do
    %QuotePost{
      base:   parse_common_keys(raw_post),
      text:   Map.get(raw_post, "text"),
      source: Map.get(raw_post, "source")
    }
  end

  def parse(%{"type" => "link"} = raw_post) do
    %LinkPost{
      base:        Map.get(raw_post, "base"),
      title:       Map.get(raw_post, "title"),
      url:         Map.get(raw_post, "url"),
      author:      Map.get(raw_post, "author"),
      excerpt:     Map.get(raw_post, "excerpt"),
      publisher:   Map.get(raw_post, "publisher"),
      photos:      raw_post
                   |> Map.get("photos")
                   |> Enum.map(&PhotoItem.parse/1),
      description: Map.get(raw_post, "description")
    }
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
