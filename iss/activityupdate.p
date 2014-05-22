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
def var lc-rowid                as char no-undo.
def var lc-title                as char no-undo.
def var lc-mode                 as char no-undo.

def var lc-link-label           as char no-undo.
def var lc-submit-label         as char no-undo.
def var lc-link-url             as char no-undo.

def var lc-error-field          as char no-undo.
def var lc-error-msg            as char no-undo.
                                
def buffer b-table              for IssActivity.
def buffer IssAction            for IssAction.
def buffer issue                for Issue.
def buffer WebAction            for WebAction.

def var lf-Audit                as dec  no-undo.
                                


/* Action Stuff */

def var lc-actioncode           as char no-undo.
def var lc-ActionNote           as char no-undo.
def var lc-CustomerView         as char no-undo.
def var lc-billing-charge       as char no-undo.
def var lc-actionstatus         as char no-undo.
def var lc-list-assign          as char no-undo.
def var lc-list-assname         as char no-undo.
def var lc-currentassign        as char no-undo.
                               

def var lc-activityby           as char no-undo.
def var lc-notes                as char no-undo.
def var lc-description          as char no-undo.
def var lc-actdate              as char no-undo.

 
/* Activity */
def var lc-hours            as char no-undo.
def var lc-mins             as char no-undo.
def var lc-secs             as char no-undo.
def var li-hours            as int  no-undo.
def var li-mins             as int  no-undo.
def var lc-StartDate        as char no-undo.
def var lc-starthour        as char no-undo.
def var lc-startmin         as char no-undo.
def var lc-endDate          as char no-undo.
def var lc-endhour          as char no-undo.
def var lc-endmin           as char no-undo.
def var lc-ActDescription   as char no-undo.
def var lc-list-actid       as char no-undo.  
def var lc-list-activtype   as char no-undo. 
def var lc-list-activdesc   as char no-undo.  
def var lc-list-activtime   as char no-undo. 


def var lc-activitytype     as char no-undo.
def var lc-saved-contract   as char no-undo.
def var lc-saved-billable   as char no-undo.
def var lc-saved-activity   as char no-undo.






def var lc-SiteVisit            as char no-undo.
def var lc-timeSecondSet        as char no-undo.
def var lc-manChecked           as char  no-undo.

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
  ( pc-htm as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Duration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Duration Procedure 
FUNCTION Format-Select-Duration RETURNS CHARACTER
  ( pc-htm as char   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Time) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Time Procedure 
FUNCTION Format-Select-Time RETURNS CHARACTER
  ( pc-htm as char, pc-idx as int  )  FORWARD.

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
         HEIGHT             = 10.19
         WIDTH              = 33.29.
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

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-ExportJScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportJScript Procedure 
PROCEDURE ip-ExportJScript :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 if lc-timeSecondSet = "" then lc-timeSecondSet = "2".

 def buffer webStatus    for webStatus.

 find first webStatus
      where webStatus.CompanyCode = lc-global-company
        and webStatus.CompletedStatus = true no-lock no-error.

/*     {&out}                                                                                 */
/*         '<script language="JavaScript" src="/scripts/js/tree.js"></script>' skip           */
 
    {&out} skip 
       '<script language="JavaScript">' skip
       'var manualTime = false;' skip
       ' function ChangeDuration() ' skip
       '~{' skip

       '  var curHourDuration   = parseInt(document.mainform.ffhours.value,10) ' skip
       '  var curMinDuration    = parseInt(document.mainform.ffmins.value,10)  ' skip
       '  var startDate         = parseInt(document.mainform.startdate.value,10) ' skip
       '  var endDate           = parseInt(document.mainform.enddate.value,10)  ' skip
       '  var endHourOption     = parseInt(document.getElementById("endhour").value,10); ' skip
       '  var endMinuteOption   = parseInt(document.getElementById("endmin").value,10);' skip
       '  var startHourOption   = parseInt(document.getElementById("starthour").value,10); ' skip
       '  var startMinuteOption = parseInt(document.getElementById("startmin").value,10);' skip
       '  var startTime         =  internalTime(startHourOption,startMinuteOption) ; '  skip
       '  var endTime           =  internalTime(endHourOption,endMinuteOption) ; '  skip
       '  var durationTime      =  internalTime(curHourDuration,curMinDuration) ; '  skip
       '  document.mainform.manualTime = true; ' skip
       '  document.mainform.ffmins.value = (curMinDuration < 10 ? "0" : "") + curMinDuration ;' skip
       '~}' skip

      ' function PrePost(Indx) ' skip
      '~{' skip
       '  var curHourDuration   = parseInt(document.mainform.ffhours.value,10) ' skip
       '  var curMinDuration    = parseInt(document.mainform.ffmins.value,10)  ' skip
       '  var startDate         = parseInt(document.mainform.startdate.value,10) ' skip
       '  var endDate           = parseInt(document.mainform.enddate.value,10)  ' skip
       '  var endHourOption     = parseInt(document.getElementById("endhour").value,10); ' skip
       '  var endMinuteOption   = parseInt(document.getElementById("endmin").value,10);' skip
       '  var startHourOption   = parseInt(document.getElementById("starthour").value,10); ' skip
       '  var startMinuteOption = parseInt(document.getElementById("startmin").value,10);' skip
       '  var startTime         =  internalTime(startHourOption,startMinuteOption) ; '  skip
       '  var endTime           =  internalTime(endHourOption,endMinuteOption) ; '  skip
       '  var durationTime      =  internalTime(curHourDuration,curMinDuration) ; '  skip
      '  var startTime         =  internalTime(startHourOption,startMinuteOption) ; '  skip
      '  var endTime           =  internalTime(endHourOption,endMinuteOption) ; '  skip
      '  var durationTime      =  internalTime(curHourDuration,curMinDuration) ; '  skip
      '  if (  (endTime - startTime) != 0  && (endTime - startTime) != durationTime )' skip
      '  ~{' skip
      '     var answer = confirm("The duration entered does not match with the Start and End time! ~\n ~\n      Press Cancel if you want to update the times before posting"); ' skip
      '     if (answer) ~{ document.forms["mainform"].submit();  ~} ' skip
      '     else  ~{ return false;  ~} ' skip
      '  ~}' skip
      '  else ~{ document.forms["mainform"].submit();  ~} ' skip
      '~}' skip


      '// INTERNAL TIME ' skip
      'function internalTime(piHours,piMins) ' skip
      '~{' skip
      '  return ( ( piHours * 60 ) * 60 ) + ( piMins * 60 ); ' skip
      '~}' skip
      '// SPLIT TIME ' skip
      'function splitTime(piTime) ' skip
      '~{' skip
      ' var retTime = new Array; ' skip
      ' var secHours = 3600 ; ' skip
      ' var secs = 0 ; ' skip
      ' var piHours = 0 ; ' skip
      ' var piMins = 0 ; ' skip
      ' secs = piTime % secHours ; ' skip
      ' piMins = Math.floor(secs / 60,0) ; ' skip
      ' piTime = piTime - secs ; ' skip
      ' piHours = Math.floor(piTime / secHours,0) ; ' skip
      ' retTime[0] = piHours ; ' skip
      ' retTime[1] = piMins ; ' skip
      ' return (retTime); ' skip
      '~}' skip
      '// CHANGE DATES ' skip
     'function chgDates(piVal,piIdx) ' skip
     '~{' skip
     '  var daysInMonth=new Array(31,28,31,30,31,30,31,31,30,31,30,31); ' skip
     '  var start = new Date(piVal);  ' skip
     '  if (start != "") ' skip
     '  ~{ ' skip
     '    var y= start.getFullYear(); ' skip
     '    // check for leap year (see if year divided by four leaves a remainder). If it is a leap year, add one day to February ' skip
     '    var remainder = y % 4; ' skip
     '    if (remainder == 0)  ' skip
     '    ~{ ' skip
     '      daysInMonth[1]=29;  ' skip
     '    ~} ' skip
     '    var m = start.getMonth(); ' skip
     '    var x = start.getDate() ; ' skip
     '    x = x + parseInt(piIdx,10); ' skip
     '    // check for roll over into next month, and then check that for roll into next year.         ' skip
     '    if (x > daysInMonth[m]) ' skip
     '    ~{ ' skip
     '      x = x - daysInMonth[m]; ' skip
     '      m++; ' skip
     '      if (m > 11) ' skip
     '      ~{ ' skip
     '        m=0; ' skip
     '        y++; ' skip
     '      ~} ' skip
     '    ~} ' skip
     '    // increment month to real month, not "Array" month ' skip
     '    m++;  ' skip
     '    if (x<10) ' skip
     '    x="0"+x ' skip
     '    if (m<10) ' skip
     '    m="0"+m ' skip
     '    var myDate = x+"/"+m+"/"+y; ' skip
     '    return(myDate); ' skip
     '  ~} ' skip
     '~} ' skip



/*                                                                                                                               */
/*       '// --  Clock --' skip                                                                                                  */
/*       'var timerID = null;' skip                                                                                              */
/*       'var timerRunning = false;' skip                                                                                        */
/*       'var timerStart = null;' skip                                                                                           */
/*       'var timeSet = null;' skip                                                                                              */
/*       'var timeSecondSet = ' lc-timeSecondSet ';' skip                                                                        */
/*       'var timeMinuteSet = 0;' skip                                                                                           */
/*       'var timeHourSet = 0;' skip                                                                                             */
/*       'var manualTime = true;' skip                                                                                           */
/*       'var timerStartseconds = 0;' skip                                                                                       */
/*                                                                                                                               */
/*       'function manualTimeSet()~{' skip                                                                                       */
/*       'manualTime = (manualTime == true) ? false : true;' skip                                                                */
/*       'if (!manualTime) ~{document.getElementById("throbber").src="/images/ajax/ajax-loader-red.gif"~}' skip                  */
/*       'else ~{document.getElementById("throbber").src="/images/ajax/ajax-loaded-red.gif"~}' skip                              */
/*       '~}' skip                                                                                                               */
/*                                                                                                                               */
/*       'function stopclock()~{' skip                                                                                           */
/*       'if(timerRunning)' skip                                                                                                 */
/*       'clearTimeout(timerID);' skip                                                                                           */
/*       'timerRunning = false;' skip                                                                                            */
/*       '~}' skip                                                                                                               */
/*                                                                                                                               */
/*       'function startclock()~{' skip                                                                                          */
/*       'stopclock();' skip                                                                                                     */
/*       'showtime();' skip                                                                                                      */
/*       'timeSecondSet = ' lc-timeSecondSet ';' skip                                                                            */
/*       'timeMinuteSet = 0;' skip                                                                                               */
/*       'timeHourSet = 0;' skip                                                                                                 */
/*       '~}' skip                                                                                                               */
/*       'function showtime()~{' skip                                                                                            */
/*       'var curMinuteOption;' skip                                                                                             */
/*       'var curHourOption;' skip                                                                                               */
/*       'var now = new Date()' skip                                                                                             */
/*       'var hours = now.getHours()' skip                                                                                       */
/*       'var minutes = now.getMinutes()' skip                                                                                   */
/*       'var seconds = now.getSeconds()' skip                                                                                   */
/*       'var millisec = now.getMilliseconds()' skip                                                                             */
/*       'var timeValue = "" +   hours' skip                                                                                     */
/*       'timeSecondSet = timeSecondSet + 1' skip                                                                                */
/*       'if (!manualTime )' skip                                                                                                */
/*       '~{'                                                                                                                    */
/*       'timeValue  += ((minutes < 10) ? ":0" : ":") + minutes' skip                                                            */
/*       'timeValue  += ((seconds < 10) ? ":0" : ":") + seconds' skip                                                            */
/*       'curHourOption = document.getElementById("endhour"  + ((minutes < 10) ? "0" : "") + hours) ' skip                       */
/*       'curHourOption.selected = true' skip                                                                                    */
/*       'curMinuteOption = document.getElementById("endmin" + ((minutes < 10) ? "0" : "") + minutes)' skip                      */
/*       'curMinuteOption.selected = true' skip                                                                                  */
/*       'if ( timeSecondSet >= 60 ) ~{ timeSecondSet = 0 ; timeMinuteSet = timeMinuteSet + 1; ~}' skip                          */
/*       'if ( timeMinuteSet >= 60 ) ~{ timeMinuteSet = 0 ; timeHourSet = timeHourSet + 1; ~}' skip                              */
/*       'document.mainform.ffhours.value = ((timeHourSet  < 10) ? "0" : "") + timeHourSet' skip                                 */
/*       'document.mainform.ffmins.value = ((timeMinuteSet < 10) ? "0" : "") + timeMinuteSet ' skip                              */
/*       'document.getElementById("clockface").innerHTML = ((timeHourSet < 10) ? "0" : "") + timeHourSet '                       */
/*       ' +   ((timeMinuteSet < 10) ? ":0" : ":") + timeMinuteSet  + ((timeSecondSet < 10) ? ":0" : ":") + timeSecondSet ' skip */
/*       '~}'                                                                                                                    */
/*       'document.getElementById("timeSecondSet").value = timeSecondSet + 2;' skip                                              */
/*       'timerRunning = true;' skip                                                                                             */
/*       'timerID = setTimeout("showtime()",1000);' skip */
/*                                                       */
/*       '~}' skip                                       */
      '</script>' skip.


/*     {&out}                                                                                 */
/*         '<script language="JavaScript" src="/scripts/js/tree.js"></script>' skip           */
/*         '<script language="JavaScript" src="/scripts/js/prototype.js"></script>' skip      */
/*         '<script language="JavaScript" src="/scripts/js/scriptaculous.js"></script>' skip. */

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

    {&out} htmlib-StartInputTable() skip.


    {&out} '<tr><td valign="top" align="right"'
           ( if lookup("activityby",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Activity By")
           else htmlib-SideLabel("Activity By"))
           '</td>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<td valign="top" align="left">'
           htmlib-Select("activityby",lc-list-assign,lc-list-assname,
                lc-activityby)
           '</td>'.
    else
    {&out} htmlib-TableField(html-encode(com-UserName(lc-activityby)),'left')
           skip.
    {&out} '</tr>' skip.
   
    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("actdate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Date")
            else htmlib-SideLabel("Date"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-InputField("actdate",10,lc-actdate) 
            htmlib-CalendarLink("actdate")
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-actdate),'left')
           skip.
    {&out} '</tr>' skip.


    {&out} '<tr><td valign="top" align="right">' 
             (if lookup("activitytype",lc-error-field,'|') > 0 
             then htmlib-SideLabelError("Activity Type")
             else htmlib-SideLabel("Activity Type"))
             '</td>' 
             '<td valign="top" align="left">'
             Format-Select-Activity(htmlib-Select("activitytype",lc-list-actid,lc-list-activtype,lc-saved-activity)) skip
             '</td></tr>' skip. 


    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("startdate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Start Date")
            else htmlib-SideLabel("Start Date"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-InputField("startdate",10,lc-startdate) 
            htmlib-CalendarLink("startdate")
            "&nbsp;@&nbsp;"
            htmlib-TimeSelect("starthour",lc-starthour,"startmin",lc-startmin)
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-startdate),'left')
           skip.
    {&out} '</tr>' skip.

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("enddate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("End Date")
            else htmlib-SideLabel("End Date"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-InputField("enddate",10,lc-enddate) 
            htmlib-CalendarLink("enddate")
            "&nbsp;@&nbsp;"
            htmlib-TimeSelect-By-Id("endhour",lc-endhour,"endmin",lc-endmin)
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-enddate),'left')
           skip.
    {&out} '</tr>' skip.



    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("hours",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Duration (HH:MM)")
            else htmlib-SideLabel("Duration (HH:MM)"))
            '</td>'.
   if not can-do("view,delete",lc-mode) then
   {&out} '<td valign="top" align="left">'
           Format-Select-Duration(htmlib-InputField("hours",4,lc-hours))
           ':'
           Format-Select-Duration(htmlib-InputField("mins",2,lc-mins))
           '</td>' skip.
   else 
   {&out} htmlib-TableField(html-encode(lc-hours),'left')
          skip.
   {&out} '</tr>' skip.
    


/*     if lc-mode = "add" then do:                                                                                                    */
/*                                                                                                                                    */
/*     {&out} '<tr><td valign="top" align="right">'                                                                                   */
/*             (if lookup("manualTime",lc-error-field,'|') > 0                                                                        */
/*             then htmlib-SideLabelError("Manual Time Entry?")                                                                       */
/*             else htmlib-SideLabel("Manual Time Entry?"))                                                                           */
/*             '</td>'.                                                                                                               */
/*                                                                                                                                    */
/*                                                                                                                                    */
/*     {&out} '<td valign="top" align="left">'                                                                                        */
/*             '<input class="inputfield" type="checkbox" onclick="javascript:manualTimeSet()" name="manualTime" ' lc-manChecked ' >' */
/*             '</td>' skip.                                                                                                          */
/*     end.                                                                                                                           */

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("sitevisit",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Site Visit?")
            else htmlib-SideLabel("Site Visit?"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-CheckBox("sitevisit", if lc-sitevisit = 'on'
                                        then true else false) 
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-sitevisit = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</tr>' skip.
    /**/

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("customerview",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Customer View?")
            else htmlib-SideLabel("Customer View?"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-CheckBox("customerview", if lc-customerview = 'on'
                                        then true else false) 
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-customerview = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</tr>' skip.


    {&out} '<tr><td valign="top" align="right">' 
               (if lookup("actdescription",lc-error-field,'|') > 0 
               then htmlib-SideLabelError("Activity Description")
               else htmlib-SideLabel("Activity Description"))
               '</td><td valign="top" align="left">'
               htmlib-ThisInputField("actdescription",40,lc-actdescription) 
               '</td></tr>' skip.


       {&out} '<tr><td valign="top" align="right">' 
               htmlib-SideLabel("Charge for Activity?")
               '</td><td valign="top" align="left">'
               htmlib-CheckBox("billingcharge", if lc-billing-charge = 'on'
                                           then true else false)
               '</td></tr>' skip.


    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("description",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Description")
            else htmlib-SideLabel("Description"))
            '</td>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<td valign="top" align="left">'
            htmlib-InputField("description",40,lc-description) 
            '</td>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-description),'left')
           skip.
    {&out} '</tr>' skip.


    {&out} '<tr><td valign="top" align="right">' 
          (if lookup("notes",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("Note")
          else htmlib-SideLabel("Note"))
          '</td>' skip
           '<td valign="top" align="left">'
           htmlib-TextArea("notes",lc-notes,6,40)
          '</td></tr>' skip
           skip.

    {&out} htmlib-EndTable() skip.

    if lc-error-msg <> "" then
    do:
       {&out} '<br><br><center>' 
               htmlib-MultiplyErrorMessage(lc-error-msg) '</center>' skip.
    end.
    {&out} '<center>' skip.

    if lc-submit-label <> "" then
    do:
       {&out}
            Return-Submit-Button("submitform",lc-submit-label,"PrePost()")  skip.

    end.
/*     if lc-mode = "updatesingle" then */
/*     do:                              */
      {&out} 
        '<input class="submitbutton" type="button" onclick="window.close()"' skip
        ' value="Close" />' skip .

/*     end. */
    {&out} '</center>' skip
      '<div style="display:none;">' skip
      '<input class="inputfield" type="checkbox" name="manualTime" id="manualTime" ' lc-manChecked ' >' skip
      '</div>' skip       
      .

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
    and li-int = 0 
    then run htmlib-AddErrorMessage(
                    'hours', 
                    'You must enter the duration',
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
       assign
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
  Purpose:     Process the web request.
  Parameters:  <none>
  emails:       
------------------------------------------------------------------------------*/

    def var li-old-duration     like IssActivity.Duration       no-undo.
    def var li-amount           like IssActivity.Duration       no-undo.

    {lib/checkloggedin.i}

    assign 
        lc-issue-rowid  = get-value("issuerowid")
        lc-rowid        = get-value("rowid")
        lc-mode         = get-value("mode")
        lc-action-rowid = get-value("actionrowid").



 

    find issue
        where rowid(issue) = to-rowid(lc-issue-rowid) NO-LOCK.
    
    find customer where Customer.CompanyCode = Issue.CompanyCode
                    and Customer.AccountNumber = Issue.AccountNumber
                    no-lock no-error.
    find IssAction
        where rowid(IssAction) = to-rowid(lc-action-rowid) no-lock.
    find WebAction
            where WebAction.ActionID = IssAction.ActionID no-lock no-error.

    

    RUN com-GetActivityType ( lc-global-company , output lc-list-actid, output lc-list-activtype, output lc-list-activdesc, output lc-list-activtime ).
    RUN com-GetInternalUser ( lc-global-company , output lc-list-assign , output lc-list-assname ).

    case lc-mode:
        when 'add'
        then assign lc-title = 'Add'
                    lc-link-label = "Cancel addition"
                    lc-submit-label = "Add Activity"
                    lc-manChecked = "" .
        when 'Update' 
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Activity'
                    lc-manChecked = "checked".
        when 'Updatesingle'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Activity'
                    lc-manChecked = "checked".


    end case.

    assign
        lc-title = lc-title + " Activity - Issue " + string(issue.IssueNumber) +
        ' - Action ' + html-encode(WebAction.Description).


    

    if request_method = "POST" then
    do:

        if lc-mode <> "delete" then
        do:                           
            assign lc-activityby       = get-value("activityby")
                   lc-actdate          = get-value("actdate")             
                   lc-StartDate        = get-value("startdate")
                   lc-starthour        = get-value("starthour")
                   lc-startmin         = get-value("startmin")
                   lc-endDate          = get-value("enddate")
                   lc-endhour          = get-value("endhour")
                   lc-endmin           = get-value("endmin")            
                   lc-hours            = get-value("hours")
                   lc-mins             = get-value("mins")
                   lc-sitevisit        = get-value("sitevisit")
                   lc-customerview     = get-value("customerview")
                   lc-description      = get-value("description")         
                   lc-notes            = get-value("notes")  
                   lc-activitytype     = get-value("activitytype")
                   lc-billing-charge   = get-value("billingcharge")
                   lc-timeSecondSet    = get-value("timeSecondSet")
                   .
            
               
            RUN ip-Validate( output lc-error-field,
                             output lc-error-msg ).

            if lc-error-msg = "" then
            do:
                
                if lc-mode = 'update' or lc-mode = 'updatesingle' then
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
                           
                           b-table.ActDate          = date(lc-ActDate)
                           b-table.customerview     = lc-customerview = "on"
                           b-table.SiteVisit        = lc-SiteVisit = "on".
                           b-table.Billable         = lc-billing-charge  = "on".

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
                        assign
                            li-amount = 
                                b-table.Duration - li-old-duration.
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
                'function CloseOut() ~{ ' skip
                ' var ParentWindow = opener' skip
                ' ParentWindow.parent.RefreshDiary() ' skip
                ' window.close() ' skip
                ' ~} ' skip
                '</script>' skip  
                '<style type="text/css">' skip
                'h1 ~{ ' skip
                'color: #0033CC;   ' skip
                '~}' skip
                '</style>' skip
                '<body width="100%">' skip
                '<div  style="font-color:#E0E3E7;margin-left:auto;margin-right:auto;margin-top:80px;text-align:center;"><h1>ActionUpdated</h1><br />' skip

                '<center><input class="submitbutton" type="button" onclick="CloseOut()" value="Close" ></center></div>' skip 
                '</body></html>' skip
                .
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
                   lc-billing-charge  = if b-table.Billable then "on" else ""
                   lc-actdescription  = b-table.ActDescription 
                   lc-saved-activity  = string(Get-Activity( b-table.ActDescription ))
       
                   /*                                                      */
                   /*                                                      */
                   /*                                                      */
                   /*                                                      */
                   /*                                                      */
                   /*                                                      */
                   /*                                                      */
                   /*                                                      */
                   /*                                                      */
                    .
            if b-table.Duration > 0 then
            do:
                run com-SplitTime ( b-table.Duration, output li-hours, output li-mins ).
                assign lc-hours = string(integer(li-hours),"zz99")
                       lc-mins  = string(integer(li-mins),"99").
/*                 if li-hours > 0                                         */
/*                 then assign lc-hours = string(integer(li-hours),"zz9"). */
/*                 if li-mins > 0                                          */
/*                 then assign lc-mins = string(integer(li-mins),"99").    */

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
            lc-customerview     = if Customer.ViewActivity then "on" else ""   
            lc-activityby       = lc-global-user
            lc-actdate          = string(today,"99/99/9999")
            lc-actdescription   = "ACTIVITYDESC"  
            lc-activitytype     = "ACTIVITYTYPE"  
            lc-billing-charge   = if IssAction.Billable then "on" else "" 
            lc-timeSecondSet    = "2"
            lc-mins             = "2"
            lc-startdate        = string(today,"99/99/9999")
            lc-StartHour        = string(int(substr(string(time,"hh:mm"),1,2)))
            lc-StartMin         = substr(string(time,"hh:mm"),4,2)
            lc-enddate          = string(today,"99/99/9999")
            lc-endHour          = string(int(substr(string(time,"hh:mm"),1,2)))
            lc-endMin           = substr(string(time,"hh:mm"),4,2).

             /*                                                      */
             /*                                                      */
             /*                                                      */
             /*                                                      */
             /*                                                      */
             /*                                                      */
             /*                                                      */
             /*                                                      */
             /*                                                      */
            .

    end.

    RUN outputHeader.
    
    {&out} htmlib-OpenHeader(lc-title) skip.

    RUN ip-ExportJScript.

    {&out} htmlib-CloseHeader("") skip.

    {&out}
       htmlib-StartForm("mainform","post", selfurl)
       htmlib-ProgramTitle(lc-title) skip.


  
    if lc-mode <> "update" and lc-mode <> "updatesingle" then
    do:
        {&out}
          '<div align="right">' skip
          '<span id="clockface" class="clockface">' skip
          '....Initializing....' skip
          '</span><img id="throbber" src="/images/ajax/ajax-loader-red.gif"></div>' skip
          '<tr><td valign="top"><fieldset><legend>Main Issue Entry</legend>' skip
          .
    end.
    RUN ip-Page.

    {&out} htmlib-Hidden("issuerowid",lc-issue-rowid) skip
           htmlib-Hidden("mode",lc-mode) skip
           htmlib-Hidden("rowid",lc-rowid) skip
           htmlib-Hidden("actionrowid",lc-action-rowid) skip
           htmlib-Hidden("timeSecondSet",lc-timeSecondSet) skip.


    {&out} htmlib-Hidden("savedactivetype",lc-saved-activity) skip   
           htmlib-Hidden("actDesc",lc-list-activdesc) skip     
           htmlib-Hidden("actTime",lc-list-activtime) skip 
           htmlib-Hidden("actID",lc-list-actid) skip .


    {&out} htmlib-EndForm() skip.


    if not can-do("view,delete",lc-mode)  then
    do:
        {&out}
            htmlib-CalendarScript("actdate") skip
            htmlib-CalendarScript("startdate") skip
            htmlib-CalendarScript("enddate") skip.
    end.
    if lc-mode <> "update" and lc-mode <> "updatesingle" then
    do:
    {&out}
      '<script type="text/javascript">' skip
      'startclock();' skip
      '</script>' skip.
    end.

    {&out}
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-Format-Select-Activity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Activity Procedure 
FUNCTION Format-Select-Activity RETURNS CHARACTER
  ( pc-htm as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<select',
                   '<select onChange="ChangeActivityType()"'). 


  RETURN lc-htm.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Duration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Duration Procedure 
FUNCTION Format-Select-Duration RETURNS CHARACTER
  ( pc-htm as char   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<input',
                   '<input onChange="ChangeDuration()"'). 

  RETURN lc-htm.

  END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Time) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Time Procedure 
FUNCTION Format-Select-Time RETURNS CHARACTER
  ( pc-htm as char, pc-idx as int  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  if pc-idx = 1 then
  lc-htm = replace(pc-htm,'<select',
                   '<select onChange="ChangeDuration(' + string(pc-idx) + ')"'). 
  else
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

  RETURN  integer( entry( lookup(  pc-inp , lc-list-activdesc , "|" ),lc-list-actid , "|" ) ).   /* Function return value. */

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

