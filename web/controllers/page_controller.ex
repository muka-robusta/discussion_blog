defmodule DiscussionBlog.PageController do
  use DiscussionBlog.Web, :controller

  

  def index(conn, _params) do
    render conn, "index.html"
  end
end
