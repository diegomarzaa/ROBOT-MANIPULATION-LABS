# Lab2B_L3 — búsqueda de pistones con sensor

Abrir **Lab2B_L3.pjx**, con toda esta carpeta y la biblioteca io del
controlador. Aplicación separada de Lab2B_IsmaL2, que permanece intacta.
Solo ejecutar una aplicación sobre la celda.

Implementa el apartado 3.3 de lesson2b.pdf: detectar pistones ausentes con
el sensor bIn0 de herramienta y buscar otro. Se adapta la lógica de Isma
con nuestros nombres y cuatro recogidas reales, sin parrilla 2×4 inventada
ni offsets de matriz. Procedencia original en SOURCE.json y reference/isma.

## Secuencia

1. Alimentar cilindro y colocarlo en la estación, igual que Level 2.
2. Visitar pistonIndex, empezando por 0, aproximarse con tTip y bajar al
   punto de detección jPistonCheck[pistonIndex].
3. En físico, esperar 0.15 s para asentar y actualizar bIn0. Si detecta,
   bajar a recogida, cerrar y retirarse. Si no, retirarse sin cerrar.
4. Avanzar pistonIndex tras cada intento. Si sigue sin pistón, probar otro
   hueco. Después del 3 volver al 0; al final de bandeja sin detección,
   mostrar aviso de reposición y pausar 2 s antes de continuar buscando.
5. Con pistón recogido, insertar, retirar por jAssemblyMove, recoger el
   conjunto con tLateral y colocarlo en la matriz.
6. Contar tras depósito y retirada. Terminar con cuatro, sin quinta
   alimentación aunque haya otro cilindro detectado.

pistonIndex es independiente de partIndex: saltar un pistón no salta un
destino de matriz. Los huecos pueden revisitarse después de reponerlos.
Si toda la bandeja está vacía, el cilindro espera en la estación y la
búsqueda se repite sin cerrar la pinza, contar ni alimentar otro cilindro.
bIn0 detecta presencia delante de herramienta; no confirma agarre.

## Posiciones y detección

- Recogidas de jPistonPick: [1]=IMG_3805, [3]=3806, [5]=3807, [7]=3808.
  Ángulos idénticos a L2.
- Approaches [0,2,4,6]: calculados a **pistonLift=60 mm** sobre la recogida
  en Z world, con tTip, orientación conservada y recogida como semilla IK.
- jPistonCheck[0..3]: calculados a **pistonCheckLift=35 mm** sobre cada
  recogida, en Z world y con tTip. Los ceros guardados son espacio para
  el resultado del cálculo, no destinos ejecutados directamente.
- Matriz: cuatro parejas jMatrix[0/1], [2/3], [4/5], [6/7], sin offsets;
  par=approach, impar=depósito. Todas sus joints se mantienen.

**35 mm es una propuesta, no una calibración del sensor.** Se sigue la idea
de Isma de detectar antes de llegar al pick, pero su offset estaba en otro
frame. Comprobar que bIn0 distingue ocupado/vacío desde esta postura y
ajustar pistonCheckLift según el montaje real del sensor.

Antes de crear tareas o mover, se exige 0 < pistonCheckLift < pistonLift,
se calculan approaches y puntos de detección, y se rechaza una IK fallida.
Se comprueba e imprime que Z approach de cada pareja de matriz supere Z
depósito. Esto no comprueba colisiones, trayectorias ni agarres.

## Modos y E/S

Guardado **simulation=true**: hay movimientos pero no acceso a pines ni
open/close reales; se editan bools manualmente. Para físico poner
simulation=false antes de start; physicalRun fija el modo hasta otro start.

| Señal | Variable / función |
|---|---|
| io:bIn0 | pistonPresent: true=presente |
| io:bIn2 | cylinderPresent |
| io:bIn14 / bIn15 | feederExtended / feederRetracted |
| io:bOut10 | feederExtend: extender/retraer alimentador |
| io:valve1[0] | open/close(tTip), open/close(tLateral) |

physicalIO lee sensores y manda exclusivamente bOut10; nunca sobrescribe
valve1. Alimentador igual que L2: confirmar retraído, si falta cilindro
extender y confirmar, retraer y confirmar, esperar presencia. Tras recoger
esperar ausencia. Esperas sin timeout; secuencia mecánica pendiente de ensayo.

Simulación manual:

- Inicialmente feederRetracted=true y feederExtended=false.
- Fase 11: extended=true/retracted=false; fase 12: invertirlos.
- Fase 13: cylinderPresent=true; fase 21: cylinderPresent=false.
- **Fase 41:** mirar pistonIndex, poner pistonPresent según ese hueco y
  después pistonChecked=true. El permiso se reinicia en cada visita.

STOP conserva pinza, cancela movimiento/tarea y manda retraer alimentador
si estaban iniciadas las E/S. Otro start reinicia índices y contador:
comenzar con matriz vacía y estación preparada. No hay reanudación automática.

## Validación

Comprobados XML s6.8, nombres de hasta 15 caracteres, referencias,
conservación de joints y de Level 2. Flujo PGX probado con E/S e IK ficticias:
cuatro ocupados, huecos alternos, bandeja vacía y reposición, índices
independientes, ausencia de quinta alimentación, STOP y guardas de arranque.

Pendientes **Check Syntax en SRS**, FK/IK real, trayectorias y calibración
del punto de detección. No ejecutado en SRS ni robot físico.
