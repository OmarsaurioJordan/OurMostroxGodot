extends Panel

@onready var raiz = get_parent()

var luchadores: Array = []
var lucha_act: int = -1

func _ready() -> void:
	call_deferred("initialize")

func initialize() -> void:
	$Lugar.initialize(raiz.modelo)

func cambio() -> void:
	visible = true
	$Lugar.clear()
	var ente = raiz.get_actual_ente()
	set_ficha(ente, true)
	luchadores = raiz.modelo.get_luchadores(ente.get_id())
	lucha_act = randi() % luchadores.size()
	set_oponente(luchadores[lucha_act])

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

func _on_btn_menu_pressed() -> void:
	raiz.cambio("subluchas")

func set_oponente(oponente_id: String) -> void:
	if oponente_id == "":
		$Monstruo2/Imagen.texture = load("res://Sprites/General/challenge.png")
		$Monstruo2/Nombre.text = "*** Challenge ***"
		$Monstruo2/Nivel.text = "Place"
	else:
		var oponente = raiz.modelo.get_ente(oponente_id)
		set_ficha(oponente, false)

func _on_btn_left_pressed() -> void:
	lucha_act -= 1
	if lucha_act < 0:
		lucha_act = luchadores.size() - 1
	set_oponente(luchadores[lucha_act])

func _on_btn_right_pressed() -> void:
	lucha_act += 1
	if lucha_act >= luchadores.size():
		lucha_act = 0
	set_oponente(luchadores[lucha_act])

func _on_btn_fight_pressed() -> void:
	var ente = raiz.get_actual_ente()
	var id_op = luchadores[lucha_act]
	var lugar = $Lugar.get_value()
	var ind = ente.get_lucha(id_op, lugar)
	if ind == -1:
		var nombre_op = "*** Challenge ***"
		var prompt = raiz.modelo.get_prompt_lucha(null, lugar)
		if id_op != "":
			var oponente = raiz.modelo.get_ente(id_op)
			nombre_op = oponente.nombre
			prompt = raiz.modelo.get_prompt_lucha(oponente, lugar)
		ente.new_lucha(id_op, nombre_op, lugar, prompt)
	raiz.cambio("unalucha", ind)
	raiz.save_all()
