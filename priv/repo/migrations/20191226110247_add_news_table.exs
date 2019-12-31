defmodule DiscussionBlog.Repo.Migrations.AddNewsTable do
  use Ecto.Migration

  def change do
  	create table(:news) do
  		add :heading, :string, null: false
  		add :article, :string, null: false
  		add :creation_date, :utc_datetime, null: false
  		add :user_id, references(:users)
  	end
  end
end
