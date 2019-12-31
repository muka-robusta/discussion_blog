defmodule DiscussionBlog.Interest do
	use DiscussionBlog.Web, :model

	schema "interest" do
		field :interest_name, :string

		belongs_to :news, DiscussionBlog.Interest
	end

	def changeset(struct, params \\ %{}) do
		struct
		|> cast(params, [:interest_name])
		|> validate_required([:interest_name])
	end
	
end