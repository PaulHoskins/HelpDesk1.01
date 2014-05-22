&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/activityupdate.p
    
    Purpose:        Issue - Action Activity Add/Update
    
    Notes:
    
    
    When        Who         What
    09/04/2006  phoski      Initial
    10/05/2015  phoski      last activity on issue
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


def var lc-issue-rowid          as char no-undo.
def var lc-action-rowid         as char no-undo.
def var lc-action-index         as char no-undo.
def var lc-rowid                as char no-undo.
def var lc-title                as char no-undo.
def var lc-mode                 as char no-undo.

def var lc-link-label           as char no-undo.
def var lc-submit-label         as char no-undo.
def var lc-link-url             as char no-undo.

def var lc-error-field          as char no-undo.
def var lc-error-msg            as char no-undo.
def var li-error                as int  no-undo.

def buffer b-table      for IssActivity.
def buffer IssAction    for IssAction.
def buffer issue        for Issue.
def buffer WebAction    for WebAction.

def buffer webStatus    for webStatus.

def var lf-Audit            as dec  no-undo.




/* Action Stuff */

def var lc-actioncode           as char no-undo.
def var lc-ActionNote           as char no-undo.
def var lc-CustomerView         as char no-undo.
def var lc-description          as char no-undo.
def var lc-billing-charge       as char no-undo.
def var lc-actionstatus         as char no-undo.
def var lc-list-assign          as char no-undo.
def var lc-list-assname         as char no-undo.
def var lc-currentassign        as char no-undo.
                               
                               
/* Activity */                 
def var lc-hours                as char no-undo.
def var lc-mins                 as char no-undo.
def var lc-secs                 as char no-undo.
def var li-hours                as int  no-undo.
def var li-mins                 as int  no-undo.
def var lc-StartDate            as char no-undo.
def var lc-starthour            as char no-undo.
def var lc-startmin             as char no-undo.
def var lc-endDate              as char no-undo.
def var lc-endhour              as char no-undo.
def var lc-endmin               as char no-undo.
def var lc-ActDescription       as char no-undo.
def var lc-list-activity        as char no-undo.  
def var lc-list-actname         as char no-undo.  
def var lc-activitytype         as char no-undo.
def var lc-activityby           as char no-undo.
def var lc-notes                as char no-undo.
def var lc-actdate              as char no-undo.
 
 
def var lc-list-actid           as char no-undo.  
def var lc-list-activtype       as char no-undo. 
def var lc-list-activdesc       as char no-undo.  
def var lc-list-activtime       as char no-undo. 
                               
                               
def var lc-saved-contract       as char no-undo.
def var lc-saved-billable       as char no-undo.
def var lc-saved-activity       as char no-undo.
 
def var lc-SiteVisit            as char no-undo.
def var lc-timeSecondSet        as char no-undo.
def var lc-timeMinuteSet        as char no-undo.
def var lc-DefaultTimeSet       as char no-undo.
def var lc-manChecked           as char  no-undo.


def var lc-save-activityby      as char no-undo.
def var lc-save-actdate         as char no-undo.
def var lc-save-customerview    as char no-undo.
def var lc-save-StartDate       as char no-undo.
def var lc-save-starthour       as char no-undo.
def var lc-save-startmin        as char no-undo.
def var lc-save-endDate         as char no-undo.
def var lc-save-endhour         as char no-undo.
def var lc-save-endmin          as char no-undo.
def var lc-save-DefaultTimeSet  as char no-undo.
def var lc-save-hours           as char no-undo.
def var lc-save-mins            as char no-undo.
def var lc-save-secs            as char no-undo.
def var lc-save-sitevisit       as char no-undo.
def var lc-save-description     as char no-undo.
def var lc-save-notes           as char no-undo.
def var lc-save-manChecked      as char no-undo.
def var lc-save-actdescription  as char no-undo.
def var lc-save-billing-charge  as char no-undo.
def var lc-save-timeSecondSet   as char no-undo.
def var lc-save-timeMinuteSet   as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-Format-Select-Activity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Activity Procedure 
FUNCTION Format-Select-Activity RETURNS CHARACTER
  ( pc-htm as char, pc-index as int  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Duration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Duration Procedure 
FUNCTION Format-Select-Duration RETURNS CHARACTER
  ( pc-htm as char , pc-idx as int  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Get-Activity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Get-Activity Procedure 
FUNCTION Get-Activity RETURNS INTEGER
  ( pc-inp as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlib-ThisInputField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlib-ThisInputField Procedure 
FUNCTION htmlib-ThisInputField RETURNS CHARACTER
  ( pc-name as char,
    pi-size as int,
    pc-value as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Return-Submit-Button) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Return-Submit-Button Procedure 
FUNCTION Return-Submit-Button RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char,
    pc-post as char
    )  FORWARD.

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
         HEIGHT             = 10.27
         WIDTH              = 32.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}
{lib/maillib.i}
{lib/ticket.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */


find first webStatus
     where webStatus.CompanyCode = lc-global-company
       and webStatus.CompletedStatus = true no-lock no-error.


{lib/checkloggedin.i}

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-ExportAccordion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportAccordion Procedure 
PROCEDURE ip-ExportAccordion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



    {&out}
      '<style type="text/css">' skip
      
      '.clear ~{ /* generic container (i.e. div) for floating buttons */' skip
      'overflow: hidden;'    skip
      'width: 100%;' skip
      '~}' skip

      'a.button ~{' skip
      'background: transparent url(~'/images/toolbar/bg_button_a.gif~') no-repeat scroll top right;' skip
      'color: #444;' skip
      'display: block;' skip
      'float: left;' skip
      'font: normal 12px arial, sans-serif;' skip
      'height: 24px;' skip
      'margin-right: 6px;' skip
      'padding-right: 18px; /* sliding doors padding */' skip
      'text-decoration: none;' skip
      '~}' skip

      'a.button span ~{' skip
      'background: transparent url(~'/images/toolbar/bg_button_span1.gif~') no-repeat;' skip
      'display: block;' skip
      'line-height: 14px;' skip
      'padding: 5px 0 5px 18px;' skip
       'cursor: pointer;' skip
      '~} ' skip

      'a.button:active ~{' skip
      'background-position: bottom right;' skip
      'color: #000;' skip
      'outline: none; /* hide dotted outline in Firefox */' skip
       'cursor: pointer;' skip
      '~}' skip

      'a.button:active span ~{' skip
      'background-position: bottom left;' skip
      'padding: 6px 0 4px 18px; /* push text down 1px */' skip
       'cursor: pointer;' skip
      '~} ' skip

      '.buttonbox ~{' skip
      'border: 0px dotted blue;'  skip
      'padding: 1px; ' skip
      'margin-bottom: 1px;'  skip
      'margin-top: 1px; ' skip
      'font-weight: bold; ' skip
      'background-color: #FFFFFF;' skip
      'position: relative;' skip
      'width: 100%;' skip
      'height: 20px;     ' skip
      '~}' skip


      '.AccordionTitle, .AccordionContent, .AccordionContainer' skip
      '~{' skip
      'position: relative;' skip
      'margin-left:auto;' skip
      'margin-right:auto;' skip
      'width: 650px; /*changeble*/' skip
      'border-bottom: 1px dotted white;' skip
      '~}' skip


      '.AccordionTitle' skip
      '~{' skip
      'height: 20px; /*changeble*/' skip
      'overflow: hidden;' skip
      'cursor: pointer;' skip
      'font-family: Verdana; /*changeble*/' skip
      'font-size: 12px; /*changeble*/' skip
      'font-weight: normal; /*changeble*/' skip
      'vertical-align: middle; /*changeble*/' skip
      'text-align: center; /*changeble*/' skip
      'display: table-cell;' skip
      '-moz-user-select: none;' skip
      'border-top: none; /*changeble*/' skip
      'border-bottom: none; /*changeble*/' skip
      'border-left: none; /*changeble*/' skip
      'border-right: none; /*changeble*/' skip
      'background-color: #0099cc;' skip
      'color: White;' skip
      '~}' skip


      '.AccordionContent' skip
      '~{' skip
      'height: 0px;' skip
      'overflow: hidden; /*display: none;  */' skip
      '~}' skip


      '.AccordionContent_' skip
      '~{' skip
      'height: auto;' skip
      '~}' skip


      '.AccordionContainer' skip
      '~{' skip
      'border-top: solid 1px #C1C1C1; /*changeble*/' skip
      'border-bottom: solid 1px #C1C1C1; /*changeble*/' skip
      'border-left: solid 1px #C1C1C1; /*changeble*/' skip
      'border-right: solid 1px #C1C1C1; /*changeble*/' skip
      '~}' skip


      '.ContentTable' skip
      '~{' skip
      'width: 100%;' skip
      'text-align: center;' skip
      'color: White;' skip
      '~}' skip

      '.ContentCell' skip
      '~{' skip
      'background-color: #666666;' skip
      '~}' skip

      '.ContentTable a:link, a:visited' skip
      '~{' skip
      'color: White;' skip
      'text-decoration: none;' skip
      '~}' skip

      '.ContentTable a:hover' skip
      '~{' skip
      'color: Yellow;' skip
      'text-decoration: none;' skip
      '~}' skip

      '</style>' skip

      '<script type="text/javascript" language="JavaScript">' skip
      'var ContentHeight = 0;' skip
      'var TimeToSlide = 200;' skip
      'var openAccordion = "";' skip
      'var totalAcc = 0 ;' skip
      'var firstTime = ' if lc-mode = 'display' or lc-mode = 'insert' then 'true' else 'false' skip
      
      'function runAccordion(index)' skip
      '~{' skip
      'var nID = "Accordion" + index + "Content";' skip
      'if(openAccordion == nID)' skip
      'nID = "";' skip

      'ContentHeight = document.getElementById("Accordion" + index + "Content"+"_").offsetHeight;' skip
      'setTimeout("animate(" + new Date().getTime() + "," + TimeToSlide + ",~'"' skip
      '+ openAccordion + "~',~'" + nID + "~')", 33);' skip
      'openAccordion = nID;' skip
      '~}' skip

      'function animate(lastTick, timeLeft, closingId, openingId)' skip
      '~{' skip
      'var curTick = new Date().getTime();' skip
      'var elapsedTicks = curTick - lastTick;' skip
      'var opening = (openingId == "") ? null : document.getElementById(openingId);' skip
      'var closing = (closingId == "") ? null : document.getElementById(closingId);' skip

      'if(timeLeft <= elapsedTicks)' skip
      '~{' skip
      'if(opening != null)' skip
      'opening.style.height = ~'auto~';' skip
      'if(closing != null)' skip
      '~{' skip
      '//closing.style.display = ~'none~';' skip
      'closing.style.height = ~'0px~';' skip
      '~}' skip
      'return;' skip
      '~}' skip

      'timeLeft -= elapsedTicks;' skip
      'var newClosedHeight = Math.round((timeLeft/TimeToSlide) * ContentHeight);' skip

      'if(opening != null)' skip
      '~{' skip
      'if(opening.style.display != ~'block~')' skip
      'opening.style.display = ~'block~';' skip
      'opening.style.height = (ContentHeight - newClosedHeight) + ~'px~';' skip
      '~}' skip

      'if(closing != null)' skip
      'closing.style.height = newClosedHeight + ~'px~';' skip
      'setTimeout("animate(" + curTick + "," + timeLeft + ",~'"' skip
      '+ closingId + "~',~'" + openingId + "~')", 33);' skip
      '~}' skip

      'function checkLoad()' skip
      '~{' skip

      'if (window.onLoad)' skip
      '~{' skip
      'window.resizeBy(0, totalAcc * 20);' skip
      '~}' skip
      'else ~{' skip
      'setTimeout("checkLoad();", 1000);' skip
      '~}' skip
/*         'alert(firstTime);' skip */
      'if ( firstTime )' skip
      '~{' skip
      'firstTime = false;' skip
      'fitWindow();' skip
      '~}' skip
      '~}' skip


      'function FitBody() ~{' skip
      'var iSize = getSizeXY();' skip
      'var iScroll = getScrollXY();' skip
/*       'window.alert( 'Width = ' + iSize[0]  +  '   Height = ' + iSize[1] );' skip     */
/*       'window.alert( 'Width = ' + iScroll[0]  +  '   Height = ' + iScroll[1] );' skip */
      'iWidth = iSize[0] + iScroll[0] + 28 ;' skip
      'iHeight = iSize[1] + iScroll[1] + iScroll[1] + 20 ;' skip
/*       'window.alert( 'Width = ' + iWidth  +  '   Height = ' + iHeight );' skip */
      'if (iScroll[1] != 0 ) window.resizeTo(iWidth, iHeight);' skip
      'self.focus();' skip
      '~};' skip

      'function getSizeXY() ~{' skip
      'var myWidth = 0, myHeight = 0;' skip
      'if( typeof( window.innerWidth ) == "number" ) ~{' skip
      '//Non-IE' skip
      'myWidth = window.innerWidth;' skip
      'myHeight = window.innerHeight;' skip
      '//window.alert("NON IE");' skip
      '~} else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) ~{' skip
      '//IE 6+ in standards compliant mode' skip
      'myWidth = document.documentElement.clientWidth;' skip
      'myHeight = document.documentElement.clientHeight;' skip
      '//window.alert("IE 6");' skip
      '~} else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) ~{' skip
      '//IE 4 compatible' skip
      'myWidth = document.body.clientWidth;' skip
      'myHeight = document.body.clientHeight;' skip
      '//window.alert("IE 4");' skip
      '~}' skip
/*       '//window.alert( 'Width = ' + myWidth  +  '   Height = ' + myHeight );' skip */
      'return [ myWidth, myHeight ];' skip
      '~}' skip

      'function getScrollXY() ~{' skip
      'var scrOfX = 0, scrOfY = 0;' skip
      'if( typeof( window.pageYOffset ) == "number" ) ~{' skip
      '//Netscape compliant' skip
      'scrOfY = window.pageYOffset;' skip
      'scrOfX = window.pageXOffset;' skip
      '~} else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) ~{' skip
      '//DOM compliant' skip
      'scrOfY = document.body.scrollTop;' skip
      'scrOfX = document.body.scrollLeft;' skip
      '~} else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) ~{' skip
      '//IE6 standards compliant mode' skip
      'scrOfY = document.documentElement.scrollTop;' skip
      'scrOfX = document.documentElement.scrollLeft;' skip
      '~}' skip
/*       '//window.alert( 'Width = ' + scrOfX  +  '   Height = ' + scrOfY );' skip */
      'return [ scrOfX, scrOfY ];' skip
      '~}' skip
      
      '</script>' skip
      .




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ExportJScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportJScript Procedure 
PROCEDURE ip-ExportJScript :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    {&out} 
      '<script type="text/javascript" language="JavaScript">' skip
      'var manualTime = false;' skip

      ' function ChangeDuration(Indx) ' skip
      '~{' skip
      '  var tFA = "ff" + Indx + "hours"; ' skip
      '  var tFB = "ff" + Indx + "mins"; ' skip
      '  var tFC = "ff" + Indx + "startdate"; ' skip
      '  var tFD = "ff" + Indx + "enddate"; ' skip
      '  var tFE = Indx + "endhour"; ' skip
      '  var tFF = Indx + "endmin"; ' skip
      '  var tFG = Indx + "starthour"; ' skip
      '  var tFH = Indx + "startmin"; ' skip
      '  var tFX = "mainform" + (Indx < 10 ? "0" : "") + Indx  ; ' skip
      '  var tFZ = Indx + "manualTime"; ' skip
      '  var curHourDuration   = parseInt(document.getElementById(tFA).value,10) ' skip
      '  var curMinDuration    = parseInt(document.getElementById(tFB).value,10) ' skip
      '  var startDate         = parseInt(document.getElementById(tFC).value,10) ' skip
      '  var endDate           = parseInt(document.getElementById(tFD).value,10) ' skip
      '  var endHourOption     = parseInt(document.getElementById(tFE).value,10);' skip
      '  var endMinuteOption   = parseInt(document.getElementById(tFF).value,10);' skip
      '  var startHourOption   = parseInt(document.getElementById(tFG).value,10);' skip
      '  var startMinuteOption = parseInt(document.getElementById(tFH).value,10);' skip
      '  var startTime         =  internalTime(startHourOption,startMinuteOption) ; '  skip
      '  var endTime           =  internalTime(endHourOption,endMinuteOption) ; '  skip
      '  var durationTime      =  internalTime(curHourDuration,curMinDuration) ; '  skip

      '  document.forms[tFX].elements[tFB].value = (curMinDuration < 10 ? "0" : "") + curMinDuration ;' skip
      '  document.getElementById("throbber").src="/images/ajax/ajax-loaded-red.gif"; ' skip
      '  document.forms[tFX].elements[tFZ].checked = true; ' skip
      '  manualTime = true; ' skip   
/*       '  document.forms[tFX].elements[tFB].value = (curMinDuration < 10 ? "0" : "") + curMinDuration ;' skip                                                      */
/*       '  if (manualTime) return;  ' skip                                                                                                                          */
/*       '  if ( (endTime - startTime) != 0  || (endTime - startTime) != durationTime || !manualTime )' skip                                                         */
/*       '  ~{' skip                                                                                                                                                 */
/* /*       '     alert("The duration entered does not match with the Start and End time! ~\n ~\n                              Setting to Manual Time."); ' skip  */ */
/*       '     document.getElementById("throbber").src="/images/ajax/ajax-loaded-red.gif"; ' skip                                                                    */
/*       '     document.forms[tFX].elements[tFZ].checked = true; ' skip                                                                                              */
/*       '     manualTime = true; ' skip                                                                                                                             */
/*       '  ~}' skip                                                                                                                                                 */
      '~}' skip

      ' function PrePost(Indx) ' skip
      '~{' skip
      '  var tFA = "ff" + Indx + "hours"; ' skip
      '  var tFB = "ff" + Indx + "mins"; ' skip
      '  var tFC = "ff" + Indx + "startdate"; ' skip
      '  var tFD = "ff" + Indx + "enddate"; ' skip
      '  var tFE = Indx + "endhour"; ' skip
      '  var tFF = Indx + "endmin"; ' skip
      '  var tFG = Indx + "starthour"; ' skip
      '  var tFH = Indx + "startmin"; ' skip
      '  var tFX = "mainform" + (Indx < 10 ? "0" : "") + Indx  ; ' skip
      '  var tFZ = Indx + "manualTime"; ' skip
      '  var curHourDuration   = parseInt(document.getElementById(tFA).value,10) ' skip
      '  var curMinDuration    = parseInt(document.getElementById(tFB).value,10) ' skip
      '  var startDate         = parseInt(document.getElementById(tFC).value,10) ' skip
      '  var endDate           = parseInt(document.getElementById(tFD).value,10) ' skip
      '  var endHourOption     = parseInt(document.getElementById(tFE).value,10);' skip
      '  var endMinuteOption   = parseInt(document.getElementById(tFF).value,10);' skip
      '  var startHourOption   = parseInt(document.getElementById(tFG).value,10);' skip
      '  var startMinuteOption = parseInt(document.getElementById(tFH).value,10);' skip
      '  var startTime         =  internalTime(startHourOption,startMinuteOption) ; '  skip
      '  var endTime           =  internalTime(endHourOption,endMinuteOption) ; '  skip
      '  var durationTime      =  internalTime(curHourDuration,curMinDuration) ; '  skip
      '  if (  (endTime - startTime) != 0  && (endTime - startTime) != durationTime )' skip
      '  ~{' skip
      '     var answer = confirm("The duration entered does not match with the Start and End time! ~\n ~\n      Press Cancel if you want to update the times before posting"); ' skip
      '     if (answer) ~{ document.forms[tFX].submit();  ~} ' skip
      '     else  ~{ return false;  ~} ' skip
      '  ~}' skip
      '  else ~{ document.forms[tFX].submit();  ~} ' skip
      '~}' skip

      'function internalTime(piHours,piMins) ' skip
      '~{' skip
      '  return ( ( piHours * 60 ) * 60 ) + ( piMins * 60 ); ' skip
      '~}' skip.
    
    {&out} 
      '// --  Clock --' skip
      'var timerID = null;' skip
      'var timerRunning = false;' skip
      'var timerStart = null;' skip
      'var timeSet = null;' skip
      'var defaultTime = parseInt(' lc-DefaultTimeSet ',10);' skip
      'var timeSecondSet = parseInt(' lc-timeSecondSet ',10);' skip
      'var timeMinuteSet = parseInt(' lc-timeMinuteSet ',10);' skip
      'var timeHourSet = 0;' skip
      'var timerStartseconds = 0;' skip(2)
      
      'function manualTimeSet()~{' skip
      'manualTime = (manualTime == true) ? false : true;' skip
      'if (!manualTime) ~{document.getElementById("throbber").src="/images/ajax/ajax-loader-red.gif"~}' skip
      'else ~{document.getElementById("throbber").src="/images/ajax/ajax-loaded-red.gif"~}' skip
      '~}' skip

      'function stopclock(levelx)~{' skip
      'if(timerRunning)' skip
      'clearTimeout(timerID);' skip
      'timerRunning = false;' skip
      '~}' skip

      'function startclock(levelx)~{' skip
      'stopclock(levelx);' skip
      'timeHourSet = 0;' skip
      'document.getElementById("clockface").innerHTML =  "00" +   ((defaultTime < 10) ? ":0" : ":") + defaultTime  + ":00" ' skip
      'var tF = "ff" + levelx + "mins";' skip
      'document.getElementById(tF).value = ((defaultTime < 10) ? "0" : "") + defaultTime ' skip
      'showtime(levelx);' skip
      '~}' skip

      'function showtime(levelx)~{' skip
      'var curMinuteOption;' skip
      'var curHourOption;' skip
      'var now = new Date()' skip
      'var hours = now.getHours()' skip
      'var minutes = now.getMinutes()' skip
      'var seconds = now.getSeconds()' skip
      'var millisec = now.getMilliseconds()' skip
      'var timeValue = "" +   hours' skip
      'var tFH = "ff" + levelx + "hours"' skip
      'var tFM = "ff" + levelx + "mins"' skip
      'var tFEH = levelx + "endhour"' skip
      'var tFEM = levelx + "endmin"'skip
      'timeSecondSet = timeSecondSet + 1' skip
      'if (!manualTime)' skip
      '~{' skip
      'timeValue  += ((minutes < 10) ? ":0" : ":") + minutes' skip
      'timeValue  += ((seconds < 10) ? ":0" : ":") + seconds' skip
      'curHourOption = document.getElementById(tFEH + ((hours == 0) ? "0" : "") + hours) ' skip
      'curHourOption.selected = true' skip
      'curMinuteOption = document.getElementById(tFEM + ((minutes < 10) ? "0" : "") + minutes)' skip
      'curMinuteOption.selected = true' skip
      'if ( timeSecondSet >= 60 ) ~{ timeSecondSet = 0 ; timeMinuteSet = timeMinuteSet + 1; ~}' skip
      'if ( timeMinuteSet >= 60 ) ~{ timeMinuteSet = 0 ; timeHourSet = timeHourSet + 1; ~}' skip
      'if ( defaultTime <= timeMinuteSet || defaultTime == 0 )' skip
      '  ~{' skip
      '     document.getElementById(tFH).value = ((timeHourSet  < 10) ? "0" : "") + timeHourSet' skip
      '     document.getElementById(tFM).value  = ((timeMinuteSet < 10) ? "0" : "") + timeMinuteSet ' skip
      '     document.getElementById("clockface").innerHTML = ((timeHourSet < 10) ? "0" : "") + timeHourSet ' skip
      '       +   ((timeMinuteSet < 10) ? ":0" : ":") + timeMinuteSet  + ((timeSecondSet < 10) ? ":0" : ":") + timeSecondSet ' skip
      '  ~}'  skip
      '~}' skip
      'document.getElementById("timeSecondSet").value = timeSecondSet' skip
      'document.getElementById("timeMinuteSet").value = timeMinuteSet' skip
      'timerRunning = true' skip
      'timerID = setTimeout("showtime(" + levelx + ")",1000)' skip
      '~}' skip
 
      '</script>' skip
      .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-HeaderInclude-Calendar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-HeaderInclude-Calendar Procedure 
PROCEDURE ip-HeaderInclude-Calendar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Page Procedure 
PROCEDURE ip-Page :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param zx as int no-undo.

    {&out}
      '<br>' skip
      .

    {&out} htmlib-StartInputTable() skip.


    {&out} '<tr><td valign="top" align="right">'
           ( if lookup("activityby",lc-error-field,'|') > 0 and li-error = zx
           then htmlib-SideLabelError("Activity By")
           else htmlib-SideLabel("Activity By"))
           '</td>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<td valign="top" align="left">'
           htmlib-Select(string(zx) + "activityby",lc-list-assign,lc-list-assname,lc-activityby)
           '</td>'.
    else
    {&out} htmlib-TableField(html-encode(com-UserName(lc-activityby)),'left')
           skip.
    {&out} '</tr>' skip.


    {&out} '<tr><td valign="top" align="right">' 
             (if lookup("activitytype",lc-error-field,'|') > 0 and li-error = zx
             then htmlib-SideLabelError("Activity Type")
             else htmlib-SideLabel("Activity Type"))
             '</td>' 
             '<td valign="top" align="left">'
             Format-Select-Activity(htmlib-Select(string(zx) + "activitytype",lc-list-actid,lc-list-activtype,lc-saved-activity), zx) skip
             '</td></tr>' skip. 


   
    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("actdate",lc-error-field,'|') > 0 and li-error = zx
            then htmlib-SideLabelError("Date")
            else htmlib-SideLabel("Date"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-InputField(string(zx) + "actdate",10,lc-actdate) 
            htmlib-CalendarLink(string(zx) + "actdate")
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-actdate),'left')
           skip.
    {&out} '</tr>' skip.

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("startdate",lc-error-field,'|') > 0 and li-error = zx
            then htmlib-SideLabelError("Start Date")
            else htmlib-SideLabel("Start Date"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-InputField(string(zx) + "startdate",10,lc-startdate) 
            htmlib-CalendarLink(string(zx) + "startdate")
            "&nbsp;@&nbsp;"
            htmlib-TimeSelect-By-Id(string(zx) + "starthour",lc-starthour,string(zx) + "startmin",lc-startmin)
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-startdate),'left')
           skip.
    {&out} '</tr>' skip.

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("enddate",lc-error-field,'|') > 0 and li-error = zx
            then htmlib-SideLabelError("End Date")
            else htmlib-SideLabel("End Date"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-InputField(string(zx) + "enddate",10,lc-enddate) 
            htmlib-CalendarLink(string(zx) + "enddate")
            "&nbsp;@&nbsp;"
            htmlib-TimeSelect-By-Id(string(zx) + "endhour",lc-endhour,string(zx) + "endmin",lc-endmin)
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-enddate),'left')
           skip.
    {&out} '</tr>' skip.



    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("hours",lc-error-field,'|') > 0 and li-error = zx
            then htmlib-SideLabelError("Duration (HH:MM)")
            else htmlib-SideLabel("Duration (HH:MM)"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            Format-Select-Duration(htmlib-InputField(string(zx) + "hours",4,lc-hours), zx)
            ':'
            Format-Select-Duration(htmlib-InputField(string(zx) + "mins",2,lc-mins), zx)
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-hours),'left')
           skip.
    {&out} '</tr>' skip.





    if lc-mode = "add" then do:
    
        {&out} '<tr><td valign="top" align="right">' 
                (if lookup("manualTime",lc-error-field,'|') > 0 and li-error = zx
                then htmlib-SideLabelError("Manual Time Entry?")
                else htmlib-SideLabel("Manual Time Entry?"))
                '</td>'.
        {&out} '<td valign="top" align="left">'
                '<input class="inputfield" type="checkbox" onclick="javascript:manualTimeSet()" id="' + string(zx) 
                     + 'manualTime" name="' + string(zx) + 'manualTime"  ' lc-manChecked ' >' 
                '</td>' skip.
    end.





    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("sitevisit",lc-error-field,'|') > 0 and li-error = zx
            then htmlib-SideLabelError("Site Visit?")
            else htmlib-SideLabel("Site Visit?"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-CheckBox(string(zx) + "sitevisit", if lc-sitevisit = 'on'
                                        then true else false) 
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-sitevisit = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</tr>' skip.
    /**/

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("customerview",lc-error-field,'|') > 0 and li-error = zx
            then htmlib-SideLabelError("Customer View?")
            else htmlib-SideLabel("Customer View?"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-CheckBox(string(zx) + "customerview", if lc-customerview = 'on'
                                        then true else false) 
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-customerview = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</tr>' skip.


    {&out} '<tr><td valign="top" align="right">' 
               (if lookup("actdescription",lc-error-field,'|') > 0 and li-error = zx
               then htmlib-SideLabelError("Activity Description")
               else htmlib-SideLabel("Activity Description"))
               '</td><td valign="top" align="left">'
               htmlib-ThisInputField(string(zx) + "actdescription",40,lc-actdescription) 
               '</td></tr>' skip.



       {&out} '<tr><td valign="top" align="right">' 
               htmlib-SideLabel("Charge for Activity?")
               '</td><td valign="top" align="left">'
               htmlib-CheckBox(string(zx) + "billingcharge", if lc-billing-charge = 'on'
                                           then true else false)
               '</td></tr>' skip.



    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("description",lc-error-field,'|') > 0 and li-error = zx
            then htmlib-SideLabelError("Description")
            else htmlib-SideLabel("Description"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-InputField(string(zx) + "description",40,lc-description) 
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-description),'left')
           skip.
    {&out} '</tr>' skip.


    {&out} '<tr><td valign="top" align="right">' 
          (if lookup("notes",lc-error-field,'|') > 0 and li-error = zx
          then htmlib-SideLabelError("Note")
          else htmlib-SideLabel("Note"))
          '</td>' skip
           '<td valign="top" align="left">'
           htmlib-TextArea(string(zx) + "notes",lc-notes,6,40)
          '</td></tr>' skip
           skip.

    {&out} htmlib-EndTable() skip.

    if lc-error-msg <> "" and li-error = zx then
    do:
       {&out} '<br><br><center>' 
               htmlib-MultiplyErrorMessage(lc-error-msg) '</center>' skip.
    end.
    
    if lc-submit-label <> "" then
    do:
       {&out} '<center>' Return-Submit-Button("submitform",lc-submit-label,"PrePost(" + string(zx) + ")") 
              '</center>' skip.
    end.

    {&out}
      '<br>' skip
      .


    if not can-do("view,delete",lc-mode) and zx > 0 then
    do:
        {&out}
            htmlib-CalendarScript(string(zx) + "actdate") skip
            htmlib-CalendarScript(string(zx) + "startdate") skip
            htmlib-CalendarScript(string(zx) + "enddate") skip.
           
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Validate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Validate Procedure 
PROCEDURE ip-Validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.


    def var ld-date     as date     no-undo.
    def var li-int      as int      no-undo.
    def var ld-startd   as date     no-undo.
    def var ld-endd     as date     no-undo.
    def var li-startt   as int      no-undo.
    def var li-endt     as int      no-undo.
    
    assign
        ld-date = date(lc-actdate) no-error.

    if error-status:error
    or ld-date = ? 
    then run htmlib-AddErrorMessage(
                    'actdate', 
                    'The date is invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-startdate <> "" then
    do:
        assign ld-startd = date(lc-startdate) no-error.
        if error-status:error
        or ld-startd = ? then
        do:
            run htmlib-AddErrorMessage(
                    'startdate', 
                    'The start date is invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

        end.
    end.
    else assign ld-startd = ?.

    if lc-enddate <> "" then
    do:
        assign ld-endd = date(lc-enddate) no-error.
        if error-status:error
        or ld-endd = ? then
        do:
            run htmlib-AddErrorMessage(
                    'enddate', 
                    'The end date is invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

        end.
    end.
    else assign ld-endd = ?.

    if ld-endd <> ?
    and ld-startd = ? then
    do:
        run htmlib-AddErrorMessage(
                    'enddate', 
                    'You must enter a start date if you enter an end date',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
    end.

    if ( ld-endd <> ? and ld-startd <> ? ) then
    do:
        if ( ld-startd > ld-endd ) 
        then run htmlib-AddErrorMessage(
                    'enddate', 
                    'The end date can not be before the start date',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        assign
            li-startt = dynamic-function("com-InternalTime",
                                         int(lc-starthour),
                                         int(lc-startmin)
                                         ).
            li-endt = dynamic-function("com-InternalTime",
                                         int(lc-endhour),
                                         int(lc-endmin)
                                        ).
        if ld-endd = ld-startd
        and li-endt < li-startt then
        do:
            run htmlib-AddErrorMessage(
                    'enddate', 
                    'The end time can not be before the start time',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

        end.
    end.

    assign li-int = int(lc-hours) no-error.
    if error-status:error or li-int < 0
    then run htmlib-AddErrorMessage(
                    'hours', 
                    'The hours are invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    assign li-int = int(lc-mins) no-error.
    if error-status:error or li-int < 0 or li-int > 59
    then run htmlib-AddErrorMessage(
                    'hours', 
                    'The minutes are invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

  
    assign li-int = int(lc-hours + lc-mins) no-error.
    if not error-status:error 
    and (li-endt > li-startt and li-int = 0 )
    then run htmlib-AddErrorMessage(
                    'hours', 
                    'You must enter the duration',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-actdescription = "" 
    then run htmlib-AddErrorMessage(
                    'actdescription', 
                    'You must enter the activity description',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    
    if lc-description = "" 
    then run htmlib-AddErrorMessage(
                    'description', 
                    'You must enter the description',
                    input-output pc-error-field,
                    input-output pc-error-msg ).




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ipResetLastActivity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ipResetLastActivity Procedure 
PROCEDURE ipResetLastActivity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pr-issue      AS ROWID            NO-UNDO.

    DEF BUFFER issue        FOR issue.
    def buffer b-query      for issAction.
    def buffer IssActivity  for IssActivity.

    DEF VAR ldt LIKE issue.lastactivity NO-UNDO.
    DEF VAR LC  AS CHAR FORMAT 'x(20)'.

    DO transaction:
    
       find issue WHERE rowid(issue) = pr-issue EXCLUSIVE-LOCK.


       ldt = ?.
       LC = "".

       for each b-query no-lock
          where b-query.CompanyCode = issue.companyCode
            and b-query.IssueNumber = issue.IssueNumber
          , each IssActivity no-lock
              where issActivity.CompanyCode = b-query.CompanyCode
                and issActivity.IssueNumber = b-query.IssueNumber
                and IssActivity.IssActionId = b-query.IssActionID
                AND IssActivity.StartDate <> ?

                by IssActivity.StartDate DESC
                by IssActivity.StartTime DESC

          :
           /*
           ldt = DATETIME(IssActivity.StartDate,STRING(IssActivity.StartTime,"HH:MM").
           */

           LC = STRING(IssActivity.StartDate,"99/99/9999") + " " + STRING(IssActivity.StartTime,"HH:MM").
           ldt = DATETIME(LC).

           LEAVE.
       END.
       issue.LastActivity = ldt.


   END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHeader Procedure 
PROCEDURE outputHeader :
/*------------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  emails:       In the event that this Web object is state-aware, this is
               a good place to set the webState and webTimeout attributes.
------------------------------------------------------------------------------*/

  /* To make this a state-aware Web object, pass in the timeout period 
   * (in minutes) before running outputContentType.  If you supply a timeout 
   * period greater than 0, the Web object becomes state-aware and the 
   * following happens:
   *
   *   - 4GL variables webState and webTimeout are set
   *   - a cookie is created for the broker to id the client on the return trip
   *   - a cookie is created to id the correct procedure on the return trip
   *
   * If you supply a timeout period less than 1, the following happens:
   *
   *   - 4GL variables webState and webTimeout are set to an empty string
   *   - a cookie is killed for the broker to id the client on the return trip
   *   - a cookie is killed to id the correct procedure on the return trip
   *
   * Example: Timeout period of 5 minutes for this Web object.
   *
   *   setWebState (5.0).
   */
    
  /* 
   * Output additional cookie information here before running outputContentType.
   *      For more information about the Netscape Cookie Specification, see
   *      http://home.netscape.com/newsref/std/cookie_spec.html  
   *   
   *      Name         - name of the cookie
   *      Value        - value of the cookie
   *      Expires date - Date to expire (optional). See TODAY function.
   *      Expires time - Time to expire (optional). See TIME function.
   *      Path         - Override default URL path (optional)
   *      Domain       - Override default domain (optional)
   *      Secure       - "secure" or unknown (optional)
   * 
   *      The following example sets cust-num=23 and expires tomorrow at (about) the 
   *      same time but only for secure (https) connections.
   *      
   *      RUN SetCookie IN web-utilities-hdl 
   *        ("custNum":U, "23":U, TODAY + 1, TIME, ?, ?, "secure":U).
   */ 
  output-content-type ("text/html":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def var li-old-duration     like IssActivity.Duration       no-undo.
  def var li-amount           like IssActivity.Duration       no-undo.
  def var li-duration         as int.
  def var li-count            as int.
  def var lc-main-title       as char no-undo.
  def var lc-acc-title-left   as char no-undo.
  def var lc-acc-title-right  as char no-undo.
  def var lc-acc-link-label   as char no-undo.
  def var lc-acc-submit-label as char no-undo.
  def var li-opener           as int  no-undo.
  def var zx                  as int  no-undo.

    assign 
        lc-issue-rowid    =  get-value("issuerowid")
        lc-rowid          =  get-value("rowid")
        lc-mode           =  get-value("mode")
        lc-action-rowid   =  get-value("actionrowid")
        lc-action-index   =  get-value("actionindex").


    RUN com-GetActivityType ( lc-global-company , output lc-list-actid, output lc-list-activtype, output lc-list-activdesc, output lc-list-activtime ).

    if lc-mode = 'add' or lc-mode ='update' or lc-mode ='delete' then run process-web-request2(lc-action-index, output li-error).

    assign
        lc-title            = 'Update'
        lc-link-label       = 'Cancel update'
        lc-submit-label     = 'Update Activity'
        lc-timeSecondSet    = "1"
        lc-timeMinuteSet    = "0" /*    entry(1,lc-list-activtime,"|")  */
        lc-DefaultTimeSet   = entry(1,lc-list-activtime,"|")
        lc-saved-activity   = "0".


    find issue
        where rowid(issue) = to-rowid(lc-issue-rowid) no-lock.
    
    find customer where Customer.CompanyCode = Issue.CompanyCode
                    and Customer.AccountNumber = Issue.AccountNumber
                    no-lock no-error.

    RUN com-GetInternalUser ( lc-global-company , output lc-list-assign , output lc-list-assname ).

    assign lc-main-title =  " Activities for Issue " + string(issue.IssueNumber).

    RUN outputHeader.
    
    {&out} htmlib-OpenHeader(lc-main-title) skip.

    RUN ip-ExportAccordion.

    RUN ip-ExportJScript.

    {&out} htmlib-CloseHeader("checkLoad()") skip.

    {&out}
       htmlib-ProgramTitle(lc-main-title) skip.
    
    {&out}
          '<div id="AccordionContainer" class="AccordionContainer">' skip.


     find first issAction no-lock where rowid(issAction) = to-rowid(lc-action-rowid) no-error.


       find WebAction 
           where WebAction.ActionID = issAction.ActionID
           no-lock no-error.

       assign li-duration = 0.

       for each IssActivity no-lock
           where issActivity.CompanyCode = issue.CompanyCode
             and issActivity.IssueNumber = issue.IssueNumber
             and IssActivity.IssActionId = issAction.IssActionID
              by issActivity.ActDate 
              by IssActivity.CreateDate 
              by issActivity.CreateTime :

         assign
             li-duration = li-duration + IssActivity.Duration
             li-count    = li-count + 1.

        assign
           lc-acc-title-left   = issActivity.Description 
           lc-acc-title-right  = "(" + string(issActivity.Duration,"HH:MM") + ")"
           lc-activityby       = issActivity.ActivityBy 
           lc-actdate          = string(issActivity.ActDate )
           lc-StartDate        = string(issActivity.StartDate )
           lc-StartHour        = string(int(substr(string(issActivity.StartTime,"hh:mm"),1,2)))
           lc-StartMin         = substr(string(issActivity.StartTime,"hh:mm"),4,2)
           lc-endDate          = string(issActivity.EndDate )
           lc-endHour          = string(int(substr(string(issActivity.endTime,"hh:mm"),1,2)))
           lc-endMin           = substr(string(issActivity.endTime,"hh:mm"),4,2)
           lc-sitevisit        = if issActivity.SiteVisit then "on" else ""
           lc-customerview     = if issActivity.CustomerView then "on" else ""  
           lc-description      = issActivity.Description   
           lc-notes            = issActivity.notes 
           lc-rowid            = string(rowid(issActivity))
           lc-action-rowid     = string(rowid(issAction))
           lc-actdescription   = issActivity.ActDescription   
           lc-activitytype     = string(Get-Activity( issActivity.ActDescription ))
           lc-billing-charge   = if issActivity.Billable then "on" else ""
           lc-saved-activity   = lc-activitytype
           lc-manChecked       = "on"
           zx                  = zx + 1 .
        
            if issActivity.Duration > 0 then
            do:
                run com-SplitTime ( issActivity.Duration, output li-hours, output li-mins ).
                  assign lc-mins = string(li-mins,"99")
                        lc-hours = string(li-hours,"99").
            end.

      {&out}
          '<div onclick="runAccordion(' zx ');">' skip
          '  <div class="AccordionTitle" onselectstart="return false;">' skip
          '<span style="float:left;margin-left:20px;">'  lc-acc-title-left  '</span><span style="float:right;margin-right:20px;">' lc-acc-title-right '</span>' skip
          '  </div>' skip
          '</div>' skip
          '<div id="Accordion' zx 'Content" class="AccordionContent">' skip
          '  <div id="Accordion' zx 'Content_" class="AccordionContent_">' skip
           htmlib-StartForm("mainform" + string(zx,"99") ,"post", 
                            selfurl 
                            + "?mode=update"
                            + "&issuerowid=" + lc-issue-rowid 
                            + "&actionrowid=" + lc-action-rowid 
                            + "&actionindex=" + string(zx)
                            + "&rowid=" + lc-rowid
                            + "&timeSecondSet=" + lc-timeSecondSet
                            ).
/* This is setup IP_PAGE */
       RUN ip-Page(zx) .

       {&out} 
            htmlib-Hidden(string(zx) + "savedactivetype",lc-saved-activity) skip
            htmlib-Hidden("actDesc",lc-list-activdesc) skip     
            htmlib-Hidden("actTime",lc-list-activtime) skip 
            htmlib-Hidden("actID",lc-list-actid) skip 
            htmlib-EndForm() skip.
       
       {&out}
          ' </div>' skip
          '</div>' skip.

       end.  /* of for each */

    if lc-mode = "insert" or li-error > zx then
    do:

      if lc-mode = "insert" then
      assign lc-title            = "Add"
             lc-link-label       = "Cancel addition"
             lc-submit-label     = "Add Activity"
             lc-mode             = "add" 
             lc-activityby       = lc-global-user
             lc-actdate          = string(today,"99/99/9999")
             lc-customerview     = lc-customerview
             lc-StartDate        = string(today,"99/99/9999")
             lc-StartHour        = string(int(substr(string(time,"hh:mm"),1,2)))
             lc-StartMin         = substr(string(time,"hh:mm"),4,2)
             lc-endDate          = string(today,"99/99/9999")        
             lc-endhour          = lc-StartHour    
             lc-endmin           = lc-StartMin
             lc-DefaultTimeSet   = entry(1,lc-list-activtime,"|") 
             lc-hours            = "0"
             lc-mins             =  lc-DefaultTimeSet  /* if integer(lc-DefaultTimeSet) < 10 then "0" + lc-DefaultTimeSet else  */
             lc-secs             = "0"                              
             lc-sitevisit        = lc-sitevisit
             lc-description      = ""   
             lc-actdescription   = entry(1,lc-list-activdesc,"|")  
             lc-notes            = ""
             lc-manChecked       = ""
             lc-billing-charge   = if issue.Billable then "on" else ""
             lc-timeSecondSet    = "1"  
             lc-timeMinuteSet    = "0" 
             lc-saved-activity   = "0"
             zx                  = zx + 1
             li-opener           =  2 .
  


      else
      assign lc-title            = "Add"
             lc-link-label       = "Cancel addition"
             lc-submit-label     = "Add Activity"
             lc-mode             = "add" 
             lc-activityby       = lc-save-activityby       
             lc-actdate          = lc-save-actdate          
             lc-customerview     = lc-save-customerview     
             lc-StartDate        = lc-save-StartDate        
             lc-starthour        = lc-save-starthour        
             lc-startmin         = lc-save-startmin         
             lc-endDate          = lc-save-endDate          
             lc-endhour          = lc-save-endhour          
             lc-endmin           = lc-save-endmin           
             lc-hours            = lc-save-hours            
             lc-mins             = lc-save-mins             
             lc-secs             = lc-save-secs             
             lc-sitevisit        = lc-save-sitevisit        
             lc-description      = lc-save-description      
             lc-notes            = lc-save-notes   
             lc-saved-activity   = "0"
             lc-activitytype     = lc-saved-activity   
             lc-manChecked       = lc-save-manChecked       
             lc-actdescription   = lc-save-actdescription   
             lc-billing-charge   = lc-save-billing-charge   
             lc-timeSecondSet    = lc-save-timeSecondSet    
             lc-timeMinuteSet    = lc-save-timeMinuteSet
             lc-DefaultTimeSet   = lc-save-DefaultTimeSet   
             zx                  = zx + 1
             li-opener           =  2 .                 

      {&out}
          '<div onclick="runAccordion(' zx ');">' skip
          ' <div class="AccordionTitle" onselectstart="return false;">' skip
          'New Activity' skip
          ' </div>' skip
          '</div>' skip
          '<div id="Accordion' zx 'Content" class="AccordionContent">' skip
          ' <div id="Accordion' zx 'Content_" class="AccordionContent_">' skip
           htmlib-StartForm("mainform" + string(zx,"99") ,"post", 
                            selfurl
                            + "?mode=add"
                            + "&issuerowid=" + lc-issue-rowid 
                            + "&actionrowid=" + lc-action-rowid 
                            + "&actionindex=" + string(zx)
                            + "&timeSecondSet=2"  
                            ).
 
      {&out}
         '<div align="right">' skip
         '<span id="clockface" name="clockface" class="clockface">' skip
         '0:00:00' skip
         '</span><img id="throbber" src="/images/ajax/ajax-loader-red.gif"></div>' skip
         '<tr><td valign="top"><fieldset><legend>Main Issue Entry</legend>' skip
         .

       /* This is create IP_PAGE  */

       RUN ip-Page(zx) .


       {&out} 
            htmlib-Hidden("timeSecondSet",lc-timeSecondSet) skip
            htmlib-Hidden("timeMinuteSet",lc-timeMinuteSet) skip
            htmlib-Hidden("defaultTime",lc-DefaultTimeSet) skip
            htmlib-Hidden(string(zx) + "savedactivetype",lc-saved-activity) skip   
            htmlib-Hidden("actDesc",lc-list-activdesc) skip     
            htmlib-Hidden("actTime",lc-list-activtime) skip 
            htmlib-Hidden("actID",lc-list-actid) skip 
            htmlib-EndForm() skip 
          ' </div>' skip
          '</div>' skip.
    end.
   
    {&out}
      '<! -- END OF CONTAINER -->' skip
      '</div>' skip
         .
  
    {&out}
      '<br><span class="inform"><div class="programtitle"> ' skip
      '<input class="submitbutton" type="button"' skip
      ' onclick="location.href=~'' appurl '/iss/activityupdmain.p?mode=insert&issuerowid=' lc-issue-rowid '&rowid=' lc-rowid
      '&actionrowid='  lc-action-rowid  '~'"' skip
      ' value="Create Activity" />' skip
      '<input class="submitbutton" type="button" onclick="window.close()"' skip
      ' value="Close" />' skip
      '</div></span>' skip.



   {&out} '<script type="text/javascript">' skip.
   if lc-manChecked = "on" then  {&out} 'manualTime = true;' skip.
   else if lc-mode = "add" then   {&out} 'startclock(' string(zx) ');' skip.
   {&out} '</script>' skip.
    
    assign li-opener = li-opener + zx .

    {&out}
      
       htmlib-Footer() skip.
      
    {&out}
      '<script type="text/javascript">' skip
      'runAccordion(' if li-error > 0 then li-error else zx ');' skip

      'function fitWindow()' skip
      '~{' skip
      'window.resizeBy(0, '  li-opener  ' * 20);' skip
      '~}' skip
      '</script>' skip.  
     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-web-request2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request2 Procedure 
PROCEDURE process-web-request2 :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  emails:       
------------------------------------------------------------------------------*/
  def input  param pi-action-index as int   no-undo.
  def output param pi-error        as int   no-undo.
  
  def var li-old-duration     like IssActivity.Duration       no-undo.
  def var li-amount           like IssActivity.Duration       no-undo.
  def var pc-action-index     as char                         no-undo.

  assign pc-action-index = string(pi-action-index).


    if request_method = "POST" then
    do:
        if lc-mode <> "delete" then
        do:                           
            assign lc-save-activityby       = get-value(pc-action-index + "activityby")
                   lc-save-actdate          = get-value(pc-action-index + "actdate")
                   lc-save-customerview     = get-value(pc-action-index + "customerview")
                   lc-save-StartDate        = get-value(pc-action-index + "startdate")
                   lc-save-starthour        = get-value(pc-action-index + "starthour")
                   lc-save-startmin         = get-value(pc-action-index + "startmin")
                   lc-save-endDate          = get-value(pc-action-index + "enddate")
                   lc-save-endhour          = get-value(pc-action-index + "endhour")
                   lc-save-endmin           = get-value(pc-action-index + "endmin")
                   lc-save-hours            = get-value(pc-action-index + "hours")
                   lc-save-mins             = get-value(pc-action-index + "mins")
                   lc-save-manChecked       = get-value(pc-action-index + "manualTime")
                   lc-save-manChecked       = if lc-save-manChecked =  "on" then "checked" else ""
                   lc-save-secs             = get-value(pc-action-index + "secs")
                   lc-save-sitevisit        = get-value(pc-action-index + "sitevisit")
                   lc-save-description      = get-value(pc-action-index + "description")
                   lc-save-notes            = get-value(pc-action-index + "notes")
                   lc-saved-activity     = get-value(pc-action-index + "activitytype")
                   lc-save-actdescription   = get-value(pc-action-index + "actdescription")
                   lc-save-billing-charge   = get-value(pc-action-index + "billingcharge")
                   lc-save-timeSecondSet    = get-value("timeSecondSet")
                   lc-save-timeMinuteSet    = get-value("timeMinuteSet")
                   lc-save-DefaultTimeSet   = get-value("defaultTime")
                  . 
                   if lc-save-manChecked <> "checked"  and
                   lc-mode = 'add' then
                   lc-save-mins = string(integer(lc-save-mins) + 1).

 
            assign lc-activityby        =   lc-save-activityby     
                   lc-actdate           =   lc-save-actdate        
                   lc-customerview      =   lc-save-customerview   
                   lc-StartDate         =   lc-save-StartDate      
                   lc-starthour         =   lc-save-starthour      
                   lc-startmin          =   lc-save-startmin       
                   lc-endDate           =   lc-save-endDate        
                   lc-endhour           =   lc-save-endhour        
                   lc-endmin            =   lc-save-endmin
                   lc-hours             =   lc-save-hours          
                   lc-mins              =   lc-save-mins           
                   lc-secs              =   lc-save-secs           
                   lc-sitevisit         =   lc-save-sitevisit      
                   lc-description       =   lc-save-description    
                   lc-notes             =   lc-save-notes          
                   lc-activitytype      =   lc-saved-activity
                   lc-manChecked        =   lc-save-manChecked     
                   lc-actdescription    =   lc-save-actdescription 
                   lc-billing-charge    =   lc-save-billing-charge 
                   lc-timeSecondSet     =   lc-save-timeSecondSet  
                   lc-timeMinuteSet     =   lc-save-timeMinuteSet  
                   lc-DefaultTimeSet    =   lc-save-DefaultTimeSet 
              .


            find issue where rowid(issue) = to-rowid(lc-issue-rowid) no-lock.
            find customer where Customer.CompanyCode = Issue.CompanyCode
                            and Customer.AccountNumber = Issue.AccountNumber
                            no-lock no-error.
            find IssAction where rowid(IssAction) = to-rowid(lc-action-rowid) no-lock.
            find WebAction where WebAction.ActionID = IssAction.ActionID no-lock no-error. 
            RUN com-GetInternalUser ( lc-global-company , output lc-list-assign , output lc-list-assname ).

            RUN ip-Validate( output lc-error-field,
                             output lc-error-msg ).

            if lc-error-msg = "" then
            do:
                
                if lc-mode = 'update' then
                do:
                    find b-table where rowid(b-table) = to-rowid(lc-rowid)
                        exclusive-lock no-wait no-error.
                    if locked b-table 
                    then  run htmlib-AddErrorMessage(
                                   'none', 
                                   'This record is locked by another user',
                                   input-output lc-error-field,
                                   input-output lc-error-msg ).
                    else assign li-old-duration = b-table.Duration.
                end.
                else
                do:
                    create b-table.
                    assign b-table.IssActionID = IssAction.IssActionID
                           b-table.CompanyCode = lc-global-company
                           b-table.IssueNumber = issue.IssueNumber
                           b-table.CreateDate  = today
                           b-table.CreateTime  = time
                           b-table.CreatedBy   = lc-global-user
                           b-table.ActivityBy  = lc-ActivityBy
                           .

                    do while true:
                        run lib/makeaudit.p (
                            "",
                            output lf-audit
                            ).
                        if can-find(first IssActivity
                                    where IssActivity.IssActivityID = lf-audit no-lock)
                                    then next.
                        assign
                            b-table.IssActivityID = lf-audit.
                        leave.
                    end.
                end.
                if lc-error-msg = "" then
                do:
                    assign b-table.notes            = lc-notes
                           b-table.description      = lc-description
                           b-table.Actdescription   = lc-actdescription
                           b-table.billable         = lc-billing-charge = "on"
                           b-table.ActDate          = date(lc-ActDate)
                           b-table.customerview     = lc-customerview = "on"
                           b-table.ContractType     = Issue.ContractType 
                           b-table.SiteVisit        = lc-SiteVisit = "on".

                    if lc-startdate <> "" then
                    do:
                        assign b-table.StartDate = date(lc-StartDate).

                        assign b-table.StartTime = dynamic-function("com-InternalTime",
                                         int(lc-starthour),
                                         int(lc-startmin)
                                         ).
                    end.
                    else assign b-table.StartDate = ?
                                b-table.StartTime = 0.

                    if lc-enddate <> "" then
                    do:
                        assign b-table.EndDate = date(lc-endDate).
    
                        assign b-table.Endtime = dynamic-function("com-InternalTime",
                                        int(lc-endhour),
                                        int(lc-endmin)
                                        ).
                        
                    end.
                    else assign b-table.EndDate = ?
                                b-table.EndTime = 0.


                    assign b-table.Duration = 
                        ( ( int(lc-hours) * 60 ) * 60 ) + 
                        ( int(lc-mins) * 60 ).

                    if Issue.Ticket then
                    do:
                        assign li-amount = b-table.Duration - li-old-duration.
                        if li-amount <> 0 then
                        do:
                            empty temp-table tt-ticket.
                            create tt-ticket.
                            assign
                                tt-ticket.CompanyCode       =   issue.CompanyCode
                                tt-ticket.AccountNumber     =   issue.AccountNumber
                                tt-ticket.Amount            =   li-Amount * -1
                                tt-ticket.CreateBy          =   lc-global-user
                                tt-ticket.CreateDate        =   today
                                tt-ticket.CreateTime        =   time
                                tt-ticket.IssueNumber       =   Issue.IssueNumber
                                tt-ticket.Reference         =   b-table.description
                                tt-ticket.TickID            =   ?
                                tt-ticket.TxnDate           =   b-table.ActDate
                                tt-ticket.TxnTime           =   time
                                tt-ticket.TxnType           =   "ACT"
                                tt-ticket.IssActivityID     =   b-table.IssActivityID.
                            RUN tlib-PostTicket.
                        end.
                    end.
                end.
            end. 
            else 
            do:
              pi-error = pi-action-index.
              return.
            end.
        end.
        else
        do:
            find b-table where rowid(b-table) = to-rowid(lc-action-rowid)
                 exclusive-lock no-wait no-error.
            if locked b-table 
            then run htmlib-AddErrorMessage(
                                   'none', 
                                   'This record is locked by another user',
                                   input-output lc-error-field,
                                   input-output lc-error-msg ).
            else delete b-table.
        end.

        if lc-error-field = "" then
        do:
            RUN ipResetLastActivity ( ROWID(issue)).
            RUN outputHeader.
            {&out}
                '<html>' skip
                '<script language="javascript">' skip
                'var ParentWindow = opener' skip
                'ParentWindow.actionCreated()' skip

                '</script>' skip
                '<body><h1>ActionUpdated</h1></body></html>'.
            return.
        end.
    end.
    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        
        if can-do("view,delete",lc-mode)
        or request_method <> "post"
        then 
        do:
            assign lc-notes           = b-table.notes
                   lc-description     = b-table.description
                   lc-activityby      = b-table.ActivityBy
                   lc-actdate         = string(b-table.ActDate,"99/99/9999")
                   lc-customerview    = if b-table.CustomerView then "on" else ""
                   lc-sitevisit       = if b-table.SiteVisit then "on" else ""
                   lc-actdescription  = b-table.actdescription
                   lc-billing-charge  = if b-table.billable then "on" else ""
                   /*                                                      */
                    .
            if b-table.Duration > 0 then
            do:
                run com-SplitTime ( b-table.Duration, output li-hours, output li-mins ).
                if li-hours > 0
                then assign lc-hours = string(li-hours).
                if li-mins > 0 
                then assign lc-mins = string(li-mins).

            end.

            if b-table.StartDate <> ? then
            do:
                assign lc-startdate = string(b-table.StartDate,"99/99/9999").
                if b-table.StartTime <> 0 then
                do:
                    assign 
                        lc-StartHour = string(int(substr(string(b-table.StartTime,"hh:mm"),1,2)))
                        lc-StartMin  = substr(string(b-table.StartTime,"hh:mm"),4,2).
                end.
            end.

            if b-table.endDate <> ? then
            do:
                assign lc-enddate = string(b-table.endDate,"99/99/9999").
                if b-table.endTime <> 0 then
                do:
                    assign 
                        lc-endHour = string(int(substr(string(b-table.endTime,"hh:mm"),1,2)))
                        lc-endMin  = substr(string(b-table.endTime,"hh:mm"),4,2).
                end.
            end.
        end.
    end.
    
    if request_method = "GET" and lc-mode = "ADD" then
    do:
        assign 
            lc-activityby = lc-global-user
            lc-actdate    = string(today,"99/99/9999")
            lc-customerview = if Customer.ViewActivity then "on" else "".
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-Format-Select-Activity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Activity Procedure 
FUNCTION Format-Select-Activity RETURNS CHARACTER
  ( pc-htm as char, pc-index as int  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<select',
                   '<select onChange="ChangeActivityType(' + string(pc-index) + ')"'). 


  RETURN lc-htm.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Duration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Duration Procedure 
FUNCTION Format-Select-Duration RETURNS CHARACTER
  ( pc-htm as char , pc-idx as int  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<input',
                   '<input onChange="ChangeDuration(' + string(pc-idx) + ')"'). 

  RETURN lc-htm.

  END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Get-Activity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Get-Activity Procedure 
FUNCTION Get-Activity RETURNS INTEGER
  ( pc-inp as char) :
/*------------------------------------------------------------------------------
  Purpose:  Get-Activity
    Notes:  
------------------------------------------------------------------------------*/
def var aa as int no-undo.
aa = integer( entry( lookup(  pc-inp , lc-list-activdesc , "|" ),lc-list-actid , "|" ) ) no-error. 
if aa = 0 then aa = integer( entry( num-entries(  lc-list-actid , "|" ),lc-list-actid , "|" ) ). 
  RETURN aa.   /* Function return value. */

END FUNCTION.


/*   lc-list-actid     = 1|15|17|19|21|23|25|27|29|31|33|35|37|39                                                                                                                                                                                                               */
/*   lc-list-activtype = Take Call|Travel To|Travel From|Meeting|Telephone Call|Survey|Config/Install|Diagnosis|Project Work|Research|Testing|Client Take-On|Administration|Other                                                                                               */
/*   lc-list-activdesc = Logging Issue|Travelling to Client|Travelling from Client|Meeting with Client|Telephone Contact with Client|Network/Site Survey|Configuration and Installation|Diagnosis of Problem|Project Work|Research|Testing|Client Take-On|Administration|Other  */
/*   lc-list-activtime = 5|1|1|1|1|1|1|1|1|1|1|1|1|1                                                                                                                                                                                                                            */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlib-ThisInputField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlib-ThisInputField Procedure 
FUNCTION htmlib-ThisInputField RETURNS CHARACTER
  ( pc-name as char,
    pi-size as int,
    pc-value as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
        substitute(
            '<input class="inputfield" type="text" name="&1" id="&1" size="&2" value="&3">',
            pc-name,
            string(pi-size),
            pc-value).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Return-Submit-Button) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Return-Submit-Button Procedure 
FUNCTION Return-Submit-Button RETURNS CHARACTER
  ( pc-name as char,
    pc-value as char,
    pc-post as char
    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN substitute('<input class="submitbutton" type="button" name="&1" value="&2" onclick="&3"  >',
                    pc-name,
                    pc-value,
                    pc-post
                    ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

