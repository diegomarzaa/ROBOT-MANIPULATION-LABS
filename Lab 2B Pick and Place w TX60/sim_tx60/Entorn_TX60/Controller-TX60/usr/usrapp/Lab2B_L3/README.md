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
2. En cada montaje revisar **siempre los 4 huecos desde el 0**. Por hueco:
   movej a jCheckApproach (check + checkLift) y movel a la pose de
   detección **enseñada** jPistonCheck. Esperar 0.15 s y leer bIn0.
3. Si no hay pistón: pasar directo al siguiente hueco, sin retirarse.
   Coger el **primer** hueco con pistón: subir a jCheckApproach, ir al
   approach del pick, bajar vertical, cerrar tTip y subir.
4. Si los 4 están vacíos: subir sobre el hueco 3, avisar de reposición,
   esperar 2 s y repetir desde el 0.
5. Con pistón recogido, insertar, retirar por jAssemblyMove, recoger el
   conjunto con tLateral y colocarlo en la matriz.
6. Contar tras depósito y retirada. Terminar con cuatro, sin quinta
   alimentación aunque haya otro cilindro detectado.

pistonIndex es independiente de partIndex: saltar un pistón no salta un
destino de matriz. Cada búsqueda empieza en el hueco 0, así que un hueco
repuesto se vuelve a usar. Con la bandeja vacía el cilindro espera en la
estación y no se cierra la pinza, ni se cuenta, ni se alimenta otro cilindro.
bIn0 detecta presencia delante del sensor; no confirma agarre.

## Posiciones y detección

- Recogidas de jPistonPick: [1]=IMG_3805, [3]=3806, [5]=3807, [7]=3808.
  Ángulos idénticos a L2.
- Approaches [0,2,4,6]: calculados a **pistonLift=60 mm** sobre la recogida
  en Z world, con tTip, orientación conservada y recogida como semilla IK.
- jPistonCheck[0..3]: poses de detección **enseñadas en el mando**, con el
  sensor en un lateral de la pinza. No se recalculan ni se sobrescriben.
- jCheckApproach[0..3]: calculados al arrancar a **checkLift=60 mm** sobre
  cada jPistonCheck en Z world, con tTip. Los ceros del DTX son espacio
  para el resultado del cálculo.
- Matriz: cuatro parejas jMatrix[0/1], [2/3], [4/5], [6/7], sin offsets;
  par=approach, impar=depósito. Todas sus joints se mantienen.

Antes de crear tareas o mover se exige pistonLift > 0 y checkLift > 0,
recogidas y poses de detección enseñadas (no todo ceros) y solución IK de
cada approach. Por hueco se imprime Z de pick / pickAppr / check /
checkAppr y el desplazamiento XY check-pick con tTip.
Se comprueba e imprime que Z approach de cada pareja de matriz supere Z
depósito. Esto no comprueba colisiones, trayectorias ni agarres.

## Modos y E/S

DTX actual con **simulation=false** (físico). Con true hay movimientos pero no acceso a pines ni
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

Ajuste posterior solicitado: mApproachSpeed.vel=27 frente a nominal 30,
tmax=300 mm/s y rmax=90 grados/s. Inserción ajustada después a vel=20,
tmax=100 mm/s y rmax=60 grados/s. Mismas aceleraciones y paradas; velocidad real dependiente
del override, límites y trayectoria. Ajuste compartido con Lab2B_IsmaL2.

Comprobados XML s6.8, nombres de hasta 15 caracteres, referencias,
conservación de joints y de Level 2. Flujo PGX probado con E/S e IK ficticias:
cuatro ocupados, huecos alternos, bandeja vacía y reposición, índices
independientes, ausencia de quinta alimentación, STOP y guardas de arranque.

Pendientes **Check Syntax en SRS**, FK/IK real, trayectorias y calibración
del punto de detección. No ejecutado en SRS ni robot físico.
