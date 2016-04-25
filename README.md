# ExTumblr
[![Build Status](https://travis-ci.org/svarlet/ex_tumblr.svg?branch=master)](https://travis-ci.org/svarlet/ex_tumblr)

This library is a client for the Tumblr API v2 for the Elixir language.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ex_tumblr to your list of dependencies in `mix.exs`:

        def deps do
          [{:ex_tumblr, "~> 0.0.1"}]
        end

  2. Ensure ex_tumblr is started before your application:

        def application do
          [applications: [:ex_tumblr]]
        end

## Requirements

To be valid, many requests must specify an API key. Therefore it must be set as a `TUMBLR_API_KEY` environment variable.
