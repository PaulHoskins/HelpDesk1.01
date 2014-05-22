&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        time/diaryview.p
    
    Purpose:        Display the diary...
    
    Notes:
    
    
    When        Who         What
    01/09/2010  DJS      Initial
     
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

 


/* PARAM VARS */

def var userList            as char   no-undo.
def var lc-submitsource     as char   no-undo.
def var dayRange            as int    no-undo.
def var hourFrom            as int    no-undo.
def var hourTo              as int    no-undo.
def var coreHourFrom        as int    no-undo.
def var coreHourTo          as int    no-undo.
def var incWeekend          as log    no-undo.
def var saveSettings        as log    no-undo.
def var changeColour        as char   no-undo.
def var viewShowY           as int    no-undo.
def var viewshowX           as int    no-undo.

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
/* def var p-cx              as char initial "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40"  no-undo.  */
def var p-vx              as int      no-undo.
def var p-vz              as int      no-undo.
def var p-zx              as int      no-undo. 


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
def var lc-changeColour     as char   no-undo.
def var li-blockheight      as int    no-undo.
def var lc-blockheight      as char   no-undo.
def var li-offsetheight     as int    no-undo.
def var li-blockwidth       as int    no-undo.
def var lc-viewShowY        as char   no-undo.
def var lc-viewshowX        as char   no-undo.

/*  TABLES  */

def temp-table NewEvents like DiaryEvents
field idRow               as rowid
field eventID             as int format "999"
field overLap             as char format "x(9)" 
field comment             as char
field columnID            as int format "zz9"
field issueLeft           as int
field issueWidth          as int
field issRowid            as char
field actRowid            as char
field issClosed           as char
field userColour          as char
field duration            as char
.

def temp-table DE         like NewEvents.

def buffer bDE            for DE.
def buffer bbDE           for DE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnText Procedure 
FUNCTION fnText RETURNS CHARACTER
  ( pf-knbid as dec,
    pi-count as int )  FORWARD.

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
         HEIGHT             = 4.69
         WIDTH              = 35.57.
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
 lc-submitsource     = get-value("submitsource")
 lc-userList         = get-value("userList")
 lc-viewerDay        = get-value("viewerDay")     
 lc-dayRange         = get-value("dayRange")      
 lc-coreHourFrom     = get-value("coreHourFrom")  
 lc-coreHourTo       = get-value("coreHourTo")    
 lc-hourFrom         = get-value("hourFrom")      
 lc-hourTo           = get-value("hourTo")       
 lc-incWeekend       = get-value("incWeekend") 
 lc-saveSettings     = get-value("saveSettings") .
 lc-changeColour     = get-value("changeColour") .
 lc-viewShowY        = get-value("viewShowY") .
 lc-viewShowX        = get-value("viewShowX") .


/* output to "C:\temp\djs.txt" append.                   */
/* put unformatted                                       */
/* "LoginID              "     DiaryParams.LoginID skip  */
/* "lc-mode              "    lc-mode           skip     */
/* "lc-submitsource      "    lc-submitsource   skip     */
/* "lc-viewerDay         "    lc-viewerDay      skip     */
/* "lc-dayRange          "    lc-dayRange       skip     */
/* "lc-coreHourFrom      "    lc-coreHourFrom   skip     */
/* "lc-coreHourTo        "    lc-coreHourTo     skip     */
/* "lc-hourFrom          "    lc-hourFrom       skip     */
/* "lc-hourTo            "    lc-hourTo         skip     */
/* "lc-incWeekend        "    lc-incWeekend     skip     */
/* "lc-userList          "    lc-userList       skip     */
/* "lc-saveSettings      "    lc-saveSettings   skip     */
/* "lc-changeColour      "    lc-changeColour   skip     */
/* "lc-viewShowY         "    lc-viewShowY      skip     */
/* "lc-viewShowX         "    lc-viewShowX      skip     */
/* "lc-global-company    "    lc-global-company skip     */
/* "lc-global-user       "    lc-global-user    skip(2). */
/* output close.                                         */


if lc-submitsource = "dateChange" then
  assign viewerDay = date(substr(lc-viewerDay,1,2)  + "/" +  substr(lc-viewerDay,4,2) + "/" +  substr(lc-viewerDay,7) ).

if lc-submitsource = "daysChange" then
  assign dayRange  = integer(lc-dayRange).

if lc-submitsource = "userChange" then
  assign userList  = lc-userList.

if lc-submitsource = "changeSizeY" then
  assign viewShowY = integer(lc-viewShowY).

if lc-submitsource = "changeSizeX" then
  assign viewShowX = integer(lc-viewShowX).

if lc-submitsource  = "weekendChange" then
  assign incWeekend = if lc-incWeekend = "checked" then true else false.

if lc-submitsource    = "saveSettings" then
  assign saveSettings = if lc-saveSettings = "checked" then true else false.  

if lc-submitsource = "changeColour" then
do:
  assign changeColour = "".
  run updateColour(lc-changeColour).
end.

if lc-mode = "refresh" then
assign
  viewerDay     = date(substr(lc-viewerDay,1,2)  + "/" +  substr(lc-viewerDay,4,2) + "/" +  substr(lc-viewerDay,7) )  
  lc-mode       = "".
else
assign
  viewerDay     = today.


if lc-mode = "view" then
assign
  dayRange      = integer(DiaryParams.initialDays)
  coreHourFrom  = integer(substr(DiaryParams.coreHours,1,4))
  coreHourTo    = integer(substr(DiaryParams.coreHours,5,4))
  hourFrom      = integer(substr(DiaryParams.displayHours,1,4))
  hourTo        = integer(substr(DiaryParams.displayHours,5,4))
  incWeekend    = DiaryParams.incWeekends 
  saveSettings  = saveSettings
  userList      = if trim(DiaryParams.initialEngineers) = "" and DiaryParams.LoginID = "system" then lc-global-user else trim(DiaryParams.initialEngineers)
  viewShowY     = DiaryParams.viewShowY
  viewShowX     = DiaryParams.viewShowX
  .
else
assign 
  viewerDay     = date(substr(lc-viewerDay,1,2)  + "/" +  substr(lc-viewerDay,4,2) + "/" +  substr(lc-viewerDay,7) )  
  dayRange      = integer(lc-dayRange)
  coreHourFrom  = integer(lc-coreHourFrom)
  coreHourTo    = integer(lc-coreHourTo)
  hourFrom      = integer(string(lc-hourFrom,"9999"))
  hourTo        = integer(string(lc-hourTo,"9999"))
  incWeekend    = if lc-incWeekend = "checked" then true else false
  saveSettings  = if lc-saveSettings = "checked" then true else false
  userList      = lc-userList
  viewShowY     = integer(lc-viewShowY)
  viewShowX     = integer(lc-viewShowX)
  .


assign
  lc-lodate       =  string(viewerDay)                    /*   string(viewerDay + (0 - (round(dayRange / 2,0))) )         */
  lc-hidate       =  string(viewerDay + dayRange)         /*   string(viewerDay + (dayRange - (round(dayRange / 2,0))) )  */
  lc-mode         = "update"
  lc-viewerDay    = string(viewerDay)
  lc-dayRange     = string(dayRange)
  lc-coreHourFrom = string(coreHourFrom)
  lc-coreHourTo   = string(coreHourTo)
  lc-hourFrom     = string(hourFrom)
  lc-hourTo       = string(hourTo)
  lc-incWeekend   = if incWeekend then "checked" else ""
  lc-saveSettings = if saveSettings then "checked" else ""
  lc-userList     = userList
  lc-viewShowY    = if viewShowY = 0 then string(DiaryParams.viewShowY) else string(viewShowY)
  lc-viewShowX    = if viewShowX = 0 then string(DiaryParams.viewShowX) else string(viewShowX)
  .




/* output to "C:\temp\djs.txt" append.                   */
/* put unformatted                                       */
/* "lc-mode              "    lc-mode           skip     */
/* "lc-submitsource      "    lc-submitsource   skip     */
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
/* "lc-changeColour      "    lc-changeColour   skip     */
/* "lc-viewShowY         "    viewShowY         skip     */
/* "lc-viewShowX         "    viewShowX         skip     */
/* "lc-global-company    "    lc-global-company skip     */
/* "lc-global-user       "    lc-global-user    skip(2). */
/* output close.                                         */

if lc-submitsource = "saveSettings" then
do:
  if saveSettings then
  do:
  
    find first DiaryParams exclusive-lock 
         where DiaryParams.CompanyCode = lc-global-company 
         and   DiaryParams.LoginID     = lc-global-user no-error.
    if not avail DiaryParams then
    do:
      create DiaryParams.
      assign DiaryParams.CompanyCode = lc-global-company
             DiaryParams.LoginID     = lc-global-user.
    end.
    assign  DiaryParams.coreHours        = string(string(integer(lc-coreHourFrom),"9999") + string(integer(lc-coreHourTo),"9999") )
            DiaryParams.displayHours     = string(string(integer(lc-HourFrom),"9999") + string(integer(lc-HourTo),"9999") )
            DiaryParams.viewHours        = string(string(integer(lc-HourFrom),"9999") + string(integer(lc-HourTo),"9999") )
            DiaryParams.incWeekends      = incWeekend
            DiaryParams.initialDays      = dayRange
            DiaryParams.initialEngineers = lc-userList
            DiaryParams.viewShowY        = viewShowY
            DiaryParams.viewShowX        = viewShowX.
  end.
  else 
  if saveSettings = false then
  do:
    find first DiaryParams exclusive-lock 
         where DiaryParams.CompanyCode = lc-global-company 
         and   DiaryParams.LoginID     = lc-global-user no-error.
    if avail DiaryParams then delete DiaryParams.
  end.
  find first DiaryParams no-lock 
            where DiaryParams.CompanyCode = lc-global-company 
            and   DiaryParams.LoginID     = "system" no-error.
end.

for each webuser no-lock
   where webuser.companycode = lc-global-company
   and   lookup(webuser.loginid,lc-userList,",") > 0 :
  
  find WebStdTime of WebUser no-lock no-error .

  for each IssActivity no-lock
     where IssActivity.CompanyCode = webuser.CompanyCode
       and IssActivity.ActivityBy  = webuser.loginid
       and ( ( issactivity.StartDate >= date(lc-lodate) and issactivity.StartDate <= date(lc-hidate) )  
        or  ( issactivity.EndDate >= date(lc-lodate) and issactivity.EndDate <= date(lc-hidate) ) ) :

     find first issAction no-lock of issActivity no-error.
     find first issue no-lock where issue.CompanyCode = webuser.CompanyCode
                                and issue.IssueNumber = IssActivity.IssueNumber no-error.

     create NewEvents.
     assign
       NewEvents.ID          = string(issactivity.IssueNumber)
       NewEvents.EventData   = issactivity.Description 
       NewEvents.Name        = issactivity.ActivityBy   
       NewEvents.StartDate   = issactivity.StartDate
       NewEvents.StartTime   = integer(   string(substr( string(issactivity.StartTime ,"HH:MM"),1,2) + substr( string(issactivity.StartTime ,"HH:MM"),4,2),"9999" ))
       NewEvents.Duration    = com-TimeToString(issactivity.Duration)
       NewEvents.EndDate     = issactivity.EndDate
       NewEvents.EndTime     = integer(   string(substr( string(issactivity.EndTime ,"HH:MM"),1,2) + substr( string(issactivity.EndTime ,"HH:MM"),4,2),"9999" ))
       NewEvents.EventRowid  = if avail issue then       string(rowid(issue)) else ""
       NewEvents.issRowid    = if avail issAction then   string(rowid(issAction)) else ""
       NewEvents.actRowid    = if avail issactivity then string(rowid(issactivity)) else ""
       NewEvents.issClosed   = if avail Issue then Issue.StatusCode else ""
       NewEvents.userColour  = if avail WebStdTime then WebStdTime.StdColour else "#000000"
       .
      if  NewEvents.StartTime + 5  > NewEvents.EndTime  then NewEvents.EndTime = NewEvents.StartTime + 5.
/*       else if  NewEvents.EndTime - NewEvents.StartTime <  integer(   string(substr(NewEvents.Duration,1,index(NewEvents.Duration,":") - 1) + substr(NewEvents.Duration,index(NewEvents.Duration,":") + 1,2),"9999" ) ) */
/*         then NewEvents.EndTime = NewEvents.StartTime +  integer(   string(substr(NewEvents.Duration,1,index(NewEvents.Duration,":") - 1) + substr(NewEvents.Duration,index(NewEvents.Duration,":") + 1,2),"9999" ) ).  */
/*       if NewEvents.StartTime < hourFrom then NewEvents.StartTime = hourFrom + 100.  */
/*       if NewEvents.EndTime > hourTo then NewEvents.EndTime = hourTo - 100.          */
  end.             
end.               


assign
  hourFrom        = integer(substr(DiaryParams.displayHours,1,4))
  hourTo          = integer(substr(DiaryParams.displayHours,5,4)).

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


if lc-submitsource = "changeSizeY" or lc-submitsource = "changeSizeX" then
do:
  RUN refresh-web-request.
  return.
end.
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createEvents Procedure 
PROCEDURE createEvents :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  empty temp-table DE no-error.
  p-vx = 0.
  p-vz = 0.
  p-zx = 0.
  timeEnd = 0.
    for each NewEvents no-lock where NewEvents.StartDate = currentDay  
                             break by NewEvents.StartTime :
    create DE.
    buffer-copy NewEvents to DE. 
      
      assign p-vx          = p-vx + 1
             DE.eventID    = p-vx /* integer(entry(p-vx,p-cx)) */
             DE.issueWidth = 1
             DE.overLap    = string(p-vx)
             DE.columnID   = 1.
  end.


  for each DE where  DE.StartDate = currentDay by DE.eventID :
  for each bDE where bDE.StartDate  = currentDay
               and   bDE.StartTime >= DE.StartTime
               and   bDE.eventID   <> DE.eventID
               by bDE.eventID :
      if  ( bDE.StartTime >= DE.StartTime and bDE.EndTime  <= DE.EndTime )
        or (bDE.StartTime <= DE.EndTime and bDE.StartTime  >= DE.StartTime)
      then assign bDE.ColumnID = DE.ColumnID + 1.
      else assign bDE.ColumnID = if DE.ColumnID > 1 then bDE.ColumnID else 1.
  end.
  end.
  
  for each DE where DE.Startdate = currentDay by DE.StartTime  :
  for each bDE where bDE.Startdate = currentDay
               and bDE.eventID <> DE.eventID
               and ( bDE.StartTime >= DE.StartTime
               or   (bDE.StartTime <= DE.EndTime and bDE.StartTime  >= DE.StartTime) )
               by bDE.StartTime :
    if bDE.EndTime  <= DE.EndTime  and bDE.StartTime <= DE.EndTime then assign DE.overLap = if lookup(string(bDE.eventID),DE.overLap) > 0 then DE.overLap else DE.overLap + "," + string(bDE.eventID).
    else
    if  bDE.StartTime >= DE.EndTime and bDE.eventID < DE.eventID then assign bDE.overLap = if lookup(string(DE.eventID),bDE.overLap) > 0 then bDE.overLap else bDE.overLap + "," + string(DE.eventID).
    else
    if  DE.EndTime >= bDE.StartTime and bDE.eventID > DE.eventID then assign DE.overLap = if lookup(string(bDE.eventID),DE.overLap) > 0 then DE.overLap else DE.overLap + "," + string(bDE.eventID).
    else
      if bDE.StartTime <= DE.EndTime and bDE.StartTime  >= DE.StartTime then assign DE.overLap = if lookup(string(bDE.eventID),DE.overLap) > 0 then DE.overLap else bDE.overLap + "," + string(bDE.eventID).
   end.
  end.
  for each DE where DE.Startdate = currentDay by DE.StartTime  :
  for each bDE where bDE.Startdate = currentDay
               and   bDE.eventID <> DE.eventID
               and  (bDE.StartTime <= DE.EndTime and bDE.StartTime  >= DE.StartTime)
               by bDE.StartTime :
      assign bDE.overLap =  if lookup(string(bDE.eventID),DE.overLap) > 0 then bDE.overLap else bDE.overLap + "," + DE.overLap  .
     end.
  end.
  
  
  for each DE where DE.Startdate = currentDay by DE.StartTime   :
  INNER:
  for each bDE where bDE.Startdate = currentDay  by bDE.columnID :
    if lookup(string(bDE.eventID),DE.overLap) > 0
    then
    do:
      if bDE.columnID > DE.issueWidth
      then
      do:
          DE.issueWidth = bDE.columnID.
      end.
      else if bDE.issueWidth > DE.issueWidth
      then
      do:
          DE.issueWidth = bDE.issueWidth.
      end.
    end.
  end.
  if DE.issueWidth < DE.columnID then DE.issueWidth = DE.columnID.
  DE.issueLeft = DE.columnID.
  end.
  
  
  


END PROCEDURE.


/*                                                                                                             */
/*       if   (DE.StartTime <= bDE.StartTime) and (DE.StartTime < bDE.EndTime)                                 */
/*       then assign DE.overLap = DE.overLap + "," + string(bDE.eventID).                                      */
/*                                                                                                             */
/*       else                                                                                                  */
/*       if  ((DE.StartTime > bDE.StartTime) and (DE.StartTime > bDE.EndTime)) and DE.columnID < bDE.columnID  */
/*       then assign DE.overLap = DE.overLap + "," + string(bDE.eventID).                                      */
/*                                                                                                             */
/*       else                                                                                                  */
/*       if DE.columnID <> bDE.columnID                                                                        */
/*       then  assign DE.overLap = DE.overLap + "," + string(bDE.eventID).                                     */
/*                                                                                                             */


/*  for each DE where DE.Startdate = currentDay by DE.StartTime  :                                                                                                                       */
/*                                                                                                                                                                                       */
/*     for each bDE where bDE.Startdate = currentDay                                                                                                                                     */
/*                  and   bDE.EndTime >= DE.EndTime by bDE.StartTime :                                                                                                                   */
/*                                                                                                                                                                                       */
/*       if ( (((DE.StartTime < bDE.StartTime) and (DE.StartTime < bDE.EndTime)) or ((DE.StartTime > bDE.StartTime) and (DE.StartTime > bDE.EndTime))) and DE.columnID < bDE.columnID )  */
/*       then do:                                                                                                                                                                        */
/*                                                                                                                                                                                       */
/*             assign DE.overLap = DE.overLap + "," + string(bDE.eventID).                                                                                                               */
/*                                                                                                                                                                                       */
/*       end.                                                                                                                                                                            */
/*       else if DE.columnID <> bDE.columnID then do:                                                                                                                                    */
/*           assign DE.overLap = DE.overLap + "," + string(bDE.eventID).                                                                                                                 */
/*       end.                                                                                                                                                                            */
/*       else do:                                                                                                                                                                        */
/*           assign DE.overLap = DE.overLap.                                                                                                                                             */
/*       end.                                                                                                                                                                            */
/*     end.                                                                                                                                                                              */
/*   end.                                                                                                                                                                                */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-diaryHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE diaryHeader Procedure 
PROCEDURE diaryHeader :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



{&out}

/* '<link type="text/css" rel="stylesheet" href="demo.css" />' skip */
 
'<script type="text/javascript">' skip
' var myWidth=' string(li-blockwidth)  ';' skip
' var myHeight=10;' skip
' var isIE = false;' skip
' var ActionAjax = "' appurl '/time/diaryview.p"' skip
skip

 

/* FIX DIV POSITION */
'function fixTimeDiv(div) ~{' skip
'  var obj = document.getElementById(div);' skip 
'  var cw = document.body.clientWidth;' skip
'  var ch = document.body.clientHeight;' skip
'  var x = document.body.scrollLeft;' skip
'  var y = document.body.scrollTop;' skip
'  var w = obj.offsetWidth;' skip
'  var h = obj.offsetHeight;' skip
/*   'alert( " X = " + x + "  CW = "  + cw  + "  W = " + w + " Total = " + ( cw + x - (cw  +  w - 60)  ) );'  */
'  if ( isIE == true ) ~{' skip
'    obj.style.left = cw + x - (cw +  w - 60);' skip
'    obj.style.top =  15;' skip
'  ~}' skip
'  else ~{' skip
'    obj.style.left = cw + x - (cw + w - 54);' skip
'    obj.style.top = 15;' skip
'  ~}' skip
'~}' skip
skip

/* Select Event */
'function eventSelect(thisRow,actRow,issRow)' skip
' ~{' skip
'    window.open(~'' appurl '/iss/activityupdate.p?mode=updatesingle&issuerowid=~' + thisRow + ~'&actionrowid=~' + actRow + ~'&rowid=~' + issRow + ~'~',~'mywindow~',~'width=600,height=400~');' skip
' ~}' skip
skip


/* SCROLL WINDOW */
'function scrollWindow()' skip
' ~{' skip
'   window.location.hash = "moveHere";' skip
' ~}' skip
skip
'</script>' skip


 /* STYLE ADDITION */
'<STYLE TYPE="text/css">' skip
'<!--' skip
'* html .minwidth ~{' skip
'    border-left:' dayWidth 'px; ' skip
'         _width:' dayWidth 'px; ' skip  /* IE6 hack */
'          width:' dayWidth 'px; ' skip
'      min-width:' dayWidth 'px; ' skip
'~}' skip
'-->' skip
'</STYLE>' skip

'<style type="text/css" media="screen" >' skip
'body ~{' skip
'       width: ' string(li-blockwidth)  skip
'       background-color: #FFFFFF;' skip
'       color: #000000;' skip
'       font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;' skip
'       font-size: 11px;' skip
'       font-style: normal;' skip
'       font-variant: normal;' skip
'       font-weight: normal;' skip
'       margin: 0px 0px 0px 0px;' skip
'~}' skip
'.programtitle ~{' skip
'       background-color: #F2EFE9;' skip
'       color: Blue;' skip
'       text-align: center;' skip
'       width: 100%;' skip
'       word-spacing: 2px;' skip
'       font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;' skip
'       font-weight: bold;' skip
'       font-size: 14px;' skip
'~}' skip
'.button ~{' skip
'       font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;' skip
'       font-weight:normal;' skip
'       font-size:100%;' skip
'       color:#000000;' skip
'       background-color:#ffffff;' skip
'       border-color:#6699ff;' skip
'       margin-top:2pt;' skip
'       margin-left: .5em;' skip
'~}' skip
 skip 

'</style>' skip
  '</head>' skip
 skip
 .
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertEvents Procedure 
PROCEDURE insertEvents :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var timeStart     as dec    no-undo.
def var timeSPixels   as char   no-undo.
def var timeFinish    as dec    no-undo.
def var timeFPixels   as char   no-undo.
def var daysIssues    as int    no-undo.
def var issueWidth    as int    no-undo.
def var issueLeft     as int    no-undo.
def var startMin      as int    no-undo.
def var startMax      as int    no-undo.
def var offSetCol     as int    no-undo.
def var offSetWidth   as int    no-undo.
def var offRowid      as rowid  no-undo.
def var closedColour  as char   no-undo.
def var userColour    as char   no-undo.
def var thisEndTime   as int    no-undo.

/* Down to XXX will be iterations through the database... */

/* assign timeStart = truncate(hourFrom / 100,0) + dec(hourFrom modulo 100 / 60).  */

do zx = 1 to dayRange:

   assign currentDay = date(string(viewerDay + (zx - 1)))  /* date(string(viewerDay + (zx - (round(dayRange / 2,0))))) */
          dayNum     = weekday(currentDay).
   if not incWeekend and (dayNum = 1 or dayNum = 7) then next.
   if can-find(first NewEvents where NewEvents.StartDate = currentDay)
   then
   do:
      {&out} '<td width="'  + dayWidth  + 'px"  style="height:1px;text-align:left;">'  skip.
          
      run createEvents.

      for each DE where DE.StartDate = currentDay by DE.StartTime :

        if DE.StartTime + 100 <= hourFrom then timeStart = hourFrom + 100. else timeStart = DE.StartTime + 100.
        if DE.EndTime - 100  >= hourTo then timeFinish = hourTo - 100. else timeFinish = DE.EndTime + 100.
        assign bubbleNo     = bubbleNo + 1
               timeStart    = truncate(timeStart / 100,0) + dec(timeStart modulo 100 / 60) /* convert time to decimal  */

               timeSPixels  = string(round(((timeStart - (hourFrom / 100)) * (li-blockheight * 2)) - li-offsetheight,2))

               timeFinish   = truncate(timeFinish / 100,0) + dec(timeFinish modulo 100 / 60) /* convert time to decimal  */
               timeFPixels  = string(round(((timeFinish - timeStart) * (li-blockheight * 2)),0))
               timeFPixels  = if integer(timeFPixels) < 16 then "16" else timeFPixels

               issueWidth   = round(truncate(100 / DE.issueWidth,0) - 1,2)                   
               issueLeft    = (DE.issueleft - 1) * (issueWidth + 1)
               closedColour = if DE.IssClosed begins "CLOS" then "green" else "red"  
               userColour   = DE.userColour
               .

      {&out}  /* CCC */
                '<div id="CCC"  style="display:block;margin-right:5px;position:relative;height:1px;font-size:1px;margin-top:-1px;">' skip .


      {&out}  /* DDD */
                '<div id="DDD"  onselectstart="return false;" onclick="javascript:event.cancelBubble=true;' /*  'eventSelect(~'' + DE.EventRowid  + '~',~'' + NewEvents.issRowid + '~',~'' + NewEvents.actRowid + '~');' */
                  '"' 
                  ' style="-moz-user-select:none;-khtml-user-select:none;user-select:none;cursor:pointer;position:absolute;font-family:Tahoma;font-size:8pt;white-space:nowrap;'
                  ' left:' + string(issueLeft)  + '%;top:' + timeSPixels + 'px;width:' + string(issueWidth) + '%;height:' + timeFPixels + 'px;background-color:#000000;">' skip
             /*                      ^^^^^ hour position                                                               */
                  '<div  id="EEE" ' 
                  ' onclick="eventSelect(~'' + DE.EventRowid  + '~',~'' + DE.issRowid + '~',~'' + DE.actRowid + '~')";'
                  ' onmouseover="this.style.backgroundColor=~'#DCDCDC~';event.cancelBubble=true;"'
                  ' onmouseout="this.style.backgroundColor=~'#FFFFFF~';event.cancelBubble=true;"'
                  ' title="'
          string(DE.Name + " - "  + DE.ID + " - " + timeFormat(DE.StartTime) + " - " + timeFormat(DE.EndTime) +  " - " + DE.EventData ). /* Full details here */
           timeFPixels = string(integer(timeFPixels) - 2 ).     /* fix the inner height */
           issueWidth  = if issueWidth < 70 then 98 else 99.    /* fix the inner width */
      {&out}
                    '" style="width:' + string(issueWidth) + '%;margin-top:1px;display:block;height:' 
                    + timeFPixels +
                    /* ^^^^  time spread of box                                                        vvvvv main box border        */
                    'px;background-color:#FFFFFF;border-left:1px solid ' + userColour + ';border-right:2px solid ' + closedColour + ';overflow:hidden;">' skip
                    /*                                                         vvvv time spread of box                  */
                     '<div id="INNER" style="float:left;width:5px;height:' + timeFPixels + 'px;margin-top:0px;' 
                     'background-color:' + userColour + ';font-size:1px;"></div>' skip
                    /*                 ^^^^  big bar colour                 */
                     '<div id="ione" style="float:left;width:1px;background-color:#000000;height:100%;"></div>' skip
                     '<div id="itwo" style="float:left;width:2px;height:100%;"></div>' skip
                     '<div id="ithree" style="padding:1px;">' skip
      string(DE.Name + "<br>" + timeFormat(DE.StartTime) + " - " + timeFormat(DE.EndTime) +  "<br>" + DE.EventData )  skip /* Box detail here */
                    '</div>' skip
                  '</div>' skip
                '</div>' skip.

      {&out}  /* EEE */
                '</div>'  skip.
      end.
      {&out}  '</td>' skip.
 
   end.
   else
   do:
      {&out}  /* BBB */
            '<td width="'  + dayWidth  + 'px" style="height:1px;text-align:left;">'  skip
              '<div id="BBB" style="display:block;margin-right:5px;position:relative;height:1px;font-size:1px;margin-top:-1px;">'  skip
              '</div>'  skip
            '</td>' skip.
   end.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mainDiary) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mainDiary Procedure 
PROCEDURE mainDiary :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* START OF PAGE */



lc-blockheight = string(li-blockheight) + "px".

/* run timeBar. */

{&out}   /* MAIN OUTER TABLE BEGIN */
'<table id="Calendar1" cellpadding="0" cellspacing="0" border="0" width="' string(li-blockwidth)  'px" >'  skip
    '<tr>'  skip
      '<td valign="top">'   

  .
{&out} 
'<div id="CalInner" style="position:absolute;top:0px;left:0px;;border-right:1px solid #000000;">' skip
'<table id="CalendarInner" cellpadding="0" cellspacing="0" border="0" width="100%" style="border-bottom:1px solid #000000;text-align:left;">'  skip
  '<tr>'  skip
    '<td valign="top">'  skip
    '</td>' skip
    '<td width="100%" valign="top">'  skip.

 {&out}   /* AAA */
      '<table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-left:1px solid #000000;">'  skip
        '<tr style="height:1px;background-color:#000000;">' skip .

 run insertEvents.

  /*   below here should be constant .....*/


/* COLUMN DATE ENTRY  */
 {&out}  
        '</tr>' skip
        '<tr style="background-color:#ECE9D8;height:21px;">'  skip.

    do zx = 1 to dayRange:
    
        assign dayDate = viewerDay + int(zx - 1)   /*  viewerDay + int(zx - (round(dayRange / 2,0))) */
               dayNum  = weekday(dayDate)
               dayDesc = entry(dayNum,dayList)
               dayDesc = if dayRange > 7 then substr(dayDesc,1,4) else dayDesc
               .
     if not incWeekend and (dayNum = 1 or dayNum = 7) then next.

     {&out}
              '<td class="minwidth" valign="bottom" style="background-color:#ECE9D8;cursor:default;border-right:1px solid #000000;">'.
     
     if dayDate = today then  
          {&out}  '<a name="moveHere" />'  skip
                  '<div   class="minwidth" style="display:block;background-color:yellow;border-bottom:1px solid #000000;text-align:center;height:20px; ">'.

     else {&out}  '<div   class="minwidth" style="display:block;border-bottom:1px solid #000000;text-align:center;height:20px; ">'.

     {&out}         '<div >' skip
             
                    '<div   style="padding:2px;font-family:Tahoma;font-size:10pt;width:90%;">' skip
                      '<div   style="position:relative; font-family:Tahoma;font-size:10pt;float:left;left:-10px;width:30px;">' skip
                        string(day(dayDate))  skip
                      '</div>' skip
                      '<span style="position:relative;left:-18px;">' + dayDesc  + '</span>' skip
                                 '</div>' skip
                    '</div>' skip
                                '</div>' skip
                                '</td>'   .   
    end.

 {&out}
        '</tr>'  .


/* HOUR CELL ENTRY  */
        
  do vx = 01 to 24 :
  
    if vx * 100 >= hourFrom and vx * 100 <= hourTo then  /* or how ever many hours to do... */
    do:
  
   {&out}
          '<!-- empty cells -->' skip
          '<tr>'   skip.
  
       do zx = 0 to dayRange:
        assign dayDate = viewerDay + int(zx)   /*  viewerDay + int(zx - (round(dayRange / 2,0))) */
               dayNum  = weekday(dayDate)
               dayDesc = string(viewerDay + zx) + " - " + string(vx).    /* string(viewerDay + (zx - (round(dayRange / 2,0)))) + " - " + string(vx). */
      
       if not incWeekend and (dayNum = 1 or dayNum = 7) then next.

       {&out}
              '<td onclick="javascript:alert(~''
          dayDesc 
                ':00~');"'.
        if vx * 100 < coreHourFrom or vx * 100  > coreHourTo or dayNum = 1 or dayNum = 7 then
          {&out} ' onmouseover="this.style.backgroundColor=~'#99FFCC~';"'
                 ' onmouseout="this.style.backgroundColor=~'#CCFFCC~';"'
                 ' valign="bottom" style="background-color:#CCFFCC;cursor:pointer;border-right:1px solid #000000;height:' lc-blockheight ';">'
                .
        else
          {&out} ' onmouseover="this.style.backgroundColor=~'#FFED95~';"'
                 ' onmouseout="this.style.backgroundColor=~'#FFFFD5~';"'
                 ' valign="bottom" style="background-color:#FFFFD5;cursor:pointer;border-right:1px solid #000000;height:' lc-blockheight ';">'
                .
          {&out}
                '<div style="display:block;height:14px;border-bottom:1px solid #EAD098;z-index:50;">'
                  '<span style="font-size:1px">&nbsp;</span>'
                '</div>'
              '</td>' skip.
       end.
      
   {&out}
          '</tr>' skip 
          '<tr style="height:' lc-blockheight ';">'  skip .
  
       do zx = 0 to dayRange:
         assign dayDate = viewerDay + int(zx)   /*  viewerDay + int(zx - (round(dayRange / 2,0))) */
                dayNum  = weekday(dayDate)
                dayDesc = string(viewerDay + zx) + " - " + string(vx).    /* string(viewerDay + (zx - (round(dayRange / 2,0)))) + " - " + string(vx). */
      
        if not incWeekend and (dayNum = 1 or dayNum = 7) then next.

       {&out}
            '<td onclick="javascript:alert(~'' 
        dayDesc
              ':30~');"'.


        if vx * 100 < coreHourFrom or vx * 100  > coreHourTo or dayNum = 1 or dayNum = 7 then
          {&out} ' onmouseover="this.style.backgroundColor=~'#99FFCC~';"'
                 ' onmouseout="this.style.backgroundColor=~'#CCFFCC~';"'
                 ' valign="bottom" style="background-color:#CCFFCC;cursor:pointer;border-right:1px solid #000000;height:' lc-blockheight ';">'
                .
        else
          {&out} ' onmouseover="this.style.backgroundColor=~'#FFED95~';"'
                 ' onmouseout="this.style.backgroundColor=~'#FFFFD5~';"'
                 ' valign="bottom" style="background-color:#FFFFD5;cursor:pointer;border-right:1px solid #000000;height:' lc-blockheight ';">'
                .
          {&out}
                  '<div style="display:block;height:14px;border-bottom:1px solid #EAD098;z-index:50;">'
                  '<span style="font-size:1px">&nbsp;</span>'
                '</div>'
            '</td>' skip.
       end.
   
   {&out}
          '</tr>' skip .
    end.
  end.
        

{&out}
      '</table>'  skip   
    '</td>'       skip   
  '</tr>'         skip   
'</table>'        skip
'</div>'          skip
'</table>'        skip
    .


{&out}
  '<!--[if IE ]>' skip
  ' <script>' skip
  '   isIE = true;' skip
  ' </script>' skip
  '<![endif]-->' skip
/*   '<script type="text/javascript">' skip                            */
/*   '  fixTimeDiv("fixedTimeDiv");' skip                              */
/*   '  window.setInterval(~'fixTimeDiv("fixedTimeDiv")~', 500);' skip */
/*   '  scrollWindow();' skip                                          */
/*   '</script>'                                                       */
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

    RUN outputHeader.

    {&out} htmlib-OpenHeader("Diary View") skip.
 
    {&out}
        '<style>' skip
           '.hi ~{ color: red; font-size: 10px; margin-left: 15px; font-style: italic;~}' skip
           '</style>' skip 
           '<link href="/style/diary.css" type="text/css" rel="stylesheet" />' skip.

    run diaryHeader.

    {&out} htmlib-CloseHeader("") skip.
 
    {&out} '<div id="diaryinner" style="clear:both;" >' skip.
    
    run mainDiary.

    {&out} '</div>' skip.

    {&out} htmlib-StartForm("diaryinnerform","post", appurl + '/time/diaryview.p' ) skip.
    {&out} htmlib-Hidden("mode",lc-mode) skip.
    {&out} htmlib-Hidden("submitsource","null") skip.
    {&out} htmlib-Hidden("userList",lc-userList) skip.
    {&out} htmlib-Hidden("viewerDay",lc-viewerDay) skip.
    {&out} htmlib-Hidden("dayRange",lc-dayRange) skip.
    {&out} htmlib-Hidden("coreHourFrom",lc-coreHourFrom) skip.
    {&out} htmlib-Hidden("coreHourTo",lc-coreHourTo) skip.
    {&out} htmlib-Hidden("hourFrom",lc-hourFrom) skip.
    {&out} htmlib-Hidden("hourTo",lc-hourTo) skip.
    {&out} htmlib-Hidden("incWeekend",lc-incWeekend) skip.
    {&out} htmlib-Hidden("saveSettings",lc-saveSettings) skip.
    {&out} htmlib-Hidden("changeColour",lc-changeColour) skip.
    {&out} htmlib-Hidden("viewShowY",lc-viewShowY) skip.
    {&out} htmlib-Hidden("viewShowX",lc-viewShowX) skip.

    {&out} htmlib-EndForm() skip.
 
    {&out} htmlib-Footer() skip.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refresh-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-web-request Procedure 
PROCEDURE refresh-web-request :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN outputHeader.
  
 
   {&out} '<script language="javascript">' skip
         ' parent.RefreshSelf("' lc-mode '", "'
                                lc-viewerDay        '", "'  
                                lc-dayRange         '", "'  
                                lc-coreHourFrom     '", "'  
                                lc-coreHourTo       '", "'  
                                lc-hourFrom         '", "'  
                                lc-hourTo           '", "'  
                                lc-incWeekend       '", "'  
                                lc-viewShowY        '", "'  
                                lc-viewShowX        '", "' 
                                lc-userList         '" ); ' skip
         '</script>' skip  .

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

  '<div id="fixedTimeDiv" style="position:absolute;top:0px;left:0px;width:56px;z-index:100;">' skip

  '<input type="button" onclick="scrollWindow()" value="Today" />'  skip 
  

        '<table cellpadding="0" cellspacing="0" border="0" width="0" style="border-left:1px solid #000000;border-right:1px solid #000000;border-bottom:1px solid #000000;">'  skip
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
      if vx * 100 > hourFrom and vx * 100 < hourTo then /* or how ever many hours to do... */
      do:
        if vx > 11 then assign ap = 2.
                     else assign ap = 1.
        if vx > 12 then assign yx = vx - 12.
                     else assign yx = vx.

    {&out}

           '<tr style="height:40px;">' skip
            '<td valign="bottom" style="background-color:#ECE9D8;cursor:default;">' skip
             '<div id="idMenuFixedInViewport" >' skip
              '<div style="display:block;border-bottom:1px solid #ACA899;height:39px;text-align:right;">' skip
                '<div style="padding:2px;font-family:Tahoma;font-size:16pt;">' skip
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

&IF DEFINED(EXCLUDE-updateColour) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateColour Procedure 
PROCEDURE updateColour :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pc-input   as char   no-undo.

def var pc-user             as char   no-undo.
def var pc-colour           as char   no-undo.

assign pc-user = entry(1,pc-input,"|")
       pc-colour = entry(2,pc-input,"|").
              
  find first WebStdTime where WebStdTime.CompanyCode = lc-global-company
                        and   WebStdTime.loginID = pc-user no-error.

  if avail WebStdTime then
      assign WebStdTime.StdColour = pc-colour.

              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

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

