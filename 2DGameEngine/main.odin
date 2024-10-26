package beyonddd_engine

import "core:fmt"
import "core:c"
import rl "vendor:raylib"

WindowData :: struct {
	height: c.int,
	width: c.int,
	fps: c.int,
	states: rl.ConfigFlags,
	title: cstring,
	icon: rl.Image,
}

window_data: WindowData

main :: proc() {
	entities_setup()

	window_setup()
	defer rl.CloseWindow()
	

// Input ----------------------------------------------------------------	
	for !rl.WindowShouldClose() {
		if rl.IsMouseButtonPressed(.LEFT) {
			// generate_random_entity()
			component_activate(player.id, .Rectangle)
			fmt.println(component_has(player.id, .Rectangle))
		}

		if rl.IsMouseButtonPressed(.RIGHT) {
			// entity_deactivate_last()
			component_deactivate(player.id, .Rectangle)
			fmt.println(component_has(player.id, .Rectangle))
		}

// Rendering ------------------------------------------------------------		
		rl.BeginDrawing()

		rl.ClearBackground(rl.WHITE)

		rendering()

		rl.EndDrawing()
	}
}

window_setup :: proc() {
	window_data.height = c.int(600)
	window_data.width = c.int(800)
	window_data.states = {.VSYNC_HINT}
	window_data.title = "Beyonddd Engine"
	window_data.fps = 60

	rl.InitWindow(window_data.width, window_data.height, window_data.title)
	rl.SetTargetFPS(window_data.fps)
	rl.SetWindowState(window_data.states)
}

rendering :: proc() {
	used_entities_id := scenes[scene_current_id].entities_id
	for id in used_entities_id {
		_entity := entities[id]
		if _entity.active {
			r_ptr := component_get(id, ^RectangleComponent)
			if r_ptr.active {
				rl.DrawRectangleRec(r_ptr.rect, r_ptr.col)
			}
		}
	}
}