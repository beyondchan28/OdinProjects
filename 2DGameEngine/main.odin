package game_engine

import "core:fmt"
import "core:strings"
import "core:math/rand"
import rl "vendor:raylib"

WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600

ENTITIES_SIZE :: int(1000)

entity_id :: distinct i32
entity :: struct {
	id: entity_id,
	active: bool,
	name: string,
}

transfrom_component :: struct {
	active: bool,
	pos: rl.Vector2,
	size: rl.Vector2,
	scale: rl.Vector2,
}

rectangle_component :: struct {
	active: bool,
	rect: rl.Rectangle,
	col: rl.Color,
}

entities : [ENTITIES_SIZE]entity

transforms : [ENTITIES_SIZE]transfrom_component
rectangles : [ENTITIES_SIZE]rectangle_component 
// shape := [ENTITIES_SIZE]shape_component

player := &entities[0]

main :: proc() {
	setup_entities()

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Game Engine")
	defer rl.CloseWindow()
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		if rl.IsMouseButtonPressed(.LEFT) {
			generate_random_entity()
		}

		if rl.IsMouseButtonPressed(.RIGHT) {
			deactivate_last_entity()
		}


		game_loop()

		rl.EndDrawing()
	}
}

/*

Implementing Entity Manager:
- Need a function to check and find active and deactive entities
- Adding a new entity, should be automatically choose the right index
- Removing an entity should also deactivated all its components
- Nice way to setup the entity with its components ?

*/

//for add a new entity
find_deactive_entity :: proc() -> ^entity {
	for &_entity in entities {
		if !_entity.active {
			return &_entity
		} 
	}
	return nil // TODO: need to find a way to handling this error properly
}

//for deactivated the latest active entity
deactivate_last_entity :: proc() {
	#reverse for &_entity in entities {
		if _entity.active {
			_transform := &transforms[_entity.id]
			_rectangle := &rectangles[_entity.id]

			if _transform.active {
				_transform.active = false
			}

			if _rectangle.active {
				_rectangle.active = false
			}

			_entity.active = false
			break
		} 
	}
}

generate_random_entity :: proc() {
	new_entity := find_deactive_entity()
	assert(new_entity != nil)
	new_entity.active = true
	new_entity.name = "Entity"

	fmt.println(new_entity.id)
	_transform := &transforms[new_entity.id]
	_transform.active = true
	_transform.pos = {rand.float32_range(80, 700), rand.float32_range(80, 500)}
	_transform.size = {80, 80}
	_transform.scale = {1, 1}

	_rectangle := &rectangles[new_entity.id]
	_rectangle.active = true
	_rectangle.rect = {_transform.pos.x, _transform.pos.y, _transform.size.x, _transform.size.y}
	_rectangle.col = rl.BLUE
}


game_loop :: proc() {
	for _entity in entities {
		if _entity.active {
			//TODO: Need to check activated components first before compute
			_transform := transforms[_entity.id]
			// fmt.println(_entity.name)
			// fmt.printfln("%.9f", _transform.pos)
			_rectangle := rectangles[_entity.id]
			rl.DrawRectangleRec(_rectangle.rect, _rectangle.col)
		}
	}
}

setup_entities :: proc() {

	id : entity_id = 0
	for &_entity in entities{
		_entity.id = id 
		id += 1
	}

	player.active = true
	player.name = "Player"

	player_transform := &transforms[player.id] 
	player_transform.active = true
	player_transform.pos = {f32(WINDOW_WIDTH/2) + 0.555555555555555, f32(WINDOW_HEIGHT/2)}
	player_transform.size = {80, 80}
	player_transform.scale = {1, 1}
	
	player_rectangle := &rectangles[entities[0].id]
	player_rectangle.active = true
	player_rectangle.rect = {player_transform.pos.x, player_transform.pos.y, player_transform.size.x, player_transform.size.y}
	player_rectangle.col = rl.RED
}
