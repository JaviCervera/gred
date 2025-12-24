load("dialogs")

import("src/_class.lua")
import("src/camera.lua")
import("src/command/place_flag.lua")
import("src/command/remove_flag.lua")
import("src/command/remove_tile.lua")
import("src/command/set_tile.lua")
import("src/grid_mesh/create_stairs_mesh.lua")
import("src/grid_mesh/grid_mesh.lua")
import("src/grid_mesh/grid_surface.lua")
import("src/grid_mesh/grid_vertex.lua")
import("src/create_grid_mesh.lua")
import("src/cursor.lua")
import("src/flag.lua")
import("src/flag_manager.lua")
import("src/grid.lua")
import("src/grid_manager.lua")
import("src/list.lua")
import("src/load_grid.lua")
import("src/memblock_reader.lua")
import("src/memblock_writer.lua")
import("src/read_textures.lua")
import("src/save_grid.lua")
import("src/texture_viewer.lua")
import("src/undo_manager.lua")
import("src/util.lua")

TEX_PATH = "../textures/"
FONT_SIZE = 20
COLOR_WHITE = Color()
COLOR_WHITE.r = 255
COLOR_WHITE.g = 255
COLOR_WHITE.b = 255
COLOR_WHITE.a = 255

function main()
  SetConfigFlags(FLAG_WINDOW_RESIZABLE)
  InitWindow(1024, 768, "GRED")

  local texture_names = ReadTextures(TEX_PATH)
  local ceiling_tex_viewer = TextureViewer:Create(texture_names, 1, TEX_PATH, KEY_W, KEY_E)
  local wall_tex_viewer = TextureViewer:Create(texture_names, 2, TEX_PATH, KEY_S, KEY_D)
  local floor_tex_viewer = TextureViewer:Create(texture_names, 3, TEX_PATH, KEY_X, KEY_C)

  local grid = Grid:Create(64, 16, 64, ceiling_tex_viewer, wall_tex_viewer, floor_tex_viewer, TEX_PATH)
  local cursor = Cursor:Create(grid)
  local flag_mgr = FlagManager:Create()
  local undo_mgr = UndoManager:Create()
  local grid_mgr = GridManager:Create(grid, cursor, ceiling_tex_viewer, wall_tex_viewer, floor_tex_viewer, flag_mgr, undo_mgr)
  local cam = Camera:Create(cursor)

  while not WindowShouldClose() do
    undo_mgr:update()
    cursor:update(grid_mgr.editing)
    cam:update(grid_mgr.editing)
    grid_mgr:update()
    if grid_mgr.editing then
      ceiling_tex_viewer:update()
      wall_tex_viewer:update()
      floor_tex_viewer:update()
    end
    flag_mgr:update(grid_mgr.current_flag)

    BeginDrawing()
    ClearBackground(GetColor(0x0000FFFF))
    BeginMode3D(cam.cam)
    cursor:draw()
    EndMode3D()
    flag_mgr:drawFlagNumbers(font, cam.entity)
    if grid_mgr.editing then
      ceiling_tex_viewer:draw(GetScreenWidth() - 144, 16, 128, 128)
      wall_tex_viewer:draw(GetScreenWidth() - 144, 160, 128, 128)
      floor_tex_viewer:draw(GetScreenWidth() - 144, 304, 128, 128)
      local pos = Vector2()
      pos.x = 4
      pos.y = 4
      DrawText(
        "[F1] New -- [F2] Load -- [F3] Save -- [F4] Mode: " .. EditModeName(grid_mgr.mode) .. " -- [ENTER] Preview",
        4,
        4,
        FONT_SIZE,
        COLOR_WHITE)
      DrawText(
        "[F] " .. EnableDisableText(grid:filteringEnabled()) .. " texture filtering -- " ..
        "[L] " .. EnableDisableText(grid_mgr:lightingEnabled()) .. " lighting -- " ..
        "[R] " .. EnableDisableText(grid:wireframeEnabled()) .. " wireframe",
        8,
        28,
        FONT_SIZE,
        COLOR_WHITE)
      DrawText(
        "[U/I] Select flag number (current: " .. grid_mgr.current_flag .. ") -- " ..
        "[P] Place flag -- " ..
        "[O] Delete flag",
        8,
        52,
        FONT_SIZE,
        COLOR_WHITE)
      DrawText(
        "Cursor Position " ..
        math.floor(cursor.position.x) .. "x" ..
        math.floor(cursor.position.y) .. "x" ..
        math.floor(cursor.position.z),
        8,
        GetScreenHeight() - 24,
        FONT_SIZE,
        COLOR_WHITE)
      -- TODO: Draw grid
    end
    EndDrawing()
  end
  CloseWindow()
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
