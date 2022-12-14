-- placeholder node for foreign unknown nodes
minetest.register_node("placeholder:placeholder", {
	description = "Placeholder node",
	groups = {
		cracky = 3,
		oddly_breakable_by_hand = 3,
		not_in_creative_inventory = 1
	},
	drop = "",
	tiles = {
		"unknown_node.png"
	}
})

-- places a placeholder node and populates the unknown name and metadata
function placeholder.place(pos, node, metadata)
	assert(type(node) == "table")
	minetest.set_node(pos, { name = "placeholder:placeholder", param2 = node.param2 })
	placeholder.populate(pos, node.name, metadata)
end

-- store the original metadata for later extraction if the node is available then
function placeholder.populate(pos, node_name, metadata)
	local meta = minetest.get_meta(pos)
	meta:set_string("infotext", "Unknown node: '" .. node_name .. "'")
	meta:set_string("original_nodename", node_name)

	if metadata then
		local serialized_meta = minetest.serialize(metadata)
		meta:set_string("original_metadata", serialized_meta)
	end
end

-- unwraps the placeholder node to the original nodename and metadata
function placeholder.unwrap(meta)
	local nodename = meta:get_string("original_nodename")
	local metadata

	local serialized_metadata = meta:get_string("original_metadata")
	if serialized_metadata and serialized_metadata ~= "" then
		metadata = minetest.deserialize(serialized_metadata)
	end

	return nodename, metadata
end

-- try to restore the placeholder at the position
function placeholder.replace(pos, node)
	node = node or minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local nodename = meta:get_string("original_nodename")
	if nodename == "" then
		-- invalid nodename
		return
	end
	if minetest.registered_nodes[nodename] then
		-- node exists now, restore it
		node.name = nodename
		minetest.swap_node(pos, node)

		local serialized_meta = meta:get_string("original_metadata")
		-- clear stored recover data
		meta:set_string("infotext", "")
		meta:set_string("original_metadata", "")
		meta:set_string("original_nodename", "")
		if serialized_meta ~= "" then
			-- restore metadata and inventory
			local metadata = minetest.deserialize(serialized_meta)
			meta:from_table(metadata)
		end
	end
end


minetest.register_lbm({
	label = "restore unknown nodes from placeholders",
	name = "placeholder:restore_unknown_nodes",
	nodenames = {"placeholder:placeholder"},
	run_at_every_load = true,
	action = placeholder.replace
})
