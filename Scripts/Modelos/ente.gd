extends Node

enum LUCHA {
	ID_OP, NOMBRE_OP, LUGAR, PROMPT, NARRACION, RESULT, VICTORIA
}

enum CITA {
	ID_PAR, NOMBRE_PAR, ID_HIJO, NOMBRE_HIJO, PROMPT, NARRACION, ADN_PAR, GENERO
}

var id: String = ""
var nombre: String = ""
var genero: int = 0
var parametros: Array = []
var imagen = ""
var activo = true

var id_madre: String = ""
var nombre_madre: String = ""
var id_padre: String = ""
var nombre_padre: String = ""

var nivel: int = 0
var descripcion: String = ""
var prompt_descrip: String = ""
var prompt_imagen: String = ""

var luchas: Array = []
var citas: Array = []

@onready var modelo = get_parent()

func _ready() -> void:
	id = modelo.get_new_id()

func initialize(nomb: String, gen: int, param: Array, prompt: String,
		idma="", nombrema="", idpa="", nombrepa="", idd="") -> void:
	if idd != "":
		id = idd
	nombre = nomb
	genero = gen
	parametros = param
	id_madre = idma
	nombre_madre = nombrema
	id_padre = idpa
	nombre_padre = nombrepa
	prompt_descrip = prompt
	nivel = 1
	for i in param:
		if i != 0:
			nivel += 1

func new_lucha(idop: String, nombreop: String, lugar: int, prompt: String) -> int:
	var i = get_lucha(idop, lugar)
	if i == -1:
		var data = [idop, nombreop, lugar, prompt, "", "", false]
		luchas.append(data)
		return luchas.size() - 1
	luchas[i][LUCHA.NOMBRE_OP] = nombreop
	luchas[i][LUCHA.PROMPT] = prompt
	return i

func new_cita(idpar: String, nombrepar: String, prompt: String,
		namehijo: String, gen: int, adn=[]) -> int:
	var i = get_cita(idpar)
	if i == -1:
		var data = [idpar, nombrepar, "", namehijo, prompt, "", adn, gen]
		citas.append(data)
		return citas.size() - 1
	citas[i][CITA.NOMBRE_PAR] = nombrepar
	citas[i][CITA.NOMBRE_HIJO] = namehijo
	citas[i][CITA.PROMPT] = prompt
	citas[i][CITA.ADN_PAR] = adn
	citas[i][CITA.GENERO] = gen
	return i

func get_id() -> String:
	return id

func get_params() -> Array:
	return parametros

func get_lucha_ind(ind: int = -1) -> Array:
	return luchas[ind]

func get_cita_ind(ind: int = -1) -> Array:
	return citas[ind]

func is_huerfano() -> bool:
	return id_madre == "" and id_padre == ""

func set_imagen(img: String) -> void:
	imagen = img

func get_data() -> Dictionary:
	var data = {
		"id": id,
		"nombre": nombre,
		"genero": genero,
		"parametros": parametros,
		"id_madre": id_madre,
		"nombre_madre": nombre_madre,
		"id_padre": id_padre,
		"nombre_padre": nombre_padre,
		"nivel": nivel,
		"descripcion": descripcion,
		"prompt_descrip": prompt_descrip,
		"prompt_imagen": prompt_imagen,
		"luchas": luchas,
		"citas": citas,
		"activo": activo,
		"imagen": imagen
	}
	return data

func set_data(data: Dictionary) -> void:
	# datos que si o si existen
	id = data.get("id", "")
	nombre = data.get("nombre", "")
	genero = data.get("genero", 0)
	parametros = data.get("parametros", [])
	prompt_descrip = data.get("prompt_descrip", "")
	nivel = data.get("nivel", 1)
	id_madre = data.get("id_madre", "")
	nombre_madre = data.get("nombre_madre", "")
	id_padre = data.get("id_padre", "")
	nombre_padre = data.get("nombre_padre", "")
	activo = data.get("activo", true)
	# datos que pueden estar desactualizados
	if data.get("descripcion", "") != "":
		descripcion = data.get("descripcion", "")
	if data.get("prompt_imagen", "") != "":
		prompt_imagen = data.get("prompt_imagen", "")
	if data.get("imagen", "") != "":
		imagen = data.get("imagen", "")
	# actualizar la lista de luchas
	var luchas_data = data.get("luchas", [])
	for luda in luchas_data:
		var i = get_lucha(luda[LUCHA.ID_OP], luda[LUCHA.LUGAR])
		if i == -1:
			luchas.append(luda)
		elif luda[LUCHA.NARRACION] != "":
			luchas[i][LUCHA.NARRACION] = luda[LUCHA.NARRACION]
			luchas[i][LUCHA.RESULT] = luda[LUCHA.RESULT]
			luchas[i][LUCHA.VICTORIA] = luda[LUCHA.VICTORIA]
	# actualizar la lista de citas
	var citas_data = data.get("citas", [])
	for cida in citas_data:
		var i = get_cita(cida[CITA.ID_PAR])
		if i == -1:
			citas.append(cida)
		elif cida[CITA.NARRACION] != "":
			citas[i][CITA.NARRACION] = cida[CITA.NARRACION]
			citas[i][CITA.ID_HIJO] = cida[CITA.ID_HIJO]
			citas[i][CITA.NOMBRE_HIJO] = cida[CITA.NOMBRE_HIJO]

func save_txt() -> String:
	var data = get_data()
	return JSON.stringify(data)

func get_lucha(idop: String, lugar: int) -> int:
	var i = 0
	for lu in luchas:
		if lu[LUCHA.ID_OP] == idop and lu[LUCHA.LUGAR] == lugar:
			return i
		i += 1
	return -1

func get_luchas_uno(idop: String) -> Array:
	var res = []
	for lu in luchas:
		if lu[LUCHA.ID_OP] == idop:
			res.append(lu)
	return res

func get_luchas_oponentes() -> Array:
	var ops = []
	for lu in luchas:
		if not lu[LUCHA.ID_OP] in ops:
			ops.append(lu[LUCHA.ID_OP])
	return ops

func get_citas_oponentes() -> Array:
	var ops = []
	for ci in citas:
		if not ci[CITA.ID_PAR] in ops:
			ops.append(ci[CITA.ID_PAR])
	return ops

func get_cita(idpar: String) -> int:
	var i = 0
	for ci in citas:
		if ci[CITA.ID_PAR] == idpar:
			return i
		i += 1
	return -1

func get_cita_uno(idpar: String) -> Array:
	for ci in citas:
		if ci[CITA.ID_PAR] == idpar:
			return ci
	return []

func get_num_opovictorias() -> Array:
	var opo = []
	var vic = 0
	for lu in luchas:
		if lu[LUCHA.NARRACION] != "":
			if lu[LUCHA.ID_OP] == "":
				if not str(int(lu[LUCHA.LUGAR])) in opo:
					opo.append(str(int(lu[LUCHA.LUGAR])))
			elif not lu[LUCHA.ID_OP] in opo:
				opo.append(lu[LUCHA.ID_OP])
	for op in opo:
		for lu in luchas:
			if lu[LUCHA.NARRACION] != "":
				if lu[LUCHA.ID_OP] == "":
					if str(int(lu[LUCHA.LUGAR])) == op:
						if lu[LUCHA.VICTORIA]:
							vic += 1
							break
				elif lu[LUCHA.ID_OP] == op:
					if lu[LUCHA.VICTORIA]:
						vic += 1
						break
	return [opo.size(), vic] # oponentes, victorias

func get_num_luchas() -> Array:
	var data = [0, 0, 0] # total, victorias, derrotas
	for lu in luchas:
		if lu[LUCHA.NARRACION] != "":
			data[0] += 1
			if lu[LUCHA.VICTORIA]:
				data[1] += 1
			else:
				data[2] += 1
	return data

func get_num_hijos() -> int:
	var tot = 0
	for ci in citas:
		if ci[CITA.ID_HIJO] != "":
			tot += 1
	return tot

func change_activo() -> void:
	activo = not activo

func get_ready() -> bool:
	return activo and descripcion != ""

func is_family(ide: String) -> bool:
	if id_madre == ide or id_padre == ide:
		return true
	for ci in citas:
		if ci[CITA.ID_HIJO] == ide:
			return true
	return false
