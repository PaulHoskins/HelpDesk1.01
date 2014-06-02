&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        lib/translatetemplate.p
    
    Purpose:        Email Template Merge
    
    Notes:
    
    
    When        Who         What
    02/06/2014  phoski      Initial      
***********************************************************************/

DEF INPUT PARAM pc-companyCode  AS CHAR     NO-UNDO.
DEF INPUT PARAM pc-tmpCode      AS CHAR     NO-UNDO.
DEF INPUT PARAM pi-IssueNumber  AS INT      NO-UNDO.
DEF INPUT PARAM pc-TxtIn        AS CHAR     NO-UNDO.

DEF OUTPUT PARAM pc-TxtOut      AS CHAR     NO-UNDO.
DEF OUTPUT PARAM pc-Erc         AS CHAR     NO-UNDO.




DEF TEMP-TABLE tt-mf    NO-UNDO
    FIELD   mf          AS CHAR 
    FIELD   val         AS CHAR
    
    INDEX mf mf.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


RUN ipBuildMergeFields.

pc-TxtOut = STRING(NOW).
FOR EACH tt-mf:
    pc-txtOut = pc-txtOut + '~n' + 
            tt-mf.mf.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ipBuildMergeFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ipBuildMergeFields Procedure 
PROCEDURE ipBuildMergeFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF VAR lc-part AS CHAR     NO-UNDO.
    DEF VAR li-loop AS INT      NO-UNDO.
    DEF VAR lc-this AS CHAR     NO-UNDO.
    
    DO li-loop = 1 TO NUM-ENTRIES(pc-TxtIn,"<%"):
        lc-part = ENTRY(li-Loop + 1,pc-TxtIn,"<%").

        lc-this = replace(ENTRY(1,lc-part,">%"),"%",'').

        FIND tt-mf
                WHERE tt-mf.mf = lc-this NO-LOCK NO-ERROR.
        IF AVAIL tt-mf THEN NEXT.


        CREATE tt-mf.
        ASSIGN 
            tt-mf.mf = lc-this.


    END.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

