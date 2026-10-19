# Registro de trabajo y evidencias de Lab 2B

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
