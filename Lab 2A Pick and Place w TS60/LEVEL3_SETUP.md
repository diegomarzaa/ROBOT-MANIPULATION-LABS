# Lab 2A — Level 3 explicado y simulacion manual

## Que abrir

- **Simulacion para aprender:** `sim_ts60/Entorn_TS60/Controller-TS60/usr/usrapp/Lab2A/Lab2A.pjx`. Tiene entradas y salidas logicas BOOL, sin enlaces ni alias de E/S fisicas. Es la aplicacion actual.
- **Version fisica, pendiente de validar:** `sim_ts60/Entorn_TS60/Controller-TS60/usr/usrapp/Lab2A_Physical/Lab2A_Physical.pjx`. Tiene la misma secuencia, con variables DIO descriptivas enlazadas a io:bIn/io:bOut. No ejecutarla en el emulador si lo que se quiere es simulacion manual.

No hay que descomentar lineas ni configurar un modo. Son dos aplicaciones diferentes; no se han abierto ni ejecutado. Recargar desde disco sin guardar encima una copia antigua de SRS. Pasar Check Syntax para s6.8 SCARA. La simulacion anterior de movimientos sin interaccion se conserva en el ZIP de copia previa.

## Organizacion del codigo

En cada aplicacion solo hay tres programas:

- `start`: bloques numerados de variables/parametros, generacion cinematica de la matriz, mapa de senales, preparacion y ciclo de clasificacion completo.
- `pickAndPlace`: recogida, transporte y deposito. Se separa porque se llama para cada una de las ocho piezas.
- `stop`: parada del programa; es un punto de entrada del sistema.

Los encabezados `// =====` son comentarios visuales, no mecanismos para activar/desactivar codigo. La separacion entre aplicaciones evita depender de comentarios de bloque y conserva `end` activo. No se han usado `/* ... */` como forma de desactivar programas.

## Nombres nuevos

| Antes | Ahora | Significado |
|---|---|---|
| nType | materialType | 0=no metalica roja; 1=metalica |
| nCount | placedCount[2] | Piezas colocadas por material |
| nPlace | placeIndex | Hueco de destino, de 0 a 7 |
| bCycleOK | cycleOK | La rutina de robot termino correctamente |
| pHome | homePose | Joint de referencia para inicio/retorno |
| pPick[2] | pickPose[2] | Joints de recogida, 0=no metalica y 1=metalica |
| pApproachPick[2] | pickApproach[2] | Aproximaciones a las recogidas |
| pPlace[8] | placePose[8] | Joints de los huecos |
| pApproachPlace[8] | placeApproach[8] | Joints de aproximacion a los huecos |
| tTool | vacuumTool | TCP de la ventosa |
| mNomSpeed | moveSpeed | Descriptor de movimiento, 10/10/10 y blend off |

`cycleStep` es nuevo: indica la fase y no debe editarse. Las variables de geometria siguen siendo jointRs; solo targetPose es un punto local temporal para la cinematica. Los nombres de programa y variable respetan el limite de 15 caracteres de esta version.

## Entradas: las que debes modificar en simulacion

No hay piezas animadas ni entradas fisicas. Tu representas lo que detectaria cada sensor.

| Variable manual | Senal fisica equivalente | true significa |
|---|---|---|
| partOnTool | bIn0 | Pieza detectada en ventosa |
| partAtClass | bIn1 | Pieza presente en clasificacion |
| partIsMetal | bIn2 | Pieza metalica; solo se lee con presencia |
| partAtSource | bIn3 | Pieza disponible en alimentacion |
| partAtRamp | bIn4 | Pieza pasando por el sensor de rampa |
| gate1Extended | bIn5 | Actuador no metalico extendido |
| gate1Retracted | bIn6 | Actuador no metalico retraido |
| gate2Extended | bIn7 | Actuador metalico extendido |
| gate2Retracted | bIn8 | Actuador metalico retraido |

Inicialmente todas las entradas son false salvo gate1Retracted y gate2Retracted, que son true. start NO las reinicializa: si repites la prueba, deja los sensores en estados coherentes antes de arrancar.

## Salidas: observar, no editar durante la prueba

| Variable observada | Equivalente fisico | Orden |
|---|---|---|
| vacuumOn | bOut0 | Aspirar |
| blowOn | bOut1 | Soplar |
| trolleyOn | bOut2 | Mover carro |
| nonMetalGate | bOut3 | Extender actuador 1, supuesto |
| metalGate | bOut4 | Extender actuador 2, supuesto |
| barrierClosed | bOut5 | Cerrar/retener, supuesto |

En simulacion son solo BOOL y no accionan hardware. No escribas en ellas para fingir un sensor: las escribe el programa. En fisico son DIO, enlazadas una por una en start con comentarios explicativos.

## Primera prueba manual: una pieza no metalica

Las ediciones deben hacerse sobre las variables de la aplicacion cargada **en memoria del emulador**, durante su ejecucion; editar solo el DTX en el PC no equivale a cambiar una variable viva. Segun la vista de SRS puede requerir el editor de datos del controlador/emulador. Si no ves los cambios en cycleStep mientras ejecuta, comprobar primero que miras la instancia correcta; no suponer que guardar el archivo modifica el controlador. La ubicacion exacta de esa vista se explicara con el usuario, sin controlar la interfaz.

La simulacion usa wait sin timeout: espera indefinidamente para darte tiempo a editar. No es un bloqueo de interfaz.

| cycleStep / mensaje | Que haces manualmente | Que ocurre despues |
|---|---|---|
| 10: espera origen | partAtSource=true | trolleyOn pasa a true |
| 20: espera clasificacion | Primero partIsMetal=false; luego partAtSource=false y partAtClass=true | Se guarda materialType=0; se ordena ruta no metalica |
| 30: espera actuadores | gate1Extended=true, gate1Retracted=false; gate2Extended=false, gate2Retracted=true | Se abre barrera y mueve carro |
| 40: espera paso | partAtRamp=true | Se detiene carro y cierra barrera |
| 50: espera zona libre | partAtRamp=false y partAtClass=false | El robot va a recoger de la rampa 0 |
| 60: espera agarre | partOnTool=true | Retira y transporta hacia la matriz |
| 70: espera liberacion | partOnTool=false | Retira, vuelve a Home y suma placedCount[0] |
| 10 siguiente ciclo | Prepara otra pieza | Continua hasta cuatro por material |

Para una metalica, en fase 20 pon partIsMetal=true ANTES de partAtClass=true. En fase 30 confirma gate1Extended=false, gate1Retracted=true, gate2Extended=true y gate2Retracted=false. El robot usa recogida 1 y destinos 4..7. Puedes introducir un orden mezclado; no hay alternancia automatica.

80 puede pasar demasiado rapido para verlo; informa de que termino una pieza, no es una espera. 100 indica cuatro piezas de cada tipo colocadas. -1 indica stop. Si un material ya tiene cuatro piezas, la siguiente de ese tipo se retiene en clasificacion y el programa termina con aviso: no descarta automaticamente sobrantes.

## Matriz y geometria conservadas

Origen exacto: placePose[0]={-88.99,114.77,10.19,-318.7}. start calcula siete destinos y ocho aproximaciones con jointToPoint y pointToJoint ANTES de mover. Los valores restantes del DTX son semillas iguales al origen, no soluciones precalculadas; no usarlos manualmente antes del calculo.

Dos filas de cuatro huecos: paso 60 mm a lo largo de columnas y 70 entre filas. Offsets elegidos en world: X=-70*rowIndex, Y=-60*columnIndex. TODO: confirmar esquina y sentidos con el palet real/simulado. Aproximaciones 50 mm sobre cada destino. No se usa fMatrix. Se han preservado todas las transformaciones, las joints de recogida actualizadas por el usuario (J3=100 en ambas aproximaciones) y la definicion geometrica del TCP. Las herramientas necesitan una referencia DIO valida incluso sin usar open/close. En simulacion flange y vacuumTool referencian toolDummy[0], una DIO local auxiliar sin dioLink ni alias fisico. No es un detector que deba editarse. En fisico referencian io:valve1[0], como en la configuracion original; aspiracion y soplado siguen controlandose explicitamente mediante vacuumOn/blowOn, sin open/close.

## TODOs fisicos conservados

- Verificar bOut5: supuesto 1=retener y 0=liberar. Invertir las ordenes coherentemente si es al reves, incluidos arranque, fallos y stop.
- Verificar que bOut3=1 y bOut4=1 extienden/empujan sus actuadores. Actuador 1 no metalico rojo a la derecha, actuador 2 metalico, segun usuario. Confirmar la ruta combinada.
- Verificar el ciclo del carro para suministrar UNA pieza y quedar listo para la siguiente; puede necesitar un retorno diferente al propuesto.
- Verificar el pulso de bIn4 y medir llegada a la ventosa. La version fisica espera 0.5 s despues del paso; valor inicial.
- Confirmar 0.3 s de soplado, timeouts de 10 s para estacion y 3 s para ventosa. Simulacion no tiene estos timeouts de sensores para permitir el control manual.
- Revisar homePose, movimientos entre zonas, TCP, signos de matriz y altura. La cinematica no comprueba colisiones.

En fisico iniciar con matriz vacia, rampas sin piezas antiguas y ventosa vacia. Un reinicio borra los contadores y no recupera una tarea interrumpida. La comprobacion de pieza durante el traslado es puntual; no hay vigilancia continua ni recuperacion automatica. stop no suelta automaticamente la pieza. Nada de esto sustituye los dispositivos de seguridad del robot.

## Estado de validacion

Preparacion por archivos, sin controlar SRS, sin ejecutar el robot, sin commits. Comprobados esquemas XML oficiales s6.8, declaraciones/referencias, limites de nombres, preservacion de geometria y ausencia de enlaces fisicos en Lab2A. Falta Check Syntax en SRS y prueba de la secuencia manual. La version fisica es codigo preparado con TODOs, no una instalacion validada.

Copia previa completa: `work/recovery/20261025-195032-Lab2A-before-interactive-simulation.zip`.

## Correccion de enlaces de herramientas

El compilador s6.8 rechazo los enlaces de herramienta con alias/nombre vacios (dos errores por aplicacion). Se sustituyeron por toolDummy[0] local sin enlace en simulacion y por io:valve1[0] en fisico. El TCP no cambia. Recargar ambas aplicaciones desde disco y repetir Check Syntax; comprobar estos enlaces y XML no equivale a una compilacion confirmada. No editar toolDummy ni enlazarla a un pin.

Copia previa a la correccion: `work/recovery/20261025-201457-Lab2A-before-tool-link-fix.zip`.
