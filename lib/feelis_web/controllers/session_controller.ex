defmodule FeelisWeb.SessionController do
  use FeelisWeb, :controller

  def set(conn, %{"user_id" => user_id}) do
    conn
    |> put_session("user_id", user_id)
    |> json("ok")
  end
end
