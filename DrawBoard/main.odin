package main

import rl "vendor:raylib"
import "core:fmt"
import "core:c"
import "core:mem"

WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600

Tint :: struct {
	pos: rl.Vector2,
	size: rl.Vector2,
	col: rl.Color,
}

draw_tint : [dynamic][dynamic]Tint
tint_to_add : [dynamic]Tint

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
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
			paint := Tint{mouse_pos - 8, rl.Vector2{16, 16}, rl.BLACK}
			append(&tint_to_add, paint) 
		}
		else if rl.IsMouseButtonReleased(.LEFT) {
			new_tint := make([dynamic]Tint, len(tint_to_add), cap(tint_to_add))
			//defer delete(new_tint)
			copy(new_tint[:], tint_to_add[:])
			append(&draw_tint, new_tint) 
			clear(&tint_to_add)
			//delete(tint_to_add)
		}
		else if rl.IsKeyPressed(.SPACE) {
			if len(draw_tint) != 0 {
				//delete(draw_tint[len(draw_tint) - 1])
				pop_safe(&draw_tint)
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
	delete(draw_tint)
	delete(tint_to_add)
	rl.CloseWindow()
}

setup :: proc() {
	//rl.SetTraceLogLevel(.FATAL)
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Drawing Board")
	// rl.SetTargetFPS(60)
}
