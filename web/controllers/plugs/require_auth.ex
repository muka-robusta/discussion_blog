defmodule DiscussionBlog.Plugs.RequireAuth do
	import Plug.Conn
	import Phoenix.Controller

	alias DiscussionBlog.Router.Helpers

	def init(_params) do
	end

	def call(conn, _params) do
		if conn.assigns[:user] do
			conn
		else
			conn
			|> put_flash(:error, "You must be authorized")
			|> redirect(to: Helpers.user_path(conn, :log_in))
			|> halt()
		end
	end
end