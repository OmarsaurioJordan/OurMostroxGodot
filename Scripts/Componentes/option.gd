extends Label

var anterior = ""

func _ready() -> void:
	var i = 1
	for it in $GridContainer.get_children():
		it.get_node("BtnOpt").pressed.connect(set_selected.bind(i))
		i += 1

func initialize(modelo: Node, param: int) -> void:
	$Titulo.text = modelo.get_par_titulo(param)
	var i = 1
	for it in $GridContainer.get_children():
		var img = str(param) + "_" + str(i)
		it.get_node("Imagen").texture = load("res://Sprites/Caracteristicas/" + img + ".png")
		it.get_node("Titulo").text = modelo.get_par_en(param, i)
		i += 1

func clear() -> void:
	anterior = ""
	for it in $GridContainer.get_children():
		it.get_node("BtnOpt").button_pressed = false
		it.get_node("BtnOpt").self_modulate = Color(1, 1, 1, 0.6)

func set_selected(ind: int) -> void:
	var act = ""
	for it in $GridContainer.get_children():
		it.get_node("BtnOpt").button_pressed = it.name == "Item" + str(ind)
		act += "1" if it.get_node("BtnOpt").button_pressed else "0"
		if it.get_node("BtnOpt").button_pressed:
			it.get_node("BtnOpt").self_modulate = Color(1, 1, 1, 0.3)
		else:
			it.get_node("BtnOpt").self_modulate = Color(1, 1, 1, 0.6)
	if anterior == act:
		clear()
	anterior = act

func get_selected() -> int:
	var i = 1
	for it in $GridContainer.get_children():
		if it.get_node("BtnOpt").button_pressed:
			return i
		i += 1
	return 0
