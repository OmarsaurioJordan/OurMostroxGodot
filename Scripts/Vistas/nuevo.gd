extends Panel

@onready var raiz = get_parent()

func _ready() -> void:
	call_deferred("initialize")

func initialize() -> void:
	var i = 0
	for op in $Scroll/Options.get_children():
		op.initialize(raiz.modelo, i)
		i += 1

func cambio() -> void:
	visible = true
	$LinNombre.text = ""
	$BtnGenero/Genero.frame = 0 if randf() < 0.5 else 1
	for op in $Scroll/Options.get_children():
		op.clear()

func _on_btn_menu_pressed() -> void:
	raiz.cambio("galeria")

func _on_btn_genero_pressed() -> void:
	if $BtnGenero/Genero.frame == 0:
		$BtnGenero/Genero.frame = 1
	else:
		$BtnGenero/Genero.frame = 0

func _on_btn_nombre_pressed() -> void:
	var fem = $BtnGenero/Genero.frame == 0
	var masc = $BtnGenero/Genero.frame == 1
	$LinNombre.text = raiz.modelo.get_random_name(fem, masc)

func _on_btn_crear_pressed() -> void:
	var nombre = raiz.filtro_str($LinNombre.text,"ÁÉÍÓÚáéíóú" +
		"ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz0123456789 ").strip_edges()
	if nombre == "":
		raiz.set_mensaje("No Name!!!")
		return
	var param = []
	for op in $Scroll/Options.get_children():
		param.append(op.get_selected())
	var gen = $BtnGenero/Genero.frame
	var id = raiz.modelo.create(nombre, gen, param)
	raiz.set_enmira(id)
	raiz.save_all()
