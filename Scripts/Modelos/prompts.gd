extends Node

const PROMPT_DESC =\
"""IA esto es un prompt proveniente de un software que crea monstruos para luego enfrentarlos en lucha e ilustrarlos usando otra IA, el resultado será visto por un software API, no por un humano, a continuación se te entregarán las características que definen a un monstruo y vas a entregar dos resultados siguiendo las instrucciónes listadas abajo.
---
$
---
# Resultado 1:
- crearás una descripción del monstruo utilizando sus características.
- en al menos una parte de la descripción debe estar el nombre del monstruo.
- No inventarás, No imaginarás, No alucinarás, solo usa las características.
- ajusta las características acorde al género, ej: "delgado (masculino)" - "delgada (femenino)".
- este primer resultado debe estar en idioma: $$$.
- el estilo de escritura debe ser narrativamente agradable de leer, literario.
- puedes escribir las características en cualquier órden que tenga sentido.
- si la característica sugiere varias ópciónes (ej: varios peinados) escoge uno al azar.
- las características que influyan a la hora de luchar deben permanecer en el nivel
de poder descrito, para que un monstruo no tenga ventaja sobre otro por las variaciónes narrativas a pesar de que tengan la misma característica.
---
# Resultado 2:
- usarás la descripción generada en el resultado 1.
- generarás un prompt para que una IA generativa dibuje al monstruo.
- omitirás el nombre del monstruo.
- No inventarás, No imaginarás, No alucinarás, solo usa la descripción.
- puedes omitir cosas que No influyan en la imágen.
- este segundo resultado debe estar en idioma: inglés.
- el prompt debe incluir las instrucciónes de estilo dadas en #estilo.
---
## #estilo
- concepto: una figura de monstruo de cuerpo completo.
- dibujo con trazos tipo cartoon / cómic hechos a mano.
- fondo borroso monocromático, como de carta coleccionable.
- atmósfera con un toque oscuro, de terror, siniestra, con colores fríos.
- renderizado estilizado, alto contraste, alta definición.
- debe tener relación de aspecto 4:5.
---
## Los resultados serán entregados con las siguientes condiciónes:
- No formato markdown, nada de '', Ni **, Ni subrrayado, Ni itálica.
- No comentarios extra, nada de "quieres que ahora te haga..." o "aquí tengo tus resultados...".
- en el siguiente formato JSON válido:
{
  "txt": "aquí el resultado 1",
  "img": "aquí el resultado 2"
}"""

const PROMPT_FIGHT =\
"""IA esto es un prompt proveniente de un software que enfrenta monstruos en lucha, el resultado será visto por un software API, no por un humano, a continuación se te entregarán las características de la contienda y vas a entregar el resultado siguiendo las instrucciónes listadas abajo.
---
# Reglas de lucha:
- harás un análisis profundo, lógico, profesional, creativo y detallado de una pelea entre los oponentes A y B en el escenario dado.
- la aplicación es para un público adulto y maduro, por lo que puedes describir daño realista, gore, amputación, en general los oponentes luchan a muerte destrozándose, lo anterior hasta donde cumpla con los límites impuestos por la IA.
- respecto a la forma, habilidades, poderes, ítems y personalidad de los monstruos: No inventarás, No imaginarás, No alucinarás, solo usa los datos que se te proporcionan.
- los nombres de los monstruos No afectan, ejemplo: si se llama "Invencible" No significa que sea invencible.
- si un personaje tiene la habilidad de camuflaje, ten en cuenta que será pre-adaptada al escenario elegido.
- el tamaño de los personajes es similar, tallas humanoides, si un personaje se describe como gigante, a lo mucho será un 150% el tamaño promedio (es decir un poco más grande), si tiene piernas largas eso también añadirá un poco de altura claramente.
- ten en cuenta que los poderes y habilidades No deben ser ilimitados, obedecen a cansancio o limitaciónes de energía o tiempos de recarga.
- los compañeros extra o ayudantes deben tener una influencia baja en la contienda, ejemplo: un perro será de pequeño tamaño, para evitar que sea un ítem de peso decicivo.
- los poderes o habilidades No serán exageradas, ejemplo: si tiene la habilidad de movimiento veloz, esta No debe asumirse que es como la del Flash de DC cómics, eso sería muy exagerado.
- puedes hacer que el escenario influya mucho, por ejemplo, con objetos que utilizar o tranceuntes que se crucen en la lucha si es en una ciudad o eventos aleatorios como derrumbes si es en una cueva (eso si, con muy poca probabilidad dichos eventos aleatorios).
- el perdedor no necesariamente debe recibir un 100% de daño y morir, puede quedar herido, esto dependerá de la diferencia de poder entre los monstruos, dependerá de la suerte también, ya que podría suceder un ataque fatal o por el contrario una salvada milagrosa.
---
# Oponente A:
$A
---
# Oponente B:
$B
---
# Escenario:
$E
---
## Resultado esperado:
- No formato markdown, nada de '', Ni **, Ni subrrayado, Ni itálica.
- No comentarios extra, nada de "quieres que ahora te haga..." o "aquí tengo tus resultados...".
- No incluirá análisis individual de cada personaje, nada de describir pros y contras, solo importa la narrativa de la lucha.
- el encabezado de la narrativa será: nombre_A vs nombre_B -> nombre_escenario.
- la narrativa incluirá: inicio de la contienda - punto intermedio o clímax - final con una fatality o movimiento decicivo que permita mostrar claramente al ganador.
- la narrativa debe estar en idioma: $$$.
- el resultado incluirá datos estadísticos así: el porcentaje de daño recibido por cada uno de los oponentes, y el porcentaje probabilístico que tenía cada uno de ganar la pelea. Ejemplo:
Damage received:
nombre_A: num%
nombre_B: num%

Probability of Victory:
nombre_A: num%
nombre_B: num%
- incluirá un resultado result_bool que es true si ganó A, y false si ganó B.
- en el siguiente formato JSON válido:
{
  "txt": "aquí la narrativa incluído su encabezado",
  "est": "aquí los datos estadísticos",
  "res": result_bool
}"""

const PROMPT_DATE =\
"""IA esto es un prompt proveniente de un software que enfrenta monstruos en lucha aunque en esta ocasión se hará un intento de cruce genético a partir de una cita romántica, el resultado será visto por un software API, no por un humano, a continuación se te entregarán las características de la cita y vas a entregar el resultado siguiendo las instrucciónes listadas abajo.
---
# Reglas de la cita:
- harás un análisis profundo, lógico, profesional, creativo y detallado de una cita entre los monstruos A y B.
- la aplicación es para un público adulto y maduro, por lo que puedes hacer chistes verdes, usar referencias subidas de tono, usar un lenguaje cómico para público adulto, sea amoroso o violento, siempre que cumpla con los límites impuestos por la IA.
- respecto a la forma, habilidades, poderes, ítems y personalidad de los monstruos: No inventarás, No imaginarás, No alucinarás, solo usa los datos que se te proporcionan.
- los nombres de los monstruos No afectan, ejemplo: si se llama "Afrodita" No significa que sea la bella diosa como tal.
- si un personaje tiene la habilidad de camuflaje, ten en cuenta que será pre-adaptada al escenario elegido.
- el tamaño de los personajes es similar, tallas humanoides, si un personaje se describe como gigante, a lo mucho será un 150% el tamaño promedio (es decir un poco más grande), si tiene piernas largas eso también añadirá un poco de altura claramente.
- los poderes o habilidades No serán exageradas, ejemplo: si tiene la habilidad de movimiento veloz, esta No debe asumirse que es como la del Flash de DC cómics, eso sería muy exagerado.
- el lugar lo seleccionarás al azar: desierto caliente, nevado helado, montaña rocosa, llanura con pasto, ciudad con humanos peatones, interior de casa en la ciudad, terraza de edificio, limbo oscuro como cementerio, bosque denso, rio lluvioso.
- los monstruos recién se conocen, debes imaginar creativamente cómo, debe ser una narrativa entretenida y divertida de leer.
- los monstruos pueden tener una buena o mala cita, creativamente dependerá de muchos factores: la suerte, sus características, el contexto en que se conocen, sus compatibilidades, sus intereses, etc.
- No se hablará del cruce genético como tal, solo de la cita para saber si hay chance o no.
- Pueden suceder cosas extrañas y creativas nacidas del contexto.
- si el personaje B dice simplemente, Hombre: (comodín) o Mujer: (comodín), significa que debes imáginar cómo será, No es monstruo en este caso, sino humano/a, según el lugar elegido, inventarás a dicho personaje, su físico, su vestimenta, su personalidad, su oficio.
---
# Monstruo A:
$A
---
# Monstruo B:
$B
---
## Resultado esperado:
- No formato markdown, nada de '', Ni **, Ni subrrayado, Ni itálica.
- No comentarios extra, nada de "quieres que ahora te haga..." o "aquí tengo tus resultados...".
- No incluirá análisis individual de cada personaje, nada de describir pros y contras, solo importa la narrativa de la cita.
- el encabezado de la narrativa será: nombre_A date nombre_B.
- la narrativa incluirá: cómo se inició del encuentro - punto intermedio o clímax - final con resultado a favor o en contra, usualmente con un suceso chistoso o exagerado.
- la narrativa debe estar en idioma: $$$.
- incluirá un resultado result_bool que es true si la cita fué un éxito o false si fracasó.
- en el siguiente formato JSON válido:
{
  "txt": "aquí la narrativa incluído su encabezado",
  "fin": result_bool
}"""
