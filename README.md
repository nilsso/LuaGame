# LuaGame
Practice game engine project using Lua and the LÖVE framework.

[Install Instructions](/install.md)

## States
Managing the game state system are state objects with their own list of entities.

[Source](/src/base_state.lua)

Game | Contains and displays the entire game world
---- |
  | Entities (player, NPCs, etc.
Menu | Contains and displays the controls for a main menu environment
---- |
  | Change client settings
  | Load and save the game
  | Exit the game
