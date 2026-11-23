# Registro de trabajo y evidencias de Lab 2B

## Level 2 separado — 23 noviembre 2026

- A petición del usuario, se conserva la aplicación `Lab2B` como Level 1,
  comprobando los hashes de todos sus archivos antes y después del trabajo.
  Nueva aplicación: `Lab2B_Level2`, con PJX/DTX propios y seis programas.
- Releído el enunciado, incluyendo las figuras del dispensador y la tabla
  de E/S. bOut10 ordena extensión/retracción; bIn2 detecta cilindro;
  bIn14 y bIn15 confirman extendido/retraído.
- Se prepara una secuencia extender/retraer antes de la recogida, con
  esperas de finales de carrera y presencia. Si ya hay cilindro no empuja
  otro. La secuencia mecánica completa no está detallada en el PDF y queda
  pendiente de comprobar. Tras recoger se exige liberar bIn2 antes de otra vuelta.
- Se conservan de Level 1 geometría de herramientas, estaciones, tránsito,
  velocidades y accionamiento open/close sobre valve1. Se sustituye la rampa
  por cuatro parejas de matriz exactas de la foto, sin calcular offsets.
- Transcripción comprobada visualmente en recorte de la captura:
  jMatrix[0..7], parejas 0/1, 2/3, 4/5, 6/7. Atención a J3=48.48 en [4]
  y J6=104.55 en [6]. Tabla completa en README de Level 2.
- No se ha afirmado una altura a partir de ángulos: start calcula y muestra
  Z del TCP lateral de cada aproximación y depósito mediante jointToPoint;
  si Z de aproximación no es mayor, termina antes de movimientos/salidas.
  Este cálculo real todavía debe ejecutarse en SRS; las pruebas de lógica
  usan alturas sintéticas y no validan cinemática.
- Las cuatro recogidas de pistón están pendientes. jPistonPick[0..7] tiene
  ocho posturas a cero explícitas; se rechaza el arranque mientras falte
  alguna. No se repite el único pistón antiguo ni se inventan coordenadas.
- start llama feedCylinder, assemble y placeAssembly mientras placedCount<4.
  El contador aumenta tras depósito y retirada. partIndex selecciona
  consecutivamente las cuatro parejas de pistón y matriz. Al completar 4,
  no hay otra alimentación aunque siga activo el sensor de presencia.
- physicalIO nuevo lee bIn2/14/15 y escribe solo bOut10. No se copia la
  referencia no declarada grippe1rOpen del archivo actual de Level 1;
  esa incidencia queda documentada sin alterar su archivo original.
- STOP conserva pinza, termina el adaptador, cancela movimiento y ordena
  retraer si se había inicializado hardware. Un arranque incompleto no
  acciona salidas ni siquiera al ejecutar STOP. Un nuevo inicio presupone
  matriz vacía; no se implementa reanudación ni búsqueda de pistones Level 3.
- Comprobado: ocho XML contra XSD s6.8; referencias de programas, variables,
  herramientas y E/S; 48 valores de matriz; preservación de Level 1; cuatro
  ciclos en seco de ambos modos, con/sin cilindro inicial; índices 0..7
  sin desbordar; ausencia de quinto suministro con presencia activa; guardas
  por pistones pendientes/altura invertida; espera por final ausente; STOP
  en fases del proceso. Movimiento, E/S y alturas sustituidos por modelos
  de prueba: no es ejecución de VAL3 ni validación de trayectorias.
- Evidencias locales: `work/verify_lab2b_level2.py`,
  `work/level2-review/checks.json` y `baseline.json`; copia completa previa
  de Level 1: `work/recovery/20261123-081913-Lab2B-Level1-before-Level2.zip`.
- Pendiente: ocho joints de pistones; Check Syntax en SRS; ejecutar revisión
  de alturas de matriz; comprobar secuencia, polaridad y dosificación física
  del alimentador; validar trayectorias. No se ha ejecutado hardware.
- No se han realizado commits ni push. Memoria LaTeX aún sin sincronizar.

## Estado inicial — 18 octubre 2026

- El usuario ha abierto la celda y guardado la aplicación inicial.
- Se han inspeccionado `Lab2B.pjx`, `Lab2B.dtx`, `start.pgx` y `stop.pgx`.
- `start` contiene `userPage()`, `cls()` y un mensaje con `putln()`; `stop` está vacío.
- Solo están definidos world, flange y mNomSpeed; la velocidad guardada sigue a 100.
- Pendiente: confirmación de Check syntax, configuración de herramientas/velocidad y toda ejecución.
- Preparación documental asistida: conservación de plantilla, registro de requisitos y borrador del informe. No atribuir automáticamente esta preparación a un miembro del grupo.

## Herramientas y parámetros iniciales — 18 octubre 2026

- El usuario ha configurado los datos en SRS; la revisión de archivos confirma ambos TCP, su padre flange, salida io:valve1[0] y tiempos de 1 s.
- tLateral: X/Y/Z = 30/30/170 mm; RX/RY/RZ = -90/44/-90 grados.
- tTip: X/Y/Z = -30/-30/175 mm; RX/RY/RZ = 0/0/-134 grados.
- mNomSpeed: accel/vel/decel = 10/10/10; blend = off. tmax/rmax conservan 99999 y leave/reach 50/50.
- Se observó en la ventana de SRS el resultado de Check syntax: 0 errores y 0 avisos. La aplicación abierta muestra Lab2B y Controller-TX60 s6.8.
- start y stop siguen sin órdenes de movimiento ni de pinza. No hay puntos articulares o cartesianos propios todavía.
- Evidencia: inspección XML de los archivos guardados y observación directa de la ventana. No se ha validado alineación visual del TCP, trayectoria, agarre ni ejecución real.
- Informe actualizado para reflejar los datos implementados. Próximo bloque: seleccionar cada TCP y revisar su referencia en 3D antes de enseñar posiciones.
- Commit del hito: pendiente de que el usuario revise y guarde los cambios.

## Posturas inicial y de tránsito — 18 octubre 2026

- Se verificaron en Lab2B.dtx jStart = (0,0,0,0,0,0) y jTransCylinder = (-50,30,0,0,0,0), en grados.
- El nombre guardado por el usuario es jTransCylinder; usar ese identificador exacto en el programa.
- La postura de tránsito es provisional. No representa el agarre ni demuestra por sí sola que el recorrido completo esté libre de colisiones.
- El panel JOG observado con los seis ejes a cero y tLateral activo mostró X/Y/Z = 30/50/840 mm y RX/RY/RZ = -90/44/-90 grados.
- Durante la exploración gráfica se observó un cambio de J2 a 12,5 grados, con TCP aproximado 211,10/50/813,60 mm. Esa exploración gráfica no fue una ejecución VAL3 ni una validación dinámica del recorrido.
- Próxima prueba propuesta: recorrido articular jStart → jTransCylinder → jStart, con esperas y mensajes MCP, en el emulador local. Pendiente de que el usuario lo implemente y ejecute; start guardado todavía solo muestra el mensaje inicial.

## Programa de prueba guardado y próximo hito — 19 octubre 2026

- El archivo start.pgx ya contiene el recorrido jStart → jTransCylinder → jStart, con movej, waitEndMove, pausas y mensajes MCP.
- La revisión confirma el código guardado; no se ha confirmado todavía que el usuario haya completado la ejecución en el emulador.
- Se actualizan la explicación y el listado del informe para que coincidan con el código guardado.
- Preferencia del usuario: el siguiente commit se hará al completar y comprobar el nivel 1, no por cada microhito. Se mantiene el trabajo de 2A sin modificar.
- Próximo bloque: enseñar las poses cartesianas de recogida, estación de montaje, inserción y rampa; construir y probar el nivel 1 por tramos.

## Recuperación después del cierre de SRS — 19 octubre 2026

- Se encontró guardado el traslado completo del cilindro, con sus cuatro puntos cartesianos: pCylApproach, pCylPick, pAsmApproach y pAsmCylinder. No fue necesario reconstruirlos ni inventar coordenadas.
- Se preservaron exactamente todas las variables existentes y sus valores. mNomSpeed ya tenía accel/vel/decel = 10/30/10 y blend off.
- Copia de la celda completa previa a la edición: work/recovery/20261019-002635-Lab2B-before-recovery.zip (carpeta ignorada por Git).
- Se organizó la aplicación en start, stop, moveCylinder, insertPiston, unloadAssembly y checkSetup. Los tres bloques del proceso están preparados, sin afirmar que el nivel 1 esté ya validado.
- Se declararon seis poses pendientes con valores cero y tres confirmaciones false. El arranque queda en nRunMode=0, sin comandos de movimiento ni de pinza en start. El nivel 1 completo requiere confirmaciones y rechaza los puntos pendientes cuyo XYZ siga a cero.
- Se añadió mInsertSpeed (10/5/10, límites cartesianos 10 mm/s y 10 grados/s, blending off) como configuración inicial de precisión, pendiente de ensayo.
- stop cancela órdenes de movimiento y mantiene la orden de pinza; no se añadió retorno automático a una postura no validada.
- Comprobaciones completadas: esquemas XML oficiales instalados de s6.8 para DTX/PJX/PGX, existencia de referencias, nombres de programas y guardas de configuración. Los listados del informe se han sincronizado con las seis rutinas.
- La comprobación de sintaxis completa VAL3 de esta versión queda pendiente. El comprobador autónomo no pudo cargar su archivo de referencia de lenguaje; esto no es un resultado de compilación del programa. No se ejecutó ningún recorrido ni se diagnosticó la causa del cierre.
- No se han realizado commits ni push. Se mantiene el siguiente commit para el nivel 1 completo y validado.

## Entrada por completar después de cada hito

- Fecha y persona(s):
- Objetivo:
- Cambio de programa/variables y motivo:
- Herramienta, frame, puntos y parámetros utilizados:
- Prueba realizada: inspección / sintaxis / simulación / robot real:
- Resultado observado y limitaciones:
- Captura o vídeo y timestamp:
- Commit relacionado:
- Siguiente paso:


## Simplificación de Level 1 — 19 octubre 2026

- Se comprobaron en disco los diez puntos ya enseñados, incluidos los ajustes del cilindro.
- Se eliminaron nRunMode, las cuatro variables bool y checkSetup. start llama directamente a las tres fases una vez.
- Se conservaron todos los puntos, herramientas, posturas, velocidades, movimientos, órdenes de pinza y waitEndMove; se redujeron los mensajes a uno por fase.
- Se sincronizaron los cinco listados y el informe, incluyendo las coordenadas actuales. Check Syntax y ejecución siguen pendientes.
- Copia previa: `work/recovery/20261019-005701-Lab2B-before-simplification.zip`.

## Preparación de Level 1 con selector de modo — 9 noviembre 2026

- Se ha leído el historial completo de la conversación de 2A, el código
  actual de `Lab2A_new` y el enunciado de 2B. Se conserva la preferencia por
  un ciclo único, bloques comentados, nombres explicativos y `wait` sin
  timeouts, evitando añadir estados o comprobaciones de niveles superiores.
- El estado real guardado tenía todo el ciclo en `start` y solo `start/stop`
  en el PJX. Las notas y los listados de octubre describían otra estructura.
- Aplicación actual: `start` contiene las tres fases del montaje, numeradas
  con `cycleStep`; `physicalIO` adapta las E/S; `stop` termina la tarea y
  cancela los movimientos, sin cambiar la salida de pinza ni volver a home.
  El adaptador también termina al completar el ciclo.
- Selector público `simulation=true` guardado por defecto. Se copia a
  `physicalRun` al arrancar. En manual solo se modifica `cylinderPresent`;
  en físico se espera `ioReady` antes de continuar y se usan los pines.
- Mapa del TX60 contrastado visualmente con el apartado 2.8 del enunciado:
  bIn2 detecta cilindro preparado; bOut0=1 abre y bOut0=0 cierra. No se
  traslada la lógica de vacío del 2A. bIn0 detecta pistones frente a la
  herramienta para Level 3 y no se usa como confirmación de agarre.
- No se acciona bOut10 ni se esperan bIn14/bIn15: la alimentación automática
  corresponde a Level 2. Se presupone un cilindro preparado, un pistón en
  el punto enseñado y estación de montaje vacía. No se añade búsqueda de
  pistones ni repetición hacia la matriz.
- `physicalIO` es el único escritor de bOut0. Las referencias de los tres
  tools pasan de `io:valve1` a un DIO local válido `toolDummy`. No se usan
  `open/close`. Se conservan los tiempos de 1 s y se esperan mediante los
  campos `otime/ctime`, sin confundir tiempo mecánico con sensor de agarre.
- Se han conservado exactamente los diez puntos, `world`, las dos joints,
  los padres y transformaciones de los TCP y ambos descriptores. El orden,
  destino y TCP de los 19 movimientos se conservan. Las cuatro entradas y
  retiradas lineales del cilindro pasan a `mInsertSpeed`; todas las lineales
  usan ahora 10/5/10, tmax=10 mm/s, rmax=10 grados/s, blend off. Los traslados
  articulares conservan el descriptor nominal 10/30/10, blend off.
- Copia completa previa a las ediciones:
  `work/recovery/20261109-092015-Lab2B-before-level1-io.zip`.
- Comprobaciones realizadas: cinco XML válidos contra los XSD instalados
  de s6.8; referencias del PJX, variables y exports de la biblioteca `io`;
  preservación de geometría y parámetros frente al ZIP; 19 movimientos
  terminados con `waitEndMove`; límites de velocidad y blending.
- Pruebas de lógica en seco sobre las instrucciones de los PGX guardados,
  con E/S y movimientos sustituidos por registros: ambos modos, bloqueo sin
  cilindro, ausencia de acceso a pines en manual, actualización física de
  bIn2, selector fijado al inicio, nueve órdenes con pausa de 1 s, secuencia
  de abrir/cerrar y fin de un solo ciclo. STOP comprobado en cada frontera
  de instrucción de esas trazas: conserva pinza y elimina adaptador/movimiento.
  Estas pruebas no son un emulador VAL3 ni validan cinemática o colisiones.
- Evidencias locales ignoradas por Git: `work/verify_lab2b_level1.py`,
  `work/lab2b-review/checks.json` y `work/lab2b-review/val3check.txt`.
- El comprobador autónomo s6.8 se ha intentado con la definición de lenguaje
  instalada y la raíz `usrapp`. Falla antes del análisis de la aplicación con
  `Fatal error during SRAM creation` / `cannot load VAL3 reference file`.
  **No hay un resultado de compilación VAL3 de esta versión.** Sigue pendiente
  recargar la aplicación completa y ejecutar Check Syntax desde SRS.
- Pendiente también: ejecutar y revisar el recorrido en el emulador;
  comprobar bIn2 y la polaridad real de bOut0 con el robot quieto; ajustar
  puntos al físico, en especial inserción y recogida del conjunto. Se mantiene
  `ssame/esame/wsame`; no se certifican alcance, singularidades o colisiones.
- Añadido README junto al PJX con selector, mapa de señales y tabla de
  simulación. La memoria `main.tex` y sus listados siguen como borrador de la
  versión anterior; su README lo indica expresamente. No se ha modificado
  el código del 2A, ejecutado movimientos reales ni hecho commit/push.

## Posturas articulares de las seis fotos — 9 noviembre 2026

- El usuario ha aportado seis capturas de `Lab2bMDM` y ha aclarado que
  `startpoint` contiene posturas iniciales, no la recogida del cilindro.
- Transcritos los 72 ángulos, respetando signos y decimales; en particular,
  J6 de `gridcilinder[0]` se lee como 175,115 grados y así se conserva.
- Nuevas parejas públicas `joint[2]`: `jStart` desde `startpoint`,
  `jCylinderPick` desde `cylinderpick`, `jCylinderPlace` desde `gridcilinder`,
  `jPistonPick` desde `pistonpick`, `jPistonInsert` desde `gridpiston`, y
  `jRampPlace` desde `ramp`. La tabla completa está en el README de la app.
- Por petición del usuario se adopta **provisionalmente** [0]=aproximación y
  [1]=trabajo en las cinco parejas de proceso. No se deduce una altura del
  valor J3: en TX60 los seis valores son ángulos. Falta comprobar el orden y
  la asignación de estaciones en simulación. Para invertir una pareja basta
  con intercambiar sus dos filas completas en Data.
- `jStart` es la excepción: solo se ejecuta `jStart[0]` al iniciar el recorrido;
  `jStart[1]` se conserva como alternativa sin ejecutar. Sustituye el tránsito
  anterior en la primera de las 19 órdenes de movimiento.
- Se retiran los diez puntos cartesianos y el tránsito antiguo del DTX activo.
  Las entradas y retiradas usan `movel(jointToPoint(TCP, world, joint), TCP,
  mInsertSpeed)`, con el mismo TCP dentro y fuera de la conversión; los
  traslados usan `movej` con joints directamente. `jCylinderPlace` se reutiliza
  para depositar el cilindro y recoger el conjunto después de insertar.
- Conservados los TCP, `world`, los descriptores, las E/S, los tiempos de
  pinza y `simulation=true`. No se activa hardware ni se ejecuta SRS.
- Copia previa: `work/recovery/20261109-093224-Lab2B-before-photo-joints.zip`.
- Comprobado: cinco XML con XSD s6.8; coincidencia de los 72 valores con la
  transcripción; existencia/tipo/índice de cada joint; correspondencia entre
  los roles de las 19 órdenes y las parejas nuevas; espera tras cada movimiento;
  mismo TCP en cada conversión/movimiento. Las firmas `jointToPoint` y `movel`
  se han contrastado con `val3.std.anthro.cfx` instalado de s6.8.
- Repetidas y superadas las pruebas de lógica en seco de ambos modos y STOP
  sobre los PGX actualizados. No calculan cinemática ni certifican movimientos.
  Sigue pendiente Check Syntax en SRS y la prueba de las cinco parejas con
  MCP al 10%, confirmando aproximación/trabajo, TCP y colisiones.
- La memoria LaTeX y sus listados continúan pendientes de sincronización.
  Cambios locales, sin commit ni push.

## Aproximaciones más rápidas — 9 noviembre 2026

- A petición del usuario, las diez entradas/retiradas de recogida y depósito pasan a mApproachSpeed: accel/vel/decel 10/20/10, tmax 100 mm/s, rmax 60 grados/s, blend off. Antes estaban a 5 y 10 mm/s.
- La entrada y retirada de inserción conservan mInsertSpeed (5, 10 mm/s); los traslados mantienen mNomSpeed (30). Se conservan puntos, TCP, esperas y E/S.
- Nueva copia previa: work/recovery/20261109-152917-Lab2B-before-faster-approaches.zip.
- Velocidades programadas; MCP sigue multiplicando la velocidad efectiva. Pendiente comprobar tiempos y trayectorias en SRS.

## Corrección de recogida del pistón — 16 noviembre 2026

- El usuario identifica expresamente la aproximación y recogida nuevas.
- `jPistonPick[0]`: (32.78, 54.5, 88.65, -178.63, -30.05, 163).
- `jPistonPick[1]`: (32.78, 64.92, 84.14, -178.32, -24.13, 162.65).
- Se actualizan exclusivamente esas dos posturas en el DTX y su tabla del README.
  Se conserva la secuencia aproximación [0], recogida [1], cierre y retirada [0],
  así como velocidades, TCP, E/S y mensajes de diagnóstico de fase 40.
- Comprobado el formato XML y la correspondencia de índices en `start`.
  Pendiente Check Syntax y prueba de trayectoria. Esto no diagnostica ni corrige
  por sí solo la falta de cierre de la pinza o el recorrido extraño observado.

## Pinza por valve1 — 16 noviembre 2026

- El registro muestra physicalIO en marcha y bOut0=0 sin cierre físico.
- El usuario confirma funcionamiento mediante mando manual; T1 está configurado como valve1 en cell.cfx. Se cambia la salida programada a io:valve1, manteniendo true=abrir/false=cerrar.
- Diagnóstico actualizado para leer valve1. STOP sigue conservando la salida. No se alteran movimientos, posturas, velocidades ni modo de ejecución.
- Comprobados XSD PGX, export valve1 y equivalencia de instrucciones excepto el nombre de salida. Pendiente Check Syntax y prueba física del cierre desde el programa.
- Copia previa: work/recovery/20261116-094832-Lab2B-before-valve1.zip.

## Herramientas y adaptador unificados — 16 noviembre 2026

- A petición del usuario se configura gripper=io:valve1[0] en tLateral y tTip, igual que flange. Se conservan geometría, padres y tiempos de 1 s.
- Se mantiene el mecanismo único de mando: gripperOpen es bool y physicalIO escribe io:valve1. No se introducen open/close ni cambios de polaridad. Los prints leen valve1.
- Verificado: XML s6.8 de los cinco archivos, exports bIn2/valve1, referencias de las tres herramientas y único escritor de valve1. Ninguna instrucción ejecutable ha cambiado en esta actualización; se conservan modo, movimientos, velocidades y STOP.
- Pendiente recargar aplicación completa en el ordenador de clase, Check Syntax y comprobar cierre físico. No se ha ejecutado hardware ni hecho commit/push.
- Copia previa: work/recovery/20261116-101938-Lab2B-before-tool-valve1-alignment.zip.

## Control directo open/close — 16 noviembre 2026

- A peticion del usuario se sustituyen las nueve ordenes bool por seis open(tool) y tres close(tool), usando tLateral para cilindro/conjunto y tTip para piston/insercion.
- Se elimina gripperOpen del DTX y toolDummy sin referencias. physicalIO solo lee bIn2 y no escribe salidas. Ambos TCP conservan io:valve1[0], geometria y tiempos de 1 s.
- En fisico open/close ya incluyen la espera otime/ctime. En simulacion manual se omiten las llamadas y se mantiene la pausa equivalente, sin acceso a pines. STOP conserva la pinza.
- Se mantienen los prints, actualizados para close(tTip), los 19 movimientos, sus esperas, velocidades y posturas.
- Comprobados cinco XML s6.8, orden/TCP de las nueve acciones, guardas de modo y ausencia de escritor de salidas en physicalIO. Pendiente Check Syntax y prueba fisica.
- Copia previa: work/recovery/20261116-102324-Lab2B-before-direct-open-close.zip.

## Transito tras dejar el piston — 16 noviembre 2026

- Anadida jAssemblyTransit: (45.22, 73.93, 39.28, -174.58, -56.97, 157.87) grados, proporcionada por el usuario.
- Fase 55: movej con tTip, despues de soltar y retirarse del piston, antes de la recogida lateral del conjunto. Prints 55A/55B y waitEndMove. El ciclo pasa de 19 a 20 movimientos.
- XML, seis angulos, orden de fases y esperas comprobados. Pendiente Check Syntax y validar trayectoria. No se modifica la insercion previa ni se afirma resuelto el desvio observado antes de soltar.

## Level 2 e integración de Isma — 23 noviembre 2026

- Conservadas Lab2B y Lab2B_Level2 sin cambiar sus archivos. Copia previa de
  Level 2 en work/recovery/20261123-083051-Lab2B-Level2-before-Isma.zip.
- Importados los ocho archivos originales del repositorio ismaelbentaleb/isma,
  commit 5a233aeb5c9bc9946dc8e01b13d66c8949386d8d, en reference/isma.
  Huellas Git verificadas; revisión en reference/isma/REVISION.md.
- Creada Lab2B_Isma_Level2 con organización por operaciones, nuestros nombres
  y E/S, TCP y joints enseñadas. Omitidas búsqueda Level 3 y parrillas con
  offsets. El original carece de io.dtx y del alias io en su proyecto.
- Añadidas las cuatro recogidas de pistón en orden IMG_3805, 3806, 3807,
  3808. Conservados exactamente sus 24 ángulos, incluida la configuración
  de muñeca. Los approaches se calculan a +60 mm Z world con tTip antes de
  crear tareas o mover. Si falla pointToJoint, se termina el arranque.
- Matriz: cuatro parejas de joints exactas, sin offsets. Comprobación de
  Z approach > Z depósito al iniciar. Cuatro montajes y ninguna quinta
  alimentación, incluso con presencia activa. Pinza con open/close de
  herramienta y sin escritor de valve1 en physicalIO.
- Guardado simulation=true; modo manual sin acceso a E/S. Alimentador con
  finales de carrera y una extensión/retracción por pieza ausente; falta
  confirmar la secuencia mecánica en la celda.
- Validación: esquemas XML s6.8, referencias, declaraciones, transcripción,
  cuatro ciclos en ambos modos con E/S ficticias, sensor inicialmente activo,
  guardas por posturas ausentes/altura/IK y STOP en fases del proceso.
  Resultados en work/isma-review/checks.json. Aplicaciones anteriores
  verificadas por hash. Copia integrada antes de fotos en
  work/recovery/20261123-084023-Isma-Level2-before-piston-photos.zip.
- No hay compilación completa: VAL3Check aislado no carga sus recursos.
  Pendientes Check Syntax en SRS, FK/IK real de approaches y matriz,
  trayectorias, agarres y pruebas físicas. Sin commit ni push.

## Corrección de nombres tras VAL3Check — 23 noviembre 2026

- El log del usuario rechaza jAssemblyTransit y no encuentra la aplicación
  Lab2B_Isma_Level2. Se acortan a jAssemblyMove y Lab2B_IsmaL2; también
  pickPlaceCylinder→placeCylinder, pickInsertPiston→insertPiston,
  pistonApproachHeight→pistonLift y pistonApproachPose→pistonApproach.
  Declaraciones, llamadas, nombres de archivos y referencias PJX/DTX
  actualizados. Ningún nombre declarado supera 15 caracteres.
- jAssemblyMove se corrige también en las dos versiones anteriores;
  retirado el escritor inválido grippe1rOpen de physicalIO de Level 1,
  para dejar el control de pinza a open/close. No se cambia geometría.
- Copia completa anterior en work/recovery/20261123-084426-before-VAL3-name-fix.zip.
  Verificador adaptado: compara las versiones previas contra esta copia
  y exige exclusivamente las correcciones anteriores; flujo en seco y
  esquemas comprobados otra vez. Pendiente volver a Check Syntax en SRS.
