package beyonddd_engine

import rl "vendor:raylib"

/*
How to build scene system :
- stored EntityId as an array of used entity to access its components for rendering and other systems
- handle rendering asset (texture, font, etc)
*/

SCENE_AMOUNT :: int(2) 
SceneId:: distinct int
Scene :: struct {
	id: SceneId,
	entities_id: [dynamic]EntityId, //NOTE: to accessing used entites in a particular scene.
}

scenes : [SCENE_AMOUNT]Scene
scene_current_id : SceneId = 0

scenes_setup :: proc() {
	_id: SceneId = 0
	for &s in scenes {
		s.id = 0
		_id += 1 
	}
}

scene_add_entity :: proc(_scene_id: SceneId, _entity_id: EntityId) {
	append(&scenes[_scene_id].entities_id, _entity_id)
}

scene_change :: proc(_scene_id: SceneId) {
	if int(_scene_id) < len(scenes) {
		scene_current_id = _scene_id
	}
	else {
		panic("Inserted SceneId out of the bounds.")
	}
}

scene_render :: proc() {
	used_entities_id := scenes[scene_current_id].entities_id
	for id in used_entities_id {
		_entity := entities[id]
		if _entity.active {
			r_ptr := component_get(id, ^RectangleComponent)
			if r_ptr.active {
				rl.DrawRectangleRec(r_ptr.rect, r_ptr.col)
			}
			s_ptr := component_get(id, ^SpriteComponent)
			if s_ptr.active {
				if s_ptr.texture_id != -1 {
					_texture := textures[s_ptr.texture_id].texture
					rl.DrawTextureEx(_texture, s_ptr.pos, s_ptr.rot, s_ptr.scale, s_ptr.tint)
				}
			}
		}
	}
}