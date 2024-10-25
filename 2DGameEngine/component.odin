package game_engine

import rl "vendor:raylib"
import "core:math/rand"
import "core:fmt"

component_has :: proc(_id: entity_id, _comp_type: component_type) -> bool {
	switch _comp_type {
		case .Transform:
			is_transform_active := transforms[_id].active
			return is_transform_active
		case .Rectangle:
			is_rectangle_active := rectangles[_id].active
			return is_rectangle_active
		case:
			panic("Non component_type passed as parameter")
	}
}

component_add :: proc(_id: entity_id, _comp_type: ..component_type) {
	for c in _comp_type {
		switch c {
			case .Transform:
				_transform := &transforms[_id]
				if !_transform.active {
					_transform.active = true
					if _transform.pos == rl.Vector2({0, 0}){
						component_setup_default(_transform)
					}
				}
			case .Rectangle:
				_rectangle := &rectangles[_id]
				_rectangle.active = true
				component_setup_default(_rectangle)
			case:
				panic("Non component_type passed as parameter")
		}
	} 
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

component_activate :: proc(_id: entity_id, _comp_type: ..component_type) {
	for c in _comp_type {
		switch c {
			case .Transform:
				_transform := &transforms[_id]
				_transform.active = true
			case .Rectangle:
				_rectangle := &rectangles[_id]
				_rectangle.active = true
			case:
				panic("Non component_type passed as parameter")
		}
	}
}

//NOTE: deactivate only one component
component_deactivate :: proc(_id: entity_id, _comp_type: ..component_type) {
	for c in _comp_type {
		switch c {
			case .Transform:
				_transform := &transforms[_id]
				_transform.active = false
			case .Rectangle:
				_rectangle := &rectangles[_id]
				_rectangle.active = false
			case:
				panic("Non component_type passed as parameter")
		}
	}
}

//NOTE: deactivate all components
component_deactivate_all :: proc(_id: entity_id) {
	_transform := &transforms[_id]
	_transform.active = false
	_rectangle := &rectangles[_id]
	_transform.active = false
}