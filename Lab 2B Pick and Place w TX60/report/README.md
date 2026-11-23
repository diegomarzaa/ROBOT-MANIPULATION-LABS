# Memoria de Lab 2B

> **Integración posterior del 23/11/2026:** la versión para las nuevas pruebas
> es `Lab2B_IsmaL2`, con las cuatro recogidas IMG_3805–3808 y approaches
> calculados +60 mm en Z world. Mantiene las cuatro parejas de joints de
> matriz sin offsets. `Lab2B_Level2` queda como copia anterior intacta.
> Ver `../LEVELS.md`. Siguen pendientes Check Syntax y ensayos SRS/físico;
> los listados de esta memoria siguen sin sincronizar.

> **23 de noviembre de 2026:** existe una aplicación separada `Lab2B_Level2`.
> Ver `../LEVELS.md` y su README. El Level 1 actual se conserva sin cambios.
> Level 2 incluye alimentación y matriz de cuatro huecos, pero faltan las
> cuatro parejas de recogida de pistón y las pruebas en SRS/físico. Esta
> memoria y sus listados no se han actualizado a Level 2.

> **Estado a 9 de noviembre de 2026:** la aplicación se ha reorganizado en
> `start`, `physicalIO` y `stop`, con un solo ciclo Level 1 y selector
> `simulation`. El README situado junto a `Lab2B.pjx` documenta la versión
> actual. **`main.tex` y los cinco listados de `code/` aún describen la versión
> anterior** y deben sincronizarse antes de entregar el informe. Esta revisión
> se centra en preparar el código; no se ha validado el montaje en SRS o físico.

Abrir `main.tex` o esta carpeta en el editor LaTeX de Codex; también se puede importar la carpeta completa en Overleaf. El documento está en inglés, como la plantilla original. Conserva el logo, cabecera y márgenes UdG, con el contenido de ejemplo sustituido por la práctica TX60.

- `main.tex`: informe en elaboración. Los marcadores azules TODO son datos por completar.
- `img/udglogo.png`: logo de la plantilla original; añadir aquí las capturas de la celda y resultados.
- `code/*.val3`: copia de los cinco programas actuales (start, stop, moveCylinder, insertPiston, unloadAssembly). **No se actualizan automáticamente**; refrescarlos cuando cambie el código de SRS.
- `WORKLOG.md`: registrar pruebas y contribuciones mientras se desarrolla la práctica.
- Requisitos: PDF con memoria, nombres completos, programa y variables explicados, y vídeo del último nivel alcanzado con estudiantes visibles. Un representante puede entregar por el grupo; verificar acceso al vídeo.
- Evaluación 2B: nivel, trabajo personal, preguntas de demostración, explicación de la aplicación y calidad de programa/memoria. La puntuación del criterio de nivel es 2/10, 4/10 o 6/10 para L1, L2 o L3 (no se suman). Las sugerencias sobre las sesiones son opcionales.

La aplicación editable sigue en `../sim_tx60/Entorn_TX60/Controller-TX60/usr/usrapp/Lab2B/`. No editar los listados del informe esperando que cambie el programa del robot.

Los diez puntos de proceso ya tienen coordenadas guardadas. La aplicación se ha simplificado a un ciclo: start llama a moveCylinder, insertPiston y unloadAssembly, sin modos ni variables de confirmación. Al arrancar solicita directamente el ciclo completo. Se deben revisar las fases con el depurador en simulación. Un nuevo Check Syntax, la validación geométrica y la ejecución completa siguen pendientes. Ver `../RECOVERY.md` para la copia de recuperación y cómo retomar.

Antes de exportar el PDF final: completar nombres de todos los integrantes, vídeo con estudiantes visibles, nivel demostrado, explicación de cada variable y programa, resultados y contribuciones; actualizar los listados; eliminar los TODO; comprobar enlaces y diseño del PDF. Guardar el PDF final junto al proyecto de informe cuando esté listo.
