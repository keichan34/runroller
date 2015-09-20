defmodule Runroller.Errors do
  def description_for(:timeout),
    do: "I tried to contact the server but the transmission timed out."

  def description_for(:nxdomain),
    do: "A DNS error occurred."

  def description_for(:too_many_redirects),
    do: "Too many redirects."

  def description_for("http_404"),
    do: "404 File Not Found."

  def description_for(_),
    do: "Undefined error."

  def code_for(:crash),   do: 500
  def code_for(:timeout), do: 504
  def code_for(:too_many_redirects),
                          do: 504
  def code_for("http_404"),
                          do: 404
  def code_for(_),        do: 500
end
