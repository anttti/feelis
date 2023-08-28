defmodule FeelisWeb.Router do
  use FeelisWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FeelisWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", FeelisWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/poll", PollLive.Index, :index

    live "/presentations", PresentationLive.Index, :index
    live "/presentations/new", PresentationLive.Index, :new
    live "/presentations/:id/edit", PresentationLive.Index, :edit
    live "/presentations/:id", PresentationLive.Show, :show
    live "/presentations/:id/show/edit", PresentationLive.Show, :edit

    live "/p/:id", PresentLive.Index, :index
    live "/v/:id", ViewerLive.Index, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", FeelisWeb do
    pipe_through :api

    post "/session", SessionController, :set
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:feelis, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FeelisWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
