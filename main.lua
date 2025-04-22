import("src/_class.lua")
import("src/camera.lua")
import("src/command/place_flag.lua")
import("src/command/remove_flag.lua")
import("src/command/remove_tile.lua")
import("src/command/set_tile.lua")
import("src/create_grid_mesh.lua")
import("src/cursor.lua")
import("src/flag.lua")
import("src/flag_manager.lua")
import("src/grid.lua")
import("src/grid_editor.lua")
import("src/list.lua")
import("src/load_grid.lua")
import("src/memblock_reader.lua")
import("src/memblock_writer.lua")
import("src/read_textures.lua")
import("src/save_grid.lua")
import("src/texture_viewer.lua")
import("src/undo_manager.lua")

TEX_PATH = "textures/"

function main()
  OpenConsole()
  OpenScreen(1024, 768, DesktopDepth(), SCREEN_RESIZABLE + SCREEN_VSYNC)

  local font = LoadFont("system.xml")

  local texture_names = ReadTextures(TEX_PATH)
  local ceiling_tex_viewer = TextureViewer:Create(texture_names, 1, TEX_PATH, KEY_W, KEY_E)
  local wall_tex_viewer = TextureViewer:Create(texture_names, 2, TEX_PATH, KEY_S, KEY_D)
  local floor_tex_viewer = TextureViewer:Create(texture_names, 3, TEX_PATH, KEY_X, KEY_C)

  local grid = Grid:Create(64, 16, 64, ceiling_tex_viewer, wall_tex_viewer, floor_tex_viewer, TEX_PATH)
  local cursor = Cursor:Create(grid)
  local flag_mgr = FlagManager:Create()
  local undo_mgr = UndoManager:Create()
  local grid_editor = GridEditor:Create(grid, cursor, ceiling_tex_viewer, wall_tex_viewer, floor_tex_viewer, flag_mgr, undo_mgr)
  local cam = Camera:Create(cursor)

  while not ScreenShouldClose() do
    undo_mgr:update()
    cursor:update(grid_editor.editing)
    cam:update(grid_editor.editing)
    grid_editor:update()
    if grid_editor.editing then
      ceiling_tex_viewer:update()
      wall_tex_viewer:update()
      floor_tex_viewer:update()
    end
    flag_mgr:update(grid_editor.current_flag)

    DrawWorld()
    if grid_editor.editing then
      ceiling_tex_viewer:draw(ScreenWidth() - 144, 16, 128, 128)
      wall_tex_viewer:draw(ScreenWidth() - 144, 160, 128, 128)
      floor_tex_viewer:draw(ScreenWidth() - 144, 304, 128, 128)
      DrawText(
        font,
        "[F2] Load -- [F3] Save -- [F4] Mode: " .. EditModeName(grid_editor.mode) .. " -- [ENTER] Preview",
        8,
        8,
        COLOR_WHITE)
      DrawText(
        font,
        "[F] " .. EnableDisableText(grid:filteringEnabled()) .. " texture filtering -- " ..
        "[L] " .. EnableDisableText(grid_editor:lightingEnabled()) .. " lighting -- " ..
        "[R] " .. EnableDisableText(grid:wireframeEnabled()) .. " wireframe",
        8,
        24,
        COLOR_WHITE)
      DrawText(
        font,
        "[U/I] Select flag number (current: " .. grid_editor.current_flag .. ") -- " ..
        "[P] Place flag -- " ..
        "[O] Delete flag",
        8,
        40,
        COLOR_WHITE)
      DrawText(
        font,
        "Cursor Position " .. Int(EntityX(cursor.entity)) .. "x" .. Int(EntityY(cursor.entity)) .. "x" .. Int(EntityZ(cursor.entity)),
        8,
        ScreenHeight() - 24,
        COLOR_WHITE)
    end
    RefreshScreen()
  end
end

function EditModeName(mode_id)
  local names = {
    "Tile",
    "Stairs Forward",
    "Stairs Right",
    "Stairs Backwards",
    "Stairs Left",
  }
  local name = names[mode_id]
  if name == nil then name = "" end
  return name
end

function EnableDisableText(state)
  if state then return "Disable" else return "Enable" end
end

main()
