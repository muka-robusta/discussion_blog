defmodule DiscussionBlog.UserController do
	use DiscussionBlog.Web, :controller
	alias DiscussionBlog.User

plug DiscussionBlog.Plugs.RequireAuth when action in [:list, :temp_id, :userpage]

	def signout(conn, _params) do
		conn
		|> configure_session(drop: true)
		|> redirect(to: page_path(conn, :index))
	end

	def list(conn, _params) do
		users = Repo.all(User)
		render conn, "list.html", users: users
	end

	def new(conn, _params) do
		changeset = User.changeset(%User{}, %{})
		render conn, "new.html", changeset: changeset
	end

	def create(conn, %{"user" => user_params_raw}) do
		
		creation_account_date = :os.system_time(:seconds)
		user_params_raw = Map.put(user_params_raw, "creation_date", creation_account_date)
		
		password_raw = Map.get(user_params_raw, "password")
		password_hashed = generate_hashed_passkey(password_raw, creation_account_date)
		
		user_params = %{user_params_raw | "password" => password_hashed}
		
		changeset = User.changeset(%User{}, user_params)

		case Repo.insert(changeset) do
			{:ok, _user} -> 
				conn
				|> put_flash(:info, "Thanks for registration")
				|> redirect(to: page_path(conn, :index))
			{:error, _changeset} ->
				render conn, "new.html", changeset: changeset
		end
	end

	def log_in(conn, _params) do
		changeset = User.changeset(%User{}, %{})
		render conn, "authentication.html", changeset: changeset
	end

	def authentication(conn, %{"user" => %{"email" => email, "password" => usr_password}}) do
		user_check = Repo.get_by(User, email: email)
		if user_check do
			user_password_check = generate_hashed_passkey(usr_password, user_check.creation_date)
			if user_check.password == user_password_check do
				conn
				|> put_flash(:info, "Welcome back!")
				|> put_session(:user_id, user_check.id)
				|> redirect(to: page_path(conn, :index))
				
			else
				conn
				|> put_flash(:error, "Password is invalid")
				|> redirect(to: user_path(conn, :log_in))
			end
		else
			conn
			|> put_flash(:error, "Email is invalid")
			|> redirect(to: user_path(conn, :log_in))
		end
	end

	def temp_id(conn, _params) do
		changeset = User.changeset(%User{}, %{})
		user_id = get_session(conn, :user_id)
		hash_link = DiscussionBlog.TempLinker.generate_link(user_id)

		render conn, "fetched_link.html", hash_link: hash_link
	end

	def fetch_user(conn, params) do
		{:atomic, [{:temporary_links, id_val, _ }]} = DiscussionBlog.TempLinker.fetch_id(Map.get(params, "id"))
		IO.inspect id_val
		if id_val do
			user = Repo.get_by(User,id: id_val)
			render conn, "user_profile.html", user: user
		else 
			conn
			|> put_flash(:error, "UserId is not found or hidden")
			|> redirect(to: page_path(conn, :index))
		end

	end

	def userpage(conn, _params) do
		id = get_session(conn, :user_id)
		user = Repo.get(User, id)
		render conn, "user_profile.html", user: user
	end

	defp generate_hashed_passkey(usr_password, creation_account_date) do
		unhashed_passkey = usr_password <> Integer.to_string(creation_account_date)
		hashed_passkey = :crypto.hash(:sha256, unhashed_passkey) |> Base.encode64(padding: false)
		hashed_passkey
	end
end