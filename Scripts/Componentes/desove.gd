extends Label

var eliminable = false
var ente_id: String = ""
var oponente_id: String = ""

var la_raiz = null

func set_eliminable() -> void:
	eliminable = true

func get_activo(entid: String, opid: String) -> bool:
	return ente_id == entid and oponente_id == opid

func eliminar() -> void:
	if eliminable:
		queue_free()

func set_activo(entid: String, opid: String) -> void:
	ente_id = entid
	oponente_id = opid

func _on_button_seleccion(ind_cita: int) -> void:
	la_raiz.cambio("unacita", ind_cita)

func actualize(raiz: Node) -> void:
	la_raiz = raiz
	eliminable = false
	var ente = raiz.modelo.get_ente(ente_id)
	var oponente = raiz.modelo.get_ente(oponente_id)
	if oponente == null:
		$Imagen.texture = load("res://Sprites/General/default_card.png")
		$Nivel.text = "LVL: ???"
	else:
		if oponente.imagen == "":
			$Imagen.texture = load("res://Sprites/General/default_card.png")
		else:
			$Imagen.texture = raiz.base64_to_image(oponente.imagen)
		$Nivel.text = "LVL: " + str(oponente.nivel)
	var cita = ente.get_cita_uno(oponente_id)
	$Nombre.text = cita[ente.CITA.NOMBRE_PAR]
	if cita[ente.CITA.ID_PAR] == "":
		$Imagen.texture = load("res://Sprites/General/humans.png")
		$Nivel.text = "LVL: 0"
	if cita[ente.CITA.NARRACION] == "":
		$Resultado.text = "Result: ???"
		$Hijo.visible = false
		$BtnSeleccion.size.y = 260
	elif cita[ente.CITA.ID_HIJO] == "":
		$Resultado.text = "Result: Failure"
		$Hijo.visible = false
		$BtnSeleccion.size.y = 260
	else:
		$Resultado.text = "Result: Yes"
		$Hijo.visible = true
		$BtnSeleccion.size.y = 370
		$Hijo/Nombre.text = cita[ente.CITA.NOMBRE_HIJO]
		var hijo = raiz.modelo.get_ente(cita[ente.CITA.ID_HIJO])
		if hijo == null:
			$Hijo/Imagen.texture = load("res://Sprites/General/default_card.png")
		elif hijo.imagen == "":
			$Hijo/Imagen.texture = load("res://Sprites/General/default_card.png")
		else:
			$Hijo/Imagen.texture = raiz.base64_to_image(hijo.imagen)
	if $BtnSeleccion.size.y == 370:
		text = ".\n.\n.\n.\n.\n.\n.\n.\n.\n."
	else:
		text = ".\n.\n.\n.\n.\n.\n."
