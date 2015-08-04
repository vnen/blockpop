
extends Container

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	get_node("score").set_text("Score: " + str(get_node("/root/score_manager").get_score()))
	get_node("lives").set_text("Lives: " + str(get_node("/root/score_manager").get_lives()))
	get_node("level").set_text("Level " + str(get_node("/root/level_manager").currentLevel + 1))


