&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        prince/manrep.p
    
    Purpose:        Management PDF Report     
    
    Notes:
    
    
    When        Who         What
    10/07/2006  phoski      Initial
***********************************************************************/
                                          
{lib/htmlib.i}
{lib/princexml.i}
{rep/manreptt.i}

&IF DEFINED(UIB_is_Running) EQ 0 &THEN

def input param pc-user             as char no-undo.
def input param pc-CompanyCode      as char no-undo.
def input param pd-date             as date no-undo.
def input param pi-days             as int  no-undo.
def input param table for tt-mrep.
def output param pc-pdf            as char no-undo.

&ELSE

def var pc-user                    as char no-undo.
def var pc-CompanyCode             as char no-undo.
def var pd-date                    as date no-undo.
def var pi-days                    as int  no-undo.
def var pc-pdf                     as char no-undo.

assign pc-CompanyCode = "MICAR"
       pd-date        = today
       pi-days        = 150.
run rep/manrepbuild.p 
        ( pc-companyCode,
          pd-date,
          pi-days,
          output table tt-mrep ).

&ENDIF



def var lc-html         as char     no-undo.
def var lc-pdf          as char     no-undo.
def var ll-ok           as log      no-undo.
def var li-ReportNumber as int      no-undo.

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


assign
    pc-pdf = ?
    li-ReportNumber = next-value(ReportNumber).
assign 
    lc-html = session:temp-dir + caps(pc-CompanyCode) + "-ManagementReport-" + string(li-ReportNumber).

assign 
    lc-pdf = lc-html + ".pdf"
    lc-html = lc-html + ".html".

os-delete value(lc-pdf) no-error.
os-delete value(lc-html) no-error.


dynamic-function("pxml-Initialise").

create tt-pxml.
assign 
    tt-pxml.PageOrientation = "LANDSCAPE".

dynamic-function("pxml-OpenStream",lc-html).
dynamic-function("pxml-Header", pc-CompanyCode).

RUN ip-Print.

dynamic-function("pxml-Footer",pc-CompanyCode).
dynamic-function("pxml-CloseStream").


ll-ok = dynamic-function("pxml-Convert",lc-html,lc-pdf).

if ll-ok
then assign pc-pdf = lc-pdf.
    
&IF DEFINED(UIB_is_Running) ne 0 &THEN

    os-command silent start value(lc-pdf).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-Print) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Print Procedure 
PROCEDURE ip-Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var lf-bfwd         like tt-mrep.bfwd       no-undo.
    def var lf-openper      like tt-mrep.openper    no-undo.
    def var lf-closeper     like tt-mrep.closeper   no-undo.
    def var lf-outst        like tt-mrep.outst      no-undo.
    def var lf-duration     like tt-mrep.duration   no-undo.

    def var li-other        as int                  no-undo.
    def var lc-other-code   as char                 no-undo.
    def var lc-other-desc   as char                 no-undo.
    def var li-other-total  as int extent 10        no-undo.
    def var li-temp         as int                  no-undo.

    def buffer b-rep        for tt-mrep.
    

    for each WebIssCat
        where WebIssCat.CompanyCode = pc-companyCode
           by WebIssCat.description:

        if WebIssCat.CatCode = "Support" then next.

        if lc-other-code = ""
        then assign lc-other-code = WebIssCat.CatCode
                    lc-other-desc = WebIssCat.description.
        else assign lc-other-code = lc-other-code + "|" + WebIssCat.CatCode
                    lc-other-desc = lc-other-desc + "|" + WebIssCat.description.
    end.

    {&prince}
        '<p style="text-align: center; font-size: 14px; font-weight: 900;">Management Report - '
        'From ' string(pd-date - pi-days,"99/99/9999")
        ' To ' string(pd-date,"99/99/9999") 
        ' - Days ' pi-days ' Days'
        '</div>'.

    {&prince}
        '<table class="landrep">'
            '<thead>'
            '<tr>'
                '<th colspan=2>&nbsp;</th>'
                '<th colspan=5 style="text-align: center; border-bottom: 1px solid black;">Support</th>' skip.

    do li-other = 1 to num-entries(lc-other-code,"|"):
        {&prince}
            '<th>&nbsp;</th>'.
    end.
    {&prince}
            '</tr>'
            '<tr>'
                '<th>Account</th>'
                '<th>Name</th>'
                '<th style="text-align: right;">Brought Forward</th>'
                '<th style="text-align: right;">Opened This Period</th>'
                '<th style="text-align: right;">Closed This Period</th>'
                '<th style="text-align: right;">Carried Forward</th>'
                '<th style="text-align: right;">Time Spent<br>(Hours:Mins)</th>'.
    do li-other = 1 to num-entries(lc-other-code,"|"):
        {&prince}
            '<th style="text-align: right;">' pxml-safe(entry(li-other,lc-other-desc,'|')) '<br>' pxml-safe("C/Forward") '</th>'.
    end.
    {&prince}
            '</tr>'
            '</thead>'
        skip.



    for each tt-mrep no-lock
        where tt-mrep.CatCode <> "SUPPORT":
        find b-rep 
            where b-rep.AccountNumber = tt-mrep.AccountNumber
              and b-rep.CatCode = "SUPPORT"
              no-lock no-error.
        if avail b-rep then next.
        create b-rep.
        assign b-rep.CatCode = "SUPPORT"
               b-rep.AccountNumber = tt-mrep.AccountNumber.

    end.
    for each tt-mrep no-lock
        where tt-mrep.CatCode = "SUPPORT":

        find customer where customer.companycode    = pc-companycode
                        and customer.AccountNumber  = tt-mrep.AccountNumber no-lock no-error.

        {&prince} 
            '<tr>'
                '<td>' tt-mrep.AccountNumber '</td>'
                '<td>' pxml-safe(if avail customer then customer.name else "") '</td>'
                '<td style="text-align: right;">' tt-mrep.Bfwd '</td>'
                '<td style="text-align: right;">' tt-mrep.OpenPer '</td>'
                '<td style="text-align: right;">' tt-mrep.ClosePer '</td>'
                '<td style="text-align: right;">' tt-mrep.OutSt '</td>'
                '<td style="text-align: right;">' com-TimeToString(tt-mrep.Duration) '</td>'
                
                .

        do li-other = 1 to num-entries(lc-other-code,"|"):
            assign
                li-temp = 0.
            
            find b-rep where b-rep.AccountNumber = tt-mrep.AccountNumber
                         and b-rep.CatCode       = entry(li-other,lc-other-Code,'|')
                         no-lock no-error.
            if avail b-rep
            then assign li-temp = b-rep.OutSt.

            {&prince}
                '<td style="text-align: right;">' li-temp '</td>'.

            assign
                li-other-total[li-other] = li-other-total[li-other] + li-temp.
        end.
        {&prince} 
            '</tr>'.

        assign
            lf-bfwd         = lf-bfwd + tt-mrep.bfwd
            lf-openper      = lf-openper + tt-mrep.openper
            lf-closeper     = lf-closeper + tt-mrep.closeper
            lf-outst        = lf-outst + tt-mrep.outst
            lf-duration     = lf-duration + tt-mrep.duration.

    end.
    
    

    {&prince}
        '<tfoot>'
        '<tr>'
            '<th colspan="2" style="background-color: none; border-top: 1px solid black;">Total</th>'
            '<th style="text-align: right; border-top: 1px solid black;">' lf-Bfwd '</th>'
            '<th style="text-align: right; border-top: 1px solid black;">' lf-OpenPer '</th>'
            '<th style="text-align: right; border-top: 1px solid black;">' lf-ClosePer '</th>'
            '<th style="text-align: right; border-top: 1px solid black;">' lf-OutSt '</th>'
            '<th style="text-align: right; border-top: 1px solid black;">' com-TimeToString(lf-Duration) '</th>'.
    do li-other = 1 to num-entries(lc-other-code,"|"):
        {&prince}
            '<th style="text-align: right; border-top: 1px solid black;">' li-other-total[li-other] '</th>'.
    end.
    {&prince}
        '</tr>'
        '</tfoot>' skip.

    {&prince} 
        '</table>'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

