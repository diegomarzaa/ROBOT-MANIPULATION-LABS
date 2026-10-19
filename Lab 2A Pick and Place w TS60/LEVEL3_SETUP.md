# Lab2A — simulación de movimientos lista

## Ahora

Recargar la aplicación Lab2A desde disco sin sobrescribir estos archivos con la copia antigua de SRS. Pasar Check Syntax y ejecutar en el emulador local con el MCP al 10%. No hay variables de modo ni señales que activar manualmente.

La ejecución activa recorre ocho recogidas/colocaciones sin piezas: alterna pPick[0] y pPick[1], depositando por orden en pPlace[0], [4], [1], [5], [2], [6], [3], [7]. Vuelve a pHome entre ciclos. Conserva comprobaciones de índices y waitEndMove. initPlace resuelve los destinos y aproximaciones antes de mover. La simulación termina tras cuatro colocaciones por cada grupo.

No se activan salidas, no se llama a feedPart y no se esperan sensores. La alimentación, vacío, soplado y sus comprobaciones están comentados con `// PHYSICAL |`. stop conserva resetMotion activo. No representa una prueba de clasificación física ni de agarre.

## Código físico conservado

Los programas contienen los bloques físicos originales comentados. feedPart conserva su secuencia completa en comentarios. Para volver al programa físico:

1. Restaurar las líneas marcadas `// PHYSICAL |` quitando ese prefijo; los comentarios originales que siguen a ese prefijo deben seguir siendo comentarios.
2. Quitar de start las dos asignaciones marcadas SIM ONLY: nType=0 y nType=1-nType. La detección de feedPart volverá a seleccionar el material. Restaurar su llamada y comprobación de bCycleOK.
3. Restaurar los mensajes que identifiquen la ejecución física y comprobar sintaxis. La copia ZIP indicada al final conserva exactamente la versión física previa, por si se prefiere recuperar esos PGX en lugar de descomentar.

La lógica física está escrita, **pero no validada**. Sus decisiones son bOut5=1 para retener, bOut3/bOut4=1/0 para no metálica y 0/1 para metálica, con 1 como extensión. Recogidas 0=no metálica, 1=metálica. Las polaridades y rutas deben comprobarse en la estación antes del uso físico; no son mediciones confirmadas. Debe verificarse que el carro suministre una sola pieza y quede listo para la siguiente. bIn4 detecta paso y se espera 0.5 s adicionales para la llegada. Los timeouts son 10 s en la estación y 3 s en vacío; soplado de 0.3 s.

## Matriz de joints: dos filas y cuatro columnas

pPlace es ahora jointRs[8], no pointRs. pApproachPlace es jointRs[8]. Se ha eliminado fMatrix y el punto global pAbove. El origen exacto que indicó el usuario es pPlace[0]={-88.99,114.77,10.19,-318.7}. No se cambia esa joint durante initPlace.

initPlace usa un único punto cartesiano LOCAL de cálculo y las funciones jointToPoint/pointToJoint del controlador s6.8. Este cálculo es necesario para aplicar milímetros a una postura articular; los destinos y aproximaciones quedan guardados como joints en memoria al arrancar. No se depende de un frame de palet. Los movel convierten momentáneamente la joint a point para conservar las entradas/retiradas lineales.

**Las otras siete joints no son valores numéricos precalculados fuera del controlador:** antes de ejecutar initPlace, sus valores en el DTX son copias del origen como semillas de inicialización. No usar esas entradas manualmente como si ya estuvieran calculadas. start solo permite moverse si se han resuelto las ocho aproximaciones y siete destinos restantes. Para conservar los números generados en disco habría que exportarlos/guardarlos desde el controlador después de una ejecución correcta; aquí no se ha ejecutado SRS.

En el CAD, el lado de cuatro huecos tiene paso 60 mm y el de tres filas tiene paso 70 mm; se usan dos filas adyacentes. La orientación elegida recorre el lado largo en CAD -X y cambia de fila en CAD +Y. El RobotWorld guardado gira -90 grados respecto a la escena; por tanto esas direcciones corresponden a world -Y y world -X. Se toma la joint suministrada como la esquina inicial de ese recorrido. **La captura no prueba cuál de las esquinas se enseñó: comprobar el primer desplazamiento en simulación antes del ciclo entero.** Si recorre fuera del palet, corregir el signo/dirección en initPlace; no modificar J1/J2 por ensayo.

| Índice | Fila | Columna | Desplazamiento world X/Y (mm) |
|---:|---:|---:|---|
| 0 | 0 | 0 | 0 / 0 |
| 1 | 0 | 1 | 0 / -60 |
| 2 | 0 | 2 | 0 / -120 |
| 3 | 0 | 3 | 0 / -180 |
| 4 | 1 | 0 | -70 / 0 |
| 5 | 1 | 1 | -70 / -60 |
| 6 | 1 | 2 | -70 / -120 |
| 7 | 1 | 3 | -70 / -180 |

La orientación del TCP se conserva a partir de la joint origen y la cinemática inversa usa esa joint como referencia para buscar una solución próxima. Cada aproximación añade 50 mm en world Z antes de resolver su joint. La altura procede de la nueva joint, ya no del antiguo Z=50 relativo a fMatrix. J4=-318.7 se conserva exactamente en el origen; comprobar el resto del giro y límites en SRS.

Tipos SCARA, velocidad/aceleración/deceleración 10/10/10 y blend off. pApproachPick[1].J3=50 como la primera aproximación; revisar el recorrido. Resolver cinemática no comprueba colisiones ni demuestra que los huecos elegidos coincidan con el palet físico. start reinicia contadores y en físico requiere matriz vacía.

Preparado por archivos sin controlar la app. Validación XML y comprobaciones estáticas realizadas; aún pendiente Check Syntax y ejecución en SRS. Sin commits ni cambios al informe abierto de Lab2B.

Copia de la versión física previa: `work/recovery/20261019-082612-Lab2A-physical-before-motion-simulation.zip`.

Copia previa a la matriz de joints: `work/recovery/20261019-090122-Lab2A-before-joint-matrix.zip`.
