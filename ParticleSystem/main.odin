package particle_system

import rl "vendor:raylib"
import gl "vendor:raylib/rlgl"
import "core:math/rand"
import "core:math"
import "core:fmt"
import "core:c"
import "core:mem"

WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600

particle :: struct {
  pos: rl.Vector2 `fmt: "e"`,
	size: rl.Vector2 `fmt: "e"`,
	vel: rl.Vector2 `fmt: "e"`,
	col: rl.Color,
	lifetime: f32,
	time: f32
}

particles : [1000]particle


main :: proc() {



  rl.SetTargetFPS(60)
  rl.SetTraceLogLevel(.NONE)
	for i in 0..<len(particles) {
		pos := rl.Vector2{0, 0}
		size := rl.Vector2{20, 20}
		vel := rl.Vector2{(rand.float32_range(1, 3)) * 10 - 5, (rand.float32_range(1, 3)) * 10 - 5}
		col := rl.Color{u8(rand.int_max(255)),u8(rand.int_max(255)),u8(rand.int_max(255)), 255}
		lt := rand.float32_range(1, 1.5)
		new_particle := particle{pos, size, vel, col, lt, 0}
		particles[i] = new_particle
	}

  rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Particle System ?")
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		free_all(context.temp_allocator)
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		for &p in particles {
      p.pos.x += p.vel.x 
	    p.pos.y += p.vel.y
      p.time += rl.GetFrameTime()
      p.col.a -= 3 	
			if p.time >= p.lifetime {
      	p.pos = rl.Vector2{0,0}
      	p.time = 0
      	p.col.a = 255
      }
		  rl.DrawRectangleV(p.pos, p.size, p.col)
		}

    if rl.IsKeyPressed(.SPACE) {
    	for &p in particles{
    		p.pos = rl.Vector2{0,0}
    	}
    }
		
    rl.EndDrawing()
	}
}
