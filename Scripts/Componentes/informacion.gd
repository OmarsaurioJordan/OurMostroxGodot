extends Label

func actualize(ente: Node) -> void:
	$Nombre.text = ente.nombre
	$Nivel.text = "LVL: " + str(ente.nivel)
	$Genero.frame = ente.genero
	var opovic = ente.get_num_opovictorias() # oponentes, victorias
	var luchas = ente.get_num_luchas() # total, victorias, derrotas
	var hijos = ente.get_num_hijos()
	$Estadisticas/Oponentes.text = "opp: " + str(opovic[0])
	$Estadisticas/Triunfos.text = "win: " + str(opovic[1])
	$Estadisticas/Total.text = "fig: " + str(luchas[0])
	$Estadisticas/Victorias.text = "vic: " + str(luchas[1])
	$Estadisticas/Derrotas.text = "def: " + str(luchas[2])
	$Estadisticas/Hijos.text = "chi: " + str(hijos)
	$Activo.visible = not ente.activo
	if ente.imagen == "":
		$Imagen.texture = load("res://Sprites/General/default_card.png")
		$Instructions.visible = true
	else:
		var raiz = ente.get_parent().get_parent()
		$Imagen.texture = raiz.base64_to_image(ente.imagen)
		$Instructions.visible = false
