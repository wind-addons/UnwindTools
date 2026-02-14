local ns = select(2, ...) ---@type Namespace
local E = ns[1] ---@class Engine

---@class Engine.Texture
E.Texture = {}

local directory = ([[Interface\Addons\%s\Media\]]):format(E.name)
E.Texture.Logo = directory .. [[Textures\Logo.png]]
