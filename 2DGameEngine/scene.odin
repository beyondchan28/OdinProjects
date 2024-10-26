package beyonddd_engine

/*
How to build scene system :
- stored EntityId as an array of used entity to access its components for rendering and other systems
- 
*/

SCENE_AMOUNT :: int(1) 
SceneId:: distinct int
Scene :: struct {
	id: SceneId,
	entities_id: [dynamic]EntityId //NOTE: to accessing used entites in a particular scene.

}

scenes : [SCENE_AMOUNT]Scene
scene_current_id : SceneId = 0

scene_add_entity :: proc(_scene_id: SceneId, _entity_id: EntityId){
	append(&scenes[_scene_id].entities_id, _entity_id)
}