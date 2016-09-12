defmodule ExTumblr.Post.PhotoItemTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias ExTumblr.Support.Generators.Post.PhotoGen
  alias ExTumblr.Post.PhotoItem

  property "caption, original_size and alt_sizes keys are parsed" do
    forall raw_photo_item <- PhotoGen.photo_item do
      photo_item =
        raw_photo_item
        |> PhotoItem.parse

      # if any property is not/badly parsed, we will find out by reencoding
      # to JSON, decoding and comparing to the generated value.
      raw_photo_item ==
        photo_item
        |> Poison.encode!
        |> Poison.decode!
    end
  end

end
