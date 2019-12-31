defmodule DiscussionBlog.NewsController do
	use DiscussionBlog.Web, :controller
	alias DiscussionBlog.News

	alias DiscussionBlog.Router.Helpers

plug DiscussionBlog.Plugs.RequireAuth when action in [:new, :create, :update, :delete, :show, :edit]

	def index(conn, _params) do
		news = Repo.all News
		render conn, "index.html", news: news
	end

	def new(conn, _params) do
		changeset = News.changeset(%News{},%{})
		render conn, "new.html", changeset: changeset
	end

	def create(conn, %{"news" => news_params}) do
		
		news_params = Map.put(news_params, "creation_date", DateTime.utc_now())

		changeset = conn.assigns.user
			|> build_assoc(:news)
			|> News.changeset(news_params)

		IO.inspect changeset

		case Repo.insert(changeset) do
			{:ok, _topic} -> 
				conn
				|> put_flash(:info, "News Created")
				|> redirect(to: Helpers.page_path(conn, :index))
			{:error, changeset} -> 
				conn
				|> put_flash(:error, "not created")
				|> redirect(to: Helpers.page_path(conn, :index))

		end
	end

	def show(conn, %{"id" => news_id}) do
		news = Repo.get(News, news_id)
		render conn, "news_element.html", news: news
	end

	def edit(conn, %{"id" => news_id}) do
		news = Repo.get(News, news_id)
		changeset = News.changeset(news)

		render conn, "edit.html", changeset: changeset, news: news
	end

	def update(conn, %{"news" => news, "id" => news_id}) do
		old_news = Repo.get(News, news_id)
		changeset = News.changeset(old_news, news)

		case Repo.update(changeset) do
			{:ok, _news} -> 
				conn
				|> put_flash(:info, "News Updated")
				|> redirect(to: news_path(conn, :index))
			{:error, changeset} ->
				render conn, "edit.html", changeset: changeset, news: old_news
		end
	end

	def delete(conn, %{"id" => news_id}) do
		{news_id,_} = Integer.parse(news_id)
		IO.inspect news_id

		Repo.get!(News, news_id) |> Repo.delete

		conn 
		|> put_flash(:info, "News deleted")
		|> redirect(to: page_path(conn, :index))
	end

end