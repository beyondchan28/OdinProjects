package beyonddd_engine

import rl "vendor:raylib"
import "core:math/rand"
import "core:fmt"

transforms : [ENTITIES_SIZE]TransformComponent
rectangles : [ENTITIES_SIZE]RectangleComponent 
// shape := [ENTITIES_SIZE]shape_component

ComponentType :: enum u8 {
	Transform,
	Rectangle,
}

TransformComponent :: struct {
	pos: rl.Vector2,
	size: rl.Vector2,
	scale: rl.Vector2,
	active: bool,
}

RectangleComponent :: struct {
	rect: rl.Rectangle,
	col: rl.Color,
	active: bool,
}

//NOTE: this only use once. can be replaced with 'any' type.
component_pointer_type :: union {
	^TransformComponent,
	^RectangleComponent,
} 

component_has :: proc(_id: EntityId, _comp_type: ComponentType) -> bool {
	switch _comp_type {
		case .Transform:
			is_transform_active := transforms[_id].active
			return is_transform_active
		case .Rectangle:
			is_rectangle_active := rectangles[_id].active
			return is_rectangle_active
		case:
			panic("Non ComponentType passed as parameter.")
	}
}

component_add :: proc(_id: EntityId, _comp_type: ..ComponentType) {
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
				panic("Non ComponentType passed as parameter")
		}
	} 
} 

component_setup_default :: proc(_comp_ptr: component_pointer_type) {
	switch c in _comp_ptr {
		case ^TransformComponent: 
			c.active = true
			c.pos = {rand.float32_range(80, 700), rand.float32_range(80, 500)}
			c.size = {80, 80}
			c.scale = {1, 1}
			fmt.println("Transform component inserted.")
		case ^RectangleComponent:
			c.active = true
			c.rect = {rand.float32_range(80, 700), rand.float32_range(80, 500), 80, 80}
			c.col = rl.BLUE
			fmt.println("Rectangle component inserted.")
		case: panic("Non pointer of component inserted.")
	}
}

component_get :: proc(_id: EntityId, $comp_ptr: typeid) -> comp_ptr {
	when comp_ptr == ^RectangleComponent {
		return &rectangles[_id]
	} else when comp_ptr == ^TransformComponent {
		return &transforms[_id]
	} else {
		panic("Should passing type of pointer component.")
	}
}

component_activate :: proc(_id: EntityId, _comp_type: ..ComponentType) {
	for c in _comp_type {
		switch c {
			case .Transform:
				_transform := &transforms[_id]
				_transform.active = true
			case .Rectangle:
				_rectangle := &rectangles[_id]
				_rectangle.active = true
			case:
				panic("Non ComponentType passed as parameter.")
		}
	}
}

//NOTE: deactivate only one component
component_deactivate :: proc(_id: EntityId, _comp_type: ..ComponentType) {
	for c in _comp_type {
		switch c {
			case .Transform:
				_transform := &transforms[_id]
				_transform.active = false
			case .Rectangle:
				_rectangle := &rectangles[_id]
				_rectangle.active = false
			case:
				panic("Non ComponentType passed as parameter.")
		}
	}
}

//NOTE: deactivate all components
component_deactivate_all :: proc(_id: EntityId) {
	_transform := &transforms[_id]
	_transform.active = false
	_rectangle := &rectangles[_id]
	_transform.active = false
}