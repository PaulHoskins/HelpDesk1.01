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

DEF INPUT PARAM pl-test         AS LOG      NO-UNDO.
DEF INPUT PARAM pc-TxtIn        AS CHAR     NO-UNDO.

DEF OUTPUT PARAM pc-TxtOut      AS CHAR     NO-UNDO.
DEF OUTPUT PARAM pc-Erc         AS CHAR     NO-UNDO.


DEFINE BUFFER   issue       FOR issue.
DEFINE BUFFER   assigned    FOR webuser.
DEFINE BUFFER   raised      FOR webuser.
DEFINE BUFFER   customer    FOR customer.
DEFINE BUFFER   istatus     FOR webstatus.
DEFINE BUFFER   iArea       FOR WebIssArea.


DEFINE VAR lc-bList AS CHAR INITIAL 'issue,assigned,customer,raised,istatus,iArea'
                                            NO-UNDO.
DEFINE VAR li-b     AS INT                  NO-UNDO.
DEFINE VAR hb       AS HANDLE   EXTENT 20   NO-UNDO.
DEFINE VAR lc-TimeL AS CHAR INITIAL
    'AssignTime,CompTime,CreateTime,IssueTime'
                                            NO-UNDO.


DEF TEMP-TABLE tt-mf    NO-UNDO
    FIELD   mf          AS CHAR 
    FIELD   val         AS CHAR
    FIELD   isOk        AS LOG INITIAL FALSE
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


FIND issue WHERE issue.companyCode = pc-companyCode
             AND issue.issuenumber = pi-IssueNumber NO-LOCK NO-ERROR.

hb[1] = BUFFER issue:HANDLE.

FIND assigned WHERE ASSIGNed.loginid = issue.assignto  NO-LOCK NO-ERROR.
hb[2] = BUFFER assigned:HANDLE.

FIND customer OF issue NO-LOCK NO-ERROR.
hb[3] = BUFFER customer:HANDLE.

FIND raised WHERE raised.loginid = issue.RaisedLogin  NO-LOCK NO-ERROR.
hb[4] = BUFFER raised:HANDLE.


FIND iStatus OF issue NO-LOCK NO-ERROR.
hb[5] = BUFFER iStatus:HANDLE.

FIND iArea OF issue NO-LOCK NO-ERROR.
hb[6] = BUFFER iArea:HANDLE.




RUN ipBuildMergeFields.

RUN ipMergeFields ( pc-TxtIn, OUTPUT pc-TxtOut ).

FIND FIRST tt-mf WHERE tt-mf.isOK = FALSE NO-ERROR.
IF AVAIL tt-mf 
THEN pc-erc = "Not all merge fields completed".



IF pl-test THEN
DO:
    
    pc-TxtOut = '<b>Formatted</b> =~n<i>' + pc-TxtOut + '</i>~n~n<b>Merged Variables</b> = '.
    FOR EACH tt-mf NO-LOCK
        BY tt-mf.isOK BY tt-mf.mf :
        pc-txtOut = pc-txtOut + '~n' + 
            ( IF NOT tt-mf.isOK
              THEN '<span style="color:red;">' ELSE ''
              )
              +
            tt-mf.mf + ' ' + tt-mf.val
            + 
            ( IF NOT tt-mf.isOK
              THEN '</span>' ELSE ''
              )
              .

    END.
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

    DEF VAR lh      AS HANDLE   NO-UNDO.
    DEF VAR lf      AS HANDLE   NO-UNDO.
    DEF VAR lc-val  AS CHAR     NO-UNDO.

    
    DO li-loop = 1 TO NUM-ENTRIES(pc-TxtIn,"<%") - 1:
        lc-part = ENTRY(li-Loop + 1,pc-TxtIn,"<%").

        lc-this = replace(ENTRY(1,lc-part,">%"),"%",'').

        FIND tt-mf
                WHERE tt-mf.mf = lc-this NO-LOCK NO-ERROR.
        IF AVAIL tt-mf THEN NEXT.


        CREATE tt-mf.
        ASSIGN 
            tt-mf.mf = lc-this.


    END.

    DEF VAR lc-bname    AS CHAR     NO-UNDO.
    DEF VAR lc-bfield   AS CHAR     NO-UNDO.

    FOR EACH tt-mf EXCLUSIVE-LOCK:
        IF NUM-ENTRIES(tt-mf.mf,".") <> 2 THEN
        DO:
            tt-mf.val = "Invalid format table.field".
            NEXT.
        END.
        ASSIGN
            lc-bname = ENTRY(1,tt-mf.mf,".")
            lc-bfield = ENTRY(2,tt-mf.mf,".")
            .

        li-b = LOOKUP(lc-bname,lc-blist).

        IF li-b <= 0 THEN
        DO:
            tt-mf.val = "Unknown table " + lc-bname.
            NEXT.
        END.
            
        assign
            lh = hb[li-b]
            lf = ?.

        IF NOT lh:AVAILABLE THEN
        DO:
            ASSIGN tt-mf.val = "NOT AVAILABLE"
                   tt-mf.isOK = TRUE.
            NEXT.
        END.
        lf = lh:BUFFER-FIELD(lc-bfield) NO-ERROR.
        IF ERROR-STATUS:ERROR OR lf = ? THEN
        DO:
            tt-mf.val = "Unknown table.field " + lc-bname + "." + lc-bfield.
            NEXT.
        END.

        assign
            lc-val = lf:BUFFER-VALUE NO-ERROR.
        ASSIGN
            tt-mf.val = lc-val.

        CASE lf:DATA-TYPE:
            WHEN "DATE" THEN
            DO:
                tt-mf.val = STRING( DATE(lc-val),"99/99/9999") NO-ERROR.

            END.
            WHEN "INTEGER" THEN
            DO:         
                IF LOOKUP(lc-bfield,lc-TimeL) > 0 
                THEN ASSIGN tt-mf.val = STRING(INT(lc-val),"hh:mm") NO-ERROR.
            END.
            OTHERWISE 
                tt-mf.val = lc-val.
        END CASE.
        IF tt-mf.val = ?
        THEN tt-mf.val = "".

        ASSIGN tt-mf.ISOK = TRUE.


    END.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ipMergeFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ipMergeFields Procedure 
PROCEDURE ipMergeFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcin        AS CHAR     NO-UNDO.
    DEF OUTPUT PARAM pcout       AS CHAR     NO-UNDO.


    pcout = pcin.

    FOR EACH tt-mf WHERE tt-mf.isOK NO-LOCK:
        pcout = REPLACE(pcout,"<%" + tt-mf.mf + "%>",tt-mf.val).
        pcout = REPLACE(pcout,"<%" + tt-mf.mf + ">",tt-mf.val).

    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

