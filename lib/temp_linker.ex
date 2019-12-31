defmodule DiscussionBlog.TempLinker do
	def generate_link(element_id) do
		hashed_link = :crypto.strong_rand_bytes(40)
			|> Base.encode32
			|> binary_part(0,40)
			|> String.downcase

		linking_transaction = fn -> 
			:mnesia.write({:temporary_links, element_id, hashed_link})
			end
		:mnesia.transaction(linking_transaction)
		hashed_link
	end 

	def fetch_id(hashed_link) do
		fetch_transaction = fn -> 
			:mnesia.index_read(:temporary_links, hashed_link, :hashed_link)
			end
		:mnesia.transaction(fetch_transaction)		
	end

end