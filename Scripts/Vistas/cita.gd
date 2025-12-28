extends Panel

@onready var raiz = get_parent()

func _ready() -> void:
	pass

func cambio() -> void:
	visible = true

func _on_btn_menu_pressed() -> void:
	raiz.cambio("subcitas")
