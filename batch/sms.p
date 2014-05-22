&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        batch/sms.p
    
    Purpose:        SMS Processing
    
    Notes:
    
    
    When        Who         What
    12/05/2006  phoski      Initial

***********************************************************************/

{lib/common.i}
{iss/issue.i}

def buffer SMSQueue        for SMSQueue.
def buffer ro-SMSQueue     for SMSQueue.

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

def var ld-date             as date         no-undo.
def var li-time             as int          no-undo.
def var chSMS               as com-handle.
def var li-ok               as int      no-undo.
def var lc-id               as char     no-undo.


 create "IntelliSoftware.IntelliSMS.1" chSMS no-error.

if error-status:error then
do:
    message "Its an error".
    return.
end.


chSMS:UserName = lc-global-sms-username.
chSMS:Password = lc-global-sms-password.



for each ro-SMSQueue no-lock
    where ro-SMSQueue.QStatus = 0 transaction
    with frame f-log down stream-io:

    find SMSQueue where rowid(SMSQueue) = rowid(ro-SMSQueue) 
        exclusive-lock no-wait no-error.
    if locked SMSQueue
    or not avail SMSQueue then next.


    li-ok = chSMS:SendMessage( 
        	  SMSQueue.Mobile,
        	  trim(substr(SMSQueue.Msg,1,140)),
        	  "HelpDesk",
        	  output lc-id by-variant-pointer ).
   
    assign
        SMSQueue.SMSResponse = li-ok
        SMSQueue.SentDate    = today
        SMSQueue.SentTime    = time
        SMSQueue.QStatus     = 1.

    if li-ok = 1
    then assign
            SMSQueue.SMSID       = lc-id.
 
end.

release object chSMS.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


