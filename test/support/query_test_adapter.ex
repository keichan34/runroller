defmodule Runroller.Query.TestAdapter do
  @behaviour Runroller.Query

  def head("http://www.example.com/200", _),
    do: {:ok, 200, %{}}

  def head("http://www.example.com/one_to_200", _),
    do: {:ok, 302, %{"location" => "http://www.example.com/200"}}

  def head("http://www.example.com/two_to_200", _),
    do: {:ok, 302, %{"location" => "http://www.example.com/one_to_200"}}

  def head("http://www.example.com/three_to_200", _),
    do: {:ok, 302, %{"location" => "http://www.example.com/two_to_200"}}

  def head("http://www.example.com/one_301_to_200", _),
    do: {:ok, 301, %{"location" => "http://www.example.com/200"}}

  def head("http://www.example.com/302_to_relative", _),
    do: {:ok, 302, %{"location" => "/200"}}

  def head("http://www.example.com/timeout", _) do
    :timer.sleep(30_000)
    {:ok, 302, %{"location" => "/200"}}
  end
end
