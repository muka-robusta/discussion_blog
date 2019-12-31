defmodule DiscussionBlog.User do
	use DiscussionBlog.Web, :model

	schema "users" do
		field :first_name, :string
		field :second_name, :string
		field :username, :string
		field :email, :string
		field :confirmed, :boolean
		field :password, :string
		field :creation_date, :integer

		has_many :news, DiscussionBlog.News

		timestamps()
	end

	def changeset(struct, params \\ %{}) do
		struct 
		|> cast(params, [:email, :first_name, :second_name, :username, :email, :confirmed, :password, :creation_date])
		|> validate_required([:first_name, :second_name, :username, :email, :password, :creation_date])
	end



end