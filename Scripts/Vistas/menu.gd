extends Panel

@onready var raiz = get_parent()

func _ready() -> void:
	pass

func cambio() -> void:
	visible = true

func _on_btn_play_pressed() -> void:
	raiz.cambio("galeria")

func _on_btn_importar_pressed() -> void:
	var txt = DisplayServer.clipboard_get()
	if raiz.open_txt(txt):
		raiz.cambio("galeria")

func _on_btn_exportar_pressed() -> void:
	var data = raiz.save_txt()
	DisplayServer.clipboard_set(data)
	raiz.set_mensaje("Copied!!!")
