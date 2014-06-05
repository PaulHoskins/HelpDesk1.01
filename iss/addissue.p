&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/addissue.p
    
    Purpose:        Add Issue 
    
    Notes:
    
    
    When        Who         What
    06/04/2006  phoski      SearchField populate
    10/04/2006  phoski      CompanyCode
    02/06/2006  phoski      Category
    16/07/2006  phoski      Create from email
    18/07/2006  phoski      Ticket Job
    
    09/08/2010  DJS         3667 - view only active co's & users
    24/04/2012  Phoski      Timer problem when customer is creating
                            & various
        
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var v-debug             as log initial false.

def var lf-Audit            as dec  no-undo.

def var lc-error-field      as char no-undo.
def var lc-error-msg        as char no-undo.

def var lc-accountnumber    as char no-undo.
def var lc-briefdescription as char no-undo.
def var lc-longdescription  as char no-undo.
def var lc-submitsource     as char no-undo.
def var lc-raisedlogin      as char no-undo.
def var li-issue            as int no-undo.
def var lc-date             as char no-undo.
def var lc-AreaCode         as char no-undo.
def var lc-Address          as char no-undo.
def var lc-Ticket           as char no-undo.
def var lc-title            as char no-undo.

def var lc-list-number      as char no-undo.
def var lc-list-name        as char no-undo.

def var lc-list-login       as char no-undo.
def var lc-list-lname       as char no-undo.


def var lc-list-area        as char no-undo.
def var lc-list-aname       as char no-undo.
def var lc-gotomaint        as char no-undo.

def var lc-sla-rows         as char no-undo.
def var lc-sla-selected     as char no-undo.
def var ll-customer         as log  no-undo.

def var lc-default-catcode  as char no-undo.
def var lc-catcode          as char no-undo.
def var lc-list-catcode     as char no-undo.
def var lc-list-cname       as char no-undo.
DEF VAR lc-iclass           AS CHAR NO-UNDO.


def var lc-issuesource      as char no-undo.
def var lc-emailid          as char no-undo.

def var lc-list-actcode     as char no-undo.
def var lc-list-actdesc     as char no-undo.

/* Action Stuff */

def var lc-Quick            as char no-undo.
def var lc-actioncode       as char no-undo.
def var lc-ActionNote       as char no-undo.
def var lc-CustomerView     as char no-undo.
def var lc-activitycharge   as char no-undo.
def var lc-actionstatus     as char no-undo.
def var lc-list-assign      as char no-undo.
def var lc-list-assname     as char no-undo.
def var lc-currentassign    as char no-undo.


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

/* Status */
def var lc-list-status      as char no-undo.
def var lc-list-sname       as char no-undo.
def var lc-currentstatus    as char no-undo.

/* Contract stuff  */

def var lc-list-ctype       as char no-undo.
def var lc-list-cdesc       as char no-undo.
def var lc-contract-type    as char no-undo.

def var lc-billable-flag    as char no-undo.

def var ll-billing          as log  no-undo.
def var lc-timeSecondSet    as char no-undo.
def var lc-timeMinuteSet    as char no-undo.
def var lc-DefaultTimeSet   as char no-undo.
def var lc-manChecked       as char no-undo.

def buffer webStatus        for webStatus.

/** Adding user on the fly */

DEF VAR lc-uadd-loginid AS CHAR NO-UNDO.
DEF VAR lc-uadd-name    AS CHAR NO-UNDO.
DEF VAR lc-uadd-email   AS CHAR NO-UNDO.
DEF VAR lc-uadd-phone   AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-Format-Select-Account) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Account Procedure 
FUNCTION Format-Select-Account RETURNS CHARACTER
  ( pc-htm as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Activity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Activity Procedure 
FUNCTION Format-Select-Activity RETURNS CHARACTER
  ( pc-htm as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Desc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Desc Procedure 
FUNCTION Format-Select-Desc RETURNS CHARACTER
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
         HEIGHT             = 10.31
         WIDTH              = 30.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}
{iss/issue.i}
{lib/ticket.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

find first webStatus
     where webStatus.CompanyCode = lc-global-company
       and webStatus.CompletedStatus = true no-lock no-error.                                   
                                   
/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-AreaSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-AreaSelect Procedure 
PROCEDURE ip-AreaSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&out}  skip
            '<select id="areacode" name="areacode" class="inputfield">' skip.
    {&out}
            '<option value="' dynamic-function("htmlib-Null") '" ' if lc-AreaCode = dynamic-function("htmlib-Null") 
                then "selected" else "" '>Select Area</option>' skip
            '<option value="" ' if lc-AreaCode = ""
                then "selected" else "" '>Not Applicable/Unknown</option>' skip        
            .
    for each webIssArea no-lock
        where webIssArea.CompanyCode = lc-Global-Company 
          break by webIssArea.GroupID
                by webIssArea.AreaCode:

        if first-of(webissArea.GroupID) then
        do:
            find webissagrp
                where webissagrp.companycode = webissArea.CompanyCode
                  and webissagrp.Groupid     = webissArea.GroupID no-lock no-error.
            {&out}
                '<optgroup label="' html-encode(if avail webissagrp then webissagrp.description else "Unknown") '">' skip.
        end.

        {&out}
            '<option value="' webIssArea.AreaCode '" ' if lc-AreaCode = webIssArea.AreaCode  
                then "selected" else "" '>' html-encode(webIssArea.Description) '</option>' skip.

        if last-of(WebIssArea.GroupID) then {&out} '</optgroup>' skip.
    end.

    {&out} '</select>'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ContractSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ContractSelect Procedure 
PROCEDURE ip-ContractSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  
    {&out}  skip
            '<select id="selectcontract" name="selectcontract" class="inputfield"  onchange=~"javascript:ChangeContract();~">' skip.
    {&out}
            '<option value="ADHOC|yes" >Ad Hoc</option>' skip
            .
 

    if lc-accountnumber <> "" then
    do:

      if lc-saved-contract <> "" then  
      do:
        assign lc-contract-type = lc-saved-contract
               ll-billing       = lc-saved-billable = "on"
               lc-billable-flag = lc-saved-billable.
      end.

      if can-find (first WebIssCont                           
               where WebIssCont.CompanyCode     = lc-global-company     
                 and WebIssCont.Customer        = lc-accountnumber            
                 and WebIssCont.ConActive       = true ) 
      then
      do:

        for each WebIssCont no-lock                             
               where WebIssCont.CompanyCode     = lc-global-company     
                 and WebIssCont.Customer        = lc-accountnumber            
                 and WebIssCont.ConActive       = true
                 :                 

          find first ContractType  where ContractType.CompanyCode = WebIssCont.CompanyCode
                                    and  ContractType.ContractNumber = WebIssCont.ContractCode 
            no-lock no-error.
                                      
           if WebIssCont.DefCon and lc-saved-contract = "" then 
              assign lc-contract-type = WebIssCont.ContractCode
                     ll-billing       = WebissCont.Billable
                     lc-billable-flag = if ll-billing then "on" else "".

      {&out}
            '<option value="' WebIssCont.ContractCode "|" string(WebissCont.Billable) '" ' 
             
             if lc-contract-type = WebIssCont.ContractCode
                then " selected " else "" '>' 
                  
                  html-encode(if avail ContractType then ContractType.Description else "Unknown") '</option>' skip.
 
        end.
      end.
    end.
      

    {&out} '</select>'.

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
       '  var startTime         = internalTime(startHourOption,startMinuteOption) ; '  skip
       '  var endTime           = internalTime(endHourOption,endMinuteOption) ; '  skip
       '  var durationTime      = internalTime(curHourDuration,curMinDuration) ; '  skip
       '  document.mainform.manualTime.checked = true;' skip
       '  document.mainform.ffmins.value = (curMinDuration < 10 ? "0" : "") + curMinDuration ;' skip
       '  manualTime = true; ' skip 


/*        '  document.mainform.ffmins.value = (curMinDuration < 10 ? "0" : "") + curMinDuration ;' skip                                                         */
/*        '  if (manualTime) return;  ' skip                                                                                                                    */
/*        '  if ( (endTime - startTime) != 0  || (endTime - startTime) != durationTime || !manualTime )' skip                                                   */
/*        '  ~{' skip                                                                                                                                           */
/*        '      alert("The duration entered does not match with the Start and End time! ~\n ~\n                              Setting to Manual Time."); ' skip */
/*        '      document.getElementById("throbber").src="/images/ajax/ajax-loaded-red.gif"; ' skip                                                             */
/*        '      document.mainform.manualTime.checked = true; ' skip                                                                                            */
/*        '      manualTime = true; ' skip                                                                                                                      */
/*        '  ~}' skip                                                                                                                                           */
       '~}' skip.

    /*
    ***
    *** only for internal users, customer don't have a timer
    ***
    */
    IF NOT ll-customer THEN
    {&out}
      
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
       '  var startTime         = internalTime(startHourOption,startMinuteOption) ; '  skip
       '  var endTime           = internalTime(endHourOption,endMinuteOption) ; '  skip
       '  var durationTime      = internalTime(curHourDuration,curMinDuration) ; '  skip
      '  if ( (endTime - startTime) != 0  && (endTime - startTime) != durationTime )' skip
      '  ~{' skip
      '     var answer = confirm("The duration entered does not match with the Start and End time! ~\n ~\n      Press Cancel if you want to update the times before posting"); ' skip
      '     if (answer) ~{ document.forms["mainform"].submit();  ~} ' skip
      '     else  ~{ return false;  ~} ' skip
      '  ~}' skip
      '  else ~{ document.forms["mainform"].submit();  ~} ' skip
      '~}' skip.
    ELSE
    {&out}
    ' function PrePost(Indx) ' skip
      '~{' skip
       
      '  document.forms["mainform"].submit();   ' skip
      '~}' skip.



    {&out} SKIP



       'function internalTime(piHours,piMins) ' skip
       '~{' skip
       '  return ( ( piHours * 60 ) * 60 ) + ( piMins * 60 ); ' skip
       '~}' skip.

    {&out} skip
        'function ChangeAccount() ~{' skip
        '   SubmitThePage("AccountChange")' skip
        '~}' skip.

    {&out} skip
        'function Quick(box) ~{' skip
        ' if ( box.checked == true) ~{' skip
        '   document.mainform.actionstatus.value="CLOSED";' skip.
          if avail webStatus 
          then {&out} '   document.mainform.currentstatus.value="' webStatus.StatusCode '";' skip.
    {&out}
        '   return;' skip
        '~}' skip
        '   document.mainform.actionstatus.value="OPEN";' skip
        '   document.mainform.currentstatus.value="' entry(1,lc-list-status,"|") '";' skip
        '~}' skip.
    {&out} skip
        '</script>' skip.

    {&out} 
        '<script>' skip
        'function copyinfo() ~{' skip
        'document.mainform.elements["actionnote"].value = document.mainform.elements["longdescription"].value' skip
        '~}' skip
        '</script>' skip.

    {&out} 
      '<script type="text/javascript" language="JavaScript">' skip
      '// --  Clock --' skip
      'var timerID = null;' skip
      'var timerRunning = false;' skip
      'var timerStart = null;' skip
      'var timeSet = null;' skip
      'var defaultTime = parseInt(' lc-DefaultTimeSet ',10);' skip
      'var timeSecondSet = parseInt(' lc-timeSecondSet ',10);' skip
      'var timeMinuteSet = parseInt(' lc-timeMinuteSet ',10);' skip
      'var timeHourSet = 0;' skip
      'var timerStartseconds = 0;' skip
      
      'function manualTimeSet()~{' skip
      'manualTime = (manualTime == true) ? false : true;' skip
      'if (!manualTime) ~{document.getElementById("throbber").src="/images/ajax/ajax-loader-red.gif"~}' skip
      'else ~{document.getElementById("throbber").src="/images/ajax/ajax-loaded-red.gif"~}' skip
      '~}' skip

      'function stopclock()~{' skip
      'if(timerRunning)' skip
      'clearTimeout(timerID);' skip
      'timerRunning = false;' skip
      '~}' skip

      'function startclock()~{' skip
      'stopclock();' skip
      'timeHourSet = 0;' skip
      'document.getElementById("clockface").innerHTML =  "00" +   ((defaultTime < 10) ? ":0" : ":") + defaultTime  + ":00" ' skip
      'document.mainform.ffmins.value = ((defaultTime < 10) ? "0" : "") + defaultTime ' skip
      'showtime();' skip
      '~}' skip


      'function showtime()~{' skip
      'var curMinuteOption;' skip
      'var curHourOption;' skip
      'var now = new Date()' skip
      'var hours = now.getHours()' skip
      'var minutes = now.getMinutes()' skip
      'var seconds = now.getSeconds()' skip
      'var millisec = now.getMilliseconds()' skip
      'var timeValue = "" +   hours' skip
      'timeSecondSet = timeSecondSet + 1' skip
      'if (!manualTime)' skip
      '~{'
      'timeValue  += ((minutes < 10) ? ":0" : ":") + minutes' skip
      'timeValue  += ((seconds < 10) ? ":0" : ":") + seconds' skip
      'curHourOption = document.getElementById("endhour"  + ((hours == 0) ? "0" : "") + hours) ' skip
      'curHourOption.selected = true' skip
      'curMinuteOption = document.getElementById("endmin" + ((minutes < 10) ? "0" : "") + minutes)' skip
      'curMinuteOption.selected = true' skip
      'if ( timeSecondSet >= 60 ) ~{ timeSecondSet = 0 ; timeMinuteSet = timeMinuteSet + 1; ~}' skip
      'if ( timeMinuteSet >= 60 ) ~{ timeMinuteSet = 0 ; timeHourSet = timeHourSet + 1; ~}' skip
      'if ( defaultTime <= timeMinuteSet || defaultTime == 0 )' skip
      '  ~{' skip
      '     document.mainform.ffhours.value = ((timeHourSet  < 10) ? "0" : "") + timeHourSet' skip
      '     document.mainform.ffmins.value = ((timeMinuteSet < 10) ? "0" : "") + timeMinuteSet ' skip
      '     document.getElementById("clockface").innerHTML = ((timeHourSet < 10) ? "0" : "") + timeHourSet '
      '       +   ((timeMinuteSet < 10) ? ":0" : ":") + timeMinuteSet  + ((timeSecondSet < 10) ? ":0" : ":") + timeSecondSet ' skip
      '  ~}'  skip
      '~}' skip
      'document.getElementById("timeSecondSet").value = timeSecondSet ;' skip
      'document.getElementById("timeMinuteSet").value = timeMinuteSet ;' skip
      'timerRunning = true;' skip
      'timerID = setTimeout("showtime()",1000);' skip
      '~}' skip
      '</script>' skip
      .

    {&out} 
        '<script language="JavaScript" src="/scripts/js/tree.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/prototype.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/scriptaculous.js"></script>' skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GenHTML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GenHTML Procedure 
PROCEDURE ip-GenHTML :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&out} htmlib-Header(lc-title) skip.
    RUN ip-ExportJScript.

    {&out} htmlib-StartForm("mainform","post", appurl + '/iss/addissue.p' ) htmlib-ProgramTitle(lc-title) skip.
    
    if not ll-Customer then
    do:
            {&out} htmlib-StartInputTable() skip
                    '<tr><td>&nbsp;</td><td  align="right" width="50%">' skip
                    '<span id="clockface" class="clockface">' skip
                    '0:00:00' skip
                    '</span><img id="throbber" src="/images/ajax/ajax-loader-red.gif"></td></tr>' skip
                    '<tr><td valign="top"><fieldset><legend>Main Issue Entry</legend>' skip                 .
    end.
    run ip-MainEntry.
    if not ll-Customer then 
    do: 
            {&out} '</td><td valign="top" style="padding-left: 5px;">' skip .
            RUN ip-QuickFinish.
            {&out} '</td></tr>'.
            {&out} htmlib-EndTable().
            {&out} '</fieldset>' skip
                    '</td></tr>' skip.
    end.
    if lc-error-msg <> "" then
    do:
            {&out} '<br><br><center>' 
                                            htmlib-MultiplyErrorMessage(lc-error-msg) '</center>' skip.
    end.
    {&out} '<center>' Return-Submit-Button("submitform","Add Issue","PrePost()") 
                                     '</center>' skip.
    if not ll-Customer and can-find(customer where customer.CompanyCode = lc-global-company and 
                                    customer.AccountNumber = lc-AccountNumber) then
    do:
        RUN ip-Inventory ( lc-global-company, lc-AccountNumber ).
    end.

    {&out} htmlib-Hidden("submitsource","null") skip
         htmlib-Hidden("emailid",lc-emailid) skip
         htmlib-Hidden("issuesource",lc-issuesource) skip
         htmlib-Hidden("timeSecondSet",lc-timeSecondSet) skip
         htmlib-Hidden("timeMinuteSet",lc-timeMinuteSet) skip
         htmlib-Hidden("defaultTime",lc-DefaultTimeSet) skip
         htmlib-Hidden("contract",lc-contract-type) skip
         htmlib-Hidden("billable",lc-billable-flag) skip
         htmlib-Hidden("savedactivetype",lc-saved-activity) skip   
         htmlib-Hidden("actDesc",lc-list-activdesc) skip     
         htmlib-Hidden("actTime",lc-list-activtime) skip 
         htmlib-Hidden("actID",lc-list-actid) skip 
         htmlib-EndForm() skip.
    if not ll-customer then
    {&out}  htmlib-CalendarScript("date") skip
                                    htmlib-CalendarScript("startdate") skip
                                    htmlib-CalendarScript("enddate") skip.
    {&out}
    '<script type="text/javascript">' skip
    'startclock();' skip
    '</script>' skip.
    {&out} htmlib-Footer() skip.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GetAccountNumbers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GetAccountNumbers Procedure 
PROCEDURE ip-GetAccountNumbers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-user          as char no-undo.
    def output param pc-AccountNumber as char no-undo.
    def output param pc-Name          as char no-undo.

    def buffer b-user for WebUser.
    def buffer b-cust for Customer.


    find b-user where b-user.LoginID = pc-user no-lock no-error.

    assign pc-AccountNumber = htmlib-Null()
           pc-Name          = "Select Account".


    for each b-cust no-lock
             where b-cust.CompanyCode = b-user.CompanyCode
             and   b-cust.isActive = true   /* 3667 */
             by b-cust.name:

        assign pc-AccountNumber = pc-AccountNumber + '|' + b-cust.AccountNumber
               pc-Name          = pc-Name + '|' + b-cust.name.

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GetArea) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GetArea Procedure 
PROCEDURE ip-GetArea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

    def output param pc-AreaCode as char no-undo.
    def output param pc-Description          as char no-undo.

    
    def buffer b-cust for WebIssArea.

   
    assign pc-AreaCode = htmlib-Null() + '|'
           pc-Description          = "Select Area|Not Applicable/Known".


    for each b-cust no-lock
        where b-cust.CompanyCode = lc-global-company
            :

        assign pc-AreaCode       = pc-AreaCode + '|' + b-cust.AreaCode
               pc-Description    = pc-Description + '|' + b-cust.Description.

    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GetCatCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GetCatCode Procedure 
PROCEDURE ip-GetCatCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param pc-CatCode as char no-undo.
    def output param pc-Description          as char no-undo.

    
    def buffer b-Cat for WebIssCat.

   
    assign pc-CatCode = ""
           pc-Description = "".

    for each b-Cat no-lock
        where b-Cat.CompanyCode = lc-global-company
           by b-Cat.description
            :

        if pc-CatCode = ""
        then assign  pc-CatCode     = b-Cat.CatCode
                     pc-Description = b-Cat.Description.
        else assign pc-CatCode      = pc-CatCode + '|' + b-Cat.CatCode
                    pc-Description  = pc-Description + '|' + b-Cat.Description.

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GetContract) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GetContract Procedure 
PROCEDURE ip-GetContract :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-Account       as char no-undo.
    def output param pc-Type          as char no-undo.
    def output param pc-Contract      as char no-undo.

 

    if pc-Account <> "" then
    do:
      if can-find (first WebIssCont                           
               where WebIssCont.CompanyCode     = lc-global-company     
                 and WebIssCont.Customer        = pc-Account            
                 and WebIssCont.ConActive       = true ) 
      then
      do:
        assign pc-Type  = '0'
               pc-Contract = "AdHoc".

        for each WebIssCont no-lock                             
               where WebIssCont.CompanyCode     = lc-global-company     
                 and WebIssCont.Customer        = pc-Account            
                 and WebIssCont.ConActive       = true
                 :                 
                                                                  
                                      
/*            if WebIssCont.DefCon then assign lc-contract-type = WebIssCont.ContractCode. */
/*                                                                                         */
/*            assign pc-Type          = htmlib-Null() + '|0'     */
/*                   pc-Contract      = "Select Contract|AdHoc". */
   
    
            assign pc-Type     = pc-Type      + '|' + string(ContractType.ContractNumber)
                   pc-Contract = pc-Contract  + '|' + ContractType.Description.
    
        end.
      end.
      else
      do:
        assign pc-Type  = '0'
               pc-Contract = "AdHoc".
      end.
    end.                                                        
    else
    do:
      assign pc-Type  = '0'
             pc-Contract = "AdHoc".
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GetOwner) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GetOwner Procedure 
PROCEDURE ip-GetOwner :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-Account       as char no-undo.
    def output param pc-Login         as char no-undo.
    def output param pc-Name          as char no-undo.

    def buffer b-user for WebUser.

    if pc-Account <> "" then
    do:                                                          /* 3667 */  
      find first b-user no-lock                                  /* 3667 */
             where b-user.CompanyCode   = lc-global-company      /* 3667 */
               and b-user.AccountNumber = pc-Account             /* 3667 */  
               and b-user.Disabled      = false                  /* 3667 */  
               and b-user.DefaultUser   = true                   /* 3667 */  
                                      no-error.                  /* 3667 */  
                                                                 
      if avail b-user then                                       /* 3667 */  
         assign pc-login = b-user.loginid  + '|'                 /* 3667 */  
                pc-Name  = b-user.name     + '|Not Applicable'.  /* 3667 */  
      else
         assign pc-login = htmlib-Null() + '|'
                pc-Name  = "Select Person|Not Applicable".

      for each b-user no-lock
               where b-user.CompanyCode   = lc-global-company
                 and b-user.AccountNumber = pc-Account
                 and b-user.Disabled      = false               /* 3667 */  
                 and b-user.DefaultUser   = false               /* 3667 */  
               by b-user.name:
  
          assign pc-login = pc-login  + '|' + b-user.loginid
                 pc-Name  = pc-Name + '|' + b-user.name.
  
      end.
    end.                                                        /* 3667 */  
    else
    do:
      assign pc-login = htmlib-Null() + '|'
             pc-Name  = "Select Person|Not Applicable".
    end.

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

&IF DEFINED(EXCLUDE-ip-Inventory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Inventory Procedure 
PROCEDURE ip-Inventory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    
    def buffer Customer for Customer.
    def buffer ivClass  for ivClass.
    def buffer ivSub    for ivSub.
    def buffer b-query for CustIv.
    def buffer b-search for CustIv.

    def var lc-object           as char no-undo.
    def var lc-subobject        as char no-undo.
    def var lc-ajaxSubWindow    as char no-undo.
    def var lc-expand           as char no-undo.
    
    def var lc-update-id as char no-undo.


    lc-expand = "yes".

    find customer 
        where customer.CompanyCode = pc-CompanyCode
          and customer.AccountNumber = pc-AccountNumber
          no-lock.

    
    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').

    {&out}
            htmlib-TableHeading(
            "Select Inventory|"
            ) skip.

    
    {&out}
        '<tr class="tabrow1">'
        '<td valign="top" nowrap class="tree">' skip
        .
    for each b-query no-lock of customer,
        first ivSub no-lock of b-query,
        first ivClass no-lock of ivSub
        break 
              by ivClass.DisplayPriority desc
              by ivClass.name
              by ivSub.DisplayPriority desc
              by ivSub.name
              by b-query.Ref:

        
        

        assign 
            lc-object = "CLASS" + string(rowid(ivClass))
            lc-subobject = "SUB" + string(rowid(ivSub)).
        if first-of(ivClass.name) then
        do:
            if lc-expand = "yes" 
            then {&out} '<img src="/images/general/menuopen.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">'
                '&nbsp;' '<span style="' ivClass.Style '">' html-encode(ivClass.name) '</span><br>'
                '<div id="' lc-object '" style="padding-left: 15px; display: block;">' skip.
            else {&out}
                '<img src="/images/general/menuclosed.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">'
                '&nbsp;' '<span style="' ivClass.Style '">' html-encode(ivClass.name) '</span><br>'
                '<div id="' lc-object '" style="padding-left: 15px; display: none;">' skip.
        end.

        if first-of(ivSub.name) then
        do:
            
            if lc-expand = "yes"
            then {&out} 
                '<img src="/images/general/menuopen.gif" onClick="hdexpandcontent(this, ~''
                        lc-subobject '~')">'
                '&nbsp;'
                '<span style="' ivSub.Style '">'
                html-encode(ivSub.name) '</span><br>' skip
                '<div id="' lc-subobject '" style="padding-left: 15px; display: block;">' skip.
                
            else {&out} 
                '<img src="/images/general/menuclosed.gif" onClick="hdexpandcontent(this, ~''
                        lc-subobject '~')">'
                '&nbsp;'
                '<span style="' ivSub.Style '">'
                html-encode(ivSub.name) '</span><br>' skip
                '<div id="' lc-subobject '" style="padding-left: 15px; display: none;">' skip.
        end.
       
        {&out} '<a href="'
                    "javascript:ahah('" 
                    
                    appurl "/cust/custequiptable.p?rowid=" string(rowid(b-query))

                    "','inventory');".

        
        {&out}
                    '">' html-encode(b-query.ref) '</a><br>' skip.

        
        
        if last-of(ivSub.name) then
        do:
            {&out} '</div>' skip.
            
             
        end.


        if last-of(ivClass.name) then
        do:
            {&out} '</div>' skip.
            
        end.

        
            
    end.

    {&out} '</td>' skip.
                
    {&out} '<td valign="top" rowspan="100" ><div id="inventory">&nbsp;</div></td>'.
    {&out} '</tr>' skip.


    {&out} skip 
           htmlib-EndTable()
           skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-MainEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-MainEntry Procedure 
PROCEDURE ip-MainEntry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&out} htmlib-StartInputTable() skip.
    
    DEF BUFFER bcust    FOR customer.

    if not ll-customer then
    do:
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("accountnumber",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Account")
            else htmlib-SideLabel("Account"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">'
            format-Select-Account(htmlib-Select("accountnumber",lc-list-number,lc-list-name,
                lc-accountnumber) )
            '</TD></TR>' skip. 
    end.
    else
    do:
        {&out} '<tr><td valign="top" align="right">'
                    htmlib-SideLabel("Account")
                    '</td>'
                    htmlib-TableField(
                        replace(html-encode(lc-accountnumber + " " + customer.name + '~n' + lc-address),
                                "~n","<br>")
                        
                        ,'left')
                    

                '</tr>' skip.
        find company where company.companycode = lc-global-company
            no-lock no-error.
        if company.issueinfo <> "" then
        do:
            {&out} '<tr><td colspan="2">'
                '<div class="infobox">'
                replace(html-encode(company.issueinfo),'~n','<br>')
                '</div>'
                '</td></tr>' skip.

        end.

    end.
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("raisedlogin",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Raised By")
            else htmlib-SideLabel("Raised By"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("raisedlogin",lc-list-login,lc-list-lname,lc-raisedlogin)
            '</TD></TR>' skip. 

    {&out} '<TR><TD VALIGN="TOP" ALIGN="left" colspan=2>'  SKIP.
    

    RUN ip-NewUserHTML.

    {&out} '</td></tr>' SKIP. /* end of new user */

   



    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("areacode",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Area")
            else htmlib-SideLabel("Area"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">'
            skip(4).

    RUN ip-AreaSelect.

    {&out}
            '</TD></TR>' skip. 

    if not ll-customer then
    do:

        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
                (if lookup("date",lc-error-field,'|') > 0 
                then htmlib-SideLabelError("Date")
                else htmlib-SideLabel("Date"))
                '</TD>'
                '<TD VALIGN="TOP" ALIGN="left">'
                htmlib-InputField("date",10,lc-date) 
                htmlib-CalendarLink("date")
                '</TD>' skip.
        {&out} '</TR>' skip.


    
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
                (if lookup("contract",lc-error-field,'|') > 0 
                then htmlib-SideLabelError("Contract")
                else htmlib-SideLabel("Contract"))
                '</TD>' 
                '<TD VALIGN="TOP" ALIGN="left">'.


        RUN ip-ContractSelect.

        {&out} '</TD></tr> ' skip.  

        {&out} '<tr><td valign="top" align="right">' 
            htmlib-SideLabel("Billable?")
            '</td><td valign="top" align="left">'
            replace(htmlib-CheckBox("billcheck", if ll-billing then true else false),
                    '>',' onClick="ChangeBilling(this);">')
            '</td></tr>' skip.
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
                (if lookup("iclass",lc-error-field,'|') > 0 
                then htmlib-SideLabelError("Class")
                else htmlib-SideLabel("Class"))
                '</TD>' 
                '<TD VALIGN="TOP" ALIGN="left">'
                htmlib-Select("iclass",lc-global-iclass-code,lc-global-iclass-code,lc-iclass)
                '</TD></TR>' skip. 





    end.
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("briefdescription",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Brief Description")
            else htmlib-SideLabel("Brief Description"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("briefdescription",50,lc-briefdescription) 
            '</TD>' skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           (if lookup("longdescription",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Details")
           else htmlib-SideLabel("Details"))
           '</TD>' skip
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TextArea("longdescription",lc-longdescription,10,40)
           '</TD>' skip
            skip.
    
    if lc-sla-rows <> "" and lc-accountnumber <> "" and not ll-customer then
    do:
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
               (if lookup("sla",lc-error-field,'|') > 0 
               then htmlib-SideLabelError("SLA")
               else htmlib-SideLabel("SLA"))
               '</TD>'
               '<TD VALIGN="TOP" ALIGN="left">' skip.
        RUN ip-SLATable.
        {&out}
               '</TD>' skip.
        {&out} '</TR>' skip.

    end.
    IF NOT ll-customer  AND can-find(customer where customer.companycode = lc-global-company
                                     and customer.AccountNumber = lc-AccountNumber) THEN
    DO:

        FIND bcust where bcust.companycode = lc-global-company
                     and bcust.AccountNumber = lc-AccountNumber NO-LOCK NO-ERROR.

       IF AVAIL bcust AND bcust.SupportTicket <> "none" THEN
       {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
                    (if lookup("iclass",lc-error-field,'|') > 0 
                    then htmlib-SideLabelError("Ticket Balance")
                    else htmlib-SideLabel("Ticket Balance"))
                    '</TD>' 
                    '<TD VALIGN="TOP" ALIGN="left">'
                    dynamic-function("com-TimeToString",bcust.ticketBalance)
                    '</TD></TR>' skip. 




    END.


    if can-find(customer where customer.companycode = lc-global-company
                           and customer.AccountNumber = lc-AccountNumber)
    and com-AskTicket(lc-global-company,lc-AccountNumber) then
    do:
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("ticket",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Ticketed Issue?")
            else htmlib-SideLabel("Ticketed Issue?"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
                htmlib-CheckBox("ticket", if lc-ticket = 'on'
                                        then true else false) 
            '</TD></TR>' skip.
    end.

    if not ll-customer then
    do:
        if lc-list-catcode <> "" then
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("catcode",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Category")
            else htmlib-SideLabel("Category"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("catcode",lc-list-catcode,lc-list-cname,
                lc-catcode)
            '</TD></TR>' skip. 

        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("gotomaint",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Update Issue Now?")
            else htmlib-SideLabel("Update Issue Now?"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("gotomaint", if lc-gotomaint = 'on'
                                        then true else false) 
            '</TD></TR>' skip.
    end.

    

    {&out} htmlib-EndTable() skip.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-NewUserHTML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-NewUserHTML Procedure 
PROCEDURE ip-NewUserHTML :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    {&out} htmlib-BeginCriteria("Or Create New User").

    {&out}
        htmlib-StartMntTable().
    
    {&out} '</td></tr>' SKIP.
    
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (if lookup("uadd-loginid",lc-error-field,'|') > 0 
        then htmlib-SideLabelError("User ID")
        else htmlib-SideLabel("User ID"))
        '</TD>' 
        '<TD VALIGN="TOP" ALIGN="left">'
         htmlib-InputField("uadd-loginid",10,lc-uadd-loginid) 
        '</TD></TR>' skip. 
        
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
         (if lookup("uadd-name",lc-error-field,'|') > 0 
         then htmlib-SideLabelError("Name")
         else htmlib-SideLabel("Name"))
         '</TD>' 
         '<TD VALIGN="TOP" ALIGN="left">'
          htmlib-InputField("uadd-name",40,lc-uadd-name) 
         '</TD></TR>' skip. 
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (if lookup("uadd-email",lc-error-field,'|') > 0 
        then htmlib-SideLabelError("Email")
        else htmlib-SideLabel("Email"))
        '</TD>' 
        '<TD VALIGN="TOP" ALIGN="left">'
        htmlib-InputField("uadd-email",40,lc-uadd-email) 
        '</TD></TR>' skip. 
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
         (if lookup("uadd-phone",lc-error-field,'|') > 0 
         then htmlib-SideLabelError("Telephone")
         else htmlib-SideLabel("Telephone"))
         '</TD>' 
         '<TD VALIGN="TOP" ALIGN="left">'
          htmlib-InputField("uadd-phone",40,lc-uadd-phone) 
         '</TD></TR>' skip. 
    
    {&out} skip 
        htmlib-EndTable()
         htmlib-EndCriteria() skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-QuickFinish) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-QuickFinish Procedure 
PROCEDURE ip-QuickFinish :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 
 
    {&out} 
           '<fieldset><legend>Quick Issue Resolution</legend>'.
            

    {&out} htmlib-CustomerViewable(lc-global-company,lc-AccountNumber).

    {&out} htmlib-StartInputTable() skip.

    {&out} '<tr><td valign="top" align="right">' 
            htmlib-SideLabel("Issue Resolved?")
            '</td><td valign="top" align="left">'
            replace(htmlib-CheckBox("quick", if lc-quick = 'on'
                                        then true else false),
                    '>',' onClick="Quick(this);">')
            '</td></tr>' skip.

    {&out} '<tr><td valign="top" align="right">' 
             (if lookup("currentstatus",lc-error-field,'|') > 0 
             then htmlib-SideLabelError("Issue Status")
             else htmlib-SideLabel("Issue Status"))
             '</td>' 
             '<td valign="top" align="left">'
             htmlib-Select("currentstatus",lc-list-status,lc-list-sname,lc-currentstatus)
             '</td></tr>' skip. 

  {&out} '<tr><td valign="top" align="right">' 
          (if lookup("currentassign",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("Issue/Action Assigned To")
          else htmlib-SideLabel("Issue/Action Assigned To"))
          '</td>' 
          '<td valign="top" align="left">'
          htmlib-Select("currentassign",lc-list-assign,lc-list-assname,
              lc-currentassign)
          '</td></tr>' skip. 

    {&out} '<tr><td valign="top" align="right">' 
           ( if lookup("actioncode",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Action Type")
           else htmlib-SideLabel("Action Type"))
           '</td>' skip
           '<td valign="top" align="left">'
           htmlib-Select("actioncode",lc-list-actcode,lc-list-actdesc,
                lc-actioncode)
           '</td></tr>' skip.

    {&out} '<tr><td valign="top" align="right">' 
          (if lookup("actionnote",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("Note")
          else htmlib-SideLabel("Note"))
          '</td>' skip
           '<td valign="top" align="left">'
           '<input type="button" class="submitbutton" onclick="copyinfo();" value="Copy Issue Details"><br>'
           htmlib-TextArea("actionnote",lc-actionnote,6,40)
          '</td></tr>' skip
           skip.

    {&out} '<tr><td valign="top" align="right">' 
            htmlib-SideLabel("Customer View?")
            '</td><td valign="top" align="left">'
            htmlib-CheckBox("customerview", if lc-customerview = 'on'
                                        then true else false) 
            '</td></tr>' skip.

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("actionstatus",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Action Status")
            else htmlib-SideLabel("Action Status"))
            '</td><td valign="top" align="left">'
            htmlib-Select("actionstatus",lc-global-action-code,lc-global-action-display,lc-actionstatus)
            '</td></tr>' 
            
        skip.

    {&out} '<tr><td valign="top" align="right">' 
             (if lookup("activitytype",lc-error-field,'|') > 0 
             then htmlib-SideLabelError("Activity Type")
             else htmlib-SideLabel("Activity Type"))
             '</td>' 
             '<td valign="top" align="left">'
             Format-Select-Activity(htmlib-Select("activitytype",lc-list-actid,lc-list-activtype,lc-saved-activity)) skip
             '</td></tr>' skip. 

                   
                    
/*     {&out} '<tr><td colspan="2">'                                                                                    */
/*                                                                                                                      */
/*                 '<div class="infobox" style="font-size: 10px;">'                                                     */
/*                         'Activity Details<br>An activity will only be recorded if you enter an Activity Description' */
/*                 '</div>'                                                                                             */
/*                                                                                                                      */
/*             '</td></tr>'.                                                                                            */

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("startdate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Start Date")
            else htmlib-SideLabel("Start Date"))
            '</td>'.
    
    
    {&out} '<td valign="top" align="left">'
            htmlib-InputField("startdate",10,lc-startdate) 
            htmlib-CalendarLink("startdate")
            "&nbsp;@&nbsp;"
            htmlib-TimeSelect("starthour",lc-starthour,"startmin",lc-startmin)
            '</td>' skip.
    
           
    {&out} '</tr>' skip.

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("enddate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("End Date")
            else htmlib-SideLabel("End Date"))
            '</td>'.
    
    {&out} '<td valign="top" align="left">'
            htmlib-InputField("enddate",10,lc-enddate) 
            htmlib-CalendarLink("enddate")
            "&nbsp;@&nbsp;"
            htmlib-TimeSelect-By-Id("endhour",lc-endhour,"endmin",lc-endmin)
            '</td>' skip.
    
    {&out} '</tr>' skip.



    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("hours",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Duration (HH:MM)")
            else htmlib-SideLabel("Duration (HH:MM)"))
            '</td>'.
    
    {&out} '<td valign="top" align="left">'
            Format-Select-Duration(htmlib-InputField("hours",4,lc-hours))
            ':'
            Format-Select-Duration(htmlib-InputField("mins",2,lc-mins))
            '</td>' skip.
    
    {&out} '</tr>' skip.

    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("manualTime",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Manual Time Entry?")
            else htmlib-SideLabel("Manual Time Entry?"))
            '</td>'.


     {&out} '<td valign="top" align="left">'
             '<input class="inputfield" type="checkbox" onclick="javascript:manualTimeSet()" id="manualTime" name="manualTime" ' lc-manChecked ' >' 
             '</td></tr>' skip.




    {&out} '<tr><td valign="top" align="right">' 
            (if lookup("actdescription",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Activity Description")
            else htmlib-SideLabel("Activity Description"))
            '</td><td valign="top" align="left">'
/*             htmlib-InputField("actdescription",40,lc-actdescription) */
      Format-Select-Desc(htmlib-ThisInputField("actdescription",40,lc-actdescription) )
            '</td></tr>' skip.


/*     {&out} '<tr><td valign="top" align="right">'                          */
/*             htmlib-SideLabel("Charge for Activity?")                      */
/*             '</td><td valign="top" align="left">'                         */
/*             htmlib-CheckBox("activitycharge", if lc-activitycharge = 'on' */
/*                                         then true else false)             */
/*             '</td></tr>' skip.                                            */



    

    {&out} htmlib-EndTable() skip.

    {&out}
                
                '</fieldset>'
                '</td></tr>' skip.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-QuickUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-QuickUpdate Procedure 
PROCEDURE ip-QuickUpdate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def var lr-Action       as rowid        no-undo.
    def var lr-Issue        as rowid        no-undo.
    def var li-amount       as int          no-undo.

    if lc-actionCode <> lc-global-selcode then
    do:
        find WebAction
            where WebAction.CompanyCode = lc-global-company
              and WebAction.ActionCode  = lc-ActionCode
              no-lock no-error.
        create IssAction.
        assign IssAction.actionID     = WebAction.ActionID
               IssAction.CompanyCode  = lc-global-company
               IssAction.IssueNumber  = issue.IssueNumber
               IssAction.CreateDate   = today
               IssAction.CreateTime   = time
               IssAction.CreatedBy    = lc-global-user
               IssAction.customerview = lc-customerview = "on"
               .
    
        do while true:
            run lib/makeaudit.p (
                "",
                output lf-audit
                ).
            if can-find(first IssAction
                        where IssAction.IssActionID = lf-audit no-lock)
                        then next.
            assign
                IssAction.IssActionID = lf-audit.
            leave.
        end.
        assign IssAction.notes        = lc-actionnote
               IssAction.ActionStatus = lc-ActionStatus
               IssAction.ActionDate   = today
               IssAction.customerview = lc-customerview = "on"
               IssAction.AssignTo     = lc-currentassign
               IssAction.AssignDate   = today
               IssAction.AssignTime   = time.
    
        assign
            lr-Action = rowid(issAction).
        release issAction.
        
        find issAction where rowid(issAction) = lr-Action exclusive-lock.
    
        dynamic-function("islib-CreateAutoAction",issAction.IssActionID).
    
        if lc-ActDescription <> "" then
        do:
    
            
            create IssActivity.
            assign IssActivity.IssActionID = IssAction.IssActionID
                   IssActivity.CompanyCode = lc-global-company
                   IssActivity.IssueNumber = issue.IssueNumber
                   IssActivity.CreateDate  = today
                   IssActivity.CreateTime  = time
                   IssActivity.CreatedBy   = lc-global-user
                   IssActivity.ActivityBy  = lc-CurrentAssign .
        
            do while true:
                run lib/makeaudit.p (
                    "",
                    output lf-audit
                    ).
                if can-find(first IssActivity
                            where IssActivity.IssActivityID = lf-audit no-lock)
                            then next.
                assign
                    IssActivity.IssActivityID = lf-audit.
                leave.
            end.
            assign IssActivity.Description     = lc-briefdescription
                   IssActivity.ActDate         = today
                   IssActivity.Customerview    = lc-customerview = "on"
                   issActivity.ActDescription  = lc-actdescription
                   issActivity.Billable        = lc-billable-flag = "on"
                   issActivity.ContractType    = lc-contract-type
                   issActivity.CustomerView    = lc-customerview = "on"
                   issActivity.Notes           = lc-actionnote.
        
            if lc-startdate <> "" then
            do:
                assign IssActivity.StartDate = date(lc-StartDate).
        
                assign IssActivity.StartTime = dynamic-function("com-InternalTime",
                                 int(lc-starthour),
                                 int(lc-startmin)
                                 ).
            end.
            else assign IssActivity.StartDate = ?
                        IssActivity.StartTime = 0.
        
            if lc-enddate <> "" then
            do:
                assign IssActivity.EndDate = date(lc-endDate).
        
                assign IssActivity.Endtime = dynamic-function("com-InternalTime",
                                int(lc-endhour),
                                int(lc-endmin)
                                ).
                
            end.
            else assign IssActivity.EndDate = ?
                        IssActivity.EndTime = 0.
        
        
            assign IssActivity.Duration = 
                ( ( int(lc-hours) * 60 ) * 60 ) + 
                ( int(lc-mins) * 60 ).
        
        
            if Issue.Ticket then
            do:
                assign
                    li-amount = IssActivity.Duration.
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
                        tt-ticket.Reference         =   IssActivity.description
                        tt-ticket.TickID            =   ?
                        tt-ticket.TxnDate           =   IssActivity.ActDate
                        tt-ticket.TxnTime           =   time
                        tt-ticket.TxnType           =   "ACT"
                        tt-ticket.IssActivityID     =   IssActivity.IssActivityID.
                    RUN tlib-PostTicket.
        
        
                end.
        
            end.
    
        end.

    end.

    /*
    *** 
    *** final update of the issue
    ***
    */
    assign
        Issue.AssignTo  = lc-CurrentAssign
        Issue.AssignDate = today
        Issue.AssignTime = time
        lr-Issue       = rowid(Issue).

    if Issue.StatusCode <> lc-currentstatus then
    do:
        release issue.
        find Issue where rowid(Issue) = lr-Issue exclusive-lock.
        run islib-StatusHistory(
                        Issue.CompanyCode,
                        Issue.IssueNumber,
                        lc-global-user,
                        Issue.StatusCode,
                        lc-currentStatus ).
        release issue.
        find Issue where rowid(Issue) = lr-Issue exclusive-lock.
        assign
            Issue.StatusCode = lc-CurrentStatus.
        
    end.

    if dynamic-function("islib-StatusIsClosed",
                        Issue.CompanyCode,
                        Issue.StatusCode)
    then dynamic-function("islib-RemoveAlerts",rowid(Issue)).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SetUpQuick) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SetUpQuick Procedure 
PROCEDURE ip-SetUpQuick :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var li-end      as int      no-undo.

    assign 
        lc-StartDate      = string(today,"99/99/9999")
        lc-EndDate        = string(today,"99/99/9999")
        lc-hours          = "00"
        lc-mins           = "0"
        lc-secs           = "1"
        lc-starthour      = string(int(substr(string(time,"hh:mm"),1,2)))
        lc-endhour        = lc-starthour
        lc-startmin       = string(int(substr(string(time,"hh:mm"),4,2)))
        lc-endmin         = lc-startmin
        lc-currentassign  = lc-global-user
        lc-timeSecondSet  = if lc-timeSecondSet <> "" then lc-timeSecondSet else lc-secs 
        lc-timeMinuteSet  = if lc-timeMinuteSet <> "" then lc-timeMinuteSet else lc-mins
        lc-DefaultTimeSet = entry(1,lc-list-activtime,"|")
        lc-saved-activity = "0"
      
      .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SLATable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SLATable Procedure 
PROCEDURE ip-SLATable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def buffer slahead  for slahead.
    def var li-loop     as int      no-undo.
    def var lc-object   as char     no-undo.
    def var lc-rowid    as char     no-undo.

{&out} htmlib-Hidden("djs",lc-sla-selected) skip.

    {&out}
        htmlib-StartMntTable()
        htmlib-TableHeading(
        "Select?^left|SLA"
        ) skip.

    if lc-global-company = "MICAR" then
    do:
    {&out}
        htmlib-trmouse()
            '<td>'
                htmlib-Radio("sla", "slanone" , if lc-sla-selected = "slanone" then true else false)
            '</td>'
            htmlib-TableField(html-encode("None"),'left')
    
        '</tr>' skip.
    end.

    do li-loop = 1 to num-entries(lc-sla-rows,"|"):
        assign
            lc-rowid = entry(li-loop,lc-sla-rows,"|").

        find slahead where rowid(slahead) = to-rowid(lc-rowid) no-lock no-error.
        if not avail slahead then next.
        assign
            lc-object = "sla" + lc-rowid.
        {&out}
            htmlib-trmouse()
                '<td>'
                    htmlib-Radio("sla" , lc-object, if lc-sla-selected = lc-object then true else false) 
                '</td>'
                htmlib-TableField(html-encode(slahead.description),'left')
                
            '</tr>' skip.

    end.
    
        
    {&out} skip 
       htmlib-EndTable()
       skip.


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


    def var ld-date as date no-undo.
    def var ld-startd   as date     no-undo.
    def var ld-endd     as date     no-undo.
    def var li-startt   as int      no-undo.
    def var li-endt     as int      no-undo.
    def var li-int      as int      no-undo.
    DEF BUFFER b FOR webuser.
    

    if not can-find(customer where customer.accountnumber 
                        = lc-accountnumber 
                        and customer.companycode = lc-global-company
                        no-lock) 
    then run htmlib-AddErrorMessage(
                    'accountnumber', 
                    'You must select the account',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
    if pc-error-field = "" 
    and ( lc-raisedlogin = htmlib-Null() OR lc-raisedLogin = "" ) THEN 
    do:
        
        IF lc-uadd-loginId = "" THEN
        run htmlib-AddErrorMessage(
                    'raisedlogin', 
                    'Select the person who raised the issue or create one',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        /* Oherwise adding a new user! */
        ELSE
        DO:
            IF CAN-FIND(b WHERE b.loginid = lc-uadd-loginid NO-LOCK) 
            THEN run htmlib-AddErrorMessage(
                    'uadd-loginid', 
                    'This user already exists',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
            ELSE
            DO:
                IF lc-uadd-name = "" THEN
                 run htmlib-AddErrorMessage(
                    'uadd-name', 
                    'You must enter the users name',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
                 IF lc-uadd-email = "" THEN
                 run htmlib-AddErrorMessage(
                    'uadd-email', 
                    'You must enter the users email',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
                 IF lc-uadd-phone = "" THEN
                 run htmlib-AddErrorMessage(
                    'uadd-phone', 
                    'You must enter the users phone number',
                    input-output pc-error-field,
                    input-output pc-error-msg ).



            END.
        END.
    END.

    if lc-areacode = htmlib-Null() 
    then run htmlib-AddErrorMessage(
                    'areacode', 
                    'Select the issue area',
                    input-output pc-error-field,
                    input-output pc-error-msg ).





    assign ld-date = date(lc-date) no-error.
    if error-status:error
    or ld-date = ? 
    then run htmlib-AddErrorMessage(
                    'date', 
                    'You must enter the date',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
    
    if lc-briefdescription = ""
    then run htmlib-AddErrorMessage(
                    'briefdescription', 
                    'You must enter a brief description for the issue',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-longdescription = ""
    then run htmlib-AddErrorMessage(
                    'longdescription', 
                    'You must enter the details for the issue',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if not ll-Customer then
    do:
        if lc-actionCode = lc-global-selcode then 
        do:
            if lc-quick = "on" then
            do:
                run htmlib-AddErrorMessage(
                    'actioncode', 
                    'You have not selected an action type but have closed the issue',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

            end.
            if lc-actionnote <> "" then
            do:
                run htmlib-AddErrorMessage(
                    'actioncode', 
                    'You have not selected an action type but have entered a note',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

            end.
        end.
        else
        do:
            if lc-actionnote = "" then
            run htmlib-AddErrorMessage(
                    'actionnote', 
                    'You must enter the action note',
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


            if lc-actdescription = "" 
            then run htmlib-AddErrorMessage(
                    'actdescription', 
                    'You must enter the activity description',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

            

        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ipCreateNewUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ipCreateNewUser Procedure 
PROCEDURE ipCreateNewUser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF BUFFER b FOR webuser.

   CREATE b.
   ASSIGN
       b.loginid = lc-uadd-loginid
       b.NAME = lc-uadd-name
       b.companycode = issue.companyCode
       b.accountnumber = issue.accountnumber
       b.email = lc-uadd-email
       b.expiredate = TODAY
       b.passwd = ENCODE(LC(b.loginid))
       b.telephone = lc-uadd-phone
       b.userclass = "CUSTOMER"

       .



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
  Notes:       In the event that this Web object is state-aware, this is
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
  Notes:       
------------------------------------------------------------------------------*/    
    def buffer b for webUser.
    def var ll-ok as log no-undo.

    {lib/checkloggedin.i}

    assign  lc-title = 'Add Issue'
            lc-default-catcode = 
            dynamic-function("com-GetDefaultCategory",lc-global-company)
            lc-emailid  = get-value("emailid")
            lc-issuesource = get-value("issuesource")
            lc-iclass = ENTRY(1,lc-global-iclass-code,"|").
    find webuser where webuser.LoginID = lc-global-user no-lock no-error.

    RUN com-GetAction ( lc-global-company , output lc-list-actcode, output lc-list-actdesc ).
    RUN com-GetStatusIssue ( lc-global-company , output lc-list-status, output lc-list-sname ).
    RUN com-GetActivityType ( lc-global-company , output lc-list-actid, output lc-list-activtype, output lc-list-activdesc, output lc-list-activtime ).
    RUN com-GetAssignList ( lc-global-company , output lc-list-assign , output lc-list-assname ).
    assign  lc-list-actcode = lc-global-selcode + "|" + lc-list-actcode
            lc-list-actdesc = lc-global-seldesc + "|" + lc-list-actdesc
            lc-actdescription = entry(1,lc-list-activdesc,"|").

    if lc-IssueSource = "custenq" then
    do:
        assign
            lc-AccountNumber = get-value("accountnumber") .
            lc-sla-selected = "slanone". 
    end.
    if WebUser.UserClass = "CUSTOMER" then
    do:
        assign
            lc-emailid = ""
            lc-issuesource = "".
        find Customer where Customer.CompanyCode   = lc-global-company
                        and Customer.AccountNumber = WebUser.AccountNumber
                        no-lock no-error.
        assign lc-AccountNumber = WebUser.AccountNumber
               lc-raisedlogin   = WebUser.LoginID
               ll-customer      = true.
        if request_method = "get" then
        do:
            set-user-field("raisedlogin",lc-raisedLogin).
        end.
        else 
        do:
            assign lc-raisedlogin = get-value("raisedlogin").
        end.
        set-user-field("accountnumber",lc-accountNumber).
        set-user-field("raisedlogin",lc-raisedLogin).
        assign
        lc-address = "".
        lc-address = dynamic-function("com-StringReturn",lc-address,customer.Address1).
        lc-address = dynamic-function("com-StringReturn",lc-address,customer.Address2).
        lc-address = dynamic-function("com-StringReturn",lc-address,customer.City).
        lc-address = dynamic-function("com-StringReturn",lc-address,customer.County).
        lc-address = dynamic-function("com-StringReturn",lc-address,customer.Country).
        lc-address = dynamic-function("com-StringReturn",lc-address,customer.PostCode).
    end.
    if request_method = 'post' then
    do:
            assign 
                 lc-accountnumber    = get-value("accountnumber")
                 lc-briefdescription = get-value("briefdescription")
                 lc-longdescription  = get-value("longdescription")
                 lc-submitsource     = get-value("submitsource")
                 lc-raisedlogin      = get-value("raisedlogin")
                 lc-date             = get-value("date")
                 lc-AreaCode         = get-value("areacode")
                 lc-gotomaint        = get-value("gotomaint")
                 lc-sla-selected     = get-value("sla")
                 lc-catcode          = get-value("catcode")
                 lc-ticket           = get-value("ticket")
                 lc-iclass           = get-value("iclass")
                 lc-uadd-loginid     = get-value("uadd-loginid")
                 lc-uadd-name        = get-value("uadd-name")
                 lc-uadd-email       = get-value("uadd-email")
                 lc-uadd-phone       = get-value("uadd-phone")
                .
            IF lc-iclass = ""
            THEN lc-iclass = ENTRY(1,lc-global-iclass-code,"|").
            if not ll-customer then
            do:
                 assign
                    lc-quick            = get-value("quick")
                    lc-currentstatus    = get-value("currentstatus")
                    lc-currentassign    = get-value("currentassign")
                    lc-actioncode       = get-value("actioncode")
                    lc-actionnote       = get-value("actionnote")
                    lc-customerview     = get-value("customerview")
                    lc-actionstatus     = get-value("actionstatus")
                    lc-activitytype     = get-value("activitytype")
                    lc-startdate        = get-value("startdate")
                    lc-starthour        = get-value("starthour")
                    lc-startmin         = get-value("startmin")
                    lc-enddate          = get-value("enddate")
                    lc-endhour          = get-value("endhour")
                    lc-endmin           = get-value("endmin")
                    lc-hours            = get-value("hours")
                    lc-mins             = get-value("mins")
                    lc-manChecked       = get-value("manualTime")
                    lc-manChecked       = if lc-manChecked =  "on" then "checked" else ""
                    lc-actdescription   = get-value("actdescription")
                    lc-timeSecondSet    = get-value("timeSecondSet")
                    lc-timeMinuteSet    = get-value("timeMinuteSet")
                    lc-DefaultTimeSet   = get-value("defaultTime")
                    lc-contract-type    = get-value("contract")
                    lc-billable-flag    = get-value("billcheck")
                    lc-saved-activity   = get-value("savedactivetype")                
                    lc-saved-contract   = lc-contract-type 
                    lc-saved-billable   = lc-billable-flag.
                    if lc-manChecked <> "checked"  then
                    lc-mins             = string(integer(lc-mins) + 1).
            end.
            if ll-customer
            then ASSIGN lc-date     = string(today,"99/99/9999")
                        lc-catcode  = lc-default-catcode.
            if lc-submitsource <> "accountchange" then
            do:
                RUN ip-Validate( output lc-error-field,output lc-error-msg ).
                if lc-error-field = "" then
                do:
                    repeat:
                        find last issue 
                                        where issue.companycode = lc-global-company
                                        no-lock no-error.
                        assign
                                        li-issue = if avail issue then issue.issueNumber + 1 else 1.
                        leave.
                    end.
                    if com-TicketOnly(lc-global-company,lc-AccountNumber) then assign lc-ticket = "on".
                    create issue.
                    assign issue.IssueNumber  = li-issue
                         issue.BriefDescription   = lc-BriefDescription
                         issue.LongDescription    = lc-LongDescription
                         issue.AccountNumber      = lc-accountnumber
                         issue.CompanyCode        = lc-global-company
                         issue.CreateDate         = today
                         issue.CreateTime         = time
                         issue.CreateBy           = lc-user
                         issue.IssueDate          = date(lc-date)
                         issue.IssueTime          = time
                         issue.areacode           = lc-areacode
                         issue.CatCode            = lc-catcode
                         issue.Ticket             = lc-ticket = "on"
                         issue.SearchField        = issue.BriefDescription + " " + issue.LongDescription
                         issue.ActDescription     = lc-actDescription
                         Issue.ContractType       = lc-contract-type   
                         Issue.Billable           = lc-billable-flag = "on"
                         issue.iclass             = lc-iclass.
                    if lc-emailID <> ""
                    then assign issue.CreateSource = "EMAIL".
                    if ll-customer then
                    do:
                        assign 
                                        lc-sla-selected = "slanone".
                        if customer.DefaultSLAID <> 0 then
                        do:
                                        find slahead where slahead.SLAID = Customer.DefaultSLAID no-lock no-error.
                                        if avail slahead then assign lc-sla-selected = "sla" + string(rowid(slahead)).
                        end.
                    end.
                    assign lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,lc-AccountNumber).
                    if lc-sla-selected = "slanone" 
                    or lc-sla-rows = "" then 
                    do:
                        assign Issue.link-SLAID = 0
                               Issue.SLAStatus = "OFF".
                    end.
                    else
                    do:
                        find slahead where rowid(slahead) = to-rowid(substr(lc-sla-selected,4)) no-lock no-error.
                        if avail slahead then 
                        do:
                            assign Issue.link-SLAID = slahead.SLAID.
                            empty temp-table tt-sla-sched.
                            run lib/slacalc.p
                                            ( Issue.IssueDate,
                                                    Issue.IssueTime,
                                                    Issue.link-SLAID,
                                                    output table tt-sla-sched ).
                            assign
                                Issue.SLADate = ?
                                Issue.SLALevel = 0
                                Issue.SLAStatus = "OFF"
                                Issue.SLATime  = 0
                                issue.SLATrip = ?
                                issue.SLAAmber = ?.
                            for each tt-sla-sched no-lock where tt-sla-sched.Level > 0:
                                assign Issue.SLADate[tt-sla-sched.Level] = tt-sla-sched.sDate
                                       Issue.SLATime[tt-sla-sched.Level] = tt-sla-sched.sTime.
                                assign Issue.SLAStatus = "ON".
                            end.
                            IF issue.slaDate[2] <> ? 
                            THEN ASSIGN issue.SLATrip = 
                             DATETIME(STRING(Issue.SLADate[2],"99/99/9999") + " " 
                                    + STRING(Issue.SLATime[2],"HH:MM")).

                        end.
                    end.
                    if lc-raisedlogin <> htmlib-Null() 
                    then assign issue.RaisedLoginid = lc-raisedlogin.

                    IF lc-raisedLogin = ""
                    OR lc-raisedLogin =  htmlib-Null() 
                    AND lc-uadd-loginid <> "" THEN
                    DO:
                        RUN ipCreateNewUser.
                        assign issue.RaisedLoginid = lc-uadd-loginid.

                    END.
                    assign issue.StatusCode = htmlib-GetAttr("System","DefaultStatus").
                    run islib-StatusHistory(
                            issue.CompanyCode,
                            issue.IssueNumber,
                            lc-user,
                            "",
                            issue.StatusCode ).
                    if lc-emailid <> "" then
                    do:
                        find emailh where emailh.EmailID = dec(lc-EmailID) exclusive-lock no-error.
                        if avail emailh then
                        do:
                            for each doch where doch.CompanyCode = lc-global-company
                                            and doch.RelType     = "EMAIL"
                                            and doch.RelKey      = string(emailh.EmailID) exclusive-lock:
                                assign
                                    doch.RelType = "ISSUE"  
                                    doch.RelKey  = string(Issue.IssueNumber)
                                    doch.CreateBy = lc-user.
                            end.
                            delete emailh.
                        end.
                    end.
                    islib-DefaultActions(lc-global-company,Issue.IssueNumber).
                    if not ll-Customer 
                    then RUN ip-QuickUpdate.

                    if lc-gotomaint = "" then
                    do:
                        find customer where customer.CompanyCode = issue.CompanyCode
                                        and customer.AccountNumber = issue.AccountNumber no-lock no-error.
                        set-user-field("newissue",string(issue.IssueNumber)).
                        release issue.

                        if lc-issueSource = "custenq" and not ll-customer then
                        do:
                            set-user-field("mode","view").
                            set-user-field("source","menu").
                            set-user-field("rowid",string(rowid(customer))).
                            RUN run-web-object IN web-utilities-hdl ("cust/custview.p").

                        end.
                        else RUN run-web-object IN web-utilities-hdl ("iss/confissue.p").
                    end.
                    else
                    do:
                        set-user-field("mode","update").
                        set-user-field("return","home").
                        set-user-field("rowid",string(rowid(issue))).
                        release issue.
                        RUN run-web-object IN web-utilities-hdl ("iss/issueframe.p").
                    end.
                    return.
                end.
            end.
            else 
            do:
                assign lc-raisedLogin = htmlib-Null().
                find customer
                                where customer.CompanyCode = lc-global-company
                                        and customer.AccountNumber = lc-AccountNumber   no-lock no-error.
                if avail customer then
                do:
                    assign lc-customerview =  if Customer.ViewAction then "on" else "".
                                                     .
                    if customer.DefaultSLAID <> 0 then
                    do:
                        find slahead where slahead.SLAID = customer.DefaultSLAID no-lock no-error.
                        if avail slahead then assign lc-sla-selected = "sla" + string(rowid(slahead)).
                    end.
                end.
            end.
    end.
    RUN ip-GetCatCode ( output lc-list-catcode,output lc-list-cname ).
    if lc-IssueSource = "custenq" then
    do:
            find customer where customer.CompanyCode = lc-global-company
                           and customer.AccountNumber = lc-AccountNumber   no-lock no-error.
            assign
                lc-list-number = customer.AccountNumber
                lc-list-name   = customer.Name.
            if request_method = "GET"
            then assign lc-customerview = if Customer.ViewAction then "on" else "".
    end.
    else RUN ip-GetAccountNumbers ( input lc-user,output lc-list-number,output lc-list-name ).
    RUN ip-GetOwner ( input lc-accountnumber,output lc-list-login,output lc-list-lname ).
    RUN ip-GetContract ( input lc-accountnumber,output lc-list-ctype,output lc-list-cdesc   ).
    run ip-GetArea ( output lc-list-area,output lc-list-aname ).
    assign
        lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,lc-AccountNumber).

    if request_method = "get" then 
    do:
            find slahead where slahead.SLAID = Customer.DefaultSLAID no-lock no-error.

            assign lc-date = string(today,'99/99/9999')
                             lc-raisedlogin = if ll-customer then lc-user else htmlib-Null()
                             lc-areacode = htmlib-Null()
                             lc-gotomaint = "on"
                             lc-sla-selected = if lc-global-company = "MICAR" then "slanone" 
                             else if avail slahead then  "sla" + string(rowid(slahead))
                             else "slanoneZZZZ" 
                             lc-catcode      = lc-default-catcode.
            if not ll-Customer 
            then RUN ip-SetUpQuick.
    end.
    if lc-issuesource = "email" then
    do:
            find emailh where emailh.EmailID = dec(lc-emailid)
                                            no-lock no-error.
            if not avail emailh 
            then assign lc-emailid = ""
                        lc-issuesource = "".
            else
            do:
                if request_method = "GET" then
                assign lc-briefdescription = emailh.Subject
                       lc-longdescription  = emailh.mText.
                if emailh.AccountNumber <> "" then
                do:
                    find customer
                        where customer.CompanyCode      = lc-global-company
                          and customer.AccountNumber    = emailh.AccountNumber
                          no-lock no-error.
                    if avail customer then
                    do:
                        assign lc-customerview = if Customer.ViewAction then "on" else ""
                                                 lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,customer.AccountNumber)
                                                 lc-list-number = customer.AccountNumber
                                                 lc-list-name   = customer.name
                                                 lc-accountnumber = customer.AccountNumber.
                        RUN ip-GetOwner ( input lc-accountnumber,
                                                output lc-list-login,
                                                output lc-list-lname ).
                        if request_method = "GET" then
                        do:
                            find first b 
                                where b.CompanyCode = lc-global-company
                                        and b.Email       = emailh.Email
                                        and b.UserClass   = "CUSTOMER"
                                        and b.AccountNumber = customer.AccountNumber
                                        no-lock no-error.
                            if avail b
                            then assign lc-raisedlogin = b.LoginID.
                        end.
                    end.
                end.
            end.
    end.
    RUN outputHeader.

    RUN ip-GenHTML.

       
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-Format-Select-Account) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Account Procedure 
FUNCTION Format-Select-Account RETURNS CHARACTER
  ( pc-htm as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<select',
                   '<select onChange="ChangeAccount()"'). 


  RETURN lc-htm.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-Format-Select-Desc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Desc Procedure 
FUNCTION Format-Select-Desc RETURNS CHARACTER
  ( pc-htm as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<input',
                   '<input onChange="ChangeActivityDesc()"'). 


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

