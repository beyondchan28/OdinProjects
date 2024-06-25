package main

import rl "vendor:raylib"
import "core:fmt"
import "core:c"

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
	setup()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		if rl.IsMouseButtonDown(.LEFT) {
			// fmt.println("pressed")

			mouse_pos := rl.GetMousePosition()
			paint := Tint{mouse_pos - 8, rl.Vector2{16, 16}, rl.BLACK}
			
			append(&tint_to_add, paint)
		}
		else if rl.IsMouseButtonReleased(.LEFT) {
			// fmt.println("released")
			new_tint := make([dynamic]Tint, len(tint_to_add), cap(tint_to_add))
			copy(new_tint[:], tint_to_add[:])
			append(&draw_tint, new_tint)
			clear(&tint_to_add)
		}
		else if rl.IsKeyPressed(.SPACE) {
			if len(draw_tint) != 0 {
				// fmt.println(len(draw_tint))
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

	rl.CloseWindow()
}

setup :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Drawing Board")
	// rl.SetTargetFPS(60)
}