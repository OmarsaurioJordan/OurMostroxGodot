extends Label

func actualize(ente: Node) -> void:
	var i = 0
	var param = ente.get_params()
	for it in $GridContainer.get_children():
		var img = str(i) + "_" + str(int(param[i]))
		it.get_node("Imagen").texture = load("res://Sprites/Caracteristicas/" + img + ".png")
		i += 1
