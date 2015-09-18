#!/usr/bin/env elixir

Mix.start
dir = Path.expand(Path.join(__ENV__.file, ".."))
mixfile = Path.join(dir, "mix.exs")
File.cd! dir, fn ->
  Code.load_file(mixfile)
  IO.write Runroller.Mixfile.project[:version]
end
