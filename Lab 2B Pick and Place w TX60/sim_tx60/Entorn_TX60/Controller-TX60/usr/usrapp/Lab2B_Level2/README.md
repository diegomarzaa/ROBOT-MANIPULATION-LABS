# Lab2B_Level2 — cuatro montajes con alimentación automática

**Level 1 sigue en `../Lab2B/Lab2B.pjx`, sin modificar sus archivos.**
Esta versión nueva se abre con **`Lab2B_Level2.pjx`**. Cargar la carpeta
completa, con su DTX y los seis PGX; no mezclar archivos entre aplicaciones.
Solo debe ejecutarse una aplicación sobre el mismo robot y las mismas E/S.

## Estado actual

- Se conservan del Level 1 los TCP, herramientas sobre `io:valve1[0]`,
  velocidades, recogida del cilindro, estación de montaje, inserción y
  `jAssemblyMove`.
- Se añaden alimentación controlada y cuatro depósitos en matriz.
- **Faltan las cuatro recogidas de pistón, con sus aproximaciones:**
  `jPistonPick[0..7]` está a cero y debe enseñarse. No se inventan posiciones
  ni se repite cuatro veces el punto antiguo.
- **Mientras falte una postura, `start` termina con un mensaje antes de
  mover el robot o accionar salidas.** Primero calcula y muestra las alturas
  de matriz; después identifica la primera postura de pistón pendiente.
- No se afirma que el ciclo esté probado en SRS o en físico. No hay búsqueda
  de pistones ausentes: esa función pertenece al Level 3.

## Elegir modo

**`simulation=true` por defecto**: el robot ejecuta sus movimientos, tú
representas los sensores con bools; no se leen ni escriben pines y se omiten
`open/close`, conservando sus pausas. Esto no anima piezas ni alimentadores.

**`simulation=false` antes del arranque**: `physicalIO` lee los sensores y
escribe bOut10. La pinza se manda directamente con `open(tLateral/tTip)` y
`close(tLateral/tTip)`, como en la última preparación del Level 1.
El modo queda fijado en `physicalRun` hasta el siguiente arranque.

## Alimentador: señales y secuencia propuesta

Mapa del enunciado `lesson2b.pdf`, apartado 2.8, páginas PDF 6–7:

| Pin | Variable | Significado |
|---|---|---|
| **bIn2** | `cylinderPresent` | Detecta cilindro preparado para recoger. |
| **bIn14** | `feederExtended` | Final de carrera extendido. |
| **bIn15** | `feederRetracted` | Final de carrera retraído. |
| **bOut10** | `feederExtend` | true: extender; false: retraer. |
| **valve1** | Herramientas `tLateral`, `tTip` | Pinza: open/close. Conserva el ajuste del Level 1 al mando manual T1. |

`physicalIO` es el único escritor continuo de bOut10. **Nunca escribe
valve1**; así no sobrescribe los `open/close`. Se ha creado de nuevo y no
arrastra la referencia no declarada `grippe1rOpen` encontrada en el
`physicalIO` guardado de Level 1. Ese archivo original no se ha editado.

`feedCylinder` hace lo siguiente, estando el robot en la postura inicial:

1. Ordena retraer y espera retraído=true / extendido=false.
2. Si ya hay cilindro, no extiende para suministrar otro encima.
3. Si no hay cilindro, ordena extender y espera extendido=true / retraído=false.
4. Ordena retraer y espera retraído=true / extendido=false.
5. Espera presencia de cilindro antes de recogerlo.

**El PDF da el mapa de E/S, pero no detalla la secuencia mecánica completa.**
Extender/retraer antes de entrar con el robot es la secuencia propuesta,
pendiente de comprobar en la estación: una sola pieza por ciclo y pieza
accesible tras retraer. No se sustituye el final de carrera por una pausa.
Todas las esperas son `wait`, sin timeouts, como en el código anterior.

Después de retirar el cilindro, se espera **`cylinderPresent=false`**. Esto
impide reutilizar una detección antigua en el montaje siguiente. No se
alimenta mientras el robot trabaja en la estación o deposita en la matriz.

## Cuatro huecos y fin de misión

`placedCount` empieza en 0 y se incrementa **después de depositar, abrir y
completar la retirada** de cada hueco. `partIndex=placedCount` selecciona el
pistón y destino de esa vuelta, con valores 0, 1, 2 y 3.

El único bucle es `while placedCount < 4`. Al terminar el cuarto montaje,
no se vuelve a llamar a `feedCylinder` ni se recogen más piezas, aunque
bIn2 esté activo. Se ordena retraer el alimentador, se elimina el adaptador
y se termina sobre la última aproximación de matriz. No hay alimentación
anticipada de una quinta pieza.

**La matriz debe estar vacía al iniciar.** STOP no permite reanudar desde
el contador: otro arranque lo reinicia. Antes de reiniciar, retirar conjuntos
y preparar la estación. El conteo certifica que terminó la secuencia, no
que un sensor haya confirmado el agarre o montaje: no existe ese feedback
en este Level 2.

## Matriz: las ocho joints de tu foto

Se utilizan exactamente las cuatro parejas indicadas, con `tLateral`:

| Hueco (`partIndex`) | Aproximación | Depósito |
|---|---|---|
| 0 | `jMatrix[0]` | `jMatrix[1]` |
| 1 | `jMatrix[2]` | `jMatrix[3]` |
| 2 | `jMatrix[4]` | `jMatrix[5]` |
| 3 | `jMatrix[6]` | `jMatrix[7]` |

Transcripción, todos los valores en grados:

| Índice | J1 | J2 | J3 | J4 | J5 | J6 |
|---|---:|---:|---:|---:|---:|---:|
| 0 | -20.2 | 86.06 | 60.55 | -127.89 | 66 | 106.62 |
| 1 | -19.89 | 101.16 | 44.56 | -127.27 | 65.59 | 105.74 |
| 2 | -13.13 | 86.96 | 52.44 | -118.47 | 65.62 | 97.47 |
| 3 | -13.13 | 106.77 | 29.66 | -117.25 | 64.23 | 94.57 |
| 4 | -29.45 | 96.81 | **48.48** | -156.1 | 62.64 | 127.46 |
| 5 | -29.45 | 109.28 | 32.76 | -155.36 | 59.67 | 125.93 |
| 6 | -18.45 | 98.43 | 36.69 | -132.79 | 56.57 | **104.55** |
| 7 | -18.95 | 115.57 | 13 | -129.08 | 52.08 | 98.18 |

**Comprobación de altura:** J3 es un ángulo, no una altura. Antes de cualquier
movimiento, `start` convierte cada pareja mediante
`jointToPoint(tLateral, world, ...)`, muestra ambas Z y exige
**Z(aproximación) > Z(depósito)**. Si no se cumple, termina indicando el hueco,
sin intercambiar valores automáticamente.

Esta comprobación se ejecuta en el controlador/emulador: **no se ha medido
todavía la altura real de esas posturas**. Una Z mayor tampoco garantiza
alineación, ausencia de colisiones o una entrada vertical. Revisar cada par
con el TCP lateral en la simulación y en la célula correspondiente.

## Pistones pendientes: qué enseñar

En Data de **Lab2B_Level2**, completar `jPistonPick`, tipo joint de seis ejes,
**ocho valores**. Se conserva el convenio par/impar:

| Pistón | Aproximación | Recogida |
|---|---|---|
| 0 | `jPistonPick[0]` | `jPistonPick[1]` |
| 1 | `jPistonPick[2]` | `jPistonPick[3]` |
| 2 | `jPistonPick[4]` | `jPistonPick[5]` |
| 3 | `jPistonPick[6]` | `jPistonPick[7]` |

Enseñar estas posturas con **`tTip`**, manteniendo el pistón disponible en
cada una. Se aplican `movej` a las aproximaciones y
`movel(jointToPoint(tTip, world, joint), tTip, ...)` a recogida/retirada.
La comprobación de ceros evita usar los marcadores; no valida el agarre ni
una postura enseñada incorrectamente.

## Simulación manual por fases

Completar primero las ocho posturas de pistón. Para ensayar el caso sin
cilindro inicial, preparar `cylinderPresent=false`, `feederExtended=false`
y **`feederRetracted=true`** en la memoria del emulador.

| Fase | Qué cambiar manualmente | Qué representa |
|---|---|---|
| 0 | Nada | Muestra Z de las parejas y comprueba las posturas pendientes. |
| 10 | `feederRetracted=true`, `feederExtended=false` | Alimentador retraído. Si ya hay cilindro, salta 11/12. |
| 11 | `feederRetracted=false`, `feederExtended=true` | Ha terminado la extensión. |
| 12 | `feederExtended=false`, `feederRetracted=true` | Ha terminado la retracción. |
| 13 | **`cylinderPresent=true`** | Cilindro preparado para recoger. |
| 20 → 21 | Tras la retirada del cilindro, **`cylinderPresent=false`** | Se ha despejado el detector. |
| 30, 40, 50, 55, 60, 70 | Nada | Montaje, tránsito y depósito en el hueco correspondiente. |
| Siguiente vuelta | Repetir desde fase 10 | Siguiente pistón y pareja de matriz. |
| 100 | Nada, aunque actives `cylinderPresent` | Cuatro conjuntos; no hay quinta alimentación. |

No editar `placedCount`, `partIndex`, `cycleStep`, `feederExtend`,
`physicalRun` o `ioReady` para avanzar. El programa manda esas variables.
En físico no editar los bool de sensores: se actualizan desde las entradas.

## Programas y verificación

| Programa | Responsabilidad |
|---|---|
| `start` | Comprueba preparación/alturas, limita a cuatro y cuenta depósitos. |
| `feedCylinder` | Suministra un cilindro si falta y espera sensores. |
| `assemble` | Recoge cilindro, lo coloca, recoge el pistón seleccionado e inserta; conserva tránsito de Level 1. |
| `placeAssembly` | Recoge conjunto y lo lleva a la pareja de matriz seleccionada. |
| `physicalIO` | Lee bIn2/14/15 y aplica bOut10; no manda la pinza. |
| `stop` | Cancela movimiento y adaptador, ordena retraer si se inició hardware y conserva la pinza. |

Se mantienen nominal 30, aproximaciones 20 (tmax 100 mm/s) e inserción 5
(tmax 10 mm/s), con blend off y esperas tras todos los movimientos.

Pendiente **Check Syntax en SRS**, cálculo de alturas en el emulador, ensayo
de alimentador y trayectorias con MCP al 10% según el enunciado. No dar por
validado un recorrido por superar los esquemas XML o las pruebas de lógica.
