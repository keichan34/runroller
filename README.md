# Runroller ![Travis-CI](https://travis-ci.org/keichan34/runroller.svg)

# Getting Started

Runroller defaults to listening to the local TCP port 4000.

## Development

```
$ mix deps.get
$ iex -S mix
```

## Quick production start

The default configuration is in `config/config.exs` and `config/[MIX_ENV].exs`.
The "prod" environment will also import a `config/prod.secret.exs` file if it
exists, which is in the gitignore.

```
$ mix deps.get
$ env MIX_ENV=prod mix do compile, run --no-halt
```

# License

```
Copyright (C) 2015-2016  Keitaroh Kobayashi

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
