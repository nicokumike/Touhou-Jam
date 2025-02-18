extends EditorInspectorPlugin

func _can_handle(object: Object) -> bool:
	return object is SpineAnimationAsset
	
func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if name == "animation_name":
		var hbox = HBoxContainer.new()
		
		var label = Label.new()
		label.text = "Animation"
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(label)
		
		# Create dropdown and populate with the animation list
		var dropdown = OptionButton.new()
		dropdown.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(dropdown)
		if object.skeleton_data_resource:
			# Populate the dropdown if able
			var animations = object.skeleton_data_resource.get_animations()
			if animations.size() > 0:
				for animation in animations:
					dropdown.add_item(animation.get_name())

				# Set dropdown to the previously selected animation
				if object.animation_index <= -1:
					for i in range(dropdown.item_count):
						if object.animation_name == dropdown.get_item_text(i):
							object.animation_index = i
							break
				if object.animation_index >= 0 and object.animation_index < dropdown.item_count:
					dropdown.select(object.animation_index)

				# Connect the selection handler to change the animation name
				dropdown.item_selected.connect(func (index):
					object.animation_index = index
					object.animation_name = dropdown.get_item_text(index)
				)

		add_custom_control(hbox)
		return true
	elif name == "animation_index":
		return true
	return false
