&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        time/diaryframe.p
    
    Purpose:        Hold the diary...
    
    Notes:
    
    
    When        Who         What
    01/09/2010  DJS      Initial
     
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */


/* Local Variable Definitions ---                                       */

def var lc-error-field    as char     no-undo.
def var lc-error-mess     as char     no-undo.
def var lc-rowid          as char     no-undo.
def var li-max-lines      as int initial 12 no-undo.
def var lr-first-row      as rowid    no-undo.
def var lr-last-row       as rowid    no-undo.
def var lc-mainText       as char     no-undo.
def var lc-timeText       as char     no-undo.
def var lc-innerText      as char     no-undo.
def var lc-sliderText     as char     no-undo.
def var lc-otherText      as char     no-undo.
def var timeSPixels       as char     no-undo.
def var timeFinish        as dec      no-undo.
def var timeFPixels       as char     no-undo.
def var daysIssues        as int      no-undo.
def var issueWidth        as int      no-undo.
def var issueLeft         as int      no-undo.
def var timeStart         as dec      no-undo.
def var timeEnd           as dec      no-undo.
def var offSetCol         as int      no-undo.
def var offSetWidth       as int      no-undo.
def var offRowid          as rowid    no-undo. 
def var p-cx              as char initial "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40"  no-undo.
def var p-vx              as int      no-undo.
def var p-vz              as int      no-undo.
def var p-zx              as int      no-undo. 
def var colWheel          as char     no-undo.


/* WORKING VARS */
def var vx                 as int     no-undo.
def var yx                 as int     no-undo.
def var zx                 as int     no-undo.
def var mx                 as int     no-undo.
def var cx                 as int     no-undo.
def var AMPM               as char format "xx" extent 2 initial ["AM","PM"]  no-undo.
def var ap                 as int     no-undo.
def var dayDate            as date    no-undo.
def var bubbleNo           as int initial 1  no-undo.
def var dayWidth           as char    no-undo.
def var currentDay         as date    no-undo.  
def var viewerDay          as date    no-undo.
def var dayDesc            as char    no-undo.
def var dayNum             as int     no-undo.
def var dayList            as char    format "x(9)" initial " Sunday , Monday , Tuesday , Wednesday , Thursday , Friday , Saturday ".
def var dayRange           as int     no-undo.
def var hourFrom           as int     no-undo.
def var hourTo             as int     no-undo.
def var coreHourFrom       as int     no-undo.
def var coreHourTo         as int     no-undo.
def var incWeekend         as log     no-undo.
def var userList           as char    no-undo.
def var saveSettings       as log     no-undo.
def var viewShowY          as int     no-undo.
def var viewshowX          as int     no-undo.

/* PARAM VARS */
def var lc-lodate           as char   no-undo. 
def var lc-hidate           as char   no-undo. 
def var lc-dispDate         as char   no-undo.
def var lc-dateDate         as char   no-undo.
def var lc-viewerDay        as char   no-undo. 
def var lc-dayRange         as char   no-undo. 
def var lc-coreHourFrom     as char   no-undo. 
def var lc-coreHourTo       as char   no-undo. 
def var lc-hourFrom         as char   no-undo. 
def var lc-hourTo           as char   no-undo. 
def var lc-incWeekend       as char   no-undo. 
def var lc-mode             as char   no-undo.
def var lc-userList         as char   no-undo.
def var lc-saveSettings     as char   no-undo.
def var li-blockheight      as int    no-undo.
def var lc-blockheight      as char   no-undo.
def var li-offsetheight     as int    no-undo.
def var li-blockwidth       as int    no-undo.
def var lc-viewShowY        as char   no-undo.
def var lc-viewshowX        as char   no-undo.

/*  TABLES  */

def temp-table DE like DiaryEvents
field idRow               as rowid
field eventID             as char format "xx"
field overLap             as char format "x(9)" 
field comment             as char
field columnID            as int format "z9"
field issueLeft           as int
field issueWidth          as int.

def buffer bDE            for DE.
def buffer bbDE           for DE.
def buffer bDiaryEvents   for DiaryEvents.
def buffer b-query        for DiaryEvents.
def buffer b-search       for DiaryEvents.
def query q               for b-query scrolling.

def temp-table DDEE       like DiaryEvents.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-dateFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dateFormat Procedure 
FUNCTION dateFormat RETURNS CHARACTER
  ( params as date )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnText Procedure 
FUNCTION fnText RETURNS CHARACTER
  ( pf-knbid as dec,
    pi-count as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-DayDate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-DayDate Procedure 
FUNCTION Format-Select-DayDate RETURNS CHARACTER
  ( pc-htm as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-timeFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD timeFormat Procedure 
FUNCTION timeFormat RETURNS CHARACTER
 (param1 as int) FORWARD.

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
         HEIGHT             = 4.81
         WIDTH              = 37.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */

{lib/checkloggedin.i}

if can-find(first DiaryParams no-lock                                    
            where DiaryParams.CompanyCode = lc-global-company           
            and   DiaryParams.LoginID     = lc-global-user) 
 then  find first DiaryParams no-lock 
            where DiaryParams.CompanyCode = lc-global-company 
            and   DiaryParams.LoginID     = lc-global-user no-error.
 else  find first DiaryParams no-lock 
            where DiaryParams.CompanyCode = lc-global-company 
            and   DiaryParams.LoginID     = "system" no-error.


assign
  lc-mode             = get-value("mode")
  lc-viewerDay        = get-value("viewerDay")
  lc-dayRange         = get-value("dayRange")
  lc-userList         = get-value("userList")
  lc-coreHourFrom     = get-value("coreHourFrom")
  lc-coreHourTo       = get-value("coreHourTo")
  lc-hourFrom         = get-value("hourFrom")
  lc-hourTo           = get-value("hourTo")
  lc-incWeekend       = get-value("incWeekend")
  lc-viewShowY        = get-value("viewShowY")
  lc-viewShowX        = get-value("viewShowX")
  lc-saveSettings     = get-value("saveSettings").

/*  output to "C:\temp\djs2.txt" append.                 */
/*  put unformatted                                      */
/*  "LoginID           "    DiaryParams.LoginID skip     */
/*  "lc-mode           "    lc-mode             skip     */
/*  "lc-viewerDay      "    lc-viewerDay        skip     */
/*  "lc-dayRange       "    lc-dayRange         skip     */
/*  "lc-coreHourFrom   "    lc-coreHourFrom     skip     */
/*  "lc-coreHourTo     "    lc-coreHourTo       skip     */
/*  "lc-hourFrom       "    lc-hourFrom         skip     */
/*  "lc-hourTo         "    lc-hourTo           skip     */
/*  "lc-incWeekend     "    lc-incWeekend       skip     */
/*  "lc-viewShowY      "    lc-viewShowY        skip     */
/*  "lc-viewShowX      "    lc-viewShowX        skip     */
/*  "lc-saveSettings   "    lc-saveSettings     skip     */
/*  "lc-userList       "    lc-userList         skip(2). */
/*  output close.                                        */


if lc-mode = "refresh" then
  assign
    viewerDay       = date(lc-viewerDay)
    lc-mode         = "refresh"
    dayRange        = integer(lc-dayRange)
    coreHourFrom    = integer(lc-coreHourFrom)
    coreHourTo      = integer(lc-coreHourTo)
    hourFrom        = integer(lc-hourFrom)
    hourTo          = integer(lc-hourTo)
    incWeekend      = lc-incWeekend = "checked"
    viewShowY       = integer(lc-viewShowY)
    viewShowX       = integer(lc-viewShowX)
    saveSettings    = lc-saveSettings = "checked"
    lc-userList     = lc-userList
  .
else 
  assign 
    viewerDay       = today
    lc-mode         = "view"
    dayRange        = integer(DiaryParams.initialDays)
    coreHourFrom    = integer(substr(DiaryParams.coreHours,1,4))
    coreHourTo      = integer(substr(DiaryParams.coreHours,5,4))
    hourFrom        = integer(substr(DiaryParams.displayHours,1,4))
    hourTo          = integer(substr(DiaryParams.displayHours,5,4))
    incWeekend      = DiaryParams.incWeekends 
    viewShowY       = DiaryParams.viewShowY
    viewShowX       = DiaryParams.viewShowX
    saveSettings    = false
    lc-userList     = if trim(DiaryParams.initialEngineers) = "" and DiaryParams.LoginID = "system" then lc-global-user else trim(DiaryParams.initialEngineers)
    
/*     if DiaryParams.LoginID = "system" then "" else if DiaryParams.initialEngineers <> "" then trim(DiaryParams.initialEngineers) else lc-global-user */
  .




assign
  lc-lodate       = string(viewerDay - dayRange) 
  lc-hidate       = string(viewerDay)
  lc-viewerDay    = string(viewerDay)
  lc-dayRange     = string(dayRange)
  lc-coreHourFrom = string(coreHourFrom)
  lc-coreHourTo   = string(coreHourTo)
  lc-hourFrom     = string(hourFrom)
  lc-hourTo       = string(hourTo)
  lc-incWeekend   = if incWeekend then "checked" else ""
  lc-viewShowY    = string(viewShowY)
  lc-viewShowX    = string(viewShowX)
  lc-saveSettings = if saveSettings then "checked" else ""
.

/* output to "C:\temp\djs2.txt" append.                  */
/* put unformatted                                       */
/* "LoginID              "     DiaryParams.LoginID skip  */
/* "lc-mode              "    lc-mode            skip    */
/* "lc-viewerDay         "    lc-viewerDay      skip     */
/* "lc-dayRange          "    lc-dayRange       skip     */
/* "lc-coreHourFrom      "    lc-coreHourFrom   skip     */
/* "lc-coreHourTo        "    lc-coreHourTo     skip     */
/* "lc-hourFrom          "    lc-hourFrom       skip     */
/* "lc-hourTo            "    lc-hourTo         skip     */
/* "lc-incWeekend        "    lc-incWeekend     skip     */
/* "lc-lodate            "    lc-lodate         skip     */
/* "lc-hidate            "    lc-hidate         skip     */
/* "lc-userList          "    lc-userList       skip     */
/* "lc-saveSettings      "    lc-saveSettings   skip     */
/* "lc-viewShowY         "    lc-viewShowY       skip    */
/* "lc-viewShowX         "    lc-viewShowX       skip    */
/* "lc-global-company    "    lc-global-company skip     */
/* "lc-global-user       "    lc-global-user    skip(2). */
/* output close.                                         */

 case viewShowY :
   when 1 then assign li-blockheight  = 20
                      li-offsetheight = 18.
   when 2 then assign li-blockheight  = 40
                      li-offsetheight = 58.
   when 3 then assign li-blockheight  = 60
                      li-offsetheight = 98.
   otherwise   assign li-blockheight  = 20
                      li-offsetheight = 18.
 end case.

 case viewShowX :
   when 1 then assign li-blockwidth  = 900.
   when 2 then assign li-blockwidth  = 1350.
   when 3 then assign li-blockwidth  = 1800.
   otherwise   assign li-blockwidth  = 900.
 end case.


                      

do zx = 1 to dayRange:
   assign currentDay = date(string(viewerDay + (zx - 1)))   /*  date(string(viewerDay + (zx - (round(dayRange / 2,0)))))  */
          dayNum     = weekday(currentDay).
   if not incWeekend and (dayNum = 1 or dayNum = 7) then cx = cx + 1.
end.
assign dayWidth = string(round(li-blockwidth / (dayRange - cx),0)).

if cx > 0  and integer(dayWidth) < 80 then dayWidth = "80".
if integer(dayWidth) <= 80 then
do: 
  dayWidth = "80".
  li-blockwidth = 80 * (dayRange - cx).
end.


RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ending-JS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ending-JS Procedure 
PROCEDURE ending-JS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



  {&out}
  '<script type="text/javascript" language="javascript">' skip
  ' <!-- ' skip

/* populateIframe */
  'function populateIframe() ~{' skip

 

  'if ( "refresh" == "' lc-mode '" )' skip
  ' ~{ ' skip
 
  'var viewerDay    = document.mainform.elements["viewerDay"].value; ' skip
  'var dayRange     = document.getElementById("xdayRange").value; ' skip
  'var coreHourFrom = document.getElementById("xcoreHourFrom").value; ' skip
  'var coreHourTo   = document.getElementById("xcoreHourTo").value; ' skip
  'var hourFrom     = document.getElementById("xhourFrom").value; ' skip
  'var hourTo       = document.getElementById("xhourTo").value; ' skip
  'var incWeekend   = document.getElementById("xincWeekend").value; ' skip
  'var viewShowY    = document.getElementById("xviewShowY").value; ' skip
  'var viewShowX    = document.getElementById("xviewShowX").value; ' skip
  'var userList     = document.getElementById("xuserList").value; ' skip    
 
  ' document.getElementById("diaryinnerframe").src="'  appurl  '/time/diaryview.p?mode=' lc-mode '&viewerDay=" + viewerDay   + '
  '"&dayRange=" + dayRange + "&coreHourFrom=" + coreHourFrom + "&coreHourTo=" + coreHourTo + '    
  '"&hourFrom=" + hourFrom + "&hourTo=" + hourTo + "&incWeekend=" + incWeekend + "&viewShowY=" + viewShowY + "&viewShowX=" + viewShowX + "&userList=" + userList ;' skip

  ' ~}' skip
  'else ' skip
  ' ~{' skip
  'var viewerDay = document.mainform.elements["viewerDay"].value; ' skip
  ' document.getElementById("diaryinnerframe").src="'  appurl  '/time/diaryview.p?mode=' lc-mode '&viewerDay=" + viewerDay  ;' skip
  '~ }' skip

  '~}' skip

/* Refresh */
  'function RefreshDiary() ~{' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
  ' innerFrameForm.submit() ;' skip
  '~}' skip

/* Refresh SELF*/
  'function RefreshSelf(mode, viewerDay, dayRange, coreHourFrom, coreHourTo, hourFrom, hourTo, incWeekend, viewShowY, viewShowX, userList )' skip
  '~{' skip
  ' var url = "' appurl '/time/diaryframe.p?mode=refresh&viewerDay=" + viewerDay + '
  '"&dayRange=" + dayRange + "&coreHourFrom=" + coreHourFrom + "&coreHourTo=" + coreHourTo + '    
  '"&hourFrom=" + hourFrom + "&hourTo=" + hourTo + "&incWeekend=" + incWeekend + "&viewShowY=" + viewShowY + "&viewShowX=" + viewShowX + "&userList=" + userList ;' skip
 
  ' window.location = url;' skip
  '~}' skip

/* SaveSettings */
  'function SaveSettings(varObj) ~{' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
  ' innerFrameForm.elements["submitsource"].value = "saveSettings";' skip
  ' innerFrameForm.elements["saveSettings"].value = varObj ? "checked" : "" ;' skip
  ' innerFrameForm.submit() ;' skip
  '~}' skip

/* ChangeDates */
  'function ChangeDates() ~{' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
/*                                                         */
/*     'var myCal = Calendar; ' skip                       */
/*     'alert(myCal.cal.dateClicked ); ' skip              */
/*                                                         */
/*   ' if ( ! cal.dateClicked  ) ~{ return;    ~} ; ' skip */

  ' innerFrameForm.elements["submitsource"].value = "dateChange";' skip
  ' innerFrameForm.elements["viewerDay"].value = document.forms["mainform"].ffviewerDay.value;' skip
  ' innerFrameForm.submit() ;' skip
  '~}' skip

/* ChangeDays */
  'function ChangeDays(newVal) ~{' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
  ' if (innerFrameForm) ~{' skip
  '  innerFrameForm.elements["submitsource"].value = "daysChange";' skip
  '  innerFrameForm.elements["dayRange"].value = newVal;' skip
  '  innerFrameForm.submit() ;' skip
  ' ~}' skip
  '~}' skip

/* ChangeUsers */
  'function ChangeUsers(userName) ~{' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
  ' innerFrameForm.elements["submitsource"].value = "userChange";' skip
  ' var newuserList = "";' skip
  ' for(var i=0; i < document.mainform.scripts.length; i++) ~{ ' skip
  '  if(document.mainform.scripts[i].checked)' skip
  '  newuserList +=  document.mainform.scripts[i].value + "," ;' skip
  '  ~}' skip
  ' innerFrameForm.elements["userList"].value = newuserList ;' skip
  ' innerFrameForm.submit() ;' skip
  '~}' skip

/* ChangeWeekend */
  'function ChangeWeekend() ~{' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
  ' innerFrameForm.elements["submitsource"].value = "weekendChange";' skip
  ' innerFrameForm.elements["incWeekend"].value = document.forms["mainform"].incWeekend.checked ? "checked" : "" ;' skip
  ' innerFrameForm.submit() ;' skip
  '~}' skip

/* TodaysDate  */
  'function TodaysDate() ~{' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
  ' innerFrameForm.elements["submitsource"].value = "dateChange";' skip
  ' innerFrameForm.elements["viewerDay"].value = "' today '";' skip
  ' document.mainform.elements["viewerDay"].value = "' today '";' skip
  ' innerFrameForm.submit() ;' skip
  '~}' skip

/* ChangeSizeY */
  'function ChangeSizeY(newVal) ~{' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
  ' innerFrameForm.elements["submitsource"].value = "ChangeSizeY";' skip
  ' innerFrameForm.elements["viewShowY"].value = newVal  ;' skip
  ' innerFrameForm.submit() ;' skip
  '~}' skip

/* ChangeSizeX */
  'function ChangeSizeX(newVal) ~{' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
  ' innerFrameForm.elements["submitsource"].value = "ChangeSizeX";' skip
  ' innerFrameForm.elements["viewShowX"].value = newVal  ;' skip
  ' innerFrameForm.submit() ;' skip
  '~}' skip

/* ChangeUserColour  */
  'function ChangeUserColour(userVX, userID, colorHex) ~{' skip
  ' document.getElementById("userVX").value = userVX; ' skip
  ' document.getElementById("userID").value = userID; ' skip
  ' document.getElementById("colorHex").value = colorHex; ' skip
  ' document.getElementById("colwheel").style.display = "block"; ' skip
  ' document.getElementById("colwheel").style.top = "81px"; ' skip
  ' document.getElementById("colwheel").style.left = "208px"; ' skip
  ' document.getElementById("colwheel").style.float = "right"; ' skip
  ' document.getElementById("colwheel").style.zIndex = 999; ' skip
  ' document.getElementById("colwheel").innerHTML = ~'' + colWheel + '~'; ' skip
  ' document.getElementById("colwheel").style.background = "transparent"; ' skip
  '~}' skip

/* FixUserColour */
  'function FixUserColour(userNum, colourNum) ~{' skip
  ' document.getElementById("colwheel").innerHTML = ""; ' skip
  ' var userID =  document.getElementById("userID").value;' skip
  ' var innerDocument = window.frames["diaryinnerframe"].document; ' skip
  ' var innerFrameForm = innerDocument.forms["diaryinnerform"];' skip
  ' innerFrameForm.elements["submitsource"].value = "changeColour";' skip
  ' innerFrameForm.elements["changeColour"].value = userID + "|" + colourNum ;' skip
  ' innerFrameForm.submit() ;' skip
  '~}' skip

/* PopulateIframe */
  ' populateIframe(); ' skip

  ' var spinCtrl = new SpinControl();' skip
  ' spinCtrl.Tag = "left";' skip
  ' spinCtrl.SetMaxValue(45);' skip
  ' spinCtrl.SetMinValue(1);' skip
  ' spinCtrl.SetCurrentValue(' dayRange ');' skip
  ' var el = document.getElementById("spinCtrlContainer");' skip
  ' el.appendChild(spinCtrl.GetContainer());' skip
  ' spinCtrl.StartListening();' skip
  ' // #' lc-global-user '#   #' lc-userList '# '  skip
  ' // -->' skip 
  '</script>' skip
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
  
def var vx            as int no-undo.
def var lc-checked    as char no-undo.
def var userColour    as char no-undo.
def var userVX        as int  no-undo.

assign colWheel = 
'<iframe id="colWheel_iframe" src="/colourpick.html" allowtransparency="true" scrolling="no" marginwidth="0" marginheight="0" frameborder="0" vspace="0" hspace="0" '
  + ' style="overflow:hidden; background:transparent; width:100%; height:100%; display:block; border:0px solid blue;"></iframe>'. 

RUN outputHeader.

    {&out} htmlib-OpenHeader("Diary View") skip.

    {&out}
      '<style>' skip
      '.hi ~{ color: red; font-size: 10px; margin-left: 15px; font-style: italic;~}' skip
      '</style>' skip 
      '<link href="/style/diary.css" type="text/css" rel="stylesheet" />' skip.

   {&out}
     '<script type="text/javascript" language="javascript">' skip

     'function setSize() ~{' skip
     'var frameW' skip
     ' if ( document.frames ) ~{frameW = document.frames["diaryinnerframe"].document.getElementById("Calendar1").width + "px"; ~}' skip
     ' else ~{ frameW = document.getElementById("diaryinnerframe").contentDocument.getElementById("Calendar1").width ; ~}' skip
     'var frameH = document.getElementById("fixedTimeDiv").offsetHeight + 17 + "px";' skip
     'var iframe = document.getElementById("diaryinnerframe");' skip
/*      'alert(frameW); ' skip */
     'iframe.style.height = frameH;' skip
     'iframe.style.width  = frameW;' skip
     '~}' skip
     '</script>' skip.
   
    
    {&out} htmlib-JScript-Maintenance() skip.

    {&out} htmlib-JScript-Spinner() skip.
 
    {&out} htmlib-CalendarInclude() skip.

    {&out} '<script type="text/javascript" language="javascript">' skip  /* this moves calendar to corect position rather than default */
           ' <!-- ' skip
           'Calendar.prototype.showAt = function (x, y) ~{ ' skip
           'var s = this.element.style; ' skip
           's.left = 7 + "px"; ' skip
           's.top = 102 + "px"; ' skip
           's.zIndex = 299; ' skip
           'this.show(); ' skip
           '~}; ' skip
           ' // -->' skip 
           '</script>' skip.


    {&out} htmlib-CloseHeader("") skip.

    {&out} htmlib-StartForm("mainform","post", appurl + '/time/diaryframe.p' ) skip.

    {&out} htmlib-ProgramTitle("Engineers Time Recording") skip.
    
    {&out} htmlib-Hidden("submitsource","null").

    {&out} 
    '<input type="hidden" id="userVX" value="">' skip
    '<input type="hidden" id="userID" value="">' skip
    '<input type="hidden" id="colorHex" value="">' skip
    '<div id="diaryscreen" style="clear:both;"   > ' skip
    ' <br><br><br><br>' skip
      '<table cellpadding="0" cellspacing="0" border="0"  width="100%" >' skip
        '<tr valign="top" align="left" >' skip
          '<td width="200px" height="650px" valign="top" align="left" >' skip
      .

   {&out} '<table valign="top" align="left"  width="200px" cellpadding="0" cellspacing="0" border="0" >' skip
          ' <tr >' skip
          '  <td valign="top" align="left" width="200px"  colspan="3" >' skip.
             
   {&out} '<div class="sidelabel"   >'
          htmlib-CalendarInputField("viewerDay",10,lc-viewerDay) 
          htmlib-CalendarLink("viewerDay")
          '&nbsp; Diary Date</div>' skip.
   {&out}
              '</td>'
              '</tr>'
              '<tr>'
                '<td colspan="3" valign="middle" align="left" height="20px" width="200px" >'
                  '<div id="spinCtrlContainer" style="position:relative;border:0; width:50px;height:20px;z-index:99;"  >'
                  '</div><div class="sidelabel"  style="position:absolute;border:0;margin-left:50px;margin-top:-15px; width:200px;height:20px;" >&nbsp; Days shown</div>'
                '</td>' skip
              '</tr>'
              '<tr>' skip
                '<td colspan="3" valign="top" align="left"><input class="inputfield" type="checkbox" name="incWeekend" value="" ' lc-incWeekend ' onClick="ChangeWeekend()" >' skip
                '<span class="sidelabel">Show Weekends?</span></td>' skip
              '</tr>' skip
             

              '<tr>' skip
                '<td colspan="3" valign="top" align="left">' skip
                   '<span><input class="inputfield" type="radio" name="ChangeSizeY1" value="" ' if viewShowY = 1 then "checked" else "" ' onClick="ChangeSizeY(1)" >S</span>' skip
                   '<span><input class="inputfield" type="radio" name="ChangeSizeY2" value="" ' if viewShowY = 2 then "checked" else "" ' onClick="ChangeSizeY(2)" >M</span>' skip
                   '<span><input class="inputfield" type="radio" name="ChangeSizeY3" value="" ' if viewShowY = 3 then "checked" else "" ' onClick="ChangeSizeY(3)" >L</span>' skip
                '<span class="sidelabel">&nbsp; Hour Size</span></td>' skip
              '</tr>' skip

              '<tr>' skip
                '<td colspan="3" valign="top" align="left">' skip
                   '<span><input class="inputfield" type="radio" name="ChangeSizeX1" value="" ' if viewShowX = 1 then "checked" else "" ' onClick="ChangeSizeX(1)" >S</span>' skip
                   '<span><input class="inputfield" type="radio" name="ChangeSizeX2" value="" ' if viewShowX = 2 then "checked" else "" ' onClick="ChangeSizeX(2)" >M</span>' skip
                   '<span><input class="inputfield" type="radio" name="ChangeSizeX3" value="" ' if viewShowX = 3 then "checked" else "" ' onClick="ChangeSizeX(3)" >L</span>' skip
                '<span class="sidelabel">&nbsp; Day Width</span></td>' skip
              '</tr>' skip

                  '<tr>' skip
                '<td valign="TOP" align="left" colspan="3">' skip
                '<hr>' skip
                '</td>' skip
             '</tr>' skip

/*              '</table></tr><tr><table>' skip */
              .


    for each webUser no-lock
      where webuser.company = lc-global-company
      and webuser.UserClass matches "*internal*"
      and webuser.superuser = true
      and webuser.Disabled = false
      
      :
        find first WebStdTime of WebUser no-lock no-error .

        if not avail WebStdTime then next.

        assign userColour = if avail WebStdTime then WebStdTime.StdColour else "#FFFFFF"
               userVX     = userVX + 1.

        if lookup(trim(webUser.LoginID),lc-userList) > 0  then lc-checked = "checked".
                                                          else lc-checked = "".

      {&out}  '<tr>' skip
                '<td width="25px" valign="top" align="left" >' skip
                  '<input class="inputfield" type="checkbox" name="scripts" value="' WebUser.LoginID '" ' lc-checked ' onClick="ChangeUsers(this.name);" >' skip
                '</td>' skip
                '<td width="25px" >' skip
                  '<div id="userColor_' string(userVX) '" style="width:20px;height:10px;background-color:' userColour ';" onclick="ChangeUserColour(' string(userVX) ',~'' WebUser.LoginID '~',~'' userColour '~');">' skip
                '<td width="180px" valign="middle" align="left">' skip
                  '<span class="sidelabel" width="200px" >' webUser.name '</span>' skip
                '</td>' skip
              '</tr>' skip .
    end.


      {&out}  '<tr>' skip
                '<td valign="TOP" align="left" colspan="3">' skip
                '<hr>' skip
                '</td>' skip
              '</tr>' skip
              '<tr>' skip.

 find first WebStdTime where WebStdTime.loginID = lc-global-user no-lock no-error .
 if avail WebStdTime then 
 do:
        {&out} 
                '<td valign="top" align="left" colspan="3" width="200px" >' skip
                  ' <input type="button" class="prefsbutton" onclick="SaveSettings(false)" value="Delete Prefs" />'  skip
    
                  '<input type="button" class="prefsbutton" onclick="SaveSettings(true)" value="Save Prefs" /> '  skip
                '</td>' skip 
              '</tr>' skip

/*               '<tr>' skip                                                                                                                                                           */
/*                 '<td valign="top" align="left"><input class="inputfield" type="checkbox" name="scripts" value="DavidShilling" checked onClick="ChangeUsers(this.name)" ></td>' skip */
/*                 '<td valign="middle" align="left"><span class="sidelabel">David Shilling</span></td>' skip                                                                          */
/*               '</tr>' skip                                                                                                                                                          */
/*               '<tr>' skip                                                                                                                                                           */
/*                 '<td valign="top" align="left"><input class="inputfield" type="checkbox" name="scripts" value="Ian Bibby" onClick="ChangeUsers(this.name)" ></td>' skip             */
/*                 '<td valign="middle" align="left"><span class="sidelabel">Ian Bibby</span></td>' skip                                                                               */
/*               '</tr>' skip                                                                                                                                                          */
        .
 end.

    {&out}
            '</table>' skip

 
          '</td>' skip
          '<td width="56px" align="left">' skip
      .

      run timeBar.

      {&out}
          '</td>'

          '<td>' skip    /*  ' string(li-blockwidth) 'px */
          '<!--[if gt IE 6 ]>'
            '<!-- gt IE6 --><iframe id="diaryinnerframe" name="diaryinnerframe" src="" onload="setSize()" style="position:relative;overflow:hidden;width:' string(li-blockwidth) 'px;height:650px;" frameborder="0" '  
            ' marginwidth=0 marginheight=0 hspace=0 vspace=0 scrolling=no  >' skip
            '</iframe >' skip
          '<![endif]-->'

          '<!--[if lte IE 6 ]>'
            '<!-- lte IE6 --><iframe id="diaryinnerframe" name="diaryinnerframe" src="" onload="setSize()" style="position:relative;overflow:hidden;width:' string(li-blockwidth) 'px;height:650px;" frameborder="0" '
            ' marginwidth=0 marginheight=0 hspace=0 vspace=0 scrolling=no >' skip
            '</iframe >' skip
          '<![endif]-->'

          '<!--[if !IE]>-->'
            '<!-- ! IE --><iframe id="diaryinnerframe" name="diaryinnerframe" src="" onload="setSize()" style="position:relative;overflow:hidden;width:' string(li-blockwidth) 'px;height:650px;" frameborder="0" '
            ' marginwidth=0 marginheight=0 hspace=0 vspace=0 scrolling=no >' skip
            '</iframe >' skip
          '<!--<![endif]-->'

          '</td>' skip
        '</tr>' skip
      '</table>' skip
     '</div>' skip
     .



  {&out} htmlib-CalendarScript("viewerDay") skip.

  {&out} '<div id="colwheel" style="position:absolute;display:none;width:250px;height:280px;background:transparent;"></div>' skip.

  {&out} htmlib-Hidden("xmode",lc-mode) skip.
  {&out} htmlib-Hidden("xstartDay",lc-viewerDay) skip.
  {&out} htmlib-Hidden("xdayRange",lc-dayRange) skip.
  {&out} htmlib-Hidden("xcoreHourFrom",lc-coreHourFrom) skip.
  {&out} htmlib-Hidden("xcoreHourTo",lc-coreHourTo) skip.
  {&out} htmlib-Hidden("xhourFrom",lc-hourFrom) skip.
  {&out} htmlib-Hidden("xhourTo",lc-hourTo) skip.
  {&out} htmlib-Hidden("xincWeekend",lc-incWeekend) skip.
  {&out} htmlib-Hidden("xviewShowY",lc-viewShowY) skip.
  {&out} htmlib-Hidden("xviewShowX",lc-viewShowX) skip.
  {&out} htmlib-Hidden("xuserList",lc-userList) skip.
  {&out} htmlib-EndForm() skip.

  RUN ending-JS.

  {&OUT} htmlib-Footer() skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-timeBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE timeBar Procedure 
PROCEDURE timeBar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


 {&out}

  '<div id="fixedTimeDiv" style="position:relative;top:0px;left:0px;width:56px;z-index:100;">' skip


  

        '<table id="timeCells" cellpadding="0" cellspacing="0" border="0" width="0" style="border-left:1px solid #000000;border-right:1px solid #000000;border-bottom:1px solid #000000;">'  skip
          '<tr style="height:1px;background-color:#000000;">'  skip
            '<td>'  skip
            '</td>' skip
          '</tr>'  skip
          '<tr style="height:21px;">'  skip
            '<td valign="bottom" style="background-color:#ECE9D8;cursor:default;">'  skip
              '<div style="display:block;border-bottom:1px solid #000000;text-align:right;">'  skip 
                '<div style="padding:2px;font-size:6pt;">' skip
                  '&nbsp;' skip
                '</div>'  skip
              '</div>'  skip
            '</td>'  skip
          '</tr>'  skip.

    do vx = 01 to 24 :
      if vx * 100 >= hourFrom and vx * 100 <= hourTo then /* or how ever many hours to do... */
      do:
        if vx > 11 then assign ap = 2.
                     else assign ap = 1.
        if vx > 12 then assign yx = vx - 12.
                     else assign yx = vx.

    {&out}

           '<tr style="height:' (li-blockheight * 2) 'px;">' skip
            '<td valign="bottom" style="background-color:#ECE9D8;cursor:default;">' skip
             '<div id="idMenuFixedInViewport" >' skip
              '<div id="TT" style="display:block;border-bottom:1px solid #ACA899;height:' (li-blockheight * 1.5) 'px;text-align:right;">' skip
                '<div style="padding:2px;font-family:Tahoma;font-size:16pt;vertical-align:top;">' skip
          string(yx)   skip
                  '<span style="font-size:10px; vertical-align: super; ">&nbsp;' skip
          string(AMPM[ap])    skip
                  '</span>' skip
                '</div>' skip
              '</div>' skip
            '</div>' skip
            '</td>' skip
          '</tr>'  skip.
      end.
    end.

   {&out}
        '</table>' skip
     '</div>' skip
     .



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-dateFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dateFormat Procedure 
FUNCTION dateFormat RETURNS CHARACTER
  ( params as date ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

def var lc-day     as char no-undo.
def var lc-month   as char no-undo.
def var lc-year    as char no-undo.
def var lc-mthdesc as char initial "January,February,March,April,May,June,July,August,September,October,November,December"  no-undo.

lc-day = string(day(params)).
lc-month = entry(month(params),lc-mthdesc).
lc-year = string(year(params)).




  RETURN string((if length(lc-day) = 1 then "&nbsp;" + lc-day else lc-day) + " " + lc-month + " " + lc-year).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnText Procedure 
FUNCTION fnText RETURNS CHARACTER
  ( pf-knbid as dec,
    pi-count as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer knbText  for knbText.  
    def var li-count    as int no-undo.
    def var li-found    as int no-undo.
    def var lc-return   as char no-undo.
    def var lc-char     as char no-undo.

    find knbText where knbText.knbID = pf-knbID
                   and knbText.dType = "I" no-lock no-error.
    if not avail knbText then return "&nbsp;".


    do li-count = 1 to num-entries(knbText.dData,"~n"):

        assign lc-char = entry(li-count,knbText.dData,"~n").
        if trim(lc-char) = "" then next.

       
        if li-found = 0
        then assign lc-return = right-trim(lc-char).
        else assign lc-return = lc-return + "<br>" + right-trim(lc-char).

        assign li-found = li-found + 1.

        if li-found = pi-count then leave.

    end.

    return lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-DayDate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-DayDate Procedure 
FUNCTION Format-Select-DayDate RETURNS CHARACTER
  ( pc-htm as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<select',
                   '<select onChange="ChangeDates()"'). 


  RETURN lc-htm.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-timeFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION timeFormat Procedure 
FUNCTION timeFormat RETURNS CHARACTER
 (param1 as int):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var hh as char no-undo.
  def var mm as char no-undo.
  def var ss as char no-undo.
  def var aa as char no-undo.
 
  assign hh = string(int(substr(string(param1,"9999"),1,2)))
         mm  = substr(string(param1,"9999"),3,2).
         return string(string(hh) + ":" + string(mm) ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

