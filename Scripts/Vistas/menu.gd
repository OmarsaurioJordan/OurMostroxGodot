extends Panel

@onready var raiz = get_parent()

func cambio() -> void:
	visible = true

func _on_btn_play_pressed() -> void:
	raiz.cambio("galeria")

func _on_btn_importar_pressed(txt="") -> void:
	if txt == "":
		txt = DisplayServer.clipboard_get()
	if raiz.open_txt(txt):
		raiz.cambio("galeria")
		raiz.save_all()

func _on_btn_exportar_pressed() -> void:
	var data = raiz.save_txt()
	DisplayServer.clipboard_set(data)
	raiz.set_mensaje("Copied!!!")
	raiz.descargar_archivo_web(data, "om_all.txt")

func _on_btn_config_pressed() -> void:
	raiz.cambio("config")
