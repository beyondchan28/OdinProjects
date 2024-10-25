package game_engine

import "core:fmt"

entity_generate_random :: proc() {
	new_entity := entity_new("Entity", .Transform, .Rectangle)
}

entity_new :: proc(_name: string, _comp_type: ..component_type ) -> ^entity {
	new_entity := entity_find_deactive()
	new_entity.active = true
	new_entity.name = _name
	fmt.println("new entity_id : ", new_entity.id)
	if len(_comp_type) <= int(len(component_type)) {
		for c in _comp_type {
			component_add(new_entity.id, c)
		}
	}
	else {
		panic("component_type param elemts is more than its length.")
	}
	return new_entity
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
//TODO: Binary Search for better performance
entity_deactivate_last :: proc() {
	#reverse for &_entity in entities {
		if _entity.active {
			component_deactivate(_entity.id, .Rectangle)
			_entity.active = false
			fmt.println("entity_id", _entity.id)
			break
		}
	}
}