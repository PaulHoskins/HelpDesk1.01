&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : toolbar.i

    Author(s)   :
    Created     :
    Notes       :
    
    23/08/2010  DJS         3677 Added remote connection ability image
    23/08/2010  DJS         3678 Modified map facility to use google 
                                maps instead of streetmaps added image
    02/09/2010  DJS         3674 - Added toolbar for Quickview toggle
    26/04/2014  phoski      Asset Toolbar
    
    
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-tbar-Begin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-Begin Procedure 
FUNCTION tbar-Begin RETURNS CHARACTER
  ( pc-RightPanel as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-BeginHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-BeginHidden Procedure 
FUNCTION tbar-BeginHidden RETURNS CHARACTER
 ( pr-rowid as rowid )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-BeginID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-BeginID Procedure 
FUNCTION tbar-BeginID RETURNS CHARACTER
  ( pc-ID as char,
    pc-RightPanel as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-BeginOption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-BeginOption Procedure 
FUNCTION tbar-BeginOption RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-BeginOptionID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-BeginOptionID Procedure 
FUNCTION tbar-BeginOptionID RETURNS CHARACTER
  ( pc-ToolID as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-End) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-End Procedure 
FUNCTION tbar-End RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-EndHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-EndHidden Procedure 
FUNCTION tbar-EndHidden RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-EndOption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-EndOption Procedure 
FUNCTION tbar-EndOption RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-Find) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-Find Procedure 
FUNCTION tbar-Find RETURNS CHARACTER
  ( pc-url as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-FindCustom) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-FindCustom Procedure 
FUNCTION tbar-FindCustom RETURNS CHARACTER
  ( pc-url as char,
    pc-name as char,
    pc-action as char,
    pc-label as char,
    pi-size as int
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-FindLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-FindLabel Procedure 
FUNCTION tbar-FindLabel RETURNS CHARACTER
 ( pc-url as char,
   pc-label AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-FindLabelIssue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-FindLabelIssue Procedure 
FUNCTION tbar-FindLabelIssue RETURNS CHARACTER
 ( pc-url as char,
   pc-label AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-ImageLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-ImageLink Procedure 
FUNCTION tbar-ImageLink RETURNS CHARACTER
  ( 
    pc-image as char,
    pc-url as char,
    pc-alt as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-JavaScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-JavaScript Procedure 
FUNCTION tbar-JavaScript RETURNS CHARACTER
  ( pc-ToolBarID        as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-Link) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-Link Procedure 
FUNCTION tbar-Link RETURNS CHARACTER
  ( pc-mode as char,
    pr-rowid as rowid,
    pc-url as char,
    pc-other-params as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-StandardBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-StandardBar Procedure 
FUNCTION tbar-StandardBar RETURNS CHARACTER
  ( pc-find-url as char,
    pc-add-url  as char,
    pc-link as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-StandardRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-StandardRow Procedure 
FUNCTION tbar-StandardRow RETURNS CHARACTER
  ( pr-rowid as rowid,
    pc-user  as char,
    pc-url as char,
    pc-delete as char,
    pc-link as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-tr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-tr Procedure 
FUNCTION tbar-tr RETURNS CHARACTER
  ( pr-rowid as rowid )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-trID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tbar-trID Procedure 
FUNCTION tbar-trID RETURNS CHARACTER
  ( pc-ToolID as char,
    pr-rowid as rowid )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-tbar-Begin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-Begin Procedure 
FUNCTION tbar-Begin RETURNS CHARACTER
  ( pc-RightPanel as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if pc-RightPanel = ""
    or pc-RightPanel = ?
    then return '<div id="toolbar" style="clear: both;" class="toolbar">&nbsp;'.
    else return '<div id="toolbar" style="clear: both;" class="toolbar"><span id="tbright" class="tbright">' + pc-RightPanel + '&nbsp;</span>&nbsp;'. 


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-BeginHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-BeginHidden Procedure 
FUNCTION tbar-BeginHidden RETURNS CHARACTER
 ( pr-rowid as rowid ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-rowobj       as char no-undo.
    def var lc-toolobj      as char no-undo.

    assign
        lc-rowobj = "ROW" + string(pr-rowid)
        lc-toolobj = "TOOL" + string(pr-rowid).
        
    return
        '<div id="' 
        + lc-toolobj 
        + '" style="display: none;">'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-BeginID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-BeginID Procedure 
FUNCTION tbar-BeginID RETURNS CHARACTER
  ( pc-ID as char,
    pc-RightPanel as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-return as char       no-undo.

    assign 
        lc-return = tbar-Begin(pc-RightPanel).

    return replace(lc-return,'id="toolbar"','id="' + pc-ID + '"').

   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-BeginOption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-BeginOption Procedure 
FUNCTION tbar-BeginOption RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return '<span id="tboption" class="tboption">'.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-BeginOptionID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-BeginOptionID Procedure 
FUNCTION tbar-BeginOptionID RETURNS CHARACTER
  ( pc-ToolID as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return '<span id="' + pc-ToolID + 'tboption" class="tboption">'.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-End) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-End Procedure 
FUNCTION tbar-End RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return '</div>'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-EndHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-EndHidden Procedure 
FUNCTION tbar-EndHidden RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return '</div>'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-EndOption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-EndOption Procedure 
FUNCTION tbar-EndOption RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return '</span>'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-Find) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-Find Procedure 
FUNCTION tbar-Find RETURNS CHARACTER
  ( pc-url as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return
                '<input style="font-size: 12px;" name="search" size="20" value="' + dynamic-function("get-value","search") + '">'
                + '&nbsp;' 
                + '<a alt="Find" href="javascript:MntButtonPress(~'search~',~'' + pc-url + '~')">'
                + '<img src="/images/toolbar/find.gif" class="tbarimg" border="0" alt="Find"></a>'.
    /*
         dynamic-function("htmlib-MntButton",pc-url,"search","Search").
      */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-FindCustom) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-FindCustom Procedure 
FUNCTION tbar-FindCustom RETURNS CHARACTER
  ( pc-url as char,
    pc-name as char,
    pc-action as char,
    pc-label as char,
    pi-size as int
    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return
                '<span style="font-size: 12px;">' 
                + pc-label +
                '</span><input style="font-size: 12px;" name="' + pc-name + '" size="' + string(pi-size) + 
                '" value="' + dynamic-function("get-value",pc-name) + '">'
                + '&nbsp;' 
                + '<a alt="Find" href="javascript:MntButtonPress(~''  + pc-action + '~',~'' + pc-url + '~')">'
                + '<img src="/images/toolbar/find.gif" class="tbarimg" border="0" alt="Find"></a>'.
    /*
         dynamic-function("htmlib-MntButton",pc-url,"search","Search").
      */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-FindLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-FindLabel Procedure 
FUNCTION tbar-FindLabel RETURNS CHARACTER
 ( pc-url as char,
   pc-label AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return      '<b>' + pc-label + ':</b>&nbsp;' + 
                '<input style="font-size: 12px;" name="search" size="20" value="' + dynamic-function("get-value","search") + '">'
                + '&nbsp;' 
                + '<a alt="Find" href="javascript:MntButtonPress(~'search~',~'' + pc-url + '~')">'
                + '<img src="/images/toolbar/find.gif" class="tbarimg" border="0" alt="Find"></a>'.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-FindLabelIssue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-FindLabelIssue Procedure 
FUNCTION tbar-FindLabelIssue RETURNS CHARACTER
 ( pc-url as char,
   pc-label AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return      '<b>' + pc-label + ':</b>&nbsp;' + 
                '<input style="font-size: 12px;" name="search" size="20" value="' + dynamic-function("get-value","search") + '">'
                + '&nbsp;' 
                + '<a alt="Find" href="javascript:IssueButtonPress(~'search~',~'' + pc-url + '~')">'
                + '<img src="/images/toolbar/find.gif" class="tbarimg" border="0" alt="Find"></a>'.
    


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-ImageLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-ImageLink Procedure 
FUNCTION tbar-ImageLink RETURNS CHARACTER
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
        '<a href="&1"><img border="0" src="&2" alt="&3" class="tbarimg"></a>',
        pc-url,
        pc-image,
        pc-alt).
      

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-JavaScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-JavaScript Procedure 
FUNCTION tbar-JavaScript RETURNS CHARACTER
  ( pc-ToolBarID        as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-return as char       no-undo.

    assign 
        lc-return = "<script>" + "~n" + 
        replace(
                '/* JS for toolbar ID TOOLSUB */':U + '~n' +
                'var TOOLSUBobjRowSelected = null':U + '~n' +
                'var TOOLSUBobjRowInit = false':U + '~n' +
                'var TOOLSUBobjRowDefault = null':U + '~n' +
                'function TOOLSUBrowInit () ~{':U + '~n' +
                '       if ( TOOLSUBobjRowInit ) ~{':U + '~n' +
                '               return':U + '~n' +
                '       }':U + '~n' +
                '       TOOLSUBobjRowInit = true':U + '~n' +
                '       var objtoolBarOption = document.getElementById("TOOLSUBtboption")':U + '~n' +
                
                
                '       TOOLSUBobjRowDefault = objtoolBarOption.innerHTML':U + '~n' +
                '       return':U + '~n' +
                '}':U + '~n' +
                'function TOOLSUBrowSelect (rowObject, rowToolIDName) ~{':U + '~n' +
                '       var objRowToolBar = document.getElementById(rowToolIDName)':U + '~n' +
                '       var objtoolBarOption = document.getElementById("TOOLSUBtboption")':U + '~n' +
                '       TOOLSUBrowInit()':U + '~n' +
                '       if ( TOOLSUBobjRowSelected != null ) ~{':U + '~n' +
                '               TOOLSUBobjRowSelected.className = "tabrow1"':U + '~n' +
                '       }':U + '~n' +
                
                
                '       if ( TOOLSUBobjRowSelected == rowObject ) ~{':U + '~n' +
                '               TOOLSUBobjRowSelected = null':U + '~n' +
                '               rowObject.className = "tabrow1"':U + '~n' +
                '               // Was space':U + '~n' +
                '               objtoolBarOption.innerHTML = TOOLSUBobjRowDefault':U + '~n' +
                '               return':U + '~n' +
                '       }':U + '~n' +
                '       rowObject.className = "tabrowselected"':U + '~n' +
                '       TOOLSUBobjRowSelected = rowObject':U + '~n' +
                '       objtoolBarOption.innerHTML = objRowToolBar.innerHTML':U + '~n' +
                
                
                '}':U + '~n' +
                'function TOOLSUBrowOver (rowObject) ~{':U + '~n' +
                '       if ( TOOLSUBobjRowSelected != rowObject ) ~{':U + '~n' +
                '               rowObject.className = "tabrowover"':U + '~n' +
                '               return':U + '~n' +
                '       }':U + '~n' +
                '       rowObject.className = "tabrowselected"':U + '~n' +
                '}':U + '~n' +
                'function TOOLSUBrowOut (rowObject) ~{':U + '~n' +
                '       if ( TOOLSUBobjRowSelected != rowObject ) ~{':U + '~n' +
                
                
                '               rowObject.className = "tabrow1"':U + '~n' +
                '               return':U + '~n' +
                '       }':U + '~n' +
                '       rowObject.className = "tabrowselected"':U + '~n' +
                '}':U + '~n' +
                '/* END OF JS */':U + '~n'
            ,
            "TOOLSUB",
            pc-ToolBarID

            
            ) + "~n" + '</script>'.



    return lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-Link) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-Link Procedure 
FUNCTION tbar-Link RETURNS CHARACTER
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
        then assign lc-image = '/images/toolbar3/add.gif'
                    lc-alt-text = 'Add'.
        when 'addissue'
        then assign lc-image = '/images/toolbar3/add.gif'
                    lc-alt-text = 'Add Issue'.
        when 'delete':U
        then assign lc-image = '/images/toolbar3/delete.gif'
                    lc-alt-text = 'Delete'.
        when 'update':U
        then assign lc-image = '/images/toolbar3/update.gif'
                    lc-alt-text = 'Update'.
        when 'view':u
        then assign lc-image = '/images/toolbar3/view.gif'
                    lc-alt-text = 'View'.
        when 'documentview':u
        then assign lc-image = '/images/toolbar3/view.gif'
                    lc-alt-text = 'View'.
        when 'genpassword' 
        then assign lc-image = '/images/toolbar3/lock.gif'
                    lc-alt-text = 'Generate password'.
        when "contaccess" 
        then assign lc-image = '/images/toolbar3/contaccess.gif'
                    lc-alt-text = 'Contractor account access'.
        when "doclist" 
        then assign lc-image = '/images/toolbar3/doclist.gif'
                    lc-alt-text = 'Documents'.
        when "eqsubclass"
        then assign lc-image = '/images/toolbar3/eqsubedit.gif'
                    lc-alt-text = 'Inventory subclassifications'.
        when "customfield"
        then assign lc-image = '/images/toolbar3/customfield.gif'
                    lc-alt-text = 'Define custom fields'.
        when "custequip"
        then assign lc-image = '/images/toolbar3/custequip.gif'
                    lc-alt-text = 'Customer equipment'.
        when "addnote"
        then assign lc-image = '/images/toolbar3/addnote.gif'
                    lc-alt-text = 'Add note'.
        when "addactivity"
        then assign lc-image = '/images/toolbar3/activity.gif'
                    lc-alt-text = 'Add activity'.
        when "updateactivity"
        then assign lc-image = '/images/toolbar3/editactivity.gif'
                    lc-alt-text = 'Update activity'.
        when "pdf"
        then assign lc-image = '/images/toolbar3/pdf.gif'
                    lc-alt-text = 'PDF report'.
        when "equipview"
        then assign lc-image = '/images/toolbar3/equipview.gif'
                    lc-alt-text = 'View equipment'.
        when "ticketadd"
        then assign lc-image = '/images/toolbar3/ticketadd.gif'
                    lc-alt-text = 'Add support ticket'.
        when "emaildelete"
        then assign lc-image = '/images/toolbar3/email_delete.gif'
                    lc-alt-text = 'Delete email'.
        when "emailissue"
        then assign lc-image = '/images/toolbar3/emailissue.gif'
                    lc-alt-text = 'Create an issue from this email'.
        when "emailview"
        then assign lc-image = '/images/toolbar3/emailview.gif'
                    lc-alt-text = 'View original email'.
        when "emailsave"
        then assign lc-image = '/images/toolbar3/email_go.gif'
                    lc-alt-text = 'Save attachments in customer documents'.
        when "kbissue"
        then assign lc-image = '/images/toolbar3/kbissue.gif'
                    lc-alt-text = 'Create KB item from issue'.
        when "moveiss" 
        then assign lc-image = '/images/toolbar3/moveiss.gif'
                    lc-alt-text = 'Move issue to different customer'.
        when "statement"
        then assign lc-image = '/images/toolbar3/statement.gif'
                    lc-alt-text = 'Statement'.
        when "customerview"
        then assign lc-image = '/images/toolbar3/cview.gif'
                    lc-alt-text = 'Toggle customer view'.
        when "quickview"  /* 3674 */
        then assign lc-image = '/images/toolbar3/qview.gif'
                    lc-alt-text = 'Toggle quick view'.
        when "Gmap"   /* 3678 */
        then assign lc-image = '/images/toolbar3/Gmap.gif'
                    lc-alt-text = 'View map'.
        when "RDP"  /* 3677 */
        then assign lc-image = '/images/toolbar3/winrdp.gif'
                    lc-alt-text = 'Connect to customer'.   
        when "multiiss" 
        then assign lc-image = '/images/toolbar3/multi.gif'
                    lc-alt-text = 'Multiple issue editor'.
        when "conttime" 
        then assign lc-image = '/images/toolbar3/time-admin.gif'
                    lc-alt-text = 'Engineers Time editor'.
        when "CustAsset" 
        then assign lc-image = '/images/toolbar3/fa.gif'
                   lc-alt-text = 'Customer Asset'.
        when "TestV" 
        then assign lc-image = '/images/toolbar3/testv.gif'
                 lc-alt-text = 'Test Template'.
        when "MailIssue" 
        then assign lc-image = '/images/toolbar3/mailiss.gif'
                 lc-alt-text = 'Mail Open Issues'.





    end case.
    
  

    if pc-url = "off" then
    do:
        assign
            lc-image = replace(lc-image,"toolbar3","toolbar3off").
        assign
            pc-url = 'javascript:alert(~'Please selected a record before clicking this button~');'
            lc-alt-text = "Disabled".
        return '<img  class="tbarimg" border=0 src="' 
            + lc-image + '">'.
       
    end.
    else 
    do:
        if pc-url begins "javascript" then
        do:

        end.
        else
        do:
        
            assign pc-url = pc-url + '?mode=' + pc-mode
                    + '&rowid=' + if pr-rowid = ? then "" else string(pr-rowid).

            if pc-other-params <> ""
            and pc-other-params <> ?
            then assign pc-url = pc-url + "&" + pc-other-params.
        end.

        return dynamic-function("tbar-ImageLink",lc-image,pc-url,
                             lc-alt-text).
    end.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-StandardBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-StandardBar Procedure 
FUNCTION tbar-StandardBar RETURNS CHARACTER
  ( pc-find-url as char,
    pc-add-url  as char,
    pc-link as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    return  
        tbar-Begin(
                tbar-Find(pc-find-url)
                ) 
        + tbar-Link("add",?,pc-add-url,pc-link)
        + tbar-BeginOption()
        + tbar-Link("view",?,"off",pc-link)
        + tbar-Link("update",?,"off",pc-link)
        + tbar-Link("delete",?,"off",pc-link)
        + tbar-EndOption()
        + tbar-End().
           
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-StandardRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-StandardRow Procedure 
FUNCTION tbar-StandardRow RETURNS CHARACTER
  ( pr-rowid as rowid,
    pc-user  as char,
    pc-url as char,
    pc-delete as char,
    pc-link as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return
        tbar-BeginHidden(pr-rowid)
        + tbar-Link("view",pr-rowid,pc-url,pc-link)
        + tbar-Link("update",pr-rowid,pc-url,pc-link)
        + tbar-Link("delete",pr-rowid,
                          if DYNAMIC-FUNCTION('com-CanDelete':U,pc-user,pc-delete,pr-rowid)
                          then pc-url else "off",pc-link)
               
        + tbar-EndHidden().

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-tr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-tr Procedure 
FUNCTION tbar-tr RETURNS CHARACTER
  ( pr-rowid as rowid ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-rowobj       as char no-undo.
    def var lc-toolobj      as char no-undo.

    assign
        lc-rowobj = "ROW" + string(pr-rowid)
        lc-toolobj = "TOOL" + string(pr-rowid).
        
  
    return
        '<tr class="tabrow1" id="' + lc-rowobj 
                + '" onClick="javascript:rowSelect(this,~'' 
                + lc-toolobj 
                + '~')"'
                + ' onmouseover="javascript:rowOver(this)"' 
                + ' onmouseout="javascript:rowOut(this)"'       
                + '>' 
                .

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tbar-trID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tbar-trID Procedure 
FUNCTION tbar-trID RETURNS CHARACTER
  ( pc-ToolID as char,
    pr-rowid as rowid ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-rowobj       as char no-undo.
    def var lc-toolobj      as char no-undo.

    assign
        lc-rowobj = "ROW" + string(pr-rowid)
        lc-toolobj = "TOOL" + string(pr-rowid).
        
  
    return
        replace(
            DYNAMIC-FUNCTION('tbar-tr':U,pr-rowid),
            'javascript:',
            'javascript:' + pc-ToolID).
    /*
        '<tr class="tabrow1" id="' + lc-rowobj 
                + '" onClick="javascript:rowSelect(this,~'' 
                + lc-toolobj 
                + '~')"'
                + ' onmouseover="javascript:rowOver(this)"' 
                + ' onmouseout="javascript:rowOut(this)"'       
                + '>' 
                .
      */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

