&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************

    Program:        lib/htmlib.i
    
    Purpose:        Standard HTML
    
    Notes:
    
    
    When        Who         What
    06/04/2006  phoski      DYNAMIC-FUNCTION('htmlib-ExpandBox':U)
    08/04/2006  phoski      DYNAMIC-FUNCTION('htmlib-Header':U),
                            strict doc type
    

    02/09/2010  DJS         3674 - Added function for Document Quickview
                              toolbar buttons
                              
    13/09/2010  DJS         3708  Added Calendar Input Field Submit                              
    
***********************************************************************/

{lib/common.i}
{lib/toolbar.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-AcrobatReport Include 
FUNCTION htmlib-AcrobatReport RETURNS CHARACTER
 ( pc-url as char
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-ActionHidden Include 
FUNCTION htmlib-ActionHidden RETURNS CHARACTER
  ( pc-value as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-AddLink Include 
FUNCTION htmlib-AddLink RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-ALookup Include 
FUNCTION htmlib-ALookup RETURNS CHARACTER
  ( pc-field-name as char,
    pc-desc-name as char,
    pc-program as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-AnswerHyperLink Include 
FUNCTION htmlib-AnswerHyperLink RETURNS CHARACTER
  (INPUT pc-FieldName AS CHARACTER,
   INPUT pc-Value AS CHARACTER,
   input pc-descfield as char,
   input pc-descvalue as char,
   INPUT pc-Description AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-BeginCriteria Include 
FUNCTION htmlib-BeginCriteria RETURNS CHARACTER
  ( pc-legend as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-BlankTableLines Include 
FUNCTION htmlib-BlankTableLines RETURNS CHARACTER
  ( pi-lines as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Button Include 
FUNCTION htmlib-Button RETURNS CHARACTER
  ( 
    pc-name as char,
    pc-value as char,
    pc-param as char
   ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-CalendarInclude Include 
FUNCTION htmlib-CalendarInclude RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-CalendarInputField Include 
FUNCTION htmlib-CalendarInputField RETURNS CHARACTER
  ( pc-name as char,
    pi-size as int,
    pc-value as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-CalendarLink Include 
FUNCTION htmlib-CalendarLink RETURNS CHARACTER
  ( pc-name as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-CalendarScript Include 
FUNCTION htmlib-CalendarScript RETURNS CHARACTER
  ( pc-name as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-CheckBox Include 
FUNCTION htmlib-CheckBox RETURNS CHARACTER
    ( pc-name as char,
      pl-checked as log
     )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-CloseHeader Include 
FUNCTION htmlib-CloseHeader RETURNS CHARACTER
  ( params as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-CustomerDocs Include 
FUNCTION htmlib-CustomerDocs RETURNS CHARACTER
( pc-companyCode as char,
    pc-AccountNumber as char,  
    pc-appurl as char , 
    pl-isCustomer AS LOG

 )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-CustomerViewable Include 
FUNCTION htmlib-CustomerViewable RETURNS CHARACTER
  ( pc-companyCode as char,
    pc-AccountNumber as char
 )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-DecodeUser Include 
FUNCTION htmlib-DecodeUser RETURNS CHARACTER
  ( pc-value as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-EncodeUser Include 
FUNCTION htmlib-EncodeUser RETURNS CHARACTER
  ( pc-user as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-EndCriteria Include 
FUNCTION htmlib-EndCriteria RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-EndFieldSet Include 
FUNCTION htmlib-EndFieldSet RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-EndForm Include 
FUNCTION htmlib-EndForm RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-EndPanel Include 
FUNCTION htmlib-EndPanel RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-EndTable Include 
FUNCTION htmlib-EndTable RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-ErrorMessage Include 
FUNCTION htmlib-ErrorMessage RETURNS CHARACTER
   ( pc-error as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-ExpandBox Include 
FUNCTION htmlib-ExpandBox RETURNS CHARACTER
  ( pc-objectID as char,
    pc-Data     as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Footer Include 
FUNCTION htmlib-Footer RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-GenPassword Include 
FUNCTION htmlib-GenPassword RETURNS CHARACTER
  ( pi-Length as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-GetAttr Include 
FUNCTION htmlib-GetAttr RETURNS CHARACTER
  ( pc-systemid as char,
    pc-attrid   as char
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Header Include 
FUNCTION htmlib-Header RETURNS CHARACTER
  ( pc-title as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-HelpButton Include 
FUNCTION htmlib-HelpButton RETURNS CHARACTER
  ( pc-appurl as char,
    pc-program as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Hidden Include 
FUNCTION htmlib-Hidden RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-ImageLink Include 
FUNCTION htmlib-ImageLink RETURNS CHARACTER
  ( 
    pc-image as char,
    pc-url as char,
    pc-alt as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-InputField Include 
FUNCTION htmlib-InputField RETURNS CHARACTER
  ( pc-name as char,
    pi-size as int,
    pc-value as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-InputPassword Include 
FUNCTION htmlib-InputPassword RETURNS CHARACTER
  ( pc-name as char,
    pi-size as int,
    pc-value as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Jscript-Lookup Include 
FUNCTION htmlib-Jscript-Lookup RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-JScript-Maintenance Include 
FUNCTION htmlib-JScript-Maintenance RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-JScript-Spinner Include 
FUNCTION htmlib-JScript-Spinner RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Lookup Include 
FUNCTION htmlib-Lookup RETURNS CHARACTER
  ( pc-label as char ,
    pc-field-name as char,
    pc-desc-name as char,
    pc-program as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-LookupAction Include 
FUNCTION htmlib-LookupAction RETURNS CHARACTER
  ( pc-url as char,
    pc-action as char,
    pc-label as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-mBanner Include 
FUNCTION htmlib-mBanner RETURNS CHARACTER
  ( pc-companyCode as CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-MntButton Include 
FUNCTION htmlib-MntButton RETURNS CHARACTER
  ( pc-url as char,
    pc-action as char,
    pc-label as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-MntLink Include 
FUNCTION htmlib-MntLink RETURNS CHARACTER
  ( pc-mode as char,
    pr-rowid as rowid,
    pc-url as char,
    pc-other-params as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-MntTableField Include 
FUNCTION htmlib-MntTableField RETURNS CHARACTER
    ( pc-data as char,
      pc-align as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-MntTableFieldComplex Include 
FUNCTION htmlib-MntTableFieldComplex RETURNS CHARACTER
    ( pc-data as char,
      pc-align as char,
      pi-cols as int,
      pi-rows as int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-MultiplyErrorMessage Include 
FUNCTION htmlib-MultiplyErrorMessage RETURNS CHARACTER
  ( pc-error as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-NexusParam Include 
FUNCTION htmlib-NexusParam RETURNS CHARACTER
  ( pc-param as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-NormalTextLink Include 
FUNCTION htmlib-NormalTextLink RETURNS CHARACTER
    ( pc-text as char,
    pc-url  as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Null Include 
FUNCTION htmlib-Null RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-OpenHeader Include 
FUNCTION htmlib-OpenHeader RETURNS CHARACTER
  ( pc-title as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-ProgramTitle Include 
FUNCTION htmlib-ProgramTitle RETURNS CHARACTER
  ( pc-title as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Radio Include 
FUNCTION htmlib-Radio RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char,
    pl-checked as log
     )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-RandomURL Include 
FUNCTION htmlib-RandomURL RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-ReportButton Include 
FUNCTION htmlib-ReportButton RETURNS CHARACTER
  ( pc-url as char
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Select Include 
FUNCTION htmlib-Select RETURNS CHARACTER
  ( pc-name as char ,
    pc-value as char ,
    pc-display as char,
    pc-selected as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-Select-By-ID Include 
FUNCTION htmlib-Select-By-ID RETURNS CHARACTER
  ( pc-name as char ,
    pc-value as char ,
    pc-display as char,
    pc-selected as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-SelectJS Include 
FUNCTION htmlib-SelectJS RETURNS CHARACTER
  ( pc-name as char ,
    pc-js  AS CHAR,
    pc-value as char ,
    pc-display as char,
    pc-selected as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-SideLabel Include 
FUNCTION htmlib-SideLabel RETURNS CHARACTER
  ( pc-Label as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-SideLabelError Include 
FUNCTION htmlib-SideLabelError RETURNS CHARACTER
  ( pc-Label as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-SimpleBackButton Include 
FUNCTION htmlib-SimpleBackButton RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-SimpleExpandBox Include 
FUNCTION htmlib-SimpleExpandBox RETURNS CHARACTER
  ( pc-objectID as char,
    pc-Data     as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-StartFieldSet Include 
FUNCTION htmlib-StartFieldSet RETURNS CHARACTER
  ( pc-legend as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-StartForm Include 
FUNCTION htmlib-StartForm RETURNS CHARACTER
  ( pc-name as char ,
    pc-method as char,
    pc-action as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-StartInputTable Include 
FUNCTION htmlib-StartInputTable RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-StartMntTable Include 
FUNCTION htmlib-StartMntTable RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-StartPanel Include 
FUNCTION htmlib-StartPanel RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-StartTable Include 
FUNCTION htmlib-StartTable RETURNS CHARACTER
  ( pc-name as char,
    pi-width as int,
    pi-border as int,
    pi-padding as int,
    pi-spacing as int,
    pc-align as char
     )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-StyleSheet Include 
FUNCTION htmlib-StyleSheet RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-SubmitButton Include 
FUNCTION htmlib-SubmitButton RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char 
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-TableField Include 
FUNCTION htmlib-TableField RETURNS CHARACTER
  ( pc-data as char,
    pc-align as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-TableHeading Include 
FUNCTION htmlib-TableHeading RETURNS CHARACTER
  ( pc-param as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-TextArea Include 
FUNCTION htmlib-TextArea RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char,
    pi-rows as int,
    pi-cols as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-TextLink Include 
FUNCTION htmlib-TextLink RETURNS CHARACTER
  ( pc-text as char,
    pc-url  as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-TimeSelect Include 
FUNCTION htmlib-TimeSelect RETURNS CHARACTER
  ( pc-hour-name    as char,
    pc-hour-value   as char,
    pc-min-name     as char,
    pc-min-value    as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-TimeSelect-By-Id Include 
FUNCTION htmlib-TimeSelect-By-Id RETURNS CHARACTER
  ( pc-hour-name    as char,
    pc-hour-value   as char,
    pc-min-name     as char,
    pc-min-value    as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-trmouse Include 
FUNCTION htmlib-trmouse RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE htmlib-AddErrorMessage Include 
PROCEDURE htmlib-AddErrorMessage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-field        as char no-undo.
    def input param pc-message      as char no-undo.

    def input-output param pc-field-list  as char no-undo.
    def input-output param pc-mess-list   as char no-undo.

    if pc-field-list = ""
    or pc-field-list = ""
    then assign pc-field-list = pc-field
                pc-mess-list  = pc-message.
    else assign pc-field-list = pc-field-list + '|' + pc-field
                pc-mess-list  = pc-mess-list + '|' + pc-message.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-AcrobatReport Include 
FUNCTION htmlib-AcrobatReport RETURNS CHARACTER
 ( pc-url as char
  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return  substitute(
            '<a class="imglink" onclick="RepWindow(~'&1~')"><img src="/images/general/acrobat.gif"></a>',
            pc-url).
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-ActionHidden Include 
FUNCTION htmlib-ActionHidden RETURNS CHARACTER
  ( pc-value as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return htmlib-Hidden("action", pc-value).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-AddLink Include 
FUNCTION htmlib-AddLink RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
/*
 return substitute('<a href="&2">&1</a>',
                      pc-text,
                      pc-url ).
*/
  
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-ALookup Include 
FUNCTION htmlib-ALookup RETURNS CHARACTER
  ( pc-field-name as char,
    pc-desc-name as char,
    pc-program as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    def var lc-htm      as char no-undo.
    def var lc-click    as char no-undo.

    assign
        lc-click = 
        'javascript:LookupWindow('
            + '~'' + pc-program + '~','
            + '~'' + pc-field-name + '~','
            + '~'' + pc-desc-name + '~''

        + ')'.
    assign 
        lc-htm = 
        '<a href="' 
            + lc-click +
            '">' +
        '<img src="/images/general/lookup.gif" border=0 align="middle" alt="Lookup">' +
        '</a>'
        .
    
   
    return lc-htm.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-AnswerHyperLink Include 
FUNCTION htmlib-AnswerHyperLink RETURNS CHARACTER
  (INPUT pc-FieldName AS CHARACTER,
   INPUT pc-Value AS CHARACTER,
   input pc-descfield as char,
   input pc-descvalue as char,
   INPUT pc-Description AS CHARACTER):


    RETURN "<a href=~"#~""
       + " onclick=~'javascript:opener.document.forms[0]." 
       + pc-FieldName + ".value=~"" + pc-Value + 
       "~";opener.document.forms[0]."
       + pc-descfield + ".value=~"" + pc-descvalue + 
       "~";" +
       "opener.document.forms[0]." 
       + pc-FieldName + ".focus();"
       +
       "opener.document.forms[0]." 
       + pc-FieldName + ".blur();"
       +
       "window.close();~'>" 
       + pc-Description + "</a> <br>".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-BeginCriteria Include 
FUNCTION htmlib-BeginCriteria RETURNS CHARACTER
  ( pc-legend as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if pc-legend <> ""
    then return '<div class="crit"><fieldset><legend>' + 
        dynamic-function("html-encode",pc-legend) + '</legend>'.
    else return '<div class="crit"><fieldset>'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-BlankTableLines Include 
FUNCTION htmlib-BlankTableLines RETURNS CHARACTER
  ( pi-lines as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-char as char no-undo.

  assign lc-char = '<tr>' + htmlib-TableField("&nbsp;",'left') + '</tr>'.

  if pi-lines > 0 then
  RETURN fill(lc-char,pi-lines).   /* Function return value. */
  else return "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Button Include 
FUNCTION htmlib-Button RETURNS CHARACTER
  ( 
    pc-name as char,
    pc-value as char,
    pc-param as char
   ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RETURN substitute('<input onclick="SubmitThePage(~'&3~')" class="submitbutton" type="button" name="&1" value="&2">',
                    pc-name,
                    pc-value,
                    pc-param).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-CalendarInclude Include 
FUNCTION htmlib-CalendarInclude RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN '~n' + 
          '<link rel="stylesheet" href="/scripts/cal/calendar-blue.css?fn="' + string(time) + string(random(1,100)) + '" type="text/css" >' + '~n' +
          '<script type="text/javascript" src="/scripts/cal/calendar.js"></script>' + '~n' + 
          '<script type="text/javascript" src="/scripts/cal/lang/calendar-en.js"></script>' + '~n' + 
          '<script type="text/javascript" src="/scripts/cal/calendar-setup.js"></script>' + '~n'.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-CalendarInputField Include 
FUNCTION htmlib-CalendarInputField RETURNS CHARACTER
  ( pc-name as char,
    pi-size as int,
    pc-value as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
        substitute(
            '<input class="inputfield" type="text" name="&1" id="ff&1" size="&2" value="&3" onChange="ChangeDates()">',
            pc-name,
            string(pi-size),
            pc-value).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-CalendarLink Include 
FUNCTION htmlib-CalendarLink RETURNS CHARACTER
  ( pc-name as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
      substitute('<img src="/images/general/calendar.gif" id="trigger-ff&1" class="calimg">',
                 pc-name).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-CalendarScript Include 
FUNCTION htmlib-CalendarScript RETURNS CHARACTER
  ( pc-name as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  
    return 
        
            '<script type="text/javascript">' + '~n' +
            'Calendar.setup(' + '~n' +
            '~{' + '~n' +
            'inputField  : "ff' + pc-name + '",' + '~n' +
            'ifFormat    : "%d/%m/%Y",' + '~n' +
            'button      : "trigger-ff' + pc-name + '",' + '~n' +
            'firstDay : 1 ,' + '~n' +
            'electric : false ' + '~n' +          /* if true (default) then given fields/date areas are updated for each move; otherwise they're updated only on close */
/*             'singleClick : false ' + '~n' + */ /* (true/false) wether the calendar is in single click mode or not (default: true) */
            '~}' + '~n' +
            ');' + '~n' +
            '</script>' + '~n'.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-CheckBox Include 
FUNCTION htmlib-CheckBox RETURNS CHARACTER
    ( pc-name as char,
      pl-checked as log
     ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/

    def var lc-checked as char no-undo.

    if pl-checked
    then assign lc-checked = 'checked'.

    RETURN 
          substitute(
              '<input class="inputfield" type="checkbox" id="&1" name="&1" &2 >',
              pc-name,
              lc-checked).
              

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-CloseHeader Include 
FUNCTION htmlib-CloseHeader RETURNS CHARACTER
  ( params as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var lc-header     as char no-undo.
  def var lc-return     as char no-undo.
  
  if params <> "" then
  assign
      lc-return = lc-return + '~n</HEAD>' + '<body class="normaltext" onUnload="ClosePage()" onLoad="' + params + '">'.
  else
  assign
      lc-return = lc-return + '~n</HEAD>' + '<body class="normaltext" onUnload="ClosePage()">'.

  return lc-return.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-CustomerDocs Include 
FUNCTION htmlib-CustomerDocs RETURNS CHARACTER
( pc-companyCode as char,
    pc-AccountNumber as char,  
    pc-appurl as char , 
    pl-isCustomer AS LOG

 ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Customer for Customer.
    def var btnLink     as char   no-undo.
    def var vx          as int    no-undo.
    def var lc-return as char       no-undo.
    
    find customer
    where customer.CompanyCode = pc-CompanyCode
    and customer.AccountNumber = pc-AccountNumber no-lock no-error.
    
    if not avail customer then return "".
    
    
    assign lc-return = '<div class="buttonbox" >'.
    
    
    for each doch no-lock
        where doch.CompanyCode = lc-global-company
        and doch.RelType       = "customer"
        and doch.RelKey        = customer.AccountNumber
        and doch.QuickView     = true
        by doch.CreateDate DESC
        :
        
        IF pl-isCustomer AND doch.CustomerView = FALSE THEN NEXT.
        
    
        vx = vx + 1.
        if vx > 3 then leave.
      
        btnLink = 'javascript:OpenNewWindow('
              + '~'' + pc-appurl
              + '/sys/docview.' + lc(doch.doctype) + '?docid=' + string(doch.docid)
              + '~''
              + ');'.
        lc-return = lc-return + '<a class="button" href="' + btnLink 
                            + '" onclick="this.blur();"><span> &nbsp;&nbsp; ' 
                            + trim(doch.descr) + '</span></a>' .   
    
    end.
    assign lc-return = lc-return + '</div>'.
    
    if vx = 0 then return "". 
    else return lc-return.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-CustomerViewable Include 
FUNCTION htmlib-CustomerViewable RETURNS CHARACTER
  ( pc-companyCode as char,
    pc-AccountNumber as char
 ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Customer for Customer.

    def var lc-return as char       no-undo.

    find customer
        where customer.CompanyCode = pc-CompanyCode
          and customer.AccountNumber = pc-AccountNumber no-lock no-error.


    if not avail customer then return "".


    assign 
        lc-return = '<div class="infobox" style="font-size: 10px;">'.

    if not customer.ViewAction then
    do:
        assign lc-return = lc-return + "This customer can NOT view Actions/Activities".
    end.
    else
    do:
        if not customer.ViewActivity 
        then assign lc-return = lc-return + "This customer can view Actions only, Activities are not shown".
        else assign lc-return = lc-return + "<span style='color: red;'>This customer can view Actions AND Activities</span>".
    end.

    assign 
        lc-return = lc-return + '</div>'.


    return lc-return.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-DecodeUser Include 
FUNCTION htmlib-DecodeUser RETURNS CHARACTER
  ( pc-value as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-part1 as char no-undo.
    def var lc-part2 as char no-undo.
    def var lc-part3 as char no-undo.
    DEF VAR lc-part4 AS CHAR NO-UNDO.
    def var lr-rowid as rowid no-undo.
    DEF VAR lc-remote AS CHAR   NO-UNDO.
    
    def buffer b-webuser for webuser.

    if num-entries(pc-value,':') <> 4 then return "".

    
    assign lc-part1 = entry(1,pc-value,':')
           lc-part2 = entry(2,pc-value,':')
           lc-part3 = entry(3,pc-value,':')
           lc-part4 = ENTRY(4,pc-value,":").


    assign lr-rowid = to-rowid(lc-part2) no-error.
    if error-status:error then return "".
 
    find b-webuser where rowid(b-webuser) = lr-rowid no-lock no-error.
    if not avail b-webuser 
    then return "".


    if lc-part1 <> encode(lc(b-webuser.loginid)) 
    then return "".

    if lc-part3 <> encode('ExtraInfo')
    then return "".

    /*
    IF lc-part4 <> ENCODE(lc-remote) THEN
    DO:
        MESSAGE "Remote Addr changed".
        RETURN "".
    END.
    */

    return b-webuser.loginid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-EncodeUser Include 
FUNCTION htmlib-EncodeUser RETURNS CHARACTER
  ( pc-user as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-code as char no-undo.
    def buffer b-web for webuser.
    DEF VAR lc-remote AS CHAR   NO-UNDO.
    
    find b-web where b-web.loginid = pc-user no-lock no-error.

    if avail b-web 
    then assign lc-code = encode(lc(pc-user)) +
                        ':' +
                        string(rowid(b-web)) + 
                        ':' + 
                        encode('ExtraInfo') +
                        ":" + 
                        ENCODE(lc-remote).
   
    
    RETURN lc-code.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-EndCriteria Include 
FUNCTION htmlib-EndCriteria RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN '</fieldset></div>'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-EndFieldSet Include 
FUNCTION htmlib-EndFieldSet RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  return '</fieldset></span>'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-EndForm Include 
FUNCTION htmlib-EndForm RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
      '</fieldset></span></form>'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-EndPanel Include 
FUNCTION htmlib-EndPanel RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

   RETURN "</table>".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-EndTable Include 
FUNCTION htmlib-EndTable RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RETURN '</table>'.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-ErrorMessage Include 
FUNCTION htmlib-ErrorMessage RETURNS CHARACTER
   ( pc-error as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  
    assign pc-error = '<span class="errormessage">' + pc-error + '</span>'.

      
    return pc-error.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-ExpandBox Include 
FUNCTION htmlib-ExpandBox RETURNS CHARACTER
  ( pc-objectID as char,
    pc-Data     as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-dummy-return as char initial "MYXXX111PPP2222"   no-undo.


    def var lc-return           as char     no-undo.

    assign lc-return = 
        '<div class="expandboxc" id="' + pc-objectID +
         '" style="display: none;"><fieldset><legend>Details</legend>'.
    
    assign lc-return = lc-return + 
        replace(
            dynamic-function("html-encode",replace(pc-data,"~n",lc-dummy-return)),
                           lc-dummy-return,'<br/>').
       
    assign lc-return = lc-return + '</fieldset></div>'.

    return lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Footer Include 
FUNCTION htmlib-Footer RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "</BODY></HTML>".


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-GenPassword Include 
FUNCTION htmlib-GenPassword RETURNS CHARACTER
  ( pi-Length as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-const as char
        initial 'abcdefghijklmnopqrstuvwxyz0123456789'
        no-undo.

    def var lc-string as char no-undo.
    def var li-loop   as int  no-undo.
    def var lc-last   as char case-sensitive no-undo.
    def var lc-this   as char case-sensitive no-undo.
    def var lc-return as char no-undo.

    repeat:
        assign li-loop = random(0,etime).

        assign li-loop = random(1,length(lc-const)).

        assign lc-this = substr(lc-const,li-loop,1).

        if random(1,100) > 50
        then assign lc-this = caps(lc-this).

        if lc-this = lc-last then next.

        lc-last = lc-this.

        if lc-return = ""
        then lc-return = lc-this.
        else lc-return = lc-return + lc-this.

        if length(lc-return) = pi-length then leave.



    end.

    return lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-GetAttr Include 
FUNCTION htmlib-GetAttr RETURNS CHARACTER
  ( pc-systemid as char,
    pc-attrid   as char
    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer b-attr for webattr.
    def buffer webuser for webuser.

    if pc-attrid = "MNTNoLinesDown" and lc-global-user <> ""
    and can-find(webuser where webuser.loginid = lc-global-user no-lock) then
    do:
        find webuser where webuser.loginid = lc-global-user no-lock no-error.

        if webuser.recordsperpage > 0 
        then return string(webuser.recordsperpage).
    end.

    find b-attr where b-attr.systemid = pc-systemid
                  and b-attr.attrid   = pc-attrid no-lock no-error.

    return if avail b-attr
           then b-attr.attrvalue
           else "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Header Include 
FUNCTION htmlib-Header RETURNS CHARACTER
  ( pc-title as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-header     as char no-undo.
  def var lc-return     as char no-undo.

  def var ll-backbase       as log no-undo.


  if lookup("ip-HTM-Header",this-procedure:internal-entries) > 0 then
  do:
      run ip-HTM-Header in this-procedure 
          ( output lc-header ).
  end.

  assign 
      lc-return = 
         '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">' + '~n' +
         '<html>' +
         '<head>' +
         lc-header + 
         '<meta http-equiv="X-UA-Compatible" content="IE=7">' + '~n' +
         '<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7"/>' + '~n' +
         '<meta http-equiv="Cache-Control" content="No-Cache">' + '~n' +
         '<meta http-equiv="Pragma"        content="No-Cache">' + '~n' +
         '<meta http-equiv="Expires"       content="0">' + '~n' +
         '<title>' + pc-title + '</title>' +
         DYNAMIC-FUNCTION('htmlib-StyleSheet':U) +
         '<script type="text/javascript" src="/scripts/js/tabber.js"></script>' + '~n' +
         '<link rel="stylesheet" href="/style/tab.css" TYPE="text/css" MEDIA="screen">' + '~n' +
         '<script language="JavaScript" src="/scripts/js/standard.js"></script>' + '~n'.
   
  

  if lookup("ip-HeaderInclude-Calendar",this-procedure:internal-entries) > 0 then
  do:
      assign lc-return = lc-return + DYNAMIC-FUNCTION('htmlib-CalendarInclude':U).
          
  end.

    assign
      lc-return = lc-return + '~n</HEAD>' + '<body class="normaltext" onUnload="ClosePage()">'
        .

  return lc-return.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-HelpButton Include 
FUNCTION htmlib-HelpButton RETURNS CHARACTER
  ( pc-appurl as char,
    pc-program as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-url as char no-undo.

    def buffer b-attr for webattr.

    return "".
    /*
    find b-attr 
          where b-attr.systemid = 'help'
            and b-attr.attrid   = pc-program
            no-lock no-error.
    if not avail b-attr then return "".
    if b-attr.attrvalue = '' then return ''.

    assign lc-url = pc-appurl + '/mn/help.p?rowid=' + string(rowid(b-attr)).

    return  substitute(
            '<INPUT onclick="HelpWindow(~'&1~')" type=button class="actionbutton" value="Help">',
            lc-url).

  RETURN "".   /* Function return value. */
    */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Hidden Include 
FUNCTION htmlib-Hidden RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN 
        substitute(
            '<input  type="hidden" id="&1" name="&1" value="&2">',
            pc-name,
            pc-value).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-ImageLink Include 
FUNCTION htmlib-ImageLink RETURNS CHARACTER
  ( 
    pc-image as char,
    pc-url as char,
    pc-alt as char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return
        substitute(
        '<a href="&1"><img border="0" src="&2" alt="&3"></a>',
        pc-url,
        pc-image,
        pc-alt).
      

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-InputField Include 
FUNCTION htmlib-InputField RETURNS CHARACTER
  ( pc-name as char,
    pi-size as int,
    pc-value as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
        substitute(
            '<input class="inputfield" type="text" name="&1" id="ff&1" size="&2" value="&3">',
            pc-name,
            string(pi-size),
            pc-value).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-InputPassword Include 
FUNCTION htmlib-InputPassword RETURNS CHARACTER
  ( pc-name as char,
    pi-size as int,
    pc-value as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
        substitute(
            '<input class="inputfield" type="password" name="&1" size="&2" value="&3">',
            pc-name,
            string(pi-size),
            pc-value).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Jscript-Lookup Include 
FUNCTION htmlib-Jscript-Lookup RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN '<script language="JavaScript" src="/scripts/js/lookup.js"></script>'.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-JScript-Maintenance Include 
FUNCTION htmlib-JScript-Maintenance RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN '<script language="JavaScript" src="/scripts/js/maint.js"></script>'.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-JScript-Spinner Include 
FUNCTION htmlib-JScript-Spinner RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN '~n' +
         '<link rel="stylesheet" href="/style/spinner.css?fn="' + string(time) + string(random(1,100)) + '" type="text/css" >' + '~n' +
         '<script language="JavaScript" src="/scripts/js/spinner.js"></script>'. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Lookup Include 
FUNCTION htmlib-Lookup RETURNS CHARACTER
  ( pc-label as char ,
    pc-field-name as char,
    pc-desc-name as char,
    pc-program as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    

    return DYNAMIC-FUNCTION('htmlib-ALookup':U,
                            pc-field-name,
                            pc-desc-name,
                            pc-program).
/*
    def var lc-htm as char no-undo.

    assign lc-htm = "<input class=~"actionbutton~" type=~"button~" name=~"Submit2~" value=~"&4~" "
                    + " onclick=~"javascript:window.open(~'" 
                    + "&3" + "?FieldName=" + "&1"
                    + '£Description=' + "&2"
                    + "~',"
                    + "~'LookupWindow~',~'scrollbars=yes,width=700,height=500~')~">".

    return replace(substitute(lc-htm,
                      pc-field-name,
                      pc-desc-name,
                      pc-program ,
                      pc-label),'£','&').
  
*/
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-LookupAction Include 
FUNCTION htmlib-LookupAction RETURNS CHARACTER
  ( pc-url as char,
    pc-action as char,
    pc-label as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return  substitute(
            '<INPUT onclick="LookupButtonPress(~'&1~',~'&2~')" type=button class="actionbutton" value="&3">',
            pc-action,
            pc-url,
            pc-label).
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-mBanner Include 
FUNCTION htmlib-mBanner RETURNS CHARACTER
  ( pc-companyCode as CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF BUFFER company  FOR company.


    FIND company WHERE company.companycode = pc-companycode NO-LOCK NO-ERROR.

    RETURN IF AVAIL company THEN trim(company.mBanner) ELSE "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-MntButton Include 
FUNCTION htmlib-MntButton RETURNS CHARACTER
  ( pc-url as char,
    pc-action as char,
    pc-label as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if pc-action = "prevpage" 
    then return 
            '<a href="javascript:MntButtonPress(~'' + pc-action + '~',~'' + pc-url + '~')">'
            + '<img src="/images/toolbar/prev.gif" border=0 alt="Previous Page"></a>'
            .
    else
    if pc-action = "nextpage" 
    then return 
            '<a href="javascript:MntButtonPress(~'' + pc-action + '~',~'' + pc-url + '~')">'
            + '<img src="/images/toolbar/next.gif" border=0 alt="Next Page"></a>'
            .
    else
    if pc-action = "firstpage" 
    then return 
            '<a href="javascript:MntButtonPress(~'' + pc-action + '~',~'' + pc-url + '~')">'
            + '<img src="/images/toolbar/begin.gif" border=0 alt="First Page"></a>'
            .
    else
    if pc-action = "lastpage" 
    then return 
            '<a href="javascript:MntButtonPress(~'' + pc-action + '~',~'' + pc-url + '~')">'
            + '<img src="/images/toolbar/end.gif" border=0 alt="Last Page"></a>'
            .
    else return  substitute(
            '<INPUT onclick="MntButtonPress(~'&1~',~'&2~')" type=button class="actionbutton" value="&3">',
            pc-action,
            pc-url,
            pc-label).
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-MntLink Include 
FUNCTION htmlib-MntLink RETURNS CHARACTER
  ( pc-mode as char,
    pr-rowid as rowid,
    pc-url as char,
    pc-other-params as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-image as char no-undo.
    def var lc-alt-text as char no-undo.

    case pc-mode:
        when 'add':U
        then assign lc-image = '/images/maintenance/add.gif'
                    lc-alt-text = 'Add'.
        when 'delete':U
        then assign lc-image = '/images/maintenance/delete.gif'
                    lc-alt-text = 'Delete'.
        when 'update':U
        then assign lc-image = '/images/maintenance/update.gif'
                    lc-alt-text = 'Update'.
        when 'view':u
        then assign lc-image = '/images/maintenance/view.gif'
                    lc-alt-text = 'View'.
        when 'genpassword' 
        then assign lc-image = '/images/maintenance/lock.gif'
                    lc-alt-text = 'Generate password'.
        when "contaccess" 
        then assign lc-image = '/images/maintenance/contaccess.gif'
                    lc-alt-text = 'Contractor account access'.
        when "doclist" 
        then assign lc-image = '/images/maintenance/doclist.gif'
                    lc-alt-text = 'Documents'.
        when "eqsubclass"
        then assign lc-image = '/images/maintenance/eqsubedit.gif'
                    lc-alt-text = 'Inventory subclassifications'.
        when "customfield"
        then assign lc-image = '/images/maintenance/customfield.gif'
                    lc-alt-text = 'Define custom fields'.
        when "custequip"
        then assign lc-image = '/images/maintenance/custequip.gif'
                    lc-alt-text = 'Customer equipment'.
    end case.
    assign pc-url = pc-url + '?mode=' + pc-mode
                    + '&rowid=' + if pr-rowid = ? then "" else string(pr-rowid).
    if pc-other-params <> ""
    and pc-other-params <> ?
    then assign pc-url = pc-url + "&" + pc-other-params.


    return htmlib-ImageLink(lc-image,pc-url,
                             lc-alt-text).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-MntTableField Include 
FUNCTION htmlib-MntTableField RETURNS CHARACTER
    ( pc-data as char,
      pc-align as char) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/

      def var lc-return as char no-undo.

      /*
      assign lc-return = '<td class="mnttablefield" valign="top"'.
      */

      assign lc-return = '<td valign="top"'.

      if pc-data = ""
      then pc-data = "&nbsp;".

      if pc-align <> ""
      then lc-return = lc-return + ' align="' + pc-align + '">'.
      else lc-return = lc-return + '>'.

      assign lc-return = lc-return + pc-data + '</td>'.

      return lc-return.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-MntTableFieldComplex Include 
FUNCTION htmlib-MntTableFieldComplex RETURNS CHARACTER
    ( pc-data as char,
      pc-align as char,
      pi-cols as int,
      pi-rows as int) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/

      def var lc-return as char no-undo.

      /*
      assign lc-return = '<td class="mnttablefield" valign="top"'.
      */

      assign lc-return = '<td valign="top"'.

      if pi-cols > 1 then
      do:
          lc-return = lc-return + ' colspan="' + string(pi-cols) 
              + '" '.
        
      end.

      if pi-rows > 1 then
      do:
          lc-return = lc-return + ' rowspan="' + string(pi-rows) 
              + '" '.
          
      end.
      if pc-data = ""
      then pc-data = "&nbsp;".

      if pc-align <> ""
      then lc-return = lc-return + ' align="' + pc-align + '">'.
      else lc-return = lc-return + '>'.

      assign lc-return = lc-return + pc-data + '</td>'.

      return lc-return.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-MultiplyErrorMessage Include 
FUNCTION htmlib-MultiplyErrorMessage RETURNS CHARACTER
  ( pc-error as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-loop as int no-undo.
    def var lc-message as char no-undo.
    def var lc-line as char no-undo.
   
    if num-entries(pc-error,'|') > 0
    and pc-error <> "" then
    do:
    
        assign lc-message = '<p class="errormessage">'.
        
        do li-loop = 1 to num-entries(pc-error,'|'):

            if li-loop > 1
            then assign lc-message = lc-message + "<br>".

            assign lc-line = entry(li-loop,pc-error,'|').

            if lc-message = ""
            then lc-message = lc-line.
            else lc-message = lc-message + lc-line.

        end.
        assign 
            lc-message = lc-message + "</p>".
    end.
    return lc-message.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-NexusParam Include 
FUNCTION htmlib-NexusParam RETURNS CHARACTER
  ( pc-param as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-value as char no-undo.

  assign lc-value = htmlib-GetAttr("Nexus",pc-param).

  if lc-value = "" 
  then message 'Nexus missing ' pc-param.
  else lc-value = '<param name="' + pc-param + '" value="' +
            lc-value + '">'.

  RETURN lc-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-NormalTextLink Include 
FUNCTION htmlib-NormalTextLink RETURNS CHARACTER
    ( pc-text as char,
    pc-url  as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return substitute('<a href="&2">&1</a>',
                      pc-text,
                      pc-url ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Null Include 
FUNCTION htmlib-Null RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "AllHDDataAvail".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-OpenHeader Include 
FUNCTION htmlib-OpenHeader RETURNS CHARACTER
  ( pc-title as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-header     as char no-undo.
  def var lc-return     as char no-undo.

  def var ll-backbase       as log no-undo.


  if lookup("ip-HTM-Header",this-procedure:internal-entries) > 0 then
  do:
      run ip-HTM-Header in this-procedure 
          ( output lc-header ).
  end.

  assign 
      lc-return = 
         '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">' + '~n' +
         '<html>' +
         '<head>' +
         lc-header + 
         '<meta http-equiv="X-UA-Compatible" content="IE=7">' + '~n' +
         '<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7"/>' + '~n' +
         '<meta http-equiv="Cache-Control" content="No-Cache">' + '~n' +
         '<meta http-equiv="Pragma"        content="No-Cache">' + '~n' +
         '<meta http-equiv="Expires"       content="0">' + '~n' +
         '<title>' + pc-title + '</title>' +
         DYNAMIC-FUNCTION('htmlib-StyleSheet':U) +
         '<script type="text/javascript" src="/scripts/js/tabber.js"></script>' + '~n' +
         '<link rel="stylesheet" href="/style/tab.css" TYPE="text/css" MEDIA="screen">' + '~n' +
         '<script language="JavaScript" src="/scripts/js/standard.js"></script>' + '~n'.
   
  

  if lookup("ip-HeaderInclude-Calendar",this-procedure:internal-entries) > 0 then
  do:
      assign lc-return = lc-return + DYNAMIC-FUNCTION('htmlib-CalendarInclude':U).
          
  end.

 
  return lc-return.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-ProgramTitle Include 
FUNCTION htmlib-ProgramTitle RETURNS CHARACTER
  ( pc-title as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/



    RETURN '<div class="programtitle">' + pc-title + '</div><br>'.


  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Radio Include 
FUNCTION htmlib-Radio RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char,
    pl-checked as log
     ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/

    def var lc-checked as char no-undo.

    if pl-checked
    then assign lc-checked = 'checked'.

    RETURN 
          substitute(
              '<input class="inputfield" type="radio" id="&1" name="&1" value="&2" &3 >',
              pc-name,
              pc-value,
              lc-checked).
              


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-RandomURL Include 
FUNCTION htmlib-RandomURL RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
      "RanDomTimeValue=" + 
      string(int(today)) +
      string(time) +
      string(random(1,1000)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-ReportButton Include 
FUNCTION htmlib-ReportButton RETURNS CHARACTER
  ( pc-url as char
  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  
    return  substitute(
            '<a class="imglink" onclick="RepWindow(~'&1~')"><img src="/images/general/print.gif"></a>',
            pc-url).
    /*
    return  substitute(
            '<INPUT onclick="RepWindow(~'&1~')" type=button class="actionbutton" value="Report">',
            pc-url).

    */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Select Include 
FUNCTION htmlib-Select RETURNS CHARACTER
  ( pc-name as char ,
    pc-value as char ,
    pc-display as char,
    pc-selected as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-data as char no-undo.
  def var li-loop as int  no-undo.
  def var lc-value as char no-undo.
  def var lc-display as char no-undo.
  def var lc-selected as char no-undo.

  if pc-display = ""
  then pc-display = pc-value.

  assign lc-data = '<select class="inputfield" id="' + pc-name + '" name="' + pc-name + '">'.

  do li-loop = 1 to num-entries(pc-value,'|'):
      assign lc-value = entry(li-loop,pc-value,'|')
             lc-display = entry(li-loop,pc-display,'|').
      if lc-value = pc-selected 
      then lc-selected = 'selected'.
      else lc-selected = "".
      assign lc-data = lc-data + 
                       '<option ' +
                       lc-selected + 
                       ' value="' + 
                       lc-value + 
                       '">' + 
                       lc-display +
                       '</option>'.
  end.
  
  assign lc-data = lc-data + '</select>'.

  RETURN lc-data.

 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-Select-By-ID Include 
FUNCTION htmlib-Select-By-ID RETURNS CHARACTER
  ( pc-name as char ,
    pc-value as char ,
    pc-display as char,
    pc-selected as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-data as char no-undo.
  def var li-loop as int  no-undo.
  def var lc-value as char no-undo.
  def var lc-display as char no-undo.
  def var lc-selected as char no-undo.

  if pc-display = ""
  then pc-display = pc-value.

  assign lc-data = '<select class="inputfield" id="' + pc-name + '" name="' + pc-name + '">'.

  do li-loop = 1 to num-entries(pc-value,'|'):
      assign lc-value = entry(li-loop,pc-value,'|')
             lc-display = entry(li-loop,pc-display,'|').
      if lc-value = pc-selected 
      then lc-selected = 'selected'.
      else lc-selected = "".
      assign lc-data = lc-data + 
                       '<option ' +
                       lc-selected +
                       ' id="' +
                       pc-name +
                       lc-display +
                       '"' +
                       ' value="' + 
                       lc-value + 
                       '">' + 
                       lc-display +
                       '</option>'.
  end.
  
  assign lc-data = lc-data + '</select>'.

  RETURN lc-data.

  /*
  <select name="select">
  <option value="01">Paul</option>
  <option selected value="02">Paul2</option>
</select>
  */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-SelectJS Include 
FUNCTION htmlib-SelectJS RETURNS CHARACTER
  ( pc-name as char ,
    pc-js  AS CHAR,
    pc-value as char ,
    pc-display as char,
    pc-selected as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-data as char no-undo.
  def var li-loop as int  no-undo.
  def var lc-value as char no-undo.
  def var lc-display as char no-undo.
  def var lc-selected as char no-undo.

  if pc-display = ""
  then pc-display = pc-value.
/* onChange="ChangeAccount()"') */
  assign lc-data = '<select class="inputfield" id="' + pc-name + '" name="' + pc-name 
        + '" onChange="' + pc-js + '")>'.

  do li-loop = 1 to num-entries(pc-value,'|'):
      assign lc-value = entry(li-loop,pc-value,'|')
             lc-display = entry(li-loop,pc-display,'|').
      if lc-value = pc-selected 
      then lc-selected = 'selected'.
      else lc-selected = "".
      assign lc-data = lc-data + 
                       '<option ' +
                       lc-selected + 
                       ' value="' + 
                       lc-value + 
                       '">' + 
                       lc-display +
                       '</option>'.
  end.
  
  assign lc-data = lc-data + '</select>'.

  RETURN lc-data.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-SideLabel Include 
FUNCTION htmlib-SideLabel RETURNS CHARACTER
  ( pc-Label as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN substitute('<span class="sidelabel">&1:</span>',
                    pc-label).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-SideLabelError Include 
FUNCTION htmlib-SideLabelError RETURNS CHARACTER
  ( pc-Label as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN substitute('<span class="sidelabelerror">&1*:</span>',
                    pc-label).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-SimpleBackButton Include 
FUNCTION htmlib-SimpleBackButton RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


    return string('<a class="tlink" href="javascript:history.go(-1);">'
                      + dynamic-function("html-encode","<<") 
                      + '&nbsp;Back</a>' ).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-SimpleExpandBox Include 
FUNCTION htmlib-SimpleExpandBox RETURNS CHARACTER
  ( pc-objectID as char,
    pc-Data     as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-dummy-return as char initial "MYXXX111PPP2222"   no-undo.


    def var lc-return           as char     no-undo.

    assign lc-return = 
        '<div class="expandboxc" id="' + pc-objectID +
         '" style="display: none;">'.
    
    assign lc-return = lc-return + 
        replace(
            dynamic-function("html-encode",replace(pc-data,"~n",lc-dummy-return)),
                           lc-dummy-return,'<br/>').
       
    assign lc-return = lc-return + '</div>'.

    return lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-StartFieldSet Include 
FUNCTION htmlib-StartFieldSet RETURNS CHARACTER
  ( pc-legend as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if pc-legend = ""
    then return '<span class="inform"><fieldset>'.
    else return '<span class="inform"><fieldset><legend>' + 
            dynamic-function("html-encode",pc-legend) +
            '</legend>'.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-StartForm Include 
FUNCTION htmlib-StartForm RETURNS CHARACTER
  ( pc-name as char ,
    pc-method as char,
    pc-action as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
      substitute('<form name="&1" method="&2" action="&3">',
                 pc-name,
                 pc-method,
                 pc-action) + 
       '<span class="inform"><fieldset>'. 
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-StartInputTable Include 
FUNCTION htmlib-StartInputTable RETURNS CHARACTER:
  
  RETURN htmlib-StartTable(
            "mnt",
            0,
            0,
            0,
            0,
            "center").


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-StartMntTable Include 
FUNCTION htmlib-StartMntTable RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-table as char no-undo.
/*
pc-name as char,
    pi-width as int,
    pi-border as int,
    pi-padding as int,
    pi-spacing as int,
    pc-align as char
    */
  assign lc-table = replace(htmlib-StartTable(
            "mnt",
            100,
            0,
            0,
            0,
            "center"),'>',' class="tableback" >').

  return lc-table.
/* style="background-color: #E0E3E7;" */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-StartPanel Include 
FUNCTION htmlib-StartPanel RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN '<table class="buttonpanel" align="center" width="100%">'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-StartTable Include 
FUNCTION htmlib-StartTable RETURNS CHARACTER
  ( pc-name as char,
    pi-width as int,
    pi-border as int,
    pi-padding as int,
    pi-spacing as int,
    pc-align as char
     ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  
    def var lc-htm as char no-undo.

    assign lc-htm = '<table'.
   
    if pc-name <> ""
    then assign lc-htm = lc-htm + ' name="' + pc-name + '"'.

    if pi-width <> 0
    then assign lc-htm = lc-htm + ' width="' + string(pi-width) + '%"'.

    if pi-border <> 0
    then assign lc-htm = lc-htm + ' border="' + string(pi-border) + '"'.

   
    /* new */
    assign lc-htm = lc-htm + ' cellpadding="' + string(pi-padding) + '"'.
    
    
    assign lc-htm = lc-htm + ' cellspacing="' + string(pi-spacing) + '"'.



    if pc-align <> ""
    then assign lc-htm = lc-htm + ' align="' + pc-align + '"'.

    assign lc-htm = lc-htm + '>'.

    return lc-htm.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-StyleSheet Include 
FUNCTION htmlib-StyleSheet RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    return 
        
        replace(htmlib-GetAttr("system","stylesheet"),
                ".css",
                ".css?fn=" + string(time) + string(random(1,100))
                ).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-SubmitButton Include 
FUNCTION htmlib-SubmitButton RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char 
    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN substitute('<input class="submitbutton" type="submit" name="&1" value="&2">',
                    pc-name,
                    pc-value).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-TableField Include 
FUNCTION htmlib-TableField RETURNS CHARACTER
  ( pc-data as char,
    pc-align as char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-return as char no-undo.

    assign lc-return = '<td class="tablefield" valign="top"'.

    if pc-align <> ""
    then lc-return = lc-return + ' align="' + pc-align + '">'.
    else lc-return = lc-return + '>'.

    assign lc-return = lc-return + pc-data + '</td>'.

    return lc-return.




END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-TableHeading Include 
FUNCTION htmlib-TableHeading RETURNS CHARACTER
  ( pc-param as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    def var li-loop as int          no-undo.
    def var lc-entry as char        no-undo.
    def var lc-return as char       no-undo.
    def var lc-label as char        no-undo.
    def var lc-align as char        no-undo.
    def var lc-colspan as char      no-undo.


    /*
    assign lc-return = '<tr class="tableheading">'.


    do li-loop = 1 to num-entries(pc-param,'|'):
        assign lc-entry = entry(li-loop,pc-param,'|').

        assign lc-label = entry(1,lc-entry,'^')
               lc-align = ''.
        if num-entries(lc-entry,'^') > 1 
        then assign lc-align = ' align="' + entry(2,lc-entry,'^') + '"'.

        if li-loop = num-entries(pc-param,'|')
        then assign lc-colspan = " colspan='8'".
        else assign lc-colspan = "".
        
        assign lc-return = lc-return + '<td valign="bottom" ' + lc-align + lc-colspan + '>' + lc-label + '</td>'.
        

    end.

    assign lc-return = lc-return + '</tr>'.

    return lc-return.
    */

    assign lc-return = '<tr>'.


   do li-loop = 1 to num-entries(pc-param,'|'):
       assign lc-entry = entry(li-loop,pc-param,'|').

       assign lc-label = entry(1,lc-entry,'^')
              lc-align = ''.
       if num-entries(lc-entry,'^') > 1 
       then assign lc-align = ' style=" text-align: ' + entry(2,lc-entry,'^') + '"'.

       if li-loop = num-entries(pc-param,'|')
       then assign lc-colspan = " colspan='8'".
       else assign lc-colspan = "".

       assign lc-return = lc-return + '<th valign="bottom" ' + lc-align + lc-colspan + '>' + lc-label + '</th>'.


   end.

   assign lc-return = lc-return + '</tr>'.

   return lc-return.




END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-TextArea Include 
FUNCTION htmlib-TextArea RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char,
    pi-rows as int,
    pi-cols as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/



  return substitute(
        '<textarea class="inputfield" name="&1" rows="&3" cols="&4">&2</textarea>',
        pc-name,
        pc-value,
        string(pi-rows),
        string(pi-cols)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-TextLink Include 
FUNCTION htmlib-TextLink RETURNS CHARACTER
  ( pc-text as char,
    pc-url  as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    
    if pc-text begins "Back" 
    or pc-text begins "Cancel"
    then pc-text = 
                    dynamic-function("html-encode","<<") + 
                    "&nbsp;" + 
                    pc-text.
    return substitute('<a class="tlink" href="&2">&1</a>',
                      pc-text,
                      pc-url ).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-TimeSelect Include 
FUNCTION htmlib-TimeSelect RETURNS CHARACTER
  ( pc-hour-name    as char,
    pc-hour-value   as char,
    pc-min-name     as char,
    pc-min-value    as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-hour-info        as char     no-undo.
    def var lc-min-info         as char     no-undo.

    assign
        lc-hour-info = dynamic-function("com-TimeReturn","HOUR")
        lc-min-info  = dynamic-function("com-TimeReturn","MINUTE").


    return
        htmlib-Select(
            pc-hour-name,
            entry(1,lc-hour-info,"^"),
            entry(2,lc-hour-info,"^"),
            pc-hour-value
            ) 
            + " : " +
     htmlib-Select(
            pc-min-name,
            entry(1,lc-min-info,"^"),
            entry(2,lc-min-info,"^"),
            pc-min-value
            ) .



END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-TimeSelect-By-Id Include 
FUNCTION htmlib-TimeSelect-By-Id RETURNS CHARACTER
  ( pc-hour-name    as char,
    pc-hour-value   as char,
    pc-min-name     as char,
    pc-min-value    as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-hour-info        as char     no-undo.
    def var lc-min-info         as char     no-undo.

    assign
        lc-hour-info = dynamic-function("com-TimeReturn","HOUR")
        lc-min-info  = dynamic-function("com-TimeReturn","MINUTE").


    return
        htmlib-Select-By-Id(
            pc-hour-name,
            entry(1,lc-hour-info,"^"),
            entry(2,lc-hour-info,"^"),
            pc-hour-value
            ) 
            + " : " +
     htmlib-Select-By-Id(
            pc-min-name,
            entry(1,lc-min-info,"^"),
            entry(2,lc-min-info,"^"),
            pc-min-value
            ) .



END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-trmouse Include 
FUNCTION htmlib-trmouse RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return '<tr class="tabrow1" onmouseover="this.className=~'tabrow2~'" onmouseout="this.className=~'tabrow1~'">'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

