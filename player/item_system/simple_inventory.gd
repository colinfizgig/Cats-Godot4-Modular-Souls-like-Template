extends CanvasLayer

@export var signaling_node : Node3D 
@export var change_item_signal : String = "item_changed"
@export var use_item_signal  : String = "item_used"

@export var inventory : Array = []
@export var starter_item : ItemResource
@export var starter_item2 : ItemResource
@onready var current_item
@onready var item_count = $CurrentItem/MarginContainer/Background/MarginContainer/ItemCount
@onready var item_texture = $CurrentItem/MarginContainer/Background/MarginContainer/ItemTexture


signal item_used
signal inventory_updated

func _ready():
	if signaling_node:
		signaling_node.connect(change_item_signal,_on_change_item_signal)
		signaling_node.connect(use_item_signal, _on_item_used_signal)
	
	inventory_updated.connect(_on_inventory_updated)
	
	add_item(starter_item)
	add_item(starter_item2)
	
func _on_item_used_signal():
	if current_item.count > 0:
		current_item.count -= 1
		item_used.emit(current_item)
		inventory_updated.emit()
		
func _on_change_item_signal():
	if inventory.size() > 0:
		change_item(0,inventory.size()-1)
		
func _on_inventory_updated():
	if inventory[0]:
		current_item = inventory[0]
		item_count.text = str(current_item.count)
		item_texture.texture = current_item.texture
	else:
		item_count.text = str(0)
		image_texture.texture = null

func add_item(_new_item: ItemResource):
	inventory.append(_new_item)
	restack_amounts()
	
func change_item(_start_index,_destination_index):
	var start_item = inventory[_start_index]
	var dest_item = inventory[_destination_index]
	inventory[_start_index] = dest_item
	inventory[_destination_index] = start_item
	current_item = inventory[0]
	inventory_updated.emit()

#func remove_item(_index):
	#var former_item = inventory[_index] #store item in the current spot
	#inventory[_index] = null
	#inventory_updated.emit()
	#return former_item
	#
#func set_item(_index,_new_item: ItemResource):
	#var former_item = inventory[_index] #store item in the current spot
	#inventory[_index] = _new_item
	#inventory_updated.emit()
	#return former_item
	
func restack_amounts():
	var inventory_refresh = []
	print(inventory)
	await get_tree().process_frame
	for item in range(inventory.size()):
		var this_item = inventory[item]
		var found = false

		for others in range(inventory_refresh.size()):
			if this_item.name == inventory_refresh[others].name:
				this_item.count += inventory_refresh[others].count
				found = true
		if not found:
			inventory_refresh.append(this_item)
			
	inventory = inventory_refresh
	print(inventory)
	inventory_updated.emit()
