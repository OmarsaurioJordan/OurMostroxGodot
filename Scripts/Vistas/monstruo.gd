extends Panel

const RESULTADO = preload("res://Scenes/Componentes/resultado.tscn")
const DESOVE = preload("res://Scenes/Componentes/desove.tscn")

@onready var raiz = get_parent()

var actual_ind: int = -1
var id_hijo = ""
var id_madre = ""
var id_padre = ""

func _ready() -> void:
	$UnaCita/Scroll/Textos/Ficha.get_node("BtnSeleccion").pressed.connect(_on_ver_hijo)
	$SubInfo/Scroll/Cosas/FichaMother.get_node("BtnSeleccion").pressed.connect(_on_family.bind(0))
	$SubInfo/Scroll/Cosas/FichaFather.get_node("BtnSeleccion").pressed.connect(_on_family.bind(1))

func _on_ver_hijo() -> void:
	if id_hijo != "":
		raiz.set_enmira(id_hijo)

func _on_family(family_genero: int) -> void:
	if family_genero == 0:
		if id_madre != "":
			raiz.set_enmira(id_madre)
	else:
		if id_padre != "":
			raiz.set_enmira(id_padre)

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
		if ente.id_madre != "":
			id_madre = ente.id_madre
			$SubInfo/Scroll/Cosas/Mother.visible = true
			$SubInfo/Scroll/Cosas/FichaMother.visible = true
			$SubInfo/Scroll/Cosas/FichaMother.actuafind(
				raiz.modelo, ente.id_madre, ente.nombre_madre, 0)
		else:
			$SubInfo/Scroll/Cosas/Mother.visible = false
			$SubInfo/Scroll/Cosas/FichaMother.visible = false
		if ente.id_padre != "":
			id_padre = ente.id_padre
			$SubInfo/Scroll/Cosas/Father.visible = true
			$SubInfo/Scroll/Cosas/FichaFather.visible = true
			$SubInfo/Scroll/Cosas/FichaFather.actuafind(
				raiz.modelo, ente.id_padre, ente.nombre_padre, 1)
		else:
			$SubInfo/Scroll/Cosas/Father.visible = false
			$SubInfo/Scroll/Cosas/FichaFather.visible = false
	$SubInfo/BtnActivo.text = "Kill" if ente.activo else "Revive"

func actualize_unalucha() -> void:
	var ente = raiz.get_actual_ente()
	var lucha = ente.get_lucha_ind(actual_ind)
	var lugar = int(lucha[ente.LUCHA.LUGAR])
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
		$UnaCita/Scroll/Textos/Resultado.self_modulate = Color(1, 1, 1, 1)
		$UnaCita/Scroll/Textos/Ficha.visible = false
	else:
		$UnaCita/Scroll/Textos/Narracion.text = "Date:\n\n" + cita[ente.CITA.NARRACION]
		$UnaCita/Scroll/Textos/Ficha.visible = cita[ente.CITA.ID_HIJO] != ""
		if $UnaCita/Scroll/Textos/Ficha.visible:
			$UnaCita/Scroll/Textos/Ficha.actuafind(raiz.modelo, cita[ente.CITA.ID_HIJO],
				cita[ente.CITA.NOMBRE_HIJO], cita[ente.CITA.GENERO])
			id_hijo = cita[ente.CITA.ID_HIJO]
			$UnaCita/Scroll/Textos/Resultado.text = "Result: Yes\n"
			$UnaCita/Scroll/Textos/Resultado.self_modulate = Color("#efee00")
		else:
			$UnaCita/Scroll/Textos/Resultado.text = "Result: Failure"
			$UnaCita/Scroll/Textos/Resultado.self_modulate = Color("#ff3648")

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
	if $SubLuchas.visible or $SubCitas.visible:
		raiz.cambio("subinfo")
	elif $UnaLucha.visible:
		raiz.cambio("subluchas")
	elif $UnaCita.visible:
		raiz.cambio("subcitas")
	elif raiz.retrocede_enmira():
		raiz.cambio("monstruo")
	else:
		raiz.cambio("galeria")

func _on_btn_set_desc_pressed(txt="") -> void:
	if txt == "":
		txt = DisplayServer.clipboard_get()
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
	var txt = raiz.modelo.get_prompt_desc_ente(ente)
	DisplayServer.clipboard_set(txt)
	raiz.set_mensaje("Copied!!!")
	raiz.descargar_archivo_web(txt,
		"om_desc_" + ente.nombre.replace(" ", "") + ".txt")

func _on_btn_prm_img_pressed() -> void:
	var ente = raiz.get_actual_ente()
	if ente.prompt_imagen != "":
		DisplayServer.clipboard_set(ente.prompt_imagen)
		raiz.set_mensaje("Copied!!!")
		raiz.descargar_archivo_web(ente.prompt_imagen,
			"om_img_" + ente.nombre.replace(" ", "") + ".txt")

func is_modo_receive_imagen() -> bool:
	return visible and $SubInfo.visible

func _on_btn_activo_pressed() -> void:
	var ente = raiz.get_actual_ente()
	ente.change_activo()
	cambio("monstruo")
	raiz.save_all()

func _on_btn_exportar_pressed() -> void:
	var ente = raiz.get_actual_ente()
	DisplayServer.clipboard_set(ente.save_txt())
	raiz.set_mensaje("Copied!!!")
	raiz.descargar_archivo_web(ente.save_txt(),
		"om_mons_" + ente.nombre.replace(" ", "") + ".txt")

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
	var txt = raiz.modelo.get_prompt_lucha_ente(ente.get_id(), lucha[ente.LUCHA.PROMPT])
	DisplayServer.clipboard_set(txt)
	raiz.set_mensaje("Copied!!!")
	raiz.descargar_archivo_web(txt,
		"om_fig_" + ente.nombre.replace(" ", "") + "_" +
		lucha[ente.LUCHA.NOMBRE_OP].replace(" ", "").replace("*", "") +
		"_" + str(int(lucha[ente.LUCHA.LUGAR])) + ".txt")

func _on_btn_set_fight_pressed(txt="") -> void:
	if txt == "":
		txt = DisplayServer.clipboard_get()
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
					var lugar = int(lucha[ente.LUCHA.LUGAR])
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

func _on_btn_prm_date_pressed() -> void:
	var ente = raiz.get_actual_ente()
	var cita = ente.get_cita_ind(actual_ind)
	var txt = raiz.modelo.get_prompt_cita_ente(ente.get_id(), cita[ente.CITA.PROMPT])
	DisplayServer.clipboard_set(txt)
	raiz.set_mensaje("Copied!!!")
	raiz.descargar_archivo_web(txt,
		"om_dat_" + ente.nombre.replace(" ", "") + "_" +
		cita[ente.CITA.NOMBRE_PAR].replace(" ", "").replace("*", "") + ".txt")

func _on_btn_set_date_pressed(txt="") -> void:
	if txt == "":
		txt = DisplayServer.clipboard_get()
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
				var oponente = raiz.modelo.get_ente(cita[ente.CITA.ID_PAR])
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
					if randf() < 0.1 or (adn.all(func(v): return v == 0) and
							ente.parametros.all(func(v): return v == 0)):
						param[randi() % param.size()] = randi() % 7
					var idma = ""
					var nombrema = ""
					var idpa = ""
					var nombrepa = ""
					if ente.genero == 0:
						idma = ente.get_id()
						nombrema = ente.nombre
						if oponente != null:
							idpa = oponente.get_id()
							nombrepa = oponente.nombre
					else:
						idpa = ente.get_id()
						nombrepa = ente.nombre
						if oponente != null:
							idma = oponente.get_id()
							nombrema = oponente.nombre
					id = raiz.modelo.create(cita[ente.CITA.NOMBRE_HIJO],
						cita[ente.CITA.GENERO], param, idma, nombrema, idpa, nombrepa)
					cita[ente.CITA.ID_HIJO] = id
				# agregar los resultados tambien al otro monstruo
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

func set_txt_data(txt="") -> void:
	if $SubInfo.visible:
		_on_btn_set_desc_pressed(txt)
	elif $UnaLucha.visible:
		_on_btn_set_fight_pressed(txt)
	elif $UnaCita.visible:
		_on_btn_set_date_pressed(txt)
