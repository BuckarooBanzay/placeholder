placeholder node / a better unknown node

![](https://github.com/blockexchange/placeholder/workflows/luacheck/badge.svg)
![](https://github.com/blockexchange/placeholder/workflows/test/badge.svg)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](license.txt)
[![Download](https://img.shields.io/badge/Download-ContentDB-blue.svg)](https://content.minetest.net/packages/BuckarooBanzay/placeholder)

# Overview

Provides a "better" unknown node which can be handled properly by worldedit and other schematic mechanisms (given they support metadata).

Features:
* Handles and restores metadata
* Restores the original node and metadata if it is available (via lbm)
* Can be serialized and deserialized with worldedit

Use-cases:
* Schematic handling with unknown nodes

# Api

```lua
local metadata = {
    inventory = {},
    fields = {
        x = "y"
    }
}
-- place a placeholder manually
placeholder.place(pos, "unknown:nodename", metadata)

-- try to restore the placeholder at the position
placeholder.replace(pos)
```

# License

* Code: MIT
