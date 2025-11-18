* Encoding: UTF-8.

* 1) Variable de tiempo (antigüedad en años).
COMPUTE tiempo = (DATE.DMY(1, 1, 2025) - F_CONST) / 86400 / 365.25.
EXECUTE.

* 2) Variable de evento: 1 = quiebra, 0 = censurado (sigue activa).
COMPUTE Evento = 0.

* Estados que se consideran quiebra.
IF (ESTADO = "disuelta") Evento = 1.
IF (ESTADO = "Extinción: La empresa se encuentra en situación de extinción por fusión por absorción") Evento = 1.
IF (ESTADO = "Extinción: La empresa se encuentra en situación de extinción") Evento = 1.
IF (ESTADO = "en concurso") Evento = 1.
IF (ESTADO = "quiebra") Evento = 1.

EXECUTE.

*------------------------------------------------------------------*
* 3) Curvas de Kaplan-Meier: total y por CCAA.
*------------------------------------------------------------------*.

DATASET ACTIVATE DataSet1.

KM tiempo
  /STATUS=Evento(1)
  /PRINT TABLE MEAN
  /PLOT SURVIVAL OMS.

KM tiempo BY CCAA
  /STATUS=Evento(1)
  /PRINT TABLE MEAN
  /PLOT SURVIVAL OMS.

*------------------------------------------------------------------*
* 4) Descriptivos de las variables de ROA, empleados y BPE (3 años).
*------------------------------------------------------------------*.

EXAMINE VARIABLES=
  ROA_ULT ROA_ANT1 ROA_ANT2
  N_EMP_ULT N_EMP_ANT1 N_EMP_ANT2
  BPE_ULT BPE_ANT1 BPE_ANT2
  /STATISTICS = DESCRIPTIVES
  /CINTERVAL = 95
  /PLOT = NONE.

*------------------------------------------------------------------*
* 5) Construcción de covariables agrupadas (media de los 3 años).
*------------------------------------------------------------------*.

* ROA agrupado.
COMPUTE ROA_group = MEAN(ROA_ULT, ROA_ANT1, ROA_ANT2).
EXECUTE.

* Número de empleados agrupado.
COMPUTE N_EMP_group = MEAN(N_EMP_ULT, N_EMP_ANT1, N_EMP_ANT2).
EXECUTE.

* Beneficio por empleado agrupado.
COMPUTE BPE_group = MEAN(BPE_ULT, BPE_ANT1, BPE_ANT2).
EXECUTE.

EXAMINE VARIABLES = ROA_group N_EMP_group BPE_group
  /STATISTICS = DESCRIPTIVES
  /PLOT = NONE.

*------------------------------------------------------------------*
* 6) Modelo de Cox básico (sin términos dependientes del tiempo).
*------------------------------------------------------------------*.

COXREG tiempo
  /STATUS = Evento(1)
  /METHOD = ENTER ROA_group N_EMP_group BPE_group
  /CRITERIA = PIN(.05) POUT(.10) ITERATE(20).

*------------------------------------------------------------------*
* 7) Tabla de supervivencia (para extraer S(t) por año).
*------------------------------------------------------------------*.

SURVIVAL TABLE = tiempo
  /INTERVAL = THRU 80 BY 1
  /STATUS = Evento(1)
  /PRINT = TABLE.

*------------------------------------------------------------------*
* 8) Términos dependientes del tiempo para comprobar PH.
*------------------------------------------------------------------*.

COMPUTE ROA_time   = ROA_group   * tiempo.
COMPUTE N_EMP_time = N_EMP_group * tiempo.
COMPUTE BPE_time   = BPE_group   * tiempo.
EXECUTE.

*------------------------------------------------------------------*
* 9) Modelo de Cox extendido con covariables dependientes del tiempo.
*------------------------------------------------------------------*.

COXREG tiempo
  /STATUS = Evento(1)
  /METHOD = ENTER ROA_group N_EMP_group BPE_group
                    ROA_time N_EMP_time BPE_time
  /CRITERIA = PIN(.05) POUT(.10) ITERATE(20).
