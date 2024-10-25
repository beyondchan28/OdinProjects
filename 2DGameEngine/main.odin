package game_engine

import "core:fmt"
import rl "vendor:raylib"

WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600

ENTITIES_SIZE :: int(1000)
entity_id :: distinct int
entity :: struct {
	id: entity_id,
	active: bool,
	name: string,
}

component_type :: enum u8 {
	Transform,
	Rectangle,
}

transfrom_component :: struct {
	pos: rl.Vector2,
	size: rl.Vector2,
	scale: rl.Vector2,
	active: bool,
}

rectangle_component :: struct {
	rect: rl.Rectangle,
	col: rl.Color,
	active: bool,
}

//NOTE: this only use once. can be replaced with 'any' type.
component_pointer_type :: union {
	^transfrom_component,
	^rectangle_component,
} 

entities : [ENTITIES_SIZE]entity

transforms : [ENTITIES_SIZE]transfrom_component
rectangles : [ENTITIES_SIZE]rectangle_component 
// shape := [ENTITIES_SIZE]shape_component

player : ^entity

main :: proc() {
	entities_setup()

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Game Engine")
	defer rl.CloseWindow()
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

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


		game_loop()

		rl.EndDrawing()
	}
}

entities_setup :: proc() {
	id : entity_id = 0
	for &_entity in entities{
		_entity.id = id 
		id += 1
	}

	player = entity_new("Player", .Transform, .Rectangle)
}


game_loop :: proc() {
	for _entity in entities {
		if _entity.active {
			_transform := transforms[_entity.id]
			// fmt.println(_entity.name)
			// fmt.printfln("%.9f", _transform.pos)
			_rectangle := rectangles[_entity.id]
			if _rectangle.active {
				rl.DrawRectangleRec(_rectangle.rect, _rectangle.col)
			}
		}
	}
}