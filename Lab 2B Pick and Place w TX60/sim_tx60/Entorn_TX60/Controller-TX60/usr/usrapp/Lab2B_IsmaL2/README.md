# Lab2B_IsmaL2 — versión integrada para probar

Nombre acortado tras el log de VAL3Check: sustituye a Lab2B_Isma_Level2.
Recargar la aplicación desde el nuevo PJX; la entrada antigua de SRS ya
no apunta a una carpeta existente. Identificadores acortados: jAssemblyMove,
pistonLift, pistonApproach, placeCylinder e insertPiston. No se han cambiado
los ángulos ni las velocidades al corregir los nombres.

Abrir **Lab2B_IsmaL2.pjx**, cargando esta carpeta completa y su alias
a la biblioteca `io`. Solo ejecutar una aplicación sobre la celda.
Lab2B (Level 1) y Lab2B_Level2 (preparación anterior) quedan preservadas.

Se toma de Isma la organización en `feedCylinder`, `placeCylinder`,
`insertPiston` y `placeInMatrix`. Se conservan nuestros nombres,
TCP, velocidades, tránsito y posiciones enseñadas. No se usa la búsqueda
Level 3 ni sus parrillas calculadas. Fuente y huellas en SOURCE.json;
revisión en `reference/isma/REVISION.md`, desde la raíz de Lab 2B.

## Pistones y matriz

| partIndex | Foto | jPistonPick recogida | J1 | J2 | J3 | J4 | J5 | J6 |
|---|---|---|---|---|---|---|---|---|
| 0 | IMG_3805 | [1] | 26.81 | 69.62 | 70.85 | -1.30 | 40.12 | -108.07 |
| 1 | IMG_3806 | [3] | 29.50 | 70.36 | 69.33 | -1.43 | 39.02 | -105.26 |
| 2 | IMG_3807 | [5] | 31.95 | 72.09 | 65.41 | -1.48 | 40.92 | -102.81 |
| 3 | IMG_3808 | [7] | 34.68 | 74.46 | 60.13 | -1.50 | 43.88 | -100.11 |

Los índices pares [0,2,4,6] se calculan al arrancar: `jointToPoint` con
tTip, sumar `pistonLift=60` mm a Z de world y `pointToJoint`
con la recogida como semilla. Los ceros de esos índices en el DTX son
espacio para el resultado; no son destinos que se ejecuten directamente.
Si falla una solución o la altura es no positiva, se termina antes de
crear physicalIO o mover. Los approaches calculados deben probarse en SRS.

La matriz usa exactamente **jMatrix[0/1], [2/3], [4/5], [6/7]**:
par=approach, impar=depósito. No hay offsets. Al arrancar se imprime Z
de ambos TCP laterales y se exige approach por encima de depósito.
Esta comprobación no prueba alineación, alcance ni ausencia de colisiones.

## Modo y alimentación

Guardado con **simulation=true**: ejecuta movimiento, pero los sensores
son bools manuales y no se leen/escriben pines ni se ejecutan open/close.
La simulación manual no anima la pinza ni confirma agarres.
Para el robot físico, poner **simulation=false antes de start**.
physicalRun fija ese modo hasta el siguiente arranque.

| Señal | Variable / orden |
|---|---|
| io:bIn2 | cylinderPresent |
| io:bIn14 | feederExtended |
| io:bIn15 | feederRetracted |
| io:bOut10 | feederExtend: true extender / false retraer |
| io:valve1[0] | open/close(tLateral), open/close(tTip) |

El alimentador espera retraído y no extendido; si no hay cilindro,
extiende, espera extendido y no retraído, retrae y confirma ambos sensores.
Después espera presencia. Tras recoger, espera ausencia antes de continuar.
Todas las esperas son sin timeout. El PDF aporta el mapa de E/S; esta
secuencia mecánica debe confirmarse en la celda. No repite pulsos a ciegas.

En manual: inicialmente feederRetracted=true y feederExtended=false.
En fase 11 cambiar a extendido=true/retraído=false; en fase 12 invertirlos;
en fase 13 cylinderPresent=true; en fase 21 cylinderPresent=false.
Si la pieza ya está presente al alimentar, se omiten fases 11 y 12.

Se completan cuatro conjuntos; placedCount aumenta tras soltar y retirarse
de la matriz. Con cuatro se termina aunque el sensor siga activo. STOP
conserva la pinza, cancela movimiento/tarea y manda retraer el alimentador
si las E/S estaban iniciadas. Otro start reinicia el contador: comenzar
con matriz vacía, estación preparada y cuatro pistones disponibles.

## Comprobaciones pendientes en SRS

XML, referencias, ángulos y flujo en seco comprobados. El comprobador VAL3
aislado no pudo cargar sus recursos de lenguaje; **falta Check Syntax en
SRS**, ejecutar el cálculo real de approaches y revisar cada trayectoria.
Las pruebas locales usan cinemática y E/S ficticias; no validan agarres,
montaje, colisiones ni funcionamiento físico del alimentador.
