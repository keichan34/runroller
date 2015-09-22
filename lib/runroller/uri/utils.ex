defmodule Runroller.URI.Utils do
  def merge(a, b) do
    Map.merge a, b, fn
      (_k, v1, nil) ->
        v1
      (_k, _v1, v2) ->
        v2
    end
  end
end
