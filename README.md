# Trailblazer::Pro::Rails

## Installation

In your Rails' `Gemfile`.

```ruby
gem "trailblazer-pro-rails"
```

## Usage

1. Get your API key from https://pro.trailblazer.to/settings
2. Run our generator and enter your API key.
    ```
    $ rails g trailblazer:pro:install

    ```
3. Run your operation via `#WTF?`.
    ```ruby
    result = API::V1::Diagram::Operation::Update.WTF?(params: params)
    ```

4. Click the `[TRB PRO]` link in your terminal and start debugging.

![Our web debugger in action.](docs/debugger-ide-screenshot-august.png)

Note: we're currently playing with various invocation styles and at some point you might not even have to use `Operation.wtf?` anymore.

## Configuration (optional)

Configure your operations to use the web debugger, example configuration:
```ruby
# config/environments/development.rb
config.trailblazer.pro.trace_operations = {
  "API::V1::Diagram::Operation::Update" => true,
  "API::V1::Diagram::Operation::Create" => true,
}
```

Or, if you want to trace all operations, use `:all` as the value.
```ruby
# config/environments/development.rb
config.trailblazer.pro.trace_operations = :all
```

Disable printing trace to console, show only link to web debugger.
```ruby
# config/environments/development.rb
  config.trailblazer.pro.render_wtf = false
```

## Testing

Currently, from the top directory, you need to run

```ruby
$ rake test_1
```
This will test the generator on a new Rails app in isolation.

```ruby
$ rake test_2
```

Tests if `wtf?` works without any PRO configuration, but PRO is added.

```ruby
$ rake test_3
```

Tests that the PRO editor import generator works.

### Architecture

* One `Gemfile` for all scenarios on `test/dummies`
