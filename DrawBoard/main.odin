package main

import rl "vendor:raylib"
import "core:fmt"
import "core:c"
import "core:mem"

window_width :: 800
window_height :: 600

tint :: struct {
	pos: rl.Vector2,
	size: rl.Vector2,
	col: rl.Color,
}

draw_tint : [dynamic][dynamic]tint
tint_to_add : [dynamic]tint

main :: proc() {
	when ODIN_DEBUG {
		track: mem.tracking_allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 { 
				fmt.eprintf("== %v allocations not freed: ====\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes %v\n", entry.size, entry.location)
					
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	setup()
	for !rl.WindowShouldClose() {
		free_all(context.temp_allocator)
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		if rl.IsMouseButtonDown(.LEFT) {
			mouse_pos := rl.GetMousePosition()
			paint := tint{mouse_pos - 8, rl.Vector2{16, 16}, rl.BLACK}
			append(&tint_to_add, paint) 
		}
		else if rl.IsMouseButtonReleased(.LEFT) {
			new_tint := make([dynamic]tint, len(tint_to_add), cap(tint_to_add))
			copy(new_tint[:], tint_to_add[:])
			append(&draw_tint, new_tint) 
			clear(&tint_to_add)
		}
		else if rl.IsKeyPressed(.SPACE) {
			if len(draw_tint) != 0 {
				delete(draw_tint[len(draw_tint) - 1]) //note: deallocate a dynamic array inside a dynamic array. 
				pop(&draw_tint)
			}
		}
		for tint in tint_to_add {
			rl.DrawRectangleV(tint.pos, tint.size, tint.col)
		}
		if len(draw_tint) != 0 {
			for tint_arr in draw_tint {
				for tint in tint_arr { 
					rl.DrawRectangleV(tint.pos, tint.size, tint.col)
				}
			} 
		}
		rl.EndDrawing()
	}
	//note: clearing all the allocations when the apps is shutdown.
	for &tint_arr in draw_tint {
		delete(tint_arr)
	}
	delete_dynamic_array(draw_tint)
	delete(tint_to_add)
	rl.CloseWindow()
}

setup :: proc() {
	//rl.settraceloglevel(.fatal)
	rl.InitWindow(window_width, window_height, "drawing board")
	// rl.settargetfps(60)
}
