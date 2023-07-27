# Trailblazer::Pro::Rails

## Installation

In your Rails' `Gemfile`.

```ruby
gem "trailblazer-pro-rails"
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


### Architecture

* One `Gemfile` for all scenarios on `test/dummies`
