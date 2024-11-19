package beyonddd_engine

import "core:fmt"
import "core:c"
import rl "vendor:raylib"

WindowData :: struct {
	height: c.int,
	width: c.int,
	fps: c.int,
	title: cstring,
	states: rl.ConfigFlags,
	icon: rl.Image,
	background_color: rl.Color,
}

window_data: WindowData

window_setup :: proc() {
	window_data.height = c.int(600)
	window_data.width = c.int(800)
	window_data.states = {.VSYNC_HINT}
	window_data.title = "Beyonddd Engine"
	window_data.fps = 60
	window_data.background_color = rl.WHITE

	rl.InitWindow(window_data.width, window_data.height, window_data.title)
	rl.SetTargetFPS(window_data.fps)
	rl.SetTraceLogLevel(.ALL)
	rl.SetWindowState(window_data.states)
}

main :: proc() {
// Startup setup ------------------------------------------------------------	
	window_setup()
	scenes_setup()
	asset_texture_setup_from_dir()
	entities_setup()
	actions_setup()
	
	defer rl.CloseWindow()
	
	for !rl.WindowShouldClose() {
		action_process() // user input

// Rendering ------------------------------------------------------------		
		rl.BeginDrawing()

		rl.ClearBackground(window_data.background_color)

		
		scene_render()

		rl.EndDrawing()
	}
}

