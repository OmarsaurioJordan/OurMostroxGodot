extends Node

const ENTE = preload("res://Scenes/Componentes/ente.tscn")

enum PARAM {
	CUERPO, PIERNAS, CABEZA, SOBRECABEZA, VESTUARIO, ARMA,
	HERRAMIENTA, COBERTURA, ESPALDA, PODER, HABILIDAD, EXTRA, EMOCION
}

enum PARTIP {
	EN, ES, DESCRIPCION, EXTRA
}

const NOMBRES_FEM = [
	"Lilith",
	"Morgana",
	"Selene",
	"Raven",
	"Medusa",
	"Lamia",
	"Sirena",
	"Banshee",
	"Harpy",
	"Vespera",
	"Bellatrix",
	"Morticia",
	"Noctura",
	"Tempesta",
	"Hexara",
	"Venatrix",
	"Umbra",
	"Calypso",
	"Ravena",
	"Drusilla",
	"Nightshade",
	"Nyxara",
	"Malefica",
	"Obsidia",
	"Grimhild",
	"Echidna",
	"Nymera",
	"Zafira",
	"Sable",
	"Arcana",
	"Inferna",
	"Scarlet",
	"Valkyra",
	"Arachne",
	"Morwena",
	"Ashara",
	"Zephyra",
	"Carmilla",
	"Lucindra",
	"Pandora",
	"Ebonia",
	"Nyssara",
	"Gravina",
	"Tenebra",
	"Dreadna",
	"Spectra",
	"Furyne",
	"Hexlina",
	"Mirella",
	"Corvina",
	"Viletta",
	"Darklyn",
	"Venomra",
	"Ruinette",
	"Mistara",
	"Grisella",
	"Shadira",
	"Noxilia",
	"Blighta",
	"Malvora"
]

const NOMBRES_MAS = [
	"Azrael",
	"Draven",
	"Behemoth",
	"Malachar",
	"Grimlock",
	"Ragnar",
	"Vorgrim",
	"Hellion",
	"Revenant",
	"Specter",
	"Warlock",
	"Dreador",
	"Brutox",
	"Skarn",
	"Oblivion",
	"Nightmare",
	"Bloodaxe",
	"Ashborn",
	"Hexlord",
	"Darkfang",
	"Slayer",
	"Wraith",
	"Phantom",
	"Morbius",
	"Lucifer",
	"Diablo",
	"Inferno",
	"Vortex",
	"Grendel",
	"Fenrir",
	"Kraken",
	"Cyclops",
	"Minotaur",
	"Hydron",
	"Necros",
	"Plague",
	"Ravager",
	"Doomer",
	"Reaper",
	"Gargoyle",
	"Berserk",
	"Skullor",
	"Tyrant",
	"Madman",
	"Savager",
	"Nightfall",
	"Stormer",
	"Blighter",
	"Voidborn",
	"Blackjaw",
	"Ironhide",
	"Bloodclaw",
	"Darkbane",
	"Feralis",
	"Duskron",
	"Pyron",
	"Frostmaw",
	"Shadowen",
	"Grimjaw",
	"Warbrut"
]

const NOMBRES_ADJ = [
	"Destroyer",
	"Reaper",
	"Psycho",
	"Ravager",
	"Nightbane",
	"Bloodfang",
	"Doomclaw",
	"Shadowborn",
	"Darkmaw",
	"Voidwalker",
	"Hellbound",
	"Stormbringer",
	"Graveborn",
	"Skullcrusher",
	"Fleshrot",
	"Ironfury",
	"Dreadlord",
	"Blackspire",
	"Bonecarver",
	"Soulrender",
	"Plagueheart",
	"Ashbringer",
	"Warped",
	"Blightfall",
	"Venomous",
	"Frostbitten",
	"Mindbreaker",
	"Riftspawn",
	"Netherborn",
	"Grimhowl",
	"Bloodmoon",
	"Darktide",
	"Hexbound",
	"Nightreign",
	"Doomherald",
	"Shadowclash",
	"Deathmark",
	"Ironclad",
	"Warcry",
	"Bonegrinder",
	"Voidscar",
	"Hellrazor",
	"Soulreaver",
	"Darkvein",
	"Gravehowl",
	"Stormreaver",
	"Blackrot",
	"Nightstalker",
	"Skullbound",
	"Fleshgnaw",
	"Doomveil",
	"Shadowwrath",
	"Bloodreign",
	"Hexreaver",
	"Ironmaw",
	"Deathgaze",
	"Voidreign",
	"Darkrender",
	"Bonewrath",
	"Soulblight"
]

const PARAMS = [
	[  # CUERPO
		["Normal", "Normal", "el tronco es con forma humanoide y talla promedio, sus órganos son frágiles"],
		["Slim", "Delgado", "tiene un tronco extremadamente delgado, como cuerpo de serpiente, puede evadir ataques"],
		["Fat", "Gordo", "tiene un abdomen grueso, gordo, robusto, pesado y resistente a golpes"],
		["Strong", "Fuerte", "su tronco es fornido, fuerte, musculoso, lo que le da el doble de fuerza al luchar"],
		["Giant", "Gigante", "tiene un cuerpo grande, largo, mide el 150% de un cuerpo promedio"],
		["Rubber", "Flexible", "tiene el poder de estirar su cuerpo y estremidades, como un caucho, resistente a fracturas"],
		["Double", "Doble", "su tronco es humanoide y promedio pero con cuatro brazos y pechos, cuatriple"],
	],
	[  # PIERNAS
		["Normal", "Normales", "tiene piernas y pies humanoides, las piernas son poco fuertes, con zapatillas"],
		["Hooves", "Pezuñas", "sus piernas terminan en cascos como de toro, resistentes y duros para trotar o pisotear"],
		["Long", "Largas", "sus extremidades inferiores son muy largas, delgadas pero fuertes, con pies en punta"],
		["Heavy", "Pesadas", "sus extremidades inferiores son gruesas y pesadas, como de elefante, muy fuertes"],
		["Claws", "Uñas", "las piernas son como de insecto, terminadas en largas garras con forma de oz"],
		["Boots", "Botas", "tiene piernas y pies humanoides, protegidos por unas grandes y fuertes botas de hierro"],
		["Quad", "Cuadrúpedo", "tiene cuatro piernas, con forma humanoide pero cuadrúpedo, y pies en punta"],
	],
	[  # CABEZA
		["Normal", "Normal", "tiene cabeza con forma humanoide, redondeada y poco resistente a los golpes"],
		["Beak", "Pico", "tiene cabeza de ave rapáz, su pico es largo y puntudo, suele golpear con el pico"],
		["Jaw", "Mandíbula", "su cabeza es como la de un cocodrilo, con una mandíbula llena de dientes, larga y fuerte"],
		["Fangs", "Colmillos", "su cabeza es como la de un felino, con trompa corta pero fuerte y con dientes puntudos"],
		["Twin", "Bicéfalo", "posee dos cabezas con forma humanoide, son dos mentes independientes con total control"],
		["Longneck", "Cuellote", "su cuello es muy largo y flexible, su cabeza minúscula con pequeña boca, parece de gusano"],
		["Robust", "Robusta", "tiene una cabeza pesada y resistente, como de animal hervívoro rumeante, con pequeña boca"],
	],
	[  # SOBRECABEZA
		["Hair", "Pelo", "tiene una larga cabellera, puede ser: ondulada, lacia, afro, crespa, alborotada, trenza"],
		["Helmet", "Casco", "su cabeza está protegida por un casco que le recubre, una armadura craneal de hierro"],
		["Horns", "Cuernos", "de su cabeza salen cachos o cornamenta, con la que puede golpear, embestir o resistir golpes"],
		["Lamp", "Lámpara", "tiene un cristal bioluminiscente que genera potentes flashes de brillo cegador, o luz normal"],
		["Tongue", "Lengua", "de su boca sale una lengua muy larga y prensil, que se dispara para golpear o sujetar"],
		["Roar", "Rugido", "un órgano nasal hinchado le permite emitir rugidos y gritos de alta potencia, ensordecedores"],
		["Senses", "Multisentidos", "tiene varios ojos y sentidos extra, puede ubicarse en la oscuridad o en situaciónes confusas"],
	],
	[  # VESTUARIO
		["Simple", "Simple", "su vestimenta es una ligera prenda de trapo desgastado que le cubre solo el cuerpo"],
		["Gown", "Vestido", "porta una túnica larga, que baja desde el pecho hasta terminar como una falda larga"],
		["Cloak", "Capa", "porta un enterizo ligero que cubre el cuerpo, y una enorme capa de la espalda hasta los pies"],
		["Vest", "Chaleco", "resistente prenda de cuero con cordones al frente, en conjunto con un faldón taparrabos"],
		["Coat", "Abrigo", "gruesa prenda de lana que cubre todo el cuerpo, brazos, cuello y hasta los muslos"],
		["Plate", "Pechera", "armadura de hierro que cubre pecho, espalda y hombos, con un taparrabos largo abajo"],
		["Camo", "Camuflaje", "vestimenta de hojas para mimetizarse con la jungla, extremidades untadas de lodo"],
	],
	[  # ARMA
		["", "", ""],
		["Sword", "Espada", "arma de hierro larga, recta, con doble filo y de ágil uso"],
		["Saber", "Sable", "arma de hierro larga, curvada, con filo por su lado externo, de ágil uso"],
		["Spear", "Lanza", "laro palo de hierro con punta perforante, se pude lanzar o usar como un bo"],
		["Mace", "Mazo", "pedazo de madera maciza como un bate, con púas de hierro por todos lados"],
		["Axe", "Hacha", "palo con cabezal de hierro aplanado y cortante, arma pesada y filosa"],
		["Trident", "Tridente", "palo de hierro con tres puntas, como un gran tenedor, útil para bloquear otras armas"],
	],
	[  # HERRAMIENTA
		["", "", ""],
		["Shield", "Escudo", "pieza metálica puesta en su brazo, que cubre gran parte del cuerpo para bloquear ataques"],
		["Knife", "Cuchillo", "pequeña arma metálica hecha para cortar carne a corta distancia, la porta en su cinturón"],
		["Whip", "Látigo", "sirve para atacar a larga distancia, el látigo tiene una cuchilla en su punta para cortar"],
		["Talons", "Garras", "de las manos le sobresalen unas largas garras afiladas, para desgarrar carne"],
		["Knuckles", "Manoplas", "sus manos están cubiertas por duros guantes con nudillos para hacer más daño al golpear"],
		["Staff", "Báculo", "palo con un cristal que genera campos de repulsión, como un escudo invisible pero penetrable"],
	],
	[  # COBERTURA
		["Skin", "Piel", "su piel es como la humana e igual de frágil que esta, sin vello"],
		["Scales", "Escamas", "su piel está cubierta de escamas de reptil, lo que la hace resistente a cortes"],
		["Feathers", "Plumas", "tiene la piel emplumada como un ave, esto le protege de algunos daños y del calor por su frescura"],
		["Fur", "Pelaje", "tiene mucho pelo en su piel, como un mamífero peludo, lo que le protege de algunos daños y del frío"],
		["Spikes", "Púas", "su piel es como la humana aunque ligeramente más gruesa, pero tiene largas púas que sobresalen"],
		["Slimy", "Babosa", "tiene una piel babosa como de anfibio, es resbaloso como si estuviera enjabonado"],
		["Exoskeleton", "Exoesqueleto", "posee una cobertura de piezas sólidas en la piel, más grandes que las escamas, como armadura"],
	],
	[  # ESPALDA
		["", "", ""],
		["Battery", "Batería", "como una mochila, que le inyecta una sustancia eléctrica que le da energía y potencia"],
		["Wings", "Alas", "son alas de ave de tamaño medio, que le permiten hacer vuelos cortos y planear al caer"],
		["Tail", "Cola", "una larga cola como de reptil, con la que puede golpear como látigo y sostener cosas ligeramente"],
		["Shell", "Caparazón", "como el de una tortuga, hace la función de escudo en la espalda, resistente pero pesado"],
		["Stinger", "Agijón", "una cola como de escorpión, su aguijón inyecta veneno no letal pero incapacitante"],
		["Pack", "Mochila", "en la mochila lleva unas cuantas bombas de gas lacrimógeno, hechas para distraer al enemigo"],
	],
	[  # PODER
		["", "", ""],
		["Fire", "Fuego", "es capáz de encender llamas de fuego con sus manos y arrojarlas al enemigo"],
		["Ice", "Hielo", "con sus manos absorve la energía reduciendo la temperatura, en segundos logra congelar cosas"],
		["Light", "Rayo", "puede generar cargas eléctricas con sus manos, lanzando un rayo que sacude al enemigo"],
		["Web", "Telaraña", "por sus manos lanza hilos de seda que sirven para atar al enemigo o aferrarse a objetos"],
		["Acid", "Ácido", "por su boca puede escupir una baba ácida, que en cuestión de minutos diluye la carne"],
		["Wind", "Viento", "con sus movimientos controla las corrientes de viento alrrededor, generando mini tifónes"],
	],
	[  # HABILIDAD
		["Simple", "Simple", "su conocimiento de lucha y agilidad física es bajo, incluso a veces es torpe"],
		["Martial", "Marcial", "tiene entrenamiento ofensivo en lucha cuerpo a cuerpo, sabe dónde y cómo golpear"],
		["Gym", "Gimnasia", "tiene entrenamiento en agilidad, parkour, flexibilidad lo que le permite evadir ataques"],
		["Intel", "Inteligencia", "tiene astucia y conocimiento, puede trazar planes estratégicos rápidamente"],
		["Drain", "Absorción", "puede drenar lentamente la vitalidad del enemigo, como un vampiro"],
		["Heal", "Regeneración", "sus heridas superficiales se recuperan en cuestión de segundos, y las profundas en minutos"],
		["Speed", "Velocidad", "puede moverse el doble de rápido que alguien normal, especialmente al desplazarse"],
	],
	[  # EXTRA
		["", "", ""],
		["Ghost", "Espectro", "un fantasma que al ser intangible no puede atacar pero si distrae al enemigo"],
		["Dog", "Perro", "un pequeño pero feroz compañero, muerde y ataca por defender a su amo"],
		["Fairy", "Hada", "ser mágico, sabio e insectoide que da información sobre el enemigo y disipa efectos"],
		["Minion", "Servil", "un flacucho asistente que porta un cuchillo, cumple órdenes y recibe daño"],
		["Swarm", "Enjambre", "insectos como abejas con pequeños aguijónes, rodean al personaje y atacan"],
		["Bike", "Vehículo", "aparato de una sola rueda motorizado, como una pequeña moto, para llegar rápidamente"],
	],
	[  # EMOCION
		["Flexible", "Flexible", "su emoción y expresividad se adapta acorde a la situación que esté viviendo"],
		["Bored", "Serio", "cara de poker, expresión de cansado o aburrido, ante cualquier evento mantiene su inexpresión"],
		["Angry", "Furioso", "tiene un carácter fuerte, impulsivo y volátil, con ceño fruncido y mandíbula tensa"],
		["Sad", "Triste", "tiene cara de tragedia, todo el tiempo con lágrimas, con la boca torcida"],
		["Happy", "Risueño", "mantiene felíz, con una risa enorme y estridente, aún en el dolor actúa como si estuviera bien"],
		["Psycho", "Psicópata", "tiene expresiónes coquetas, una mirada maligna pero seductiva, con algo de maquillaje"],
		["Mask", "Máscara", "cubre su cara con una capa de esmalte terrorífico, lo que oculta sus emociónes"],
	],
]

const PAR_TITLES = [
	["Body Type", "Tipo de Cuerpo"],
	["Legs Style", "Estilo de Piernas"],
	["Head Shape", "Forma de la Cabeza"],
	["Head Accessory", "Accesorio para Cabeza"],
	["Outfit Type", "Tipo de Vestimenta"],
	["Primary Weapon", "Arma Principal"],
	["Secondary Tool", "Herramienta Secundaria"],
	["Skin or Coverage", "Piel o Cobertura"],
	["Back Attachment", "Accesorio de Espalda"],
	["Main Power", "Poder Principal"],
	["Sub Skill", "Habilidad de Apoyo"],
	["Extra or Companion", "Extra o Compañía"],
	["Mind or Emotion", "Mente o Emoción"]
]

const TERRENOS = [
	[ # 0
		"Plains", "Llanura", 
		"terreno plano y firme, con pasto bajo, sol tenue, viento suave, sin objetos ni obstáculos, es como un gran terreno libre y despejado",
		"Shadow: Una copia espejo de sí mismo, el Oponente A se ha encontrado con su misma versión maligna, ¿Qué sucedería si el monstruo lucha con sí mismo? ahora se sabrá el resultado de dicha contienda. En caso de tener acompañantes o vehículos, estos también tienen su contraparte maligna, ambos monstruos se hallan en igualdad de condiciónes"
	],
	[ # 1
		"City", "Ciudad", 
		"es un espacio urbano diurno, muy concurrido, es una zona central rodeada de edificaciónes comerciales, tiene muchos puestos de venta en las calles, hay vitrinas de vidrio de exhibición, hay muchas personas caminando por el lugar, muchos carros, motos y camiónes pasando lentamente a causa del lento tráfico",
		"Zombies: Realmente no es un solo oponente, de entre los peatones y conductores de vehículos, comienzan a salir algunos humanos infectados, similares a zombies pero no están muertos, viven con una infección que los controla y los impulsa a atacar a algún monstruo cercano, son al menos 30, sus cuerpos son débiles y pero se mueven con la agilidad humana, atacan con ira y sed de sangre, toman objetos de su alrrededor para atacar mejor, parecen estar tan infectados que no obedecen al miedo pese a seguir siendo humanos mortales, jamás hullen, luchan a muerte"
	],
	[ # 2
		"River", "Rio", 
		"es un rio de tamaño mediano, donde el agua llega a la doilla o cadera, el agua fluye con corriente fuerte, hay muchísimas rocas de todos los tamaños, a los lados la vegetación es espesa, el sol ilumina tenuemente, está lloviendo suavemente, por lo que el ambiente es en general muy húmedo y resbaladizo",
		"Adventurers: Realmente no es un oponente, sino 4 (los aventureros humanos: Ed, Ho, Ny, Ka). Ed es un guerrero defensivo, un hombre fuerte (aunque no tanto como un monstruo), que porta armadura de aluminio, ligera y poco resistente, un escudo grande de hierro y un mazo liso como un bate de béisbol. Ho es un asaltante delgado y ágil, tiene un cuchillo en cada mano y una soga para atar a sus enemigos capturados. Ny es una mujer arquera, ella es delgada y le gusta trepar a lugares altos desde los que lanza sus flechas (su canasta almacena hasta 8), ella se toma su tiempo para dispararlas pues son pocas. Ka es una bruja con túnica púrpura, ella tiene solo dos tipos de hechizos que lanza con su báculo: curación, lo que cicatriza heridas de sus aliados, pero solo si estas son daño superficial, y chispas, que pasa electricidad a sus enemigos, aunque esta no es muy fuerte, más bien se torna molesta, ella además necesita dar respiraciónes meditativas profundas y lentas para recargar entre cada hechizo"
	],
	[ # 3
		"House", "Casa", 
		"espacio cerrado y reducido, tiene habitaciónes, pasillos, sala, cocina, comedor, hay puertas de madera, muchos objetos alrrededor como sillas, ventiladores, computador, televisor, muebles, camas, lámparas, objetos de aseo, hay iluminación artificial por bombillos",
		"Psycho: Un pequeño monstruo psicópata drogado, este tiene la talla de un humano y podría mezclarse entre ellos, salvo por su piel enegrecida como ceniza, sus ojos locos y pequeños, y su risa con una boca llena de dientes que va de oreja a oreja, este ser se ha drogado para creerse capaz de enfrentar a un monstruo, con la percepción de la realidad alterada. Sus armas son: un cuchillo, una pulidora eléctrica a batería, unas cuerdas para amarrar cuando va a torturar, una jeringa con una sustancia que marea a sus víctimas despojándoles de la mitad de su fuerza y agilidad, y finalmente, tiene un pequeño y ágil amigo diablillo del tamaño de un perro, que a demás de reírse como loco, hace travesuras para poner el combate a favor de su amo"
	],
	[ # 4
		"Building", "Edificio", 
		"zona alta de la ciudad, techos y azoteas no muy amplias, andamios, escaleras exteriores, cajónes de aires acondicionados, es de día, hay obras de construcción con bigas descubiertas, en general son lugares altos con grandes caídas alrrededor, y muy abajo son callejones",
		"Witch: Una bruja monstruosa y atractiva de talla humana, con piel rojiza, túnica negra y cuernos de diablo, no es muy fuerte ni buena para el combate cuerpo a cuerpo, pero cuenta con sus hechizos, ella además requiere de una respiración profunda y calmada para recargar energía y lanzar un nuevo hechizo. Sus hechizos son: 1. encender llamas de fuego con sus manos y arrojarlas al enemigo. 2. con sus manos absorve la energía reduciendo la temperatura, en segundos logra congelar cosas. 3. generar cargas eléctricas con sus manos, lanzando un rayo que sacude al enemigo. 4. con sus movimientos controla las corrientes de viento alrrededor, generando mini tifónes. 5. puede drenar lentamente la vitalidad del enemigo, como un vampiro. 6. solo si tiene su báculo en manos, puede teletransportarse a cortas distancias, esto es útil para esquivar ataques de emergencia. Ella además cuenta con la compañía de dos fantasmas, estos aunque al ser intangibles no pueden hacer daño al enemigo, sirven para generar distracciónes"
	],
	[ # 5
		"Desert", "Desierto", 
		"un lugar con colinas arenosas, sale vapor del suelo, los pasos se hunden en la arena, el sol brilla con gran intensidad calentando el ambiente a altas temperaturas, hay alguna que otra roca en el suelo y alguno que otro cactus con púas",
		"Dragon: Un gran dragón, este es tres veces más alto que la estatura de un monstruo promedio, tiene mandíbula de Tyranosaurio Rex por la que escupe fuego, alas enormes que aunque no le sirven para volar, puede usarlas para lanzar fuertes ráfagas de viento, tiene largas garras en sus brazos delanteros, para sujetar y desgarrar, sus poderosas patas traseras finalizan en pezuñas pesadas, está recubierto por placas de escamas rojas, posee una larga cola con púas que usa como látigo, y su olfato puede hallar presas a kilómetros. Este dragón se suele moverse por las arenas del desierto resbalándose como serpiente, para ahorrar energía, su largo cuello le permite ver a los lejos del horizonte, y dada la escacés de presas en el desierto, suele ser muy hambriento y no desaprovechará alguna oportunidad para comer. Además es inmune al fuego y al calor."
	],
	[ # 6
		"Snowy", "Nevado", 
		"un lugar con colinas de nieve, caen copos de nive del cielo, los pasos se hunden en la nieve, hace mucho frío, una gran y brillante luna ilumina, hay alguna que otra roca en el suelo y algunos enormes pinos alrededor, también hay bloques de hielo que sobresalen del suelo",
		"Yeti: Es un gigante con forma humanoide, su altura es como una vivienda de 3 pisos, sus pesadas piernas son gruesas patas como de elefante, cilíndricas y resistentes, su cuerpo y cabeza están unidos sin cuello, como un cilíndro blindado por una gruesa capa de piel, de su cabeza cae una gran melena blanca que lo cubre todo hasta las rodillas, tiene una boca de hervívoro grande pero con dientes pequeños. En su cabeza una gran naríz y varios pequeños ojos, que usa poco ya que suele caminar en línea recta todo el día y el pelo los cubre. Tiene unos brazos delgados, pesados y largos que parecen ramas de árboles, finalizados en largas garras flexibles, se mueve lentamente y cuando ataca lo hace lentamente, aplastando con sus pies y golpeando con sus brazos. Por su gran tamaño es inmune a ataques congelantes o al frío"
	],
	[ # 7
		"Forest", "Bosque", 
		"un lugar lleno de vegetación, altos árboles, enrredaderas, lianas, plantas bajas de hojas grandes, algunas rocas, caminar es complejo por la maleza, es un lugar fresco al que llega poca luz del sol, el terreno es muy irregular",
		"Cats: Realmente no es un oponente, sino 2, son un par de hermanas gemelas, ellas son monstruos de talla humana con forma de gatas antropomórficas, tienen pelaje color caqui, tienen colas que les dan estabilidad. Son físicamente muy marciales y gimnásticas, son ágiles para moverse entre los objetos que las rodean, haciendo parkour como ninjas, pueden hacer ataques de melé sincronizados, donde la una complementa o protege a la otra. Son unas cazadoras que usan como arma principal una lanza cada una, la lanza pueden arrojarla a distancia y luego ir por ella, o usarla para luchar en melé como un bo perforante. Una de ellas carga en su cinturón una bomba de gas para distraer al enemigo. La otra carga en su cinturón una banda elástica para lanzar pequeños objetos como tirachinas. Ambas son buenas para el arte del camuflaje"
	],
	[ # 8
		"Mountain", "Montaña", 
		"terreno muy rocoso e irregular, están en el alto pico de la montaña, hay barrancos y caídas, hay grandes rocas entre las que se puede saltar, paredes de piedra, el sol ilumina suavemete, el viento golpea con fuerza por la altura",
		"Mecha: un robot o mecanóide autómata, su cuerpo es una caja metálica con un potente motor de combustible, del tamaño de un automóvil, del cuál salen 6 largas patas mecánicas, con pistónes y puntas en los extremos, es un robot con forma de araña, lo que lo hace muy todoterreno. Tiene además dos brazos robóticos al frente, terminados en cierras de 1 metro de diámetro, con las que podría talar un árbol en segundos. Al acelerar su motor lanza cantidades de humo, tiene en su parte superior un parlante, que al activarse lanza ondas sonoras de choque, que pueden aturdir. Su debilidad está en su muy pequeña y escondida cabeza metálica, que posee los sensores necesarios para ver y ubicarse, aunque esto el enemigo al inicio usualmente no debería saberlo"
	],
	[ # 9
		"Limbo", "Limbo", 
		"como un cementerio, está de noche y casi no hay visibilidad, todo es oscuro y lúgubre, cae una niebla densa a causa del fresco nocturno, hay lápidas en el suelo, hay una que otra estatua de mármol, algunos árboles llenos de melena fúngica",
		"Abomination: Una abominación muy grotezca, un gordo del tamaño de un automóvil, el cuál está formado de muchos cadáveres en descomposición, está más muerto que vivo, como un gran zombie, es inmune a ataques de veneno o ácido pues su biología es bacteriana, se mueve con torpeza y pesadéz, a su paso deja rastros de sangre y trozos de cadáveres que gimen como condenados. No tiene ojos, pero se ubica en la oscuridad perfectamente con sus sentidos carroñeros. Su boca es enorme como la de un sapo, busca constantemente presas vivas para ingerirlas y unirlas para siempre a su cuerpo de carne, así se mantiene vivo, excarvando cemnterios y cazando. Tiene una horda de moscas que le siguen, como una nube enfermiza, para atacar usa hasta 6 brazos (de cadáveres) a la vez, estos brazos sobresalen de su cuerpo, con ellos golpea y agarra armas y herramientas de hueso, cuando sus brazos son arrancados, salen más de su interior, hasta que se quede sin cadáveres para existir."
	]
]

var idioma: String = "en"

func _ready() -> void:
	randomize()
	obtener_idioma()

func obtener_idioma() -> void:
	var locale = OS.get_locale_language()
	if locale == "es":
		idioma = "es"
	else:
		idioma = "en"

func get_random_name(femenino=true, masculino=true) -> String:
	var nombres = []
	if femenino or (not femenino and not masculino):
		nombres.append_array(NOMBRES_FEM)
	if masculino or (not femenino and not masculino):
		nombres.append_array(NOMBRES_MAS)
	return nombres[randi() % nombres.size()] + " " + NOMBRES_ADJ[randi() % NOMBRES_ADJ.size()]

func get_par_en(param: int, subpar: int) -> String:
	return PARAMS[param][subpar][PARTIP.EN]

func get_par_titulo(param: int) -> String:
	return PAR_TITLES[param][PARTIP.EN]

func get_new_id(chars=64) -> String:
	var charsss = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var res = ""
	for c in range(chars):
		res += charsss.substr(randi() % charsss.length(), 1)
	return res

func get_terreno_en(terreno: int) -> String:
	return TERRENOS[terreno][PARTIP.EN]

func get_terreno_es(terreno: int) -> String:
	return TERRENOS[terreno][PARTIP.ES]

func get_prompt_desc(nombre: String, genero: int, param: Array) -> String:
	var gen = "Femenino" if genero == 0 else "Masculino"
	var res = "# " + nombre + " (" + gen + "):\n"
	var i = 0
	for p in param:
		if PARAMS[i][p][PARTIP.ES] != "":
			res += "## " + PAR_TITLES[i][PARTIP.ES] + ":\n- " +\
				PARAMS[i][p][PARTIP.ES] + ": " + PARAMS[i][p][PARTIP.DESCRIPCION] + "\n"
		i += 1
	return res

func get_prompt_desc_ente(ente: Node) -> String:
	var prompt = get_parent().get_node("Prompts").PROMPT_DESC
	prompt = prompt.replace("$$$", "español" if idioma == "es" else "inglés")
	return prompt.replace("$", ente.prompt_descrip)

func get_prompt_lucha(monster_b: Node, lugar: int) -> String:
	var res: String
	if monster_b == null:
		res = TERRENOS[lugar][PARTIP.EXTRA].replace("|", "")
	else:
		res = monster_b.nombre.replace("|", "") + ": " +\
			monster_b.descripcion.replace("|", "")
	res += "|" + TERRENOS[lugar][PARTIP.ES] + ": " +\
		TERRENOS[lugar][PARTIP.DESCRIPCION].replace("|", "")
	return res

func get_prompt_lucha_ente(id_a: String, lucha: String) -> String:
	var prompt = get_parent().get_node("Prompts").PROMPT_FIGHT
	prompt = prompt.replace("$$$", "español" if idioma == "es" else "inglés")
	var ente = get_ente(id_a)
	var desc = ente.nombre.replace("|", "") + ": " + ente.descripcion.replace("|", "")
	var piezas = lucha.split("|")
	return prompt.replace("$A", desc).replace("$B", piezas[0]).replace("$E", piezas[1])

func get_prompt_cita(monster_b: Node, genero=0) -> String:
	var res: String
	if monster_b == null:
		if genero == 0:
			res = "Mujer: (comodín)"
		else:
			res = "Hombre: (comodín)"
	else:
		res = monster_b.nombre + ": " + monster_b.descripcion
	return res

func get_prompt_cita_ente(id_a: String, cita: String) -> String:
	var prompt = get_parent().get_node("Prompts").PROMPT_DATE
	prompt = prompt.replace("$$$", "español" if idioma == "es" else "inglés")
	var ente = get_ente(id_a)
	var desc = ente.nombre + ": " + ente.descripcion
	return prompt.replace("$A", desc).replace("$B", cita)

func create(nombre: String, genero: int, param: Array) -> String:
	var ente = ENTE.instantiate()
	add_child(ente)
	var prompt = get_prompt_desc(nombre, genero, param)
	ente.initialize(nombre, genero, param, prompt)
	return ente.get_id()

func load_ente(data: Dictionary) -> String:
	var ente = get_ente(data["id"])
	if ente == null:
		ente = ENTE.instantiate()
		add_child(ente)
	ente.set_data(data)
	return ente.get_id()

func get_ente(id: String) -> Node:
	for ent in get_children():
		if ent.get_id() == id:
			return ent
	return null

func get_ente_ind(id: String) -> int:
	var i = 0
	for ent in get_children():
		if ent.get_id() == id:
			return i
		i += 1
	return -1

func get_luchadores(id_exeption: String) -> Array:
	var res = []
	for ent in get_children():
		if ent.get_id() == id_exeption:
			res.append("")
		elif ent.get_ready():
			res.append(ent.get_id())
	res.shuffle()
	return res

func get_parejas(id_exeption: String) -> Array:
	var res = []
	var genero = get_ente(id_exeption).genero
	for ent in get_children():
		if ent.get_id() == id_exeption:
			res.append("")
		elif ent.get_ready() and ent.genero != genero:
			res.append(ent.get_id())
	res.shuffle()
	return res

func destruir(id: String) -> void:
	for ent in get_children():
		if ent.get_id() == id:
			ent.free()
