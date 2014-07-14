&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        lib/slacalc.p
    
    Purpose:        Calculate SLA Schedule         
    
    Notes:
    
    
    When        Who         What
    06/05/2006  phoski      Initial
    18/05/2014  phoski      Date/Time Fields
    
***********************************************************************/
{lib/slatt.i}

def input param pd-Date     as date                 no-undo.
def input param pi-Time     as int                  no-undo.
def input param pf-SLAID    like slahead.SLAID      no-undo.
def output param table for tt-sla-sched.


def buffer slahead  for slahead.
def buffer company  for company.


def var ll-work-day     as log      extent 7        no-undo.
def var li-sla-begin    as int                      no-undo.
def var li-sla-end      as int                      no-undo.
def var ll-office       as log                      no-undo.
def var li-minutes      as int                      no-undo.

def var ld-start        as date                     no-undo.
def var li-start        as int                      no-undo.
def var li-level         as int                      no-undo.


def var li-loop as int no-undo.
def var li-mins-end-day     as int no-undo.
def var li-mins-begin-day   as int no-undo.
def var li-seconds as int no-undo.
def var li-min-count    as int no-undo.
def var ld-day-count    as date no-undo.
def var li-counter      as int  no-undo.
DEF VAR ldt-Level2      AS DATETIME NO-UNDO.
DEF VAR ldt-Amber2      AS DATETIME NO-UNDO.
DEF VAR li-Mill         AS INT  NO-UNDO.
DEF VAR lc-dt           AS CHAR NO-UNDO.




def buffer tt           for tt-sla-sched.
def buffer tb           for tt-sla-sched.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnConvertHourMin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnConvertHourMin Procedure 
FUNCTION fnConvertHourMin RETURNS INTEGER
  ( pi-Hours    as int,
    pi-Mins     as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnInitialise) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnInitialise Procedure 
FUNCTION fnInitialise RETURNS logical
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnSeconds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSeconds Procedure 
FUNCTION fnSeconds RETURNS INTEGER
  ( pc-Unit as char,
    pi-Unit as int )  FORWARD.

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


find slahead where slahead.SLAID = pf-SLAID no-lock no-error.
if not avail slahead then return.
if slahead.RespDesc[1] = "" then return.
find company where company.CompanyCode = slahead.CompanyCode no-lock.

DYNAMIC-FUNCTION('fnInitialise':U).

assign
    ld-start = pd-date
    li-start = truncate(pi-time / 60,0) * 60.

/*
***
*** Office hours and the SLA starts after office close
*** then set the begin date/time to tomorrow at opening time
***
*/
if ll-office then
do:
    if li-start > li-sla-end 
    then assign
            ld-start = ld-start + 1
            li-start = li-sla-begin.  
    if li-start < li-sla-begin 
    then assign 
        li-start = li-sla-begin.
end.


do while true:
    if ll-work-day[weekday(ld-start)] then leave.
    /*
    ***
    *** Not a working day so need to jump forward 
    ***
    */
    assign ld-start = ld-start + 1.
    if ll-office 
    then li-start = li-sla-begin.
    else li-start = 0.
end.


create tt.
assign tt.level = 0
       tt.note  = "begin"
       tt.sDate = ld-start
       tt.STime = li-start.

/*
***
*** End of day in minutes
***
*/
assign
    li-mins-end-day = fnSeconds("DAY",1) / 60
    li-mins-begin-day = 0.
if ll-office
then assign
        li-mins-end-day = li-sla-end / 60
        li-mins-begin-day = li-sla-begin / 60.

do li-level = 1 to 10:
    if slahead.RespDesc[li-level] = "" then leave.

    find tt
        where tt.Level = 
            ( if slahead.AlertBase = "ISSUE" then 0 else li-level - 1 ).

    create tb.
    assign tb.Level = li-level
           tb.note  = slahead.RespDesc[li-level] + ' ' + 
                      slahead.RespUnit[li-level] + ' ' + 
                      string(slahead.RespTime[li-level]) + ' prev = ' 
                      + string(tt.sdate)
                      + ' ' + string(tt.stime,'hh:mm:ss')
           tb.Sdate = tt.Sdate
           tb.STime = tt.Stime.


    /*
    ***
    *** SLA based on 24 hour clock
    ***
    */
    if not ll-office 
    or ( ll-office and can-do("DAY,WEEK",slahead.RespUnit[li-level]) = false ) then
    do:
        li-minutes = ( fnSeconds(slahead.RespUnit[li-level],
                               slahead.RespTime[li-level]) ) / 60.
    
        assign tb.note = tb.note + " mi=" + string(li-minutes).
    
        assign
            li-min-count = tb.STime / 60
            ld-day-count = tb.SDate.
    
        do li-loop = 1 to li-minutes:
            assign li-min-count = li-min-count + 1.   
            if li-min-count > li-mins-end-day then
            do:
                assign
                    li-min-count = li-mins-begin-day.
                do while true:
                    assign ld-day-count = ld-day-count + 1.
                    if ll-work-day[weekday(ld-day-count)] then leave.
                end.
    
            end.
    
        end.
        assign tb.note = tb.note + " Calc = " + 
            string(ld-day-count,'99/99/9999') + ' ' +  
            string(li-min-count * 60,'hh:mm:ss').
    
        assign 
            tb.Sdate = ld-day-count
            tb.STime = li-min-count * 60.
    
    end.
    else
    do:
        assign
            li-min-count = tb.STime / 60
            ld-day-count = tb.SDate.

        if can-do("DAY,WEEK",slahead.RespUnit[li-level]) then
        do:
            assign li-counter = slahead.RespTime[li-level].
            if slahead.RespUnit[li-level] = "WEEK"
            then assign li-counter = li-counter * 7.
            do li-loop = 1 to li-counter:
                do while true:
                    assign ld-day-count = ld-day-count + 1.
                    if ll-work-day[weekday(ld-day-count)] then leave.
                end.
            end.
        end.
        else 
        if slahead.RespUnit[li-level] = "HOUR" then
        do:

        end.
        else
        if slahead.RespUnit[li-level] = "MINUTE" then
        do:

        end.

        assign 
            tb.Sdate = ld-day-count
            tb.STime = li-min-count * 60.

    end.
    
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnConvertHourMin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnConvertHourMin Procedure 
FUNCTION fnConvertHourMin RETURNS INTEGER
  ( pi-Hours    as int,
    pi-Mins     as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return ( ( pi-hours * 60 ) * 60 ) +
           ( pi-mins * 60 ).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnInitialise) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnInitialise Procedure 
FUNCTION fnInitialise RETURNS logical
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    empty temp-table tt-sla-sched.

    assign
        ll-work-day = true.

    
    if slahead.incSat = false
    then assign ll-work-day[7] = false.
    if slahead.incSun = false
    then assign ll-work-day[1] = false.

    
    assign 
        li-sla-begin = DYNAMIC-FUNCTION('fnConvertHourMin':U,
                                        company.SLABeginHour,
                                        company.SLABeginMin)
        li-sla-end   = DYNAMIC-FUNCTION('fnConvertHourMin':U,
                                        company.SLAEndHour,
                                        company.SLAEndMin)
        ll-office    = slahead.TimeBase = "OFF".



    return true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnSeconds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSeconds Procedure 
FUNCTION fnSeconds RETURNS INTEGER
  ( pc-Unit as char,
    pi-Unit as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    case pc-Unit:
        when "MINUTE" then return pi-unit * 60.
        when "HOUR"   then return pi-unit * ( fnSeconds("MINUTE",1) * 60 ).
        when "DAY"    then return pi-unit * ( fnSeconds("HOUR",1) * 24).
        when "WEEK"   then return pi-unit * ( fnSeconds("DAY",1) * 7 ).
        otherwise
            do:
               return 1.
            end.
           
    end case.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

