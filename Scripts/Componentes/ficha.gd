extends Label

var id: String = ""

func get_id() -> String:
	return id

func actualize(ente: Node) -> void:
	id = ente.get_id()
	$Nombre.text = ente.nombre
	$Nivel.text = "LVL: " + str(ente.nivel)
	$Genero.frame = ente.genero
	var luchas = ente.get_num_luchas() # total, victorias, derrotas
	$Estadisticas/Victorias.text = str(luchas[1]) + " v"
	$Estadisticas/Derrotas.text = str(luchas[2]) + " x"
	$Estadisticas/Hijos.text = str(ente.get_num_hijos()) + " i"
	$Activo.visible = not ente.activo
	if ente.imagen == "":
		$Imagen.texture = load("res://Sprites/General/default_card.png")
	else:
		var raiz = ente.get_parent().get_parent()
		$Imagen.texture = raiz.base64_to_image(ente.imagen)

func actuafind(modelo: Node, idd: String, nombre: String, genero: int) -> void:
	var ente = modelo.get_ente(idd)
	if ente == null:
		id = idd
		$Nombre.text = nombre
		$Nivel.text = "LVL: ???"
		$Genero.frame = genero
		$Estadisticas/Victorias.text = "? v"
		$Estadisticas/Derrotas.text = "? x"
		$Estadisticas/Hijos.text = "? i"
		$Activo.visible = true
		$Imagen.texture = load("res://Sprites/General/default_card.png")
	else:
		actualize(ente)
