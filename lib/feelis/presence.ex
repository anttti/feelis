defmodule Feelis.Presence do
  use Phoenix.Presence, otp_app: :feelis, pubsub_server: Feelis.PubSub
end
