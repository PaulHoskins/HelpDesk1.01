&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************

    Program:        lib/navpanel.i
    
    Purpose:        Bottom panel on maintenance pages     
    
    Notes:
    
    
    When        Who         What
    27/04/2006  phoski      Initial    
***********************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
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

{&out} htmlib-StartPanel() 
        skip.

    
{&out}  '<tr><td align="left">'.
        

if lr-first-row <> ? then
do:
    get first q no-lock.
    if rowid(b-query) = lr-first-row 
    then assign ll-prev = false.
    else assign ll-prev = true.

    get last q no-lock.
    if rowid(b-query) = lr-last-row
    then assign ll-next = false.
    else assign ll-next = true.

    if ll-prev 
    then {&out} htmlib-MntButton(appurl + '/' + "{1}","PrevPage","Prev Page").

  
    if ll-next 
    then {&out} htmlib-MntButton(appurl + '/' + "{1}","NextPage","Next Page").

    if not ll-prev
    and not ll-next 
    then {&out} "&nbsp;".


end.
else {&out} "&nbsp;".

{&out} '</td><td align="right">' htmlib-ErrorMessage(lc-smessage)
      '</td></tr>'.

{&out} htmlib-EndPanel().

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


