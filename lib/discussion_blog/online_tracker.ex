defmodule DiscussionBlog.OnlineTracker do
	@behaviour Phoenix.Tracker

	def start_link(opts) do
    	opts = Keyword.merge([name: __MODULE__], opts)
    	Phoenix.Tracker.start_link(__MODULE__, opts, opts)
  	end

  	def init(opts) do
    	server = Keyword.fetch!(opts, :pubsub_server)
    	{:ok, %{pubsub_server: server, node_name: Phoenix.PubSub.node_name(server)}}
  	end

	def handle_diff(diff, state) do
	    for {topic, {joins, leaves}} <- diff do
	      for {key, meta} <- joins do
	        IO.puts "_______________________presence join: key \"#{key}\" with meta #{inspect meta}"
	        msg = {:join, key, meta}
	        Phoenix.PubSub.direct_broadcast!(state.node_name, state.pubsub_server, topic, msg)
	      end
	      for {key, meta} <- leaves do
	        IO.puts "_______________________presence leave: key \"#{key}\" with meta #{inspect meta}"
	        msg = {:leave, key, meta}
	        Phoenix.PubSub.direct_broadcast!(state.node_name, state.pubsub_server, topic, msg)
	      end
    	end
    	{:ok, state}
  	end
end