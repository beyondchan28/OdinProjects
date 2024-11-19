package beyonddd_engine

import "core:fmt"

ENTITIES_SIZE :: int(1000)

EntityId :: distinct int
Entity :: struct {
	id: EntityId,
	active: bool,
	name: string,
}

entities : [ENTITIES_SIZE]Entity

player : ^Entity

entities_setup :: proc() {
	id : EntityId = 0
	for &_entity in entities{
		_entity.id = id 
		id += 1
	}

	player = entity_new("Player", .Transform, .Rectangle, .Sprite)
	// sprite_set_texture_by_name(player.id, "gravital")
	scene_add_entity(scene_current_id, player.id)
}

entity_generate_random :: proc() {
	new_entity := entity_new("Entity", .Transform, .Rectangle)
}

entity_new :: proc(_name: string, _comp_type: ..ComponentType ) -> ^Entity {
	new_entity := entity_find_deactive()
	new_entity.active = true
	new_entity.name = _name
	fmt.println("new EntityId : ", new_entity.id)
	if len(_comp_type) <= int(len(ComponentType)) {
		for c in _comp_type {
			component_add(new_entity.id, c)
		}
	}
	else {
		panic("ComponentType param elemts is more than its length.")
	}
	return new_entity
}


entity_deactive :: proc(_id: EntityId) {
	_entity := &entities[_id]
	_entity.active = false
}

//for add a new entity
entity_find_deactive :: proc() -> ^Entity {
	for &_entity in entities {
		if !_entity.active {
			return &_entity
		} 
	}
	panic("Running out of entities.")
}

//for deactivated the latest active entity and its deactivate its components
//TODO: Binary Search for better performance
entity_deactivate_last :: proc() {
	#reverse for &_entity in entities {
		if _entity.active {
			component_deactivate(_entity.id, .Rectangle)
			_entity.active = false
			fmt.println("EntityId", _entity.id)
			break
		}
	}
}
