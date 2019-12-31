defmodule DiscussionBlog.Repo.Migrations.AddInterestTable do
  use Ecto.Migration

  def change do
  	create table(:interest) do
  		add :interest_name, :string
  		timestamps()
  	end
  	create(unique_index(:interest, [:interest_name], name: :unique_interest))

  	alter table(:news) do
  		add :interest_id, references(:interest)
  	end
  end
end
