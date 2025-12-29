extends Panel

@onready var raiz = get_parent()

func cambio() -> void:
	visible = true
	$BtnIdioma.text = "Prompts Languaje: " + raiz.modelo.idioma.to_upper()
	$Delete.text = $Delete.text.replace("$$$$", raiz.CLAVE_MORTAL).replace("$$$", raiz.CLAVE_MON)

func _on_btn_menu_pressed() -> void:
	raiz.cambio("menu")

func _on_btn_idioma_pressed() -> void:
	if raiz.modelo.idioma == "en":
		raiz.modelo.idioma = "es"
	else:
		raiz.modelo.idioma = "en"
	cambio()
