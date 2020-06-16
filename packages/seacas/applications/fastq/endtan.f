C    Copyright(C) 1999-2020 National Technology & Engineering Solutions
C    of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    See packages/seacas/LICENSE for details

C
C
      SUBROUTINE ENDTAN (MP, ML, N, IPOINT, COOR, LTYPE, LCON, LINKP,
     &   LINKL, LNUM, LPNTR, NP, THETA, ERR)
C***********************************************************************
C
C  SUBROUTINE ENDTAN = GETS THE ANGLE FOR THE TANGENT AT THE END OF
C                      A LINE
C
C***********************************************************************
C
C  VARIABLES USED:  LNUM   = LINE NUMBER
C                   LPNTR  = LINE POINTER
C                   VECTX  = X VECTOR
C                   VECTY     = Y VECTOR
C                   ICCW   = THE POINTER TO THE CCW END OF THE LINE
C                   ICW    = THE POINTER TO THE CW END OF THE LINE
C                   I1     = THE FIRST POINT NUMBER OF THE LINE
C                   I2     = THE SECOND POINT NUMBER OF THE LINE
C                   I3     = THE THIRD POINT NUMBER OF THE LINE
C                   J1     = THE FIRST POINT NUMBER INDEX
C                   J2     = THE SECOND POINT NUMBER INDEX
C                   J3     = THE THIRD POINT NUMBER INDEX
C
C***********************************************************************
C
      DIMENSION IPOINT (MP), COOR (2, MP), LTYPE (ML), LCON (3, ML)
      DIMENSION LINKP (2, MP), LINKL (2, ML)
      DIMENSION N (29)
C
      LOGICAL ADDLNK, ERR
C
      PI = ATAN2(0.0, -1.0)
C
      TWOPI = PI + PI
      ADDLNK = .FALSE.
      ERR = .FALSE.
C
C  GET THE POINTERS TO THE POINTS THAT DEFINE THE LINE
C
      I1 = LCON (1, LPNTR)
      I2 = LCON (2, LPNTR)
      I3 = LCON (3, LPNTR)
      CALL LTSORT (MP, LINKP, I1, J1, ADDLNK)
      CALL LTSORT (MP, LINKP, I2, J2, ADDLNK)
      IF ( (J1 .LE. 0) .OR. (J2 .LE. 0))RETURN
      IF (I3 .NE. 0) THEN
         CALL LTSORT (MP, LINKP, IABS (I3), J3, ADDLNK)
         IF (J3 .LE. 0)RETURN
      ELSE
         J3 = 0
      ENDIF
C
C  STRAIGHT LINE END TANGENT
C
      IF (LTYPE (LPNTR) .EQ. 1) THEN
         IF (I1 .EQ. NP) THEN
            VECTX = COOR (1, J2) - COOR (1, J1)
            VECTY = COOR (2, J2) - COOR (2, J1)
         ELSEIF (I2 .EQ. NP) THEN
            VECTX = COOR (1, J1) - COOR (1, J2)
            VECTY = COOR (2, J1) - COOR (2, J2)
         ELSE
            ERR = .TRUE.
            RETURN
         ENDIF
         THETA = ATAN2 (VECTY, VECTX)
C
C  ARC LINE END TANGENT
C
      ELSEIF (LTYPE (LPNTR) .NE. 5) THEN
         CALL ARCPAR (MP, LTYPE (LPNTR), LNUM, COOR, LINKP,
     &      J1, J2, J3, I3, XCEN, YCEN, THETA1, THETA2, TANG,
     &      R1, R2, ERR, ICCW, ICW, XK, XA)
C
C  CHECK FOR THE A CLOSED ARC
C
         IF (IPOINT (ICCW) .EQ. IPOINT (ICW)) THEN
            THETA  =  THETA2  +   (PI * .5)
         ELSEIF (NP .EQ. IPOINT (ICCW)) THEN
            THETA = THETA1 +  (PI * .5) + XK
         ELSEIF (NP .EQ. IPOINT (ICW)) THEN
            THETA = THETA2  -   (  (PI * .5)  -  XK )
         ELSE
            ERR = .TRUE.
            RETURN
         ENDIF
C
C  NO OTHER LINES SUPPORTED
C
      ELSE
         ERR = .TRUE.
         CALL MESAGE ('UNSUPPORTED LINE TYPE IN ENDTAN')
         RETURN
      ENDIF
C
C  MAKE SURE THAT THETA IS BETWEEN 0 AND 2PI
C
      IF (THETA .LT. 0) THEN
         THETA = THETA + TWOPI
      ELSEIF (THETA .GT. TWOPI) THEN
         THETA = THETA - TWOPI
      ENDIF
C
      RETURN
C
      END
