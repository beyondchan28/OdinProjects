package beyonddd_engine

import rl "vendor:raylib"
import "core:math/rand"
import "core:fmt"

transforms : [ENTITIES_SIZE]TransformComponent
rectangles : [ENTITIES_SIZE]RectangleComponent
sprites : [ENTITIES_SIZE]SpriteComponent
// shape := [ENTITIES_SIZE]shape_component

Vec2 :: [2]f32

ComponentType :: enum u8 {
	Transform,
	Rectangle,
	Sprite
}

TransformComponent :: struct {
	pos: Vec2,
	size: Vec2,
	scale: Vec2,
	active: bool,
}

RectangleComponent :: struct {
	rect: rl.Rectangle,
	col: rl.Color,
	active: bool,
}

SpriteComponent :: struct {
	pos: Vec2,
	tint: rl.Color,
	texture_id: TextureId,
	scale: f32,
	rot: f32,
	active: bool,
}


component_has :: proc(_id: EntityId, _comp_type: ComponentType) -> bool {
	switch _comp_type {
		case .Transform:
			return transforms[_id].active
		case .Rectangle:
			return rectangles[_id].active
		case .Sprite:
			return sprites[_id].active
		case:
			panic("Non ComponentType passed as parameter.")
	}
}

component_add :: proc(_id: EntityId, _comp_type: ..ComponentType) {
	for c in _comp_type {
		switch c {
			case .Transform:
				component_setup_default(&transforms[_id])
			case .Rectangle:
				component_setup_default(&rectangles[_id])
			case .Sprite:
				component_setup_default(&sprites[_id])
			case:
				panic("Non ComponentType passed as parameter")
		}
	} 
} 

component_setup_default :: proc(_comp_ptr: any) {
	switch c in _comp_ptr {
		case ^TransformComponent: 
			c.active = true
			c.pos = {rand.float32_range(80, 700), rand.float32_range(80, 500)}
			c.size = {80, 80}
			c.scale = {1, 1}
			fmt.println("Transform component passed as parameter")
		case ^RectangleComponent:
			c.active = true
			c.rect = {rand.float32_range(80, 700), rand.float32_range(80, 500), 80, 80}
			c.col = rl.BLUE
			fmt.println("Rectangle component passed as parameter")
		case ^SpriteComponent:
			c.active = true
			c.texture_id = -1 //NOTE: texture is not yet assigned  
			c.pos = {1, 1}
			c.rot = 0
			c.scale = 1
			c.tint = rl.WHITE
			fmt.println("Sprite component passed as parameter")
		case: panic("Non pointer of component passed as parameter")
	}
}

component_get :: proc(_id: EntityId, $comp_ptr: typeid) -> comp_ptr {
	when comp_ptr == ^RectangleComponent {
		return &rectangles[_id]
	} else when comp_ptr == ^TransformComponent {
		return &transforms[_id]
	} else when comp_ptr == ^SpriteComponent {
		return &sprites[_id]
	} else {
		panic("Should passing type of pointer component as parameter")
	}
}

component_activate :: proc(_id: EntityId, _comp_type: ..ComponentType) {
	for c in _comp_type {
		switch c {
			case .Transform:
				transforms[_id].active = true
			case .Rectangle:
				rectangles[_id].active = true
			case .Sprite:
				sprites[_id].active = true
			case:
				panic("Non ComponentType passed as parameter")
		}
	}
}

//NOTE: deactivate only one component
component_deactivate :: proc(_id: EntityId, _comp_type: ..ComponentType) {
	for c in _comp_type {
		switch c {
			case .Transform:
				transforms[_id].active = false
			case .Rectangle:
				rectangles[_id].active = false
			case .Sprite:
				sprites[_id].active = false
			case:
				panic("Non ComponentType passed as parameter")
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

sprite_set_texture_by_name :: proc(_id: EntityId, _texture_name: string) {
	if component_has(_id, .Sprite) {
		_texture_id := asset_find_texture_by_name("gravital")
		_sprite := &sprites[_id]
		_sprite.texture_id = _texture_id
	}
}