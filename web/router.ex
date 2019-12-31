defmodule DiscussionBlog.Router do
  use DiscussionBlog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DiscussionBlog.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DiscussionBlog do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    #get "/news", NewsController, :index
    #get "/news/all", NewsController, :index
    #get "/news/add", NewsController, :new
    #post "/news", NewsController, :create
    #get "/news/:id", NewsController, :news_element
    #post "/news/:id", NewsController, :delete_el

    resources "/news", NewsController
    delete "/news/:id", NewsController, :delete_news

    get "/users/list", UserController, :list
    get "/users/sign_up", UserController, :new
    post "/", UserController, :create
    get "/users/log_in", UserController, :log_in
    post "/users/authentication", UserController, :authentication
    get "/users/logout", UserController, :signout
    get "/user/hashlink", UserController, :temp_id
    get "/user/:id", UserController, :fetch_user

    
    get "/temp/article", NewsController, :temp_new
    post "/temp", NewsController, :temp_create
    get "/home", UserController, :userpage
  end

  # Other scopes may use custom stacks.
  # scope "/api", DiscussionBlog do
  #   pipe_through :api
  # end
end
