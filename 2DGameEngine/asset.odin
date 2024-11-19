package beyonddd_engine

import rl "vendor:raylib"
import "core:os"
import "core:fmt"
import "core:strings"

TEXTURE_AMOUNT :: 1

ASSET_CONFIG_FILE_NAME :: "asset_config.txt"
ASSET_FOLDER_NAME :: "/assets" //NOTE: Windows specific 

TextureId :: distinct int
TextureData :: struct {
	id: TextureId,
	owner_id : EntityId,
	name : string,
	path : cstring,
	is_used : bool,
	texture : rl.Texture2D
}

textures : [TEXTURE_AMOUNT]TextureData
/*

TODO:
- load fonts, animation, sounds.
- game settings ?

*/

// asset_texture_setup_from_config_file :: proc() {
// 	if data, ok := os.read_entire_file(ASSET_CONFIG_FILE_NAME, context.temp_allocator); ok {
// 		fmt.println("loaded data stringify :", string(data))
// 		fmt.println("loaded data in bytes :", data)
// 	}
// }

asset_texture_setup_from_dir :: proc() {
	cwd := os.get_current_directory()
	fmt.println("current_directory :", cwd)

	folder, err := os.open(strings.concatenate({cwd, ASSET_FOLDER_NAME}))
	defer os.close(folder)

	if err != os.ERROR_NONE {
		fmt.println("Could not open directory for reading", err)
		os.exit(1)
	} 

	file_info : []os.File_Info
	defer os.file_info_slice_delete(file_info, context.temp_allocator)

	file_info, err = os.read_dir(folder, -1)
	if err != os.ERROR_NONE {
		fmt.println("Could not read directory", err)
		os.exit(2)
	}

	id : TextureId
	for fi in file_info {
		t := &textures[id]
		t.id = id
		id += 1
		t.owner_id = -1 //NOTE: unused
		t.is_used = false
		t.name, _ = strings.substring_to(fi.name, len(fi.name) - 4)
		t.path = strings.clone_to_cstring(fi.fullpath)
		t.texture = rl.LoadTexture(t.path)
		fmt.println(t.name)
		fmt.println(fi.fullpath)
		// fmt.print("is asset ready :", rl.IsTextureReady(t.texture))
	}
}

asset_find_texture_by_name :: proc(_name: string) -> TextureId {
	for &t in textures {
		if t.name == _name && !t.is_used {
			t.is_used = true
			return t.id
		}
	}
	panic("Texture name is invalid or no texture available Found")
}