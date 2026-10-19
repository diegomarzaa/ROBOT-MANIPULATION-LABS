# Recuperación de Lab2B — 19 octubre 2026

## Qué se había guardado antes del fallo

Se han conservado sin cambiar sus valores: world, flange, tLateral, tTip, jStart, jTransCylinder, mNomSpeed y los cuatro puntos del cilindro. La velocidad nominal ya estaba a **30**, con aceleración/deceleración 10 y blend off; no se ha vuelto a poner a 10.

| Punto guardado | X (mm) | Y (mm) | Z (mm) | RX / RY / RZ (grados) |
|---|---:|---:|---:|---|
| pCylApproach | 357.714679 | -328.961855 | -126.148018 | -1.279933 / 177.786577 / -84.287342 |
| pCylPick | 365.440494 | -333.426787 | -325.985990 | -1.279933 / 177.786577 / -84.287342 |
| pAsmApproach | 565.669143 | -19.399424 | -153.238217 | 178.720067 / 2.213423 / 52.011479 |
| pAsmCylinder | 572.013284 | -23.065854 | -317.337461 | 178.720067 / 2.213423 / 52.011479 |

Todos son hijos de world y conservan su configuración ssame/esame/wsame. Son valores enseñados por el usuario; conservarlos no equivale a haber validado su trayectoria o agarre.

La copia completa anterior a los cambios está en `../work/recovery/20261019-002635-Lab2B-before-recovery.zip`, respecto a la raíz del repositorio `work/recovery/20261019-002635-Lab2B-before-recovery.zip`. Esta carpeta queda ignorada por Git. El ZIP conserva la celda completa de 2B, incluidas configuraciones y biblioteca io, tal como estaban antes de la preparación.

## Estado actual tras simplificar

Los valores de la tabla anterior son el registro histórico de recuperación. Después el usuario ha ajustado puntos del cilindro y enseñado los seis puntos restantes. Los valores actuales están en Lab2B.dtx y en el informe.

- `start`: llama a moveCylinder, insertPiston y unloadAssembly, en ese orden, una sola vez.
- `moveCylinder`: recogida de cilindro y depósito en el montaje con tLateral.
- `insertPiston`: recogida de pistón e inserción con tTip.
- `unloadAssembly`: retirada del conjunto hacia la rampa con tLateral.
- `stop`: resetMotion y mensaje; no ordena abrir la pinza ni volver a Home.

Se han eliminado los modos de ejecución, las variables de confirmación y checkSetup. **Al ejecutar start se solicita directamente el ciclo completo.** Los diez puntos ya tienen coordenadas; esto no certifica las trayectorias ni el agarre.

Se mantienen los dos descriptores de movimiento, todos los puntos y herramientas, las esperas waitEndMove y un mensaje por fase. jStart sigue como referencia sin retorno automático. La recogida del conjunto reutiliza pAsmApproach/pAsmCylinder: revisar su agarre tras insertar el pistón.

## Cómo retomar

1. Recargar Lab2B desde disco en SRS sin sobrescribir las ediciones externas con una copia antigua en memoria.
2. Pasar Check Syntax para esta versión.
3. En el emulador local, usar velocidad reducida y depurador/puntos de interrupción para revisar cilindro, pistón/inserción y retirada a rampa.
4. Validar después el ciclo completo, registrar resultados y actualizar el report.
5. El commit queda para el nivel 1 validado, como pidió el usuario.

No se ha ejecutado el ciclo completo ni diagnosticado la causa del cierre de SRS.
