
local pos1 = {x=0, y=0, z=0}

mtt.emerge_area(pos1, pos1)

mtt.register("replacement check, unknown node", function(callback)
    -- place unknown node
    placeholder.place(pos1, {name="dummy:node"}, {
        inventory = {},
        fields = {
            x = "y"
        }
    })

    -- some sanity tests
    assert(minetest.get_node(pos1).name == "placeholder:placeholder")
    local meta = minetest.get_meta(pos1)
    assert(meta:get_string("original_nodename") == "dummy:node")
    assert(meta:get_string("original_metadata") ~= "")

    -- try to restore the placeholder (unsuccessful)
    placeholder.replace(pos1)
    assert(minetest.get_node(pos1).name == "placeholder:placeholder")

    callback()
end)

mtt.register("replacement check, known node", function(callback)
    assert(minetest.registered_nodes["default:mese"])

    -- place unknown node
    placeholder.place(pos1, {name="default:mese", param2=10}, {
        inventory = {},
        fields = {
            x = "y"
        }
    })

    -- some sanity tests
    assert(minetest.get_node(pos1).name == "placeholder:placeholder")
    local meta = minetest.get_meta(pos1)
    assert(meta:get_string("original_nodename") == "default:mese")
    assert(meta:get_string("original_metadata") ~= "")

    local node, metadata = placeholder.unwrap(meta)
    assert(node.name == "default:mese")
    assert(node.param2 == 10)
    assert(metadata.fields.x == "y")

    -- try to restore the placeholder (successful)
    placeholder.replace(pos1)
    assert(minetest.get_node(pos1).name == "default:mese")
    assert(minetest.get_node(pos1).param2 == 10)
    meta = minetest.get_meta(pos1)
    assert(meta:get_string("x") == "y")

    callback()
end)