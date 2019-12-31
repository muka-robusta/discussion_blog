defmodule DiscussionBlog.News do
	use DiscussionBlog.Web, :model

	schema "news" do
		field :heading, :string
		field :article, :string
		field :creation_date, :utc_datetime

		belongs_to :user, DiscussionBlog.News
	end

	def changeset(struct, params \\ %{}) do
		struct
		|> cast(params, [:heading, :article, :creation_date])
		|> validate_required([:heading, :article, :creation_date])
	end

end