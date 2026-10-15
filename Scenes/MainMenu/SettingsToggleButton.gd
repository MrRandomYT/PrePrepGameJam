extends Button
class_name SettingsToggleButton

@export_subgroup("Setting")
@export var setting_name: StringName = &"is_touch"
@export var display_name: String = "Touch Controls"

@export_subgroup("Display")
@export var enabled_text: String = "ENABLED"
@export var disabled_text: String = "DISABLED"


func _ready() -> void:
	toggle_mode = true
	
	# Initialize the button from the current global setting.
	match setting_name:
		&"is_touch":
			button_pressed = GameSettings.is_touch

		_:
			push_warning(
			"SettingsToggleButton: Unknown setting: "
			+ String(setting_name)
		)

	# Initialize the button text.
	_update_display(button_pressed)

	# Update the global setting when toggled.
	toggled.connect(_on_toggled)


func _on_toggled(enabled: bool) -> void:
	match setting_name:
		&"is_touch":
			GameSettings.is_touch = enabled

		_:
			push_warning(
				"SettingsToggleButton: Unknown setting: "
				+ String(setting_name)
			)
			return

	# Update the displayed status.
	_update_display(enabled)


func _update_display(enabled: bool) -> void:
	var status: String = enabled_text if enabled else disabled_text
	text = display_name + " : " + status
