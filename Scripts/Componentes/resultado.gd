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

func _on_button_seleccion(ind_lucha: int) -> void:
	la_raiz.cambio("unalucha", ind_lucha)

func actualize(raiz: Node) -> void:
	la_raiz = raiz
	eliminable = false
	var ente = raiz.modelo.get_ente(ente_id)
	var oponente = raiz.modelo.get_ente(oponente_id)
	if oponente == null:
		$Imagen.texture = load("res://Sprites/General/default_card.png")
		$Nivel.text = "LVL: ???"
		$Genero.visible = false
	else:
		if oponente.imagen == "":
			$Imagen.texture = load("res://Sprites/General/default_card.png")
		else:
			$Imagen.texture = raiz.base64_to_image(oponente.imagen)
		$Nivel.text = "LVL: " + str(oponente.nivel)
		$Genero.visible = true
		$Genero.frame = oponente.genero
	var fichas = $Lugares.get_children()
	for fi in fichas:
		fi.visible = false
		var btn = fi.get_node("BtnSeleccion")
		for connection in btn.pressed.get_connections():
			btn.pressed.disconnect(connection.callable)
	var luchas = ente.get_luchas_uno(oponente_id)
	var tot = [0.0, 0.0]
	var i = 0
	for lu in luchas:
		fichas[i].visible = true
		fichas[i].get_node("BtnSeleccion").pressed.connect(_on_button_seleccion.bind(
			ente.get_lucha(oponente_id, lu[ente.LUCHA.LUGAR])))
		fichas[i].text = raiz.modelo.get_terreno_en(lu[ente.LUCHA.LUGAR])
		var res = lu[ente.LUCHA.RESULT]
		if res == "":
			fichas[i].text += ": ???"
		else:
			res = res.split("\n")
			fichas[i].text += ": " + res[5].split(": ")[1]
			tot[0] += 1.0 if lu[ente.LUCHA.VICTORIA] else 0.0
			tot[1] += 1.0
		i += 1
	if tot[1] == 0:
		$Total.text = "vic: ???"
		$Total.self_modulate = Color(1, 1, 1, 1)
	else:
		$Total.text = "vic: " + str(int((tot[0] / tot[1]) * 100.0)) + "%"
		if tot[0] / tot[1] >= 0.5:
			$Total.self_modulate = Color("#efee00")
		else:
			$Total.self_modulate = Color("#ff3648")
	$Nombre.text = luchas[0][ente.LUCHA.NOMBRE_OP]
	if luchas[0][ente.LUCHA.ID_OP] == "":
		$Imagen.texture = load("res://Sprites/General/challenge.png")
		$Nivel.text = "Place"
	var txt = "0000000000001222334455566778899"
	text = "."
	i = 0
	for c in range(luchas.size()):
		while txt.substr(i, 1) == str(c):
			text += "\n."
			i += 1
