defmodule DiscussionBlog.Repo.Migrations.AddUserTable do
  use Ecto.Migration

  def change do
  	create table(:users) do
  		add :first_name, :string
  		add :second_name, :string
  		add :email, :string, unique: true, null: false
  		add :username, :string, unique: true, null: false
  		add :confirmed, :boolean, default: false
  		add :password, :string, null: false
  		add :creation_date, :integer, null: false

  		timestamps()
  	end

  	create(unique_index(:users, [:username], name: :unique_usernames))
  	create(unique_index(:users, [:email], name: :unique_email))

  end
end
