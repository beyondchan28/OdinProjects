package main

import rl "vendor:raylib"
import "core:c"

window_width : c.int : 800
window_height : c.int : 600


Animation :: struct {
	texture: rl.Texture2D,
	width: f32,
	height: f32,
	speed: int,
	current_frame: int,
	num_frames: int,
	frame_timer: f32,
}


 DynamicObject :: struct {
	pos: rl.Vector2,
	vel: rl.Vector2,
	size: rl.Vector2,
	rect: rl.Rectangle,
	col: rl.Color,
	anim: [dynamic]Animation,
	curr_anim: Animation
}



//initializing player
player : DynamicObject
player_grounded : bool = false

main :: proc() {

	setup()
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		player_logic()

		draw()

		rl.EndDrawing()
	}
}

setup :: proc() {
	//setup window
	rl.InitWindow(window_width, window_height, "Platformer Game")
	rl.SetTargetFPS(60)

	//init player run animation
	run_anim := Animation {
		texture = rl.LoadTexture("Assets/cat_run.png"),
		num_frames = 4,
		speed = 8
	}
	run_anim.width = f32(run_anim.texture.width)
	run_anim.height = f32(run_anim.texture.height)
	
	//player setup
	player.pos = {400,300}
	player.size = {64, 64}
	player.rect = {player.pos.x, player.pos.y, player.size.x, player.size.y}
	player.col = rl.WHITE
	append(&player.anim, run_anim)
	player.curr_anim = player.anim[0]
	
}

draw :: proc() {
	update_animation(&player.curr_anim)
}


update_animation :: proc(a: ^Animation) {
	
	a.frame_timer += 1

	a.current_frame = (a.current_frame / a.speed) % a.num_frames

	source_rect := rl.Rectangle {
		x = f32(a.current_frame) * a.width / f32(a.num_frames),
		y = 0,
		width = a.width / f32(a.num_frames),
		height = a.height
	}

	frame_height := f32(a.texture.height) * 4
	frame_width := f32(a.texture.width) * 4 / f32(a.num_frames)
	dest_rect := rl.Rectangle{
		player.pos.x, 
		player.pos.y, 
		frame_width, 
		frame_height
	}

	// a.current_frame 
	rl.DrawTexturePro(a.texture, source_rect, dest_rect, 0, 0, player.col)

}

player_logic :: proc() {
	// movement and input
	if rl.IsKeyDown(.A) {
		player.vel.x = -400 
	} else if rl.IsKeyDown(.D) {
		player.vel.x = 400
	} else {
		player.vel.x = 0
	}

	player.vel.y += 2000 * rl.GetFrameTime()
	if player_grounded && rl.IsKeyDown(.SPACE) {
		player_grounded = false
		player.vel.y = -600
	}

	player.pos += player.vel * rl.GetFrameTime()
	
	if player.pos.y > f32(rl.GetScreenHeight()) - 64 {
		player_grounded = true
		player.pos.y = f32(rl.GetScreenHeight()) - 64
	} 

}

