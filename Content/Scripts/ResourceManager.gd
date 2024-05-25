extends Node

class_name ResourceManager

var loaded_resources = {}
var current_loader : ResourceLoader = null
var current_path: String = ""
var loading_callback = null

func load_resource(path: String):
	if path in loaded_resources:
		return loaded_resources[path]
	
	if current_loader != null:
		print("Already loading a resource.")
		return null

	current_path = path
	current_loader.load(path)

	if current_loader == null:
		print("Failed to start loading resource: ", path)
		return null

	return null

func _process(delta):
	if current_loader != null:
		var state = current_loader.poll()
		if state == ResourceLoader.THREAD_LOAD_LOADED:
			var resource = current_loader.get_resource()
			loaded_resources[current_path] = resource
			current_loader = null
		elif state == ResourceLoader.THREAD_LOAD_FAILED:
			print("Error loading resource: ", current_path)
			current_loader = null
