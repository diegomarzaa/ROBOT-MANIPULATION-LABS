# Lab2A_new — nivel 3, simulación manual y físico

Una sola aplicación. Las versiones anteriores no se han modificado.

## Elegir modo

Abrir `Lab2A_new.pjx` en SRS. **Antes de arrancar**, ajustar el bool público
**`simulation`** en los datos de la aplicación cargada:

- **`true` (por defecto): simulación manual.** Tú cambias los sensores bool;
  las salidas son órdenes bool observables y no se escriben pines físicos.
- **`false`: físico.** `physicalIO` copia las entradas reales a esos mismos bool
  y escribe sus órdenes en bOut0…5. No cambies los sensores bool a mano.

El modo se copia a `physicalRun` al arrancar. Cambiar `simulation` durante la
ejecución no cambia el modo: parar la aplicación y volver a arrancarla.
La librería `io` se carga en ambos modos, pero solo el físico accede a los pines.
El TCP usa `toolDummy` local: no se emplean `open()`/`close()`, la aspiración
y el soplado se ordenan explícitamente por bOut0/bOut1.

## Qué se ha simplificado

- Un único `start` para ambos modos, sin duplicar el ciclo.
- `wait()` para todos los sensores; **sin `watch()` ni timeouts**. Si falta una
  señal, se queda esperando en la fase indicada por `cycleStep`.
- Sin comprobaciones de estación vacía, sensor de rampa previo, pérdida de pieza
  en traslado, ni `cycleOK`. Los `waitEndMove()` se conservan para completar
  cada movimiento antes de ordenar aspiración/soplado o avanzar.
- Se conservan únicamente el fallo de conversión cinemática y fila llena
  (evitan usar destinos sin calcular o índices fuera del array).
- `pickAndPlace` agrupa la rutina repetida ocho veces. `physicalIO` es un
  adaptador independiente y automático; no es otro ciclo de misión.
- Sin rearme ni reanudación: **matriz vacía al iniciar**, cuatro piezas por tipo.

## Simulación manual: qué cambiar

Al inicio: `partAtSource`, `partAtClass`, `partIsMetal`, `partAtRamp`,
`partOnTool`, `gate1Extended`, `gate2Extended` a **false**;
`gate1Retracted`, `gate2Retracted` a **true**.
No se borran automáticamente estos sensores al iniciar.

| `cycleStep` | Cambios manuales en memoria del emulador | Qué simulas |
|---|---|---|
| 10 | **`partAtSource=true`** | Hay pieza disponible en alimentación. |
| 20 | Primero **`partIsMetal=false`** (roja) o **`true`** (metal); después **`partAtSource=false`** y al final **`partAtClass=true`** | La pieza sale de alimentación y llega al inductivo. El material debe estar fijado antes de confirmar presencia. |
| 30, roja | **`gate1Extended=true`, `gate1Retracted=false`, `gate2Extended=false`, `gate2Retracted=true`** | Los finales de carrera confirman la ruta no metálica. |
| 30, metal | **`gate1Extended=false`, `gate1Retracted=true`, `gate2Extended=true`, `gate2Retracted=false`** | Los finales de carrera confirman la ruta metálica. |
| 40 | **`partAtRamp=true`** | La pieza cruza el detector de paso. |
| 50 | **`partAtRamp=false`, `partAtClass=false`** | Ha dejado libres los detectores y se considera disponible en recogida. |
| 60 | **`partOnTool=true`**, mantenerlo durante el traslado | La ventosa ha cogido la pieza. |
| 70 | **`partOnTool=false`**, solo al llegar a esta fase | La pieza se ha soltado en la matriz. |
| 80 → 10 | Ningún cambio de contadores; preparar la siguiente pieza | Se cuenta una pieza y comienza otro ciclo. |
| 100 | Ninguno | Cuatro piezas de cada tipo colocadas. |

No editar `materialType`, `placedCount`, `placeIndex`, `cycleStep`, `physicalRun`
ni las órdenes de salida. Si un sensor ya cumple la condición, `wait` no se
detiene. Preparar sus valores a tiempo; no es una confirmación de flanco.

## Geometría y físico: pendientes conservados

Se conservan el TCP (0,20,0), velocidad 10 y las posiciones de recogida.
La matriz usa **dos referencias enseñadas**, una por fila:

- `placePose[0]`: primer hueco de la primera fila, conservado.
- `placePose[4]`: primer hueco de la segunda fila: **J1=-77.39, J2=100.14,
  J3=8.89, J4=-353.18**, proporcionado por el usuario.

Se calculan los destinos 1..3 y 5..7 desde la referencia de su propia fila,
con desplazamiento world Y=-60 mm por columna. Se conservan la altura y la
orientación de cada referencia. Las ocho aproximaciones son world Z+50 mm.
Ya no se usa X=-70 mm para calcular la segunda fila. Este cambio sustituye el
destino 4 que no resolvía; no demuestra que hubiera una singularidad.
**TODO:** comprobar destinos 5..7, aproximaciones, dirección de columnas y
recorridos en SRS y en la célula real.

**TODO físico:** confirmar bOut5=1 retiene; bOut3/bOut4=1 empujan y las rutas
(1,0) no metal / (0,1) metal; ciclo del carro; llegada a recogida (0,5 s
provisionales) y soplado (0,3 s). El selector no calibra estas diferencias.
STOP conserva aspiración, para carro y soplado y manda retener con la polaridad
asumida. La tarea física permanece activa al terminar la misión hasta STOP.

## Verificación pendiente en SRS

Los XML se han validado contra los XSD de VAL3 s6.8. Esto no sustituye
**Check Syntax** ni la prueba de movimientos/sensores en SRS y la estación.
