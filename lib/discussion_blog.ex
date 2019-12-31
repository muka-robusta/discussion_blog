defmodule DiscussionBlog do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec


    create_db_for_temp_links()
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(DiscussionBlog.Repo, []),
      # Start the endpoint when the application starts
      supervisor(DiscussionBlog.Endpoint, []),
      # Start your own worker by calling: DiscussionBlog.Worker.start_link(arg1, arg2, arg3)
      # worker(DiscussionBlog.Worker, [arg1, arg2, arg3]),
      worker(DiscussionBlog.OnlineTracker, [[name: OnlineTracker, pubsub_server: DiscussionBlog.PubSub]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DiscussionBlog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DiscussionBlog.Endpoint.config_change(changed, removed)
    :ok
  end

  defp create_db_for_temp_links() do
    :mnesia.create_schema([node()])
    :mnesia.start()
    temp_links = :mnesia.create_table(:temporary_links, [
                                {:disc_copies, [node()]}, attributes: [:id, :hashed_link]])

    :mnesia.add_table_index(:temporary_links, :hashed_link)
    :mnesia.add_table_index(:temporary_links, :id)
  end
end
