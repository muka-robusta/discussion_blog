defmodule DiscussionBlog.Plugs.SetUser do
	import Plug.Conn
	import Phoenix.Controller

	alias DiscussionBlog.Repo
	alias DiscussionBlog.User
	

	def init(_params) do
		
	end

	def call(conn, _params) do
		user_id = get_session(conn, :user_id)
#		Phoenix.Tracker.track(DiscussionBlog.OnlineTracker, self(), "online", user_id, %{stat: "away"})

		cond do
			user = user_id && Repo.get(User, user_id) ->
				assign(conn, :user, user)
			true ->
				assign(conn, :user, nil)
		end
	end

end