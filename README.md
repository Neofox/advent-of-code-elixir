# Advent of Code Elixir version

## Runing steps

### Dependencies update

```bash
mix deps.get
```

### Running tests

```bash
mix test
```

### Running a day (day 1 part 1 for example)

```bash
mix d01.p1
```

if you want to run the benchmark, you can add the `-b` flag

```bash
mix d01.p1 -b
```

### Optional Automatic Input Retriever

This starter comes with a module that will automatically get your inputs so you
don't have to mess with copy/pasting. Don't worry, it automatically caches your
inputs to your machine so you don't have to worry about slamming the Advent of
Code server. You can do enanle it by creating a `config/secrets.exs` file containing
the following:

```elixir
import Config

config :advent_of_code, AdventOfCode.Input,
  allow_network?: true,
  session_cookie: "..." # yours will be longer
```

After which, you can retrieve your inputs using the module:

```elixir
AdventOfCode.Input.get!(day, year)
AdventOfCode.Input.get!(7)
AdventOfCode.Input.delete!(7, 2019)
```
