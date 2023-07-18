# Trailblazer::Pro::Rails

## Installation

In your Rails' `Gemfile`.

```ruby
gem "trailblazer-pro-rails"
```

## Configuration

1. Go to https://pro.trailblazer.to and sign up for TRB PRO.
2. Click [Settings](https://pro.trailblazer.to/settings) and copy your API key.
3. In your Rails app, run our generator in the terminal.
    ```ruby
    $ rails g trailblazer:pro:install
    ```

    Here, you need to copy your API key and hit enter.
4. That's it!

## Usage

After configuration, every `#wtf?` call will be sent to our web debugger, the link to it is printed on the terminal.

## TODO

Lots of things!

* We want to allow filtering in `#wtf?`, so only particular operations can be traced.
* End-to-end encryption between your app and the debugger, so no one except you can read through your stack.
* Make `#wtf?` being invoked automatically when configured globally.

Hit us up with your ideas: https://trailblazer.zulipchat.com
