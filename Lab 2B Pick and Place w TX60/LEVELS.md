# Versiones de Lab 2B

| Nivel | Aplicación | Estado |
|---|---|---|
| Level 1 | [Lab2B](sim_tx60/Entorn_TX60/Controller-TX60/usr/usrapp/Lab2B/Lab2B.pjx) | Copia actual preservada sin cambios al preparar Level 2. |
| Level 2 | [Lab2B_Level2](sim_tx60/Entorn_TX60/Controller-TX60/usr/usrapp/Lab2B_Level2/Lab2B_Level2.pjx) | Cuatro montajes, alimentador y matriz; faltan las ocho joints de aproximación/recogida de los cuatro pistones. |
| Level 2 integrado | [Lab2B_IsmaL2](sim_tx60/Entorn_TX60/Controller-TX60/usr/usrapp/Lab2B_IsmaL2/Lab2B_IsmaL2.pjx) | Versión actual para probar: estructura de Isma adaptada, cuatro recogidas IMG_3805–3808 y approaches calculados a +60 mm Z world. Matriz con cuatro parejas de joints enseñadas. |

**Usar Lab2B_IsmaL2 para las nuevas pruebas.** Su [guía](sim_tx60/Entorn_TX60/Controller-TX60/usr/usrapp/Lab2B_IsmaL2/README.md)
describe modo manual/físico y comprobaciones pendientes. La preparación
Lab2B_Level2 anterior queda guardada intacta; sus pistones siguen pendientes
solo en esa copia. Los [originales de Isma](reference/isma/README.md) se
guardan aparte con revisión y commit de procedencia.

La guía de Level 2 está en el [README de la aplicación](sim_tx60/Entorn_TX60/Controller-TX60/usr/usrapp/Lab2B_Level2/README.md).
Solo ejecutar una aplicación a la vez en el controlador. Cargar cada versión
completa con su propio DTX y PGX, usando el PJX correcto.

Preparación del 23 de noviembre de 2026: Level 2 guarda `simulation=true`.
No mueve ni acciona salidas con las recogidas de pistón todavía a cero.
Se han comprobado XML, referencias, transcripción de matriz y lógica en seco;
faltan Check Syntax, cálculo de alturas en SRS y validación de trayectorias
y funcionamiento mecánico de la alimentación.

**Corrección posterior al log de VAL3Check:** la aplicación integrada se
llama ahora `Lab2B_IsmaL2` (carpeta, PJX y DTX). Se han acortado todos los
nombres declarados a un máximo de 15 caracteres, incluido `jAssemblyMove`
en las tres versiones. En Level 1 se ha retirado también la escritura
inválida `io:valve1 = grippe1rOpen`; la pinza se manda con open/close.
Las copias anteriores a estas correcciones quedan en work/recovery.
Las referencias anteriores a versiones intactas describen la preparación
inicial, antes de esta reparación solicitada por los errores de compilación.

La memoria LaTeX de `report` sigue pendiente de sincronizar y no demuestra
una ejecución de estas versiones.
