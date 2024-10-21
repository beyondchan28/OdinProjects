package game_engine

import "core:fmt"
import "core:strings"
import "core:math/rand"
import rl "vendor:raylib"

WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600

ENTITIES_SIZE :: int(1000)

entity_id :: distinct int
entity :: struct {
	id: entity_id,
	active: bool,
	name: string,
	active_comps: [dynamic]component_type //for checking what components were used
}

component_type :: enum u8 {
	Transform,
	Rectangle,
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

//NOTE: this only use once. can be replaced with 'any' type.
component_pointer_type :: union {
	^transfrom_component,
	^rectangle_component,
} 

entities : [ENTITIES_SIZE]entity

transforms : [ENTITIES_SIZE]transfrom_component
rectangles : [ENTITIES_SIZE]rectangle_component 
// shape := [ENTITIES_SIZE]shape_component

main :: proc() {
	entities_setup()

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Game Engine")
	defer rl.CloseWindow()
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		if rl.IsMouseButtonPressed(.LEFT) {
			generate_random_entity()
		}

		if rl.IsMouseButtonPressed(.RIGHT) {
			entity_deactivate_last()
			// comp := component_get(0, ^rectangle_component)
			// if comp.active {
			// 	comp.active = false
			// } else {
			// 	comp.col = rl.RED
			// 	comp.active = true
			// }
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

	entity_new("Player", .Transform, .Rectangle)
	component_active(0)
}

entity_new :: proc(_name: string, _comp_type: ..component_type ) -> ^entity {
	new_entity := entity_find_deactive()
	new_entity.active = true
	new_entity.name = _name
	if len(_comp_type) <= int(len(component_type)) {
		for c in _comp_type {
			entity_add_component(new_entity.id, c)
		}
	}
	else {
		panic("component_type param elemts is more than its length.")
	}
	return new_entity
}

entity_add_component :: proc(_id: entity_id, _comp_type: ..component_type) {
	ec := &entities[_id].active_comps
	for c in _comp_type {
		switch c {
			case .Transform:
				_transform := &transforms[_id]
				_transform.active = true
				append(ec, c)
				component_setup_default(_transform)
			case .Rectangle:
				_rectangle := &rectangles[_id]
				_rectangle.active = true
				append(ec, c)
				component_setup_default(_rectangle)
			case:
				panic("Non component_type passed as parameter")
		}
	} 
}

//for add a new entity
entity_find_deactive :: proc() -> ^entity {
	for &_entity in entities {
		if !_entity.active {
			return &_entity
		} 
	}
	return nil // NOTE: when running out of entities 
}

//for deactivated the latest active entity and its deactivate its components
entity_deactivate_last :: proc() {
	#reverse for &_entity in entities {
		if _entity.active {
			for &c in _entity.active_comps {
				fmt.println("loop: ",c) //BUG: somehow just looping once
				component_remove(_entity.id, c)
			}

			_entity.active = false
			// break
		}
	}
}

generate_random_entity :: proc() {
	new_entity := entity_new("Entity", .Transform, .Rectangle)
	fmt.println(new_entity.id)
}



component_setup_default :: proc(_comp_ptr: component_pointer_type) {
	switch c in _comp_ptr {
		case ^transfrom_component: 
			c.active = true
			c.pos = {rand.float32_range(80, 700), rand.float32_range(80, 500)}
			c.size = {80, 80}
			c.scale = {1, 1}
			fmt.println("Transform component inserted.")
		case ^rectangle_component:
			c.active = true
			c.rect = {rand.float32_range(80, 700), rand.float32_range(80, 500), 80, 80}
			c.col = rl.BLUE
			fmt.println("Rectangle component inserted.")
		case: panic("Non component inserted.")
	}
}


component_get :: proc(_id: entity_id, $comp_ptr: typeid) -> comp_ptr {
	when comp_ptr == ^rectangle_component {
		return &rectangles[_id]
	} else when comp_ptr == ^transform_component {
		return &transforms[_id]
	} else {
		panic("Should passing type of pointer component")
	}
}

component_active :: proc(_id: entity_id) {
	fmt.println(entities[0].active_comps)
}

component_remove :: proc(_id: entity_id, _comp_type: ..component_type) {
	for c in _comp_type {
		switch c {
			case .Transform:
				_transform := &transforms[_id]
				_transform.active = false
				entity_deactivate_component(_id, c)
			case .Rectangle:
				_rectangle := &rectangles[_id]
				_rectangle.active = false
				entity_deactivate_component(_id, c)
			case:
				panic("Non component_type passed as parameter")
		}
	}
}


//BUG: somehow not doing it properly
entity_deactivate_component :: proc(_id: entity_id, _comp_type: component_type) {
	ec := &entities[_id].active_comps
	for ct, ind in ec {
		if ct == _comp_type {
			fmt.println(_id)
			fmt.println("removed comp : ", ct)
			// free(&ec[ind])
			unordered_remove(ec, ind)
			fmt.println("size after remove : ", len(ec))
			component_active(_id)
			break
		}
	}
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