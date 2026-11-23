# Lab2B - Level 1, simulación manual y físico

Una sola aplicación y un solo montaje: cilindro del dispensador, pistón de
la bandeja, inserción en la estación y conjunto a la rampa final.
Se mantiene la filosofía de `Lab2A_new`: nombres claros, bloques comentados,
`wait()` sin timeouts y pocas variables. El ciclo está completo en `start`;
`physicalIO` conecta las E/S y `stop` para la aplicación.

## Elegir el modo

Abrir **`Lab2B.pjx`** y cargar **la aplicación completa**, incluyendo el DTX
y los tres PGX. Recargar desde disco antes de guardar desde una ventana de
SRS que todavía tenga la versión anterior. Así se evitan los errores
`invalid name` por cargar código nuevo con datos antiguos.

Antes de arrancar, cambiar el bool público **`simulation`**:

- **`true` (guardado por defecto): simulación manual.** El brazo ejecuta los
  movimientos; tú representas el sensor con `cylinderPresent`. No se leen ni
  escriben pines reales. Cambiar el bool no crea piezas ni las adhiere al CAD.
- **`false`: físico.** `physicalIO` lee bIn2; `start` acciona la pinza mediante `open/close`. No
  editar `cylinderPresent` a mano: la tarea lo sobrescribe continuamente.

El modo se copia a `physicalRun` al arrancar. Cambiar `simulation` en marcha
no conmuta el hardware: parar, preparar la célula y volver a arrancar.
`ioReady` impide continuar antes de la primera actualización física.

## Entradas y salidas del TX60

Mapa de sensores contrastado con `lesson2b.pdf`, apartado 2.8.
**Corrección del 16 de noviembre:** el enunciado indicaba bOut0 para la
pinza, pero T1 está configurado como `valve1` y el usuario confirma que
el mando manual sí acciona la pinza. Las herramientas actúan sobre **`io:valve1[0]`** mediante `open/close`.
Falta comprobar el cierre desde el programa tras recargarlo.
La numeración y el significado cambian respecto al TS60 del 2A.

| Señal | Variable | Significado y uso en Level 1 |
|---|---|---|
| **bIn2** | **`cylinderPresent`**, bool de entrada | 1: cilindro preparado en el dispensador; 0: no detectado. `start` espera presencia antes del primer movimiento. |
| **valve1** | `open(tLateral/tTip)` / `close(tLateral/tTip)` | **1 abre / 0 cierra** la única pinza. Se utiliza el TCP correspondiente a cada fase. |
| bIn0 | No se utiliza | Sensor delante de la herramienta para buscar pistones en Level 3. **No confirma un agarre**. |
| bOut10 | No se utiliza | 1 extiende / 0 retrae el alimentador del dispensador, para Level 2. |
| bIn14 / bIn15 | No se utilizan | Confirman alimentador extendido / retraído. |

**Control directo mediante herramientas (16 de noviembre de 2026):**
`start` usa `open(tLateral)` / `close(tLateral)` para cilindro y conjunto,
y `open(tTip)` / `close(tTip)` para pistón e inserción. Las tres herramientas
referencian `io:valve1[0]`; los TCP y tiempos de 1 s se conservan.

`open/close` ya esperan fin de movimiento y el tiempo `otime/ctime` de la
herramienta. No se añade otra pausa en físico. En simulación manual se omiten
esas llamadas y solo se conserva la pausa de 1 s, sin leer/escribir pines.
`physicalIO` **solo lee bIn2**: no escribe valve1 ni bOut0. Se ha eliminado
el bool `gripperOpen`; no deben añadirse llamadas `open(gripperOpen)`.
Los mensajes de diagnóstico de fase 40 siguen leyendo valve1 en físico.

No hay un sensor de agarre asignado en el mapa del enunciado. No se inventa
una espera de pieza sujeta con bIn0. En Level 1 se coloca manualmente un
cilindro y un pistón en las posturas enseñadas, con la estación de montaje vacía.
No se acciona el alimentador automáticamente ni se espera que bIn2 vuelva a
0 después de recoger: podría detectar otro cilindro preparado.

## Simulación: qué cambias tú

Elegir **`simulation=true`** antes del arranque. Para observar la espera,
poner **`cylinderPresent=false`** inicialmente en la memoria del emulador.
El programa no borra ese sensor al arrancar.

| `cycleStep` | Qué ocurre | Qué cambias tú |
|---|---|---|
| 0 | Prepara el modo y ordena abrir la pinza; espera 1 s. | Nada. |
| **10** | Espera un cilindro preparado, antes de mover el brazo. | **`cylinderPresent=true`**: simulas la detección de bIn2. |
| 20 | Recoge el cilindro con `tLateral`. | Nada; el programa cierra y espera 1 s. |
| 30 | Deposita el cilindro y se retira. | Nada; abre y espera 1 s. |
| 40 | Recoge el pistón con `tTip`. | Nada; se supone un pistón colocado en `jPistonPick[1]`. |
| 50 | Inserta, abre y se retira. | Nada; revisar alineación y profundidad en el modelo. |
| 55 | Va a `jAssemblyMove` con `tTip`, ya sin el pistón sujeto. | Nada; comprobar la nueva transición en simulación. |
| 60 | Recoge el conjunto con `tLateral`. | Nada; revisar que pueda agarrarse con el pistón insertado. |
| 70 | Deposita en rampa y se retira hasta `jRampPlace[0]`. | Nada. |
| 100 | Un ciclo terminado; adaptador cerrado y última orden de pinza aplicada. | Nada. Preparar de nuevo las piezas antes de otro arranque. |
| -1 | Se ha ejecutado STOP. | Preparar la célula antes de reiniciar. |

**No editar `cycleStep`, `physicalRun` ni `ioReady` para avanzar.**
`cycleStep` informa, no salta instrucciones. Si `cylinderPresent` ya es true,
`wait` avanza inmediatamente: no es una espera de flanco. Durante las fases
20 a 70 puedes volver a dejarlo false para preparar la siguiente prueba.

## Posturas de las seis fotos: asignación provisional

Se han sustituido los diez puntos cartesianos anteriores por cinco parejas
de `joint` de seis ejes. Se conservan **exactamente los ángulos de las fotos**,
incluidos los negativos de J4 y los **175,115 grados** de J6 en
`jCylinderPlace[0]`. No se han normalizado giros ni calculado alturas a partir
de J3: en el TX60, J3 también es un ángulo, no una altura.

**Criterio provisional para probar: índice 0 = aproximación; índice 1 =
recogida, depósito o inserción.** Las fotos no confirman el orden ni la
alineación del TCP. Si una pareja está invertida, intercambiar sus dos filas
completas en Data (los seis ángulos); el código mantiene el mismo convenio.

| Nombre en la foto | Variable actual | TCP | Uso |
|---|---|---|---|
| `startpoint` | `jStart[0..1]` | `tLateral` al comenzar | **Posturas iniciales**, confirmado por el usuario. Solo se mueve a **[0]**; [1] queda guardada como alternativa sin ejecutar. |
| `cylinderpick` | `jCylinderPick[0..1]` | `tLateral` | Aproximación y recogida del cilindro en el dispensador. |
| `gridcilinder` | `jCylinderPlace[0..1]` | `tLateral` | Aproximación y depósito del cilindro; también recogida posterior del conjunto. |
| `pistonpick` | `jPistonPick[0..1]` | `tTip` | Aproximación y recogida del pistón. |
| `gridpiston` | `jPistonInsert[0..1]` | `tTip` | Aproximación e inserción del pistón en el cilindro. |
| `ramp` | `jRampPlace[0..1]` | `tLateral` | Aproximación y depósito del conjunto en la rampa. |

Transcripción de las fotos, **todos los valores en grados**:

| Variable | J1 | J2 | J3 | J4 | J5 | J6 |
|---|---:|---:|---:|---:|---:|---:|
| `jStart[0]` | -17.54 | 47.8 | 73.74 | -22.19 | -14.71 | -3.13 |
| `jStart[1]` | 8.29 | 62.36 | 74 | -230.42 | 69.15 | 170.23 |
| `jCylinderPick[0]` | -24.56 | 81.43 | 76.8 | -112.1 | 82.12 | 114.24 |
| `jCylinderPick[1]` | -24.56 | 95.71 | 62.86 | -112.14 | 82.26 | 114.57 |
| `jCylinderPlace[0]` | 6.68 | 68.02 | 69.81 | -246.67 | 70.51 | 175.115 |
| `jCylinderPlace[1]` | 6.68 | 105.16 | 35.36 | -245.83 | 71.59 | 172.56 |
| `jPistonPick[0]` | 32.78 | 54.5 | 88.65 | -178.63 | -30.05 | 163 |
| `jPistonPick[1]` | 32.78 | 64.92 | 84.14 | -178.32 | -24.13 | 162.65 |
| `jPistonInsert[0]` | 27.71 | 87.95 | 13.52 | -180.66 | -76 | 162.22 |
| `jPistonInsert[1]` | 27.71 | 98.34 | 0.04 | -180.65 | -79.06 | 162.19 |
| `jRampPlace[0]` | 10.96 | 57.65 | 75.86 | -194.07 | 43.71 | 147.05 |
| `jRampPlace[1]` | 11.48 | 75.68 | 62.76 | -192.26 | 48.42 | 145 |

## Movimientos y parada

Postura intermedia añadida el 16 de noviembre por indicación del usuario:
`jAssemblyMove` = **(45.22, 73.93, 39.28, -174.58, -56.97, 157.87)** grados.
Se ejecuta después de abrir `tTip` y retirarse a `jPistonInsert[0]`, y antes
de ir con `tLateral` a recoger el conjunto. El ciclo tiene ahora **20 movimientos**.
Esta transición posterior no modifica el recorrido previo a soltar el pistón.

Actualización del 16 de noviembre de 2026: el usuario ha sustituido la pareja
`jPistonPick` por los valores de la tabla y ha identificado expresamente
[0] como aproximación y [1] como recogida. Para esa pareja la asignación ya
no se basa en la suposición inicial de las fotos; su trayectoria todavía
requiere comprobarse en SRS. Los mensajes de diagnóstico de fase 40 siguen activos.

Se conservan `world`, los dos TCP, los parámetros de movimiento y las E/S.
El ciclo tiene 20 órdenes de movimiento; la primera va a la postura
inicial `jStart[0]` en lugar del tránsito antiguo. Los valores antiguos están
en la copia previa al cambio, indicada en el registro de trabajo.

`movej` recibe directamente la joint. Para las entradas y retiradas rectas,
se convierte la joint mediante `jointToPoint(TCP, world, joint)` y se usa
`movel` con **ese mismo TCP**. Las aproximaciones usan `mApproachSpeed`;
la entrada y retirada de inserción usan `mInsertSpeed`. La conversión solo
calcula el destino cartesiano; no certifica el recorrido ni conserva por sí
sola todos los posibles giros articulares equivalentes. Cada movimiento
termina con `waitEndMove()`.

- `mNomSpeed`: accel/vel/decel **10/30/10**, blend off, conservado.
- `mApproachSpeed`: **10/20/10**, tmax **100 mm/s**, rmax **60 grados/s**, blend off.
  Se usa en las diez entradas y retiradas de recogida y depósito.
- `mInsertSpeed`: **10/5/10**, tmax **10 mm/s**, rmax **10 grados/s**, blend off.
  Se reserva para la entrada y retirada del pistón en la inserción.
- STOP cancela movimiento y elimina `physicalIO`, conservando la salida
  real de pinza. No abre ni cierra automáticamente y no vuelve a `jStart`.
- Un nuevo arranque comienza desde el principio y ordena abrir la pinza;
  no recupera automáticamente un montaje interrumpido.

## Verificación y pruebas por completar

Antes de ejecutar en SRS, pasar **VAL3 > Check Syntax** sobre la aplicación
recargada. Primero probar el ciclo en el emulador, con MCP al **10%** como
indica el enunciado, revisando los tramos con el depurador.

Para preparar el físico, comprobar primero, con el robot quieto, que
**bIn2 cambia al poner/quitar un cilindro** y que **valve1=1 abre / 0 cierra**.
Las declaraciones de la librería `io` incluyen ambos nombres; el cableado
y la respuesta real se verifican en la estación, no leyendo los archivos.
Después ajustar las posturas a la célula real y verificar especialmente
`jPistonInsert`, el cambio de TCP y el agarre del conjunto en `jCylinderPlace`.

El selector de modo no recalibra las posturas. **Primero confirmar en
simulación que [0] es la aproximación y [1] el trabajo en cada pareja**, y que
las parejas de estación coinciden con el cilindro y el pistón respectivamente.
Alcance, singularidades, colisiones y alineación no quedan certificados por
la revisión de archivos. No ejecutar directamente en el físico esta
asignación todavía provisional.

Estado de la revisión del 9 de noviembre de 2026: ver `WORKLOG.md`
en la carpeta `report` de Lab 2B.
Las validaciones XML y de lógica no sustituyen Check Syntax ni la ejecución.
