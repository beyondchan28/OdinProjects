package beyonddd_engine

import rl "vendor:raylib"
import "core:fmt"

ActionType :: enum u8 {
	START,
	END,
}

Action :: struct {
	name: string,
	type: ActionType,
}

ActionKey : map[Action]rl.KeyboardKey
ActionMouse : map[Action]rl.MouseButton
ActionGamepadButton : map[Action]rl.GamepadButton
ActionGamepadAxis : map[Action]rl.GamepadAxis

actions_setup :: proc() {
	action_register(Action{"left_click", .START}, rl.KeyboardKey.LEFT)
	action_register(Action{"right_click", .START}, rl.KeyboardKey.RIGHT)
}

action_register_key :: proc(_name: Action, _key: rl.KeyboardKey) {
	ActionKey[_name] = _key
}

action_register_mouse :: proc(_name: Action, _key: rl.MouseButton) {
	ActionMouse[_name] = _key
}

action_register_gamepad_button :: proc(_name: Action, _key: rl.GamepadButton) {
	ActionGamepadButton[_name] = _key
}

action_register_gamepad_axis :: proc(_name: Action, _key: rl.GamepadAxis) {
	ActionGamepadAxis[_name] = _key
}

action_register :: proc{action_register_key, action_register_mouse, action_register_gamepad_button, action_register_gamepad_axis}


action_process_mouse :: proc() {
	for _action, _key in ActionMouse {
		switch _action.type {
			case .START:
				if rl.IsMouseButtonPressed(_key) {
					do_action_pressed(_action.name)
				}
			case .END:
				if rl.IsMouseButtonReleased(_key) {
					do_action_released(_action.name)
				}
		}
	}
}

action_process_key :: proc() {
	for _action, _key in ActionKey {
		switch _action.type {
			case .START:
				if rl.IsKeyPressed(_key) {
					do_action_pressed(_action.name)
				}
			case .END:
				if rl.IsKeyReleased(_key) {
					do_action_released(_action.name)
				}
		}
	}
}

action_process :: proc() {
	if len(ActionMouse) != 0 {
		action_process_mouse() 
	}
	if len(ActionKey) != 0 {
		action_process_key()
	}
}

// example of gameplay code (systems) --------------------------------------------------------
do_action_pressed :: proc(_action_name: string) {
	if _action_name == "left_click" {
		fmt.println("left pressed ")
	}
	if _action_name == "right_click" {
		fmt.println("right pressed ")
	}
}

do_action_released :: proc(_action_name: string) {
	if _action_name == "left_click" {
		fmt.println("left pressed ")
	}
	if _action_name == "right_click" {
		fmt.println("right pressed ")
	}
}
// --------------------------------------------------------------------------------------------
