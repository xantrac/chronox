# Chronox

### Set up Google api credentials

- Set up a google project https://developers.google.com/calendar white listing localhost as a valid callback host.
- create a `dev.secret.exs` file in the following path `chronox/config/` containing you google api credentials
```
# chronox/config/dev.secret.exs

use Mix.Config

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: your google client_id,
  client_secret: your google client_secret
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
