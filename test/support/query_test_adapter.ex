defmodule Runroller.Query.TestAdapter do
  @behaviour Runroller.Query

  def head("http://www.example.com/200", _),
    do: {:ok, 200, %{}}

  def head("http://www.example.com/one_to_200", _),
    do: {:ok, 302, %{"location" => "http://www.example.com/200"}}

  def head("http://www.example.com/two_to_200", _),
    do: {:ok, 302, %{"location" => "http://www.example.com/one_to_200"}}

  def head("http://www.example.com/one_301_to_200", _),
    do: {:ok, 301, %{"location" => "http://www.example.com/200"}}
end
