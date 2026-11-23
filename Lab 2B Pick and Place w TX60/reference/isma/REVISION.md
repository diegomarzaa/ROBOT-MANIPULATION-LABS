# Revisión e integración para Level 2 — 23/11/2026

Fuente: [commit original de Isma](https://github.com/ismaelbentaleb/isma/tree/5a233aeb5c9bc9946dc8e01b13d66c8949386d8d).
Los ocho XML cumplen los esquemas VAL3 s6.8 instalados. Eso no prueba que
la aplicación original compile ni que las trayectorias sean correctas.

| Hallazgo en el original | Decisión en Lab2B_IsmaL2 |
|---|---|
| `Project.pjx` referencia `io.dtx`, ausente del repositorio, y no declara alias `io`; las herramientas necesitan ese alias. Los nombres de pines sin prefijo tampoco están declarados en `Data.dtx`. | Usar nuestro alias a la biblioteca `io`, referencias `io:bIn2/14/15`, `io:bOut10` y herramientas sobre `io:valve1[0]`. |
| Búsqueda Level 3 en una parrilla de pistones 2×4, con pasos supuestos de 40 mm. | Omitir búsqueda y offsets. Cuatro recogidas reales, una por montaje, en orden IMG_3805–3808. |
| Matriz 2×4 calculada con pasos de 65 mm y frame propio del original. | Cuatro parejas de joints del usuario, sin offsets de matriz. |
| El alimentador repite pulsos si no aparece una pieza. | Una extensión y retracción confirmadas por finales de carrera; esperar presencia antes de recoger. Esperar ausencia tras retirar. Validar mecánicamente en la celda. |
| `nTotalCycles` admite otras cantidades; `jStart` está a cero. | Límite fijo de cuatro, contador después de depósito y retirada, postura inicial enseñada. No hay quinta alimentación. |
| Separación en alimentación, cilindro, pistón y matriz; órdenes open/close por herramienta. | Conservar esa organización con nuestros nombres de variables, TCP, velocidades y juntas enseñadas. El adaptador no escribe valve1. |

No se consideran errores `roundDown`, `appro` ni `toString`: existen en
el lenguaje instalado. Los signos de los offsets del original no se han
calificado de incorrectos sin calibrar sus frames; simplemente no se
usan porque el usuario dispone de joints enseñadas para esta celda.

El nuevo approach de pistón se calcula 60 mm por encima en Z de world
con tTip, conservando orientación/configuración y usando la recogida como
semilla de pointToJoint. Se rechaza el arranque si no tiene solución.
El cálculo necesita confirmación en SRS; no es una postura medida.

Validación local: esquemas XML, declaraciones, referencias, transcripción
de 48 ángulos de matriz y 24 de pistones, y ejecución en seco del flujo
PGX con E/S y cinemática simuladas. Cuatro ciclos, pieza inicial presente,
ausencia de quinta alimentación, guardas de arranque y STOP comprobados.
No se ejecutó el robot ni se resolvió su cinemática real. Pendientes
Check Syntax de SRS, revisión de alturas/trayectorias y ensayo mecánico.
