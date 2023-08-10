extends RichTextLabel

var parent_entity
var added_nt:bool=false

func _ready():
	parent_entity = self.get_parent()

func _physics_process(_delta):
	if parent_entity.dead==true && added_nt==false:
		self.add_text("n't")
		added_nt=true
