C    Copyright(C) 1999-2020 National Technology & Engineering Solutions
C    of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    See packages/seacas/LICENSE for details

C
C
      SUBROUTINE UNISNP (MSNAP, SNAPDX, NSNAP, INDEX, XMIN, XMAX, STEP)
C***********************************************************************
C
C  SUBROUTINE UNISNP = GENERATES UNIFORM SNAP GRID
C
C***********************************************************************
C
C  VARIABLES USED:
C     MSNAP  = DIMENSION OV SNAP ARRAYS
C     SNAPDX = THE SNAP GRID VALUES ARRAY  (X AND Y)
C     NSNAP  = THE NUMBER OF SNAP GRID VALUES IN X AND Y
C     INDEX  = 1 FOR X VALUES,  2 FOR Y VALUES
C
C***********************************************************************
C
      DIMENSION SNAPDX (2, MSNAP), NSNAP (2)
C
      LOGICAL ERR
C
      CHARACTER*1 AXIS (2)
C
      DATA AXIS /'X', 'Y'/
C
C  DEFINE THE GRID
C
      IF (STEP.EQ.0.)RETURN
      ILOOP =  INT(((XMAX - XMIN) / STEP) + 2)
      XGRID = XMIN
      DO 100 I = 1, ILOOP
         CALL ADDSNP (MSNAP, SNAPDX, NSNAP, INDEX, XGRID, ERR)
         IF (ERR)THEN
            WRITE (*, 10000)AXIS (INDEX),  XGRID - STEP
            RETURN
         ENDIF
         XGRID = XGRID + STEP
         IF (XGRID.GE. (STEP + XMAX))RETURN
  100 CONTINUE
C
      RETURN
C
10000 FORMAT (' THE LAST SUCCESSFUL ', A1, ' GRID INPUT WAS: ', G14.7)
C
      END
