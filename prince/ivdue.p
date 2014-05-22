&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        prince/ivdue.p
    
    Purpose:        Customer Inventory - Prince Report
    
    Notes:
    
    
    When        Who         What
    10/07/2006  phoski      Initial
***********************************************************************/
                                          
{lib/htmlib.i}
{lib/princexml.i}


&IF DEFINED(UIB_is_Running) EQ 0 &THEN

def input param pc-user             as char no-undo.
def input param pc-CompanyCode      as char no-undo.
def input param pd-lodate           as date no-undo.
def input param pd-hidate           as date  no-undo.
def output param pc-pdf             as char no-undo.

&ELSE

def var pc-user                    as char no-undo.
def var pc-CompanyCode             as char no-undo.
def var pd-lodate                    as date no-undo.
def var pd-hidate                    as date  no-undo.
def var pc-pdf                     as char no-undo.

assign pc-CompanyCode = "MICAR"
       pd-lodate        = today - 100
       pd-hidate        = today + 100.


&ENDIF



def var lc-html         as char     no-undo.
def var lc-pdf          as char     no-undo.
def var ll-ok           as log      no-undo.
def var li-ReportNumber as int      no-undo.


{prince/ivdue.i}

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
    lc-html = session:temp-dir + caps(pc-CompanyCode) + "-ivDue-" + string(li-ReportNumber).

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

RUN ip-BuildTT.
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

&IF DEFINED(EXCLUDE-ip-BuildTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildTT Procedure 
PROCEDURE ip-BuildTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var ld-date     as date         no-undo.

    for each ivField no-lock
        where ivField.dType = "date"
          and ivField.dWarning > 0,
          first ivSub of ivField no-lock:

        if ivSub.Company <> pc-CompanyCode then next.

        
        for each CustField no-lock
            where CustField.ivFieldID = ivField.ivFieldID:

            
            if custField.FieldData = "" 
            or custField.FieldData = ? then next.

            assign
                ld-date = date(custfield.FieldData) no-error.
            if error-status:error 
            or ld-date = ? then next.

            
            if ld-date < pd-lodate
            or ld-date > pd-hidate then next.
            

            find CustIV 
                where custIV.custIvID = custField.custIvID no-lock no-error.
            if not avail custIV then next.
           
            find customer 
                where customer.CompanyCode = pc-CompanyCode
                  and customer.AccountNumber = custIv.AccountNumber no-lock no-error.
            if not avail customer then next.

            create tt.
            assign
                tt.CustFieldRow     = rowid(CustField)
                tt.ivFieldRow       = rowid(ivField)
                tt.ivDate           = ld-date
                tt.AccountNumber    = customer.AccountNumber
                tt.name             = customer.name
                tt.Ref              = custiv.Ref
                tt.dLabel           = ivField.dLabel
                .


        end.

       
            
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Print) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Print Procedure 
PROCEDURE ip-Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  
  {&prince}
      '<p style="text-align: center; font-size: 14px; font-weight: 900;">Customer Inventory Due Report - '
      'From ' string(pd-lodate,"99/99/9999")
      ' To ' string(pd-hidate,"99/99/9999") 
      
      '</div>'.


    {&prince}
        '<table class="landrep">'
            '<thead>'
            '<tr>'
                '<th>Account</th>'
                '<th>Name</th>'
                '<th>Reference</th>'
                '<th>Field</th>'
                '<th>Renewal</th>'
                
            '</tr>'
            '</thead>'
        skip.


    for each tt no-lock:

        {&prince} 
            '<tr>'
                '<td>' pxml-safe(tt.AccountNumber) '</td>'
                '<td>' pxml-safe(tt.name) '</td>'
                '<td>' pxml-safe(tt.Ref)  '</td>'
                '<td>' pxml-safe(tt.dLabel)  '</td>'
                '<td>' string(tt.ivDate,"99/99/9999") '</td>'
                '</tr>' skip
                .

    end.

    {&prince} 
        '</table>'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

