# Memoria de Lab 2B

Abrir `main.tex` o esta carpeta en el editor LaTeX de Codex; también se puede importar la carpeta completa en Overleaf. El documento está en inglés, como la plantilla original. Conserva el logo, cabecera y márgenes UdG, con el contenido de ejemplo sustituido por la práctica TX60.

- `main.tex`: informe en elaboración. Los marcadores azules TODO son datos por completar.
- `img/udglogo.png`: logo de la plantilla original; añadir aquí las capturas de la celda y resultados.
- `code/*.val3`: copia de los cinco programas actuales (start, stop, moveCylinder, insertPiston, unloadAssembly). **No se actualizan automáticamente**; refrescarlos cuando cambie el código de SRS.
- `WORKLOG.md`: registrar pruebas y contribuciones mientras se desarrolla la práctica.
- `../../docs/DELIVERABLES.md`: requisitos y criterios de las dos entregas.

La aplicación editable sigue en `../sim_tx60/Entorn_TX60/Controller-TX60/usr/usrapp/Lab2B/`. No editar los listados del informe esperando que cambie el programa del robot.

Los diez puntos de proceso ya tienen coordenadas guardadas. La aplicación se ha simplificado a un ciclo: start llama a moveCylinder, insertPiston y unloadAssembly, sin modos ni variables de confirmación. Al arrancar solicita directamente el ciclo completo. Se deben revisar las fases con el depurador en simulación. Un nuevo Check Syntax, la validación geométrica y la ejecución completa siguen pendientes. Ver `../RECOVERY.md` para la copia de recuperación y cómo retomar.

Antes de exportar el PDF final: completar nombres de todos los integrantes, vídeo con estudiantes visibles, nivel demostrado, explicación de cada variable y programa, resultados y contribuciones; actualizar los listados; eliminar los TODO; comprobar enlaces y diseño del PDF. Guardar el PDF final junto al proyecto de informe cuando esté listo.
