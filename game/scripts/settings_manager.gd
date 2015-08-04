extends Node

var settings = {}
var default_settings = {}
var settings_path = "user://settings.ini"

func _init():
	default_settings["audio"] = {
		"bgm": 100,
		"sfx": 50
	}
	reset_settings()
	load_settings()

func load_settings():
	var file = ConfigFile.new()
	file.load(settings_path)
	for section in file.get_sections():
		if(!settings.has(section)):
			settings[section] = {}
		for key in file.get_section_keys(section):
			settings[section][key] = file.get_value(section, key)
			
func save_settings():
	var file = ConfigFile.new()
	for section in settings:
		for key in settings[section]:
			file.set_value(section, key, settings[section][key])
	file.save(settings_path)
	
func reset_settings():
	settings = {}
	for section in default_settings:
		settings[section] = {}
		for key in default_settings[section]:
			settings[section][key] = default_settings[section][key]
		
func get_setting(section, key):
	if(settings.has(section) and settings[section].has(key)):
		return settings[section][key]
	else:
		return null
		
func set_setting(section, key, value):
	if(!settings.has(section)):
		settings[section] = {}
	settings[section][key] = value
	