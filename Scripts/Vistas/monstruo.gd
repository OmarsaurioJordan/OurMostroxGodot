extends Panel

const RESULTADO = preload("res://Scenes/Componentes/resultado.tscn")
const DESOVE = preload("res://Scenes/Componentes/desove.tscn")

@onready var raiz = get_parent()

var actual_ind: int = -1

func cambio(ventana: String, ind: int = -1) -> void:
	visible = true
	call_deferred("boton_oscuro")
	actual_ind = ind
	$SubInfo.visible = false
	$SubLuchas.visible = false
	$SubCitas.visible = false
	$UnaLucha.visible = false
	$UnaCita.visible = false
	$BtnInfo.button_pressed = false
	$BtnLuchas.button_pressed = false
	$BtnCitas.button_pressed = false
	match ventana:
		"monstruo", "subinfo", "":
			$SubInfo.visible = true
			$BtnInfo.button_pressed = true
			actualize_info()
		"subluchas":
			$SubLuchas.visible = true
			$BtnLuchas.button_pressed = true
			actualize_subluchas()
		"subcitas":
			$SubCitas.visible = true
			$BtnCitas.button_pressed = true
			actualize_subcitas()
		"unalucha":
			$UnaLucha.visible = true
			$BtnLuchas.button_pressed = true
			actualize_unalucha()
		"unacita":
			$UnaCita.visible = true
			$BtnCitas.button_pressed = true
			actualize_unacita()

func actualize_info() -> void:
	var ente = raiz.get_actual_ente()
	$SubInfo/Scroll/Cosas/Informacion.actualize(ente)
	$SubInfo/Scroll/Cosas/Caracteristicas.actualize(ente)
	if ente.descripcion == "":
		$SubInfo/Scroll/Cosas/Descrip.text = "Description:\n\n*** void ***"
	else:
		$SubInfo/Scroll/Cosas/Descrip.text = "Description:\n\n" + ente.descripcion
	if ente.is_huerfano():
		$SubInfo/Scroll/Cosas/Huerfano.visible = true
		$SubInfo/Scroll/Cosas/Mother.visible = false
		$SubInfo/Scroll/Cosas/FichaMother.visible = false
		$SubInfo/Scroll/Cosas/Father.visible = false
		$SubInfo/Scroll/Cosas/FichaFather.visible = false
	else:
		$SubInfo/Scroll/Cosas/Huerfano.visible = false
		$SubInfo/Scroll/Cosas/Mother.visible = true
		$SubInfo/Scroll/Cosas/FichaMother.visible = true
		$SubInfo/Scroll/Cosas/Father.visible = true
		$SubInfo/Scroll/Cosas/FichaFather.visible = true
		$SubInfo/Scroll/Cosas/FichaMother.actuafind(
			raiz.modelo, ente.id_madre, ente.nombre_madre, 0)
		$SubInfo/Scroll/Cosas/FichaFather.actuafind(
			raiz.modelo, ente.id_padre, ente.nombre_padre, 1)
	$SubInfo/BtnActivo.text = "Kill" if ente.activo else "Revive"

func actualize_unalucha() -> void:
	var ente = raiz.get_actual_ente()
	var lucha = ente.get_lucha_ind(actual_ind)
	var lugar = lucha[ente.LUCHA.LUGAR]
	var oponente = raiz.modelo.get_ente(lucha[ente.LUCHA.ID_OP])
	var img_op = load("res://Sprites/General/default_card.png")
	if oponente != null:
		if oponente.imagen != "":
			img_op = raiz.base64_to_image(oponente.imagen)
	if lucha[ente.LUCHA.ID_OP] == "":
		img_op = load("res://Sprites/General/challenge.png")
	if ente.imagen == "":
		$UnaLucha/Scroll/Textos/Versus/ImagenA.texture =\
			load("res://Sprites/General/default_card.png")
	else:
		$UnaLucha/Scroll/Textos/Versus/ImagenA.texture = raiz.base64_to_image(ente.imagen)
	$UnaLucha/Scroll/Textos/Versus/ImagenA/Nombre.text = ente.nombre
	$UnaLucha/Scroll/Textos/Versus/ImagenB.texture = img_op
	$UnaLucha/Scroll/Textos/Versus/ImagenB/Nombre.text = lucha[ente.LUCHA.NOMBRE_OP]
	$UnaLucha/Scroll/Textos/Lugar.text = "Place: " + raiz.modelo.get_terreno_en(lugar)
	$UnaLucha/Scroll/Textos/Imagen/Imagen.texture = load(
		"res://Sprites/Terrenos/terreno" + str(int(lugar)) + ".png")
	if lucha[ente.LUCHA.NARRACION] == "":
		$UnaLucha/Scroll/Textos/Narracion.text = "Fight:\n\n*** void ***"
	else:
		$UnaLucha/Scroll/Textos/Narracion.text = "Fight:\n\n" + lucha[ente.LUCHA.NARRACION]
	if lucha[ente.LUCHA.RESULT] == "":
		$UnaLucha/Scroll/Textos/Resultado.text = "Result:\n\n*** void ***"
		$UnaLucha/Scroll/Textos/Resultado.self_modulate = Color(1, 1, 1, 1)
	else:
		$UnaLucha/Scroll/Textos/Resultado.text = "Result:\n\n" + lucha[ente.LUCHA.RESULT]
		if lucha[ente.LUCHA.VICTORIA]:
			$UnaLucha/Scroll/Textos/Resultado.self_modulate = Color("#efee00")
		else:
			$UnaLucha/Scroll/Textos/Resultado.self_modulate = Color("#ff3648")

func actualize_unacita() -> void:
	var ente = raiz.get_actual_ente()
	var cita = ente.get_cita_ind(actual_ind)
	var oponente = raiz.modelo.get_ente(cita[ente.CITA.ID_PAR])
	var img_op = load("res://Sprites/General/default_card.png")
	if oponente != null:
		if oponente.imagen != "":
			img_op = raiz.base64_to_image(oponente.imagen)
	if cita[ente.CITA.ID_PAR] == "":
		img_op = load("res://Sprites/General/humans.png")
	if ente.imagen == "":
		$UnaCita/Scroll/Textos/Cita/ImagenA.texture =\
			load("res://Sprites/General/default_card.png")
	else:
		$UnaCita/Scroll/Textos/Cita/ImagenA.texture = raiz.base64_to_image(ente.imagen)
	$UnaCita/Scroll/Textos/Cita/ImagenA/Nombre.text = ente.nombre
	$UnaCita/Scroll/Textos/Cita/ImagenB.texture = img_op
	$UnaCita/Scroll/Textos/Cita/ImagenB/Nombre.text = cita[ente.CITA.NOMBRE_PAR]
	if cita[ente.CITA.NARRACION] == "":
		$UnaCita/Scroll/Textos/Narracion.text = "Date:\n\n*** void ***"
		$UnaCita/Scroll/Textos/Resultado.text = "Result: ???"
		$UnaCita/Scroll/Textos/Ficha.visible = false
	else:
		$UnaCita/Scroll/Textos/Narracion.text = "Date:\n\n" + cita[ente.CITA.NARRACION]
		$UnaCita/Scroll/Textos/Ficha.visible = cita[ente.CITA.ID_HIJO] != ""
		if $UnaCita/Scroll/Textos/Ficha.visible:
			$UnaCita/Scroll/Textos/Ficha.actuafind(raiz.modelo, cita[ente.CITA.ID_HIJO],
				cita[ente.CITA.NOMBRE_HIJO], cita[ente.CITA.GENERO])
			$UnaCita/Scroll/Textos/Resultado.text = "Result: Yes\n"
		else:
			$UnaCita/Scroll/Textos/Resultado.text = "Result: Failure"

func actualize_subluchas() -> void:
	var ente = raiz.get_actual_ente()
	var oponentes = ente.get_luchas_oponentes()
	for res in $SubLuchas/Scroll/Luchas.get_children():
		res.set_eliminable()
	for op in oponentes:
		var res = new_resultado(ente.get_id(), op)
		res.actualize(raiz)
	for res in $SubLuchas/Scroll/Luchas.get_children():
		res.eliminar()

func actualize_subcitas() -> void:
	var ente = raiz.get_actual_ente()
	var oponentes = ente.get_citas_oponentes()
	for res in $SubCitas/Scroll/Citas.get_children():
		res.set_eliminable()
	for op in oponentes:
		var res = new_resultado(ente.get_id(), op, DESOVE, $SubCitas/Scroll/Citas)
		res.actualize(raiz)
	for res in $SubCitas/Scroll/Citas.get_children():
		res.eliminar()

func new_resultado(ente_id: String, oponente_id: String, objeto=RESULTADO,
		lista=$SubLuchas/Scroll/Luchas) -> Node:
	for res in lista.get_children():
		if res.get_activo(ente_id, oponente_id):
			return res
	var res = objeto.instantiate()
	lista.add_child(res)
	res.set_activo(ente_id, oponente_id)
	return res

func _on_btn_info_pressed() -> void:
	raiz.cambio("subinfo")

func _on_btn_luchas_pressed() -> void:
	raiz.cambio("subluchas")

func _on_btn_citas_pressed() -> void:
	raiz.cambio("subcitas")

func boton_oscuro() -> void:
	$BtnInfo.self_modulate = Color("#ffffff64") if $BtnInfo.button_pressed else Color(1, 1, 1, 1)
	$BtnLuchas.self_modulate = Color("#ffffff64") if $BtnLuchas.button_pressed else Color(1, 1, 1, 1)
	$BtnCitas.self_modulate = Color("#ffffff64") if $BtnCitas.button_pressed else Color(1, 1, 1, 1)

func _on_btn_menu_pressed() -> void:
	if raiz.retrocede_enmira():
		raiz.cambio("monstruo")
	else:
		raiz.cambio("galeria")

func _on_btn_set_desc_pressed() -> void:
	var txt = DisplayServer.clipboard_get()
	if txt == "":
		raiz.set_mensaje("No Data In\nClipboard!!!")
		return
	var ente = raiz.get_actual_ente()
	if ente.descripcion != "":
		raiz.set_mensaje("Full Data!!!")
		return
	# intentar parsear el JSON
	var json = JSON.new()
	var error = json.parse(txt)
	if error != OK:
		raiz.set_mensaje("Bad JSON!!!")
		return
	# obtener datos de diccionario
	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		raiz.set_mensaje("Bad Data!!!")
		return
	# verificar las claves
	if data.has("txt") and data.has("img"):
		# verificar los formatos de la data
		if typeof(data["txt"]) == TYPE_STRING and typeof(data["img"]) == TYPE_STRING:
			# verificar que contenga el nombre del monstruo
			if data["txt"].contains(ente.nombre):
				ente.descripcion = data["txt"]
				ente.prompt_imagen = data["img"]
				cambio("monstruo")
				raiz.save_all()
				return
	raiz.set_mensaje("Bad Data!!!")

func _on_btn_prm_desc_pressed() -> void:
	var ente = raiz.get_actual_ente()
	DisplayServer.clipboard_set(raiz.modelo.get_prompt_desc_ente(ente))
	raiz.set_mensaje("Copied!!!")

func _on_btn_prm_img_pressed() -> void:
	var ente = raiz.get_actual_ente()
	if ente.prompt_imagen != "":
		DisplayServer.clipboard_set(ente.prompt_imagen)
		raiz.set_mensaje("Copied!!!")

func is_modo_receive_imagen() -> bool:
	return visible and $SubInfo.visible

func _on_btn_activo_pressed() -> void:
	var ente = raiz.get_actual_ente()
	ente.change_activo()
	cambio("monstruo")

func _on_btn_exportar_pressed() -> void:
	var ente = raiz.get_actual_ente()
	DisplayServer.clipboard_set(ente.save_txt())
	raiz.set_mensaje("Copied!!!")

func _on_btn_luchar_pressed() -> void:
	var ente = raiz.get_actual_ente()
	if ente.get_ready():
		raiz.cambio("lucha")
	else:
		raiz.set_mensaje("Not Yet!!!")

func _on_btn_cita_pressed() -> void:
	var ente = raiz.get_actual_ente()
	if ente.get_ready():
		raiz.cambio("cita")
	else:
		raiz.set_mensaje("Not Yet!!!")

func _on_btn_prm_fight_pressed() -> void:
	var ente = raiz.get_actual_ente()
	var lucha = ente.get_lucha_ind(actual_ind)
	DisplayServer.clipboard_set(raiz.modelo.get_prompt_lucha_ente(
		ente.get_id(), lucha[ente.LUCHA.PROMPT]))
	raiz.set_mensaje("Copied!!!")

func _on_btn_set_fight_pressed() -> void:
	var txt = DisplayServer.clipboard_get()
	if txt == "":
		raiz.set_mensaje("No Data In\nClipboard!!!")
		return
	var ente = raiz.get_actual_ente()
	var lucha = ente.get_lucha_ind(actual_ind)
	if lucha[ente.LUCHA.NARRACION] != "":
		raiz.set_mensaje("Full Data!!!")
		return
	# intentar parsear el JSON
	var json = JSON.new()
	var error = json.parse(txt)
	if error != OK:
		raiz.set_mensaje("Bad JSON!!!")
		return
	# obtener datos de diccionario
	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		raiz.set_mensaje("Bad Data!!!")
		return
	# verificar las claves
	if data.has("txt") and data.has("est") and data.has("res"):
		# verificar los formatos de la data
		if typeof(data["txt"]) == TYPE_STRING and typeof(data["est"]) == TYPE_STRING and\
				typeof(data["res"]) == TYPE_BOOL:
			# verificar que contenga el nombre del monstruo
			var nombre_op = lucha[ente.LUCHA.PROMPT].split(":")[0]
			var titulo_es = ente.nombre + " vs " + nombre_op
			var titulo_en = titulo_es + " -> " + raiz.modelo.get_terreno_en(lucha[ente.LUCHA.LUGAR])
			titulo_es += " -> " + raiz.modelo.get_terreno_es(lucha[ente.LUCHA.LUGAR])
			if data["txt"].contains(titulo_es) or data["txt"].contains(titulo_en):
				lucha[ente.LUCHA.NARRACION] = data["txt"]
				lucha[ente.LUCHA.RESULT] = data["est"]
				lucha[ente.LUCHA.VICTORIA] = data["res"]
				# agregar los resultados tambien al otro monstruo
				var oponente = raiz.modelo.get_ente(lucha[ente.LUCHA.ID_OP])
				if oponente != null:
					var lugar = lucha[ente.LUCHA.LUGAR]
					var prompt = raiz.modelo.get_prompt_lucha(ente, lugar)
					var ind = oponente.new_lucha(ente.get_id(), ente.nombre, lugar, prompt)
					lucha = oponente.get_lucha_ind(ind)
					lucha[ente.LUCHA.NARRACION] = data["txt"]
					lucha[ente.LUCHA.RESULT] = data["est"]
					lucha[ente.LUCHA.VICTORIA] = not data["res"]
				# cambiar la vista
				cambio("unalucha", actual_ind)
				raiz.save_all()
				return
	raiz.set_mensaje("Bad Data!!!")

func _on_btn_volver_pressed() -> void:
	cambio("subluchas")

func _on_btn_prm_date_pressed() -> void:
	var ente = raiz.get_actual_ente()
	var cita = ente.get_cita_ind(actual_ind)
	DisplayServer.clipboard_set(raiz.modelo.get_prompt_cita_ente(
		ente.get_id(), cita[ente.CITA.PROMPT]))
	raiz.set_mensaje("Copied!!!")

func _on_btn_set_date_pressed() -> void:
	var txt = DisplayServer.clipboard_get()
	if txt == "":
		raiz.set_mensaje("No Data In\nClipboard!!!")
		return
	var ente = raiz.get_actual_ente()
	var cita = ente.get_cita_ind(actual_ind)
	if cita[ente.CITA.NARRACION] != "":
		raiz.set_mensaje("Full Data!!!")
		return
	# intentar parsear el JSON
	var json = JSON.new()
	var error = json.parse(txt)
	if error != OK:
		raiz.set_mensaje("Bad JSON!!!")
		return
	# obtener datos de diccionario
	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		raiz.set_mensaje("Bad Data!!!")
		return
	# verificar las claves
	if data.has("txt") and data.has("fin"):
		# verificar los formatos de la data
		if typeof(data["txt"]) == TYPE_STRING and typeof(data["fin"]) == TYPE_BOOL:
			# verificar que contenga el nombre del monstruo
			var nombre_op = cita[ente.CITA.PROMPT].split(":")[0]
			var titulo = ente.nombre + " date " + nombre_op
			if data["txt"].contains(titulo):
				cita[ente.CITA.NARRACION] = data["txt"]
				# creacion del hijo
				var id = ""
				if data["fin"]:
					var param: Array = []
					var adn: Array = cita[ente.CITA.ADN_PAR]
					if adn.is_empty():
						for i in range(ente.parametros.size()):
							adn.append(0)
					for i in range(ente.parametros.size()):
						param.append(ente.parametros[i] if randf() < 0.5 else adn[i])
					id = raiz.modelo.create(cita[ente.CITA.NOMBRE_HIJO],
						cita[ente.CITA.GENERO], param)
					cita[ente.CITA.ID_HIJO] = id
				# agregar los resultados tambien al otro monstruo
				var oponente = raiz.modelo.get_ente(cita[ente.CITA.ID_PAR])
				if oponente != null:
					var prompt = raiz.modelo.get_prompt_cita(ente)
					var ind = oponente.new_cita(ente.get_id(), ente.nombre, prompt,
						cita[ente.CITA.NOMBRE_HIJO], cita[ente.CITA.GENERO], ente.parametros)
					cita = oponente.get_cita_ind(ind)
					cita[ente.CITA.NARRACION] = data["txt"]
					cita[ente.CITA.ID_HIJO] = id
				# cambiar la vista
				cambio("unacita", actual_ind)
				raiz.save_all()
				return
	raiz.set_mensaje("Bad Data!!!")

func _on_btn_volver_c_pressed() -> void:
	cambio("subcitas")
