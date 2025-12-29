extends Panel

@onready var raiz = get_parent()

var parejas: Array = []
var pareja_act: int = -1

func cambio() -> void:
	visible = true
	$LinNombre1.text = ""
	$LinNombre2.text = ""
	var ente = raiz.get_actual_ente()
	set_ficha(ente, true)
	parejas = raiz.modelo.get_parejas(ente.get_id())
	pareja_act = randi() % parejas.size()
	set_oponente(parejas[pareja_act])

func _on_btn_menu_pressed() -> void:
	raiz.cambio("subcitas")

func _on_btn_nombre_1_pressed() -> void:
	$LinNombre1.text = raiz.modelo.get_random_name(true, false)

func _on_btn_nombre_2_pressed() -> void:
	$LinNombre2.text = raiz.modelo.get_random_name(false, true)

func set_ficha(ente: Node, is_left=true) -> void:
	var ficha = $Monstruo2
	if is_left:
		ficha = $Monstruo1
	if ente.imagen == "":
		ficha.get_node("Imagen").texture = load("res://Sprites/General/default_card.png")
	else:
		ficha.get_node("Imagen").texture = raiz.base64_to_image(ente.imagen)
	ficha.get_node("Nombre").text = ente.nombre
	ficha.get_node("Nivel").text = "LVL: " + str(ente.nivel)

func set_oponente(oponente_id: String) -> void:
	if oponente_id == "":
		$Monstruo2/Imagen.texture = load("res://Sprites/General/humans.png")
		$Monstruo2/Nombre.text = "*** Human ***"
		$Monstruo2/Nivel.text = "LVL: 0"
	else:
		var oponente = raiz.modelo.get_ente(oponente_id)
		set_ficha(oponente, false)

func _on_btn_left_pressed() -> void:
	pareja_act -= 1
	if pareja_act < 0:
		pareja_act = parejas.size() - 1
	set_oponente(parejas[pareja_act])

func _on_btn_right_pressed() -> void:
	pareja_act += 1
	if pareja_act >= parejas.size():
		pareja_act = 0
	set_oponente(parejas[pareja_act])

func _on_btn_cita_pressed() -> void:
	var nombre1 = raiz.filtro_str($LinNombre1.text,"ÁÉÍÓÚáéíóú" +
		"ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz0123456789 ").strip_edges()
	var nombre2 = raiz.filtro_str($LinNombre2.text,"ÁÉÍÓÚáéíóú" +
		"ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz0123456789 ").strip_edges()
	var ente = raiz.get_actual_ente()
	var id_op = parejas[pareja_act]
	var ind = ente.get_cita(id_op)
	if ind == -1:
		if nombre1 == "" or nombre2 == "":
			raiz.set_mensaje("No Name!!!")
			return
		var nombre_op = "*** Human ***"
		var prompt = raiz.modelo.get_prompt_cita(null, 0 if ente.genero == 1 else 1)
		var gen = 0 if randf() < 0.5 else 1
		var namehijo = nombre1 if gen == 0 else nombre2
		var adn = []
		if id_op != "":
			var oponente = raiz.modelo.get_ente(id_op)
			nombre_op = oponente.nombre
			prompt = raiz.modelo.get_prompt_cita(oponente)
			adn = oponente.parametros
		ente.new_cita(id_op, nombre_op, prompt, namehijo, gen, adn)
	raiz.cambio("unacita", ind)
	raiz.save_all()
