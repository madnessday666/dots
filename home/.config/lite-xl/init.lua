local core = require "core"
local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"
local fontconfig = require "plugins.fontconfig"

--------------------------- Key bindings -------------------------------------

keymap.add({ ["ctrl+shift+a"] = "core:find-command" }, true)
keymap.add({ ["ctrl+`"] = "ui:color scheme" }, true)

------------------------------- Fonts ----------------------------------------

fontconfig.use {
     font = { name = "FiraSans-Regular", size = 14 * SCALE },
     code_font = { name = "JetBrainsMono", size = 15 * SCALE },
}

------------------------------- Config ----------------------------------------

config.fps = 120
