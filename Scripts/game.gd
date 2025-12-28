extends Node

@onready var modelo = $Modelo

var enmira = []

func _ready() -> void:
	randomize()
	get_viewport().files_dropped.connect(_on_files_dropped)
	$Mensaje.visible = false
	cambio("menu")
	call_deferred("open_all")

func _on_files_dropped(files: PackedStringArray) -> void:
	var path = files[0]
	var image = Image.load_from_file(path)
	image.resize(512, 768, Image.INTERPOLATE_LANCZOS)
	if $Monstruo.is_modo_receive_imagen():
		var ente = get_actual_ente()
		if ente != null:
			if ente.imagen == "":
				var txt_img = image_to_base64(image)
				ente.set_imagen(txt_img)
				$Monstruo.cambio("monstruo")
				save_all()
			else:
				set_mensaje("Full Image!!!")

func image_to_base64(img: Image) -> String:
	var buffer = img.save_webp_to_buffer()
	return Marshalls.raw_to_base64(buffer)

func base64_to_image(base64_img: String) -> ImageTexture:
	var buffer = Marshalls.base64_to_raw(base64_img)
	var img = Image.new()
	img.load_webp_from_buffer(buffer)
	return ImageTexture.create_from_image(img)

func cambio(ventana: String, ind: int = -1) -> void:
	$Menu.visible = false
	$Galeria.visible = false
	$Nuevo.visible = false
	$Monstruo.visible = false
	$Lucha.visible = false
	$Cita.visible = false
	match ventana:
		"menu", "":
			$Menu.cambio()
		"galeria":
			$Galeria.cambio()
		"nuevo":
			$Nuevo.cambio()
		"lucha":
			$Lucha.cambio()
		"cita":
			$Cita.cambio()
		"monstruo", "subinfo", "subluchas", "subcitas", "unalucha", "unacita":
			$Monstruo.cambio(ventana, ind)

func set_enmira(id: String) -> void:
	enmira.append(id)
	cambio("monstruo")

func retrocede_enmira() -> bool:
	if enmira.is_empty():
		return false
	enmira.remove_at(enmira.size() - 1)
	return not enmira.is_empty()

func get_enmira() -> String:
	if enmira.is_empty():
		return ""
	return enmira[-1]

func get_actual_ente() -> Node:
	var id = get_enmira()
	if id == "":
		return null
	return $Modelo.get_ente(id)

func set_mensaje(msj: String) -> void:
	$Mensaje.visible = true
	$Mensaje/TimMsj.start()
	$Mensaje/Titulo.text = msj

func _on_tim_msj_timeout() -> void:
	$Mensaje.visible = false

func save_txt() -> String:
	var data = []
	for ent in $Modelo.get_children():
		data.append(ent.get_data())
	return JSON.stringify(data)

func open_txt(txt: String) -> bool:
	if txt == "":
		return false
	var json = JSON.new()
	var error = json.parse(txt)
	if error != OK:
		return false
	# obtener datos de array
	var data = json.data
	if typeof(data) != TYPE_ARRAY:
		return false
	for dt in data:
		$Modelo.load_ente(dt)
	return true

func save_all() -> void:
	var file = FileAccess.open("user://data.json", FileAccess.WRITE)
	if file:
		var data = save_txt()
		file.store_string(data)
		file.close()

func open_all() -> void:
	if FileAccess.file_exists("user://data.json"):
		var file = FileAccess.open("user://data.json", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		open_txt(data)
