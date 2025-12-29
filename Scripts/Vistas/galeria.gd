extends Panel

const FICHA = preload("res://Scenes/Componentes/ficha.tscn")

@onready var raiz = get_parent()

func _ready() -> void:
	pass

func cambio() -> void:
	visible = true
	for ent in raiz.modelo.get_children():
		var ficha = find_ficha(ent.get_id())
		if ficha == null:
			ficha = FICHA.instantiate()
			$Scroll/Fichas.add_child(ficha)
			ficha.actualize(ent)
			ficha.get_node("BtnSeleccion").pressed.connect(seleccion.bind(ent.get_id()))
		else:
			ficha.actualize(raiz.modelo.get_ente(ficha.get_id()))
		ficha.visible = ent.activo or $BtnActivos.button_pressed

func find_ficha(id: String) -> Node:
	for fi in $Scroll/Fichas.get_children():
		if fi.get_id() == id:
			return fi
	return null

func seleccion(id: String) -> void:
	raiz.set_enmira(id)

func _on_btn_menu_pressed() -> void:
	raiz.cambio("menu")

func _on_btn_crear_pressed() -> void:
	raiz.cambio("nuevo")

func _on_btn_activos_pressed() -> void:
	call_deferred("cambio")

func _on_btn_importar_pressed(txt="") -> void:
	if txt == "":
		txt = DisplayServer.clipboard_get()
	if txt == "":
		raiz.set_mensaje("No Data In\nClipboard!!!")
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
	if data.has("id"):
		# verificar los formatos de la data
		if typeof(data["id"]) == TYPE_STRING:
			if raiz.modelo.load_ente(data):
				cambio()
				return
	raiz.set_mensaje("Bad Data!!!")

func destruir(id: String) -> void:
	for fi in $Scroll/Fichas.get_children():
		if fi.get_id() == id:
			fi.queue_free()

func delete_all() -> void:
	for fi in $Scroll/Fichas.get_children():
		fi.queue_free()
