/***********************************************************************

    Program:        lib/maillib.i
    
    Purpose:             
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      Initial
    20/06/2011  DJS         Added email html format
***********************************************************************/

&if defined(maillib-library-defined) = 0 &then

&glob maillib-library-defined yes

DEFINE STREAM mlib-s.

FUNCTION mlib-SendAttEmail RETURNS LOG
    (pc-companyCode AS CHARACTER,
    pc-Sender AS CHARACTER,
    pc-Subject AS CHARACTER,
    pc-Message AS CHARACTER,
    pc-To AS CHARACTER,
    pc-cc AS CHARACTER,
    pc-Bcc AS CHARACTER,
    pc-Attachment AS CHARACTER):
     
    DEFINE VARIABLE lc-perl       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-message    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE li-loop       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE li-mail       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-address-to AS CHARACTER NO-UNDO.

    DEFINE BUFFER company FOR company.
    FIND company 
        WHERE company.companycode = pc-companyCode NO-LOCK NO-ERROR.
    IF NOT AVAILABLE company THEN RETURN FALSE.
    IF company.smtp = "" THEN RETURN FALSE.

    ASSIGN 
        pc-subject = REPLACE(pc-subject,"~"","").
    ASSIGN 
        pc-subject = REPLACE(pc-subject,"'","").
    
    ASSIGN 
        pc-message = REPLACE(pc-message,"~"","").
    ASSIGN 
        pc-message = REPLACE(pc-message,"'","").
    
    IF company.EmailFooter <> ""
        THEN ASSIGN pc-message = pc-message + "~n~n" + company.EmailFooter.

    IF pc-Sender = ""
        THEN ASSIGN pc-Sender = company.HelpDeskEmail.
    
    ASSIGN 
        pc-message = pc-message + "~n~n"
        + dynamic-function("mlib-Reader",pc-attachment).

    DO li-loop = 1 TO NUM-ENTRIES(pc-message,'|'):
    
        IF li-loop = 1
            THEN ASSIGN lc-message = ENTRY(1,pc-message,'|').
        ELSE ASSIGN lc-message = lc-message + "\n" 
                                + entry(li-loop,pc-message,'|').
    END.

    ASSIGN 
        lc-address-to = DYNAMIC-FUNCTION("mlib-OutAddress",pc-to).
    
    DO li-mail = 1 TO NUM-ENTRIES(lc-address-to):
        ASSIGN 
            lc-perl = DYNAMIC-FUNCTION("mlib-PerlFile").
        OUTPUT to value(lc-perl).
        PUT UNFORMATTED
            "use Mail::Sender;" SKIP
            "$sender = new Mail::Sender ~{ smtp => '" company.smtp "',"
            " from => '" pc-Sender "'~};" SKIP.
   

        PUT UNFORMATTED
            "$sender->MailFile(~{to =>'" ENTRY(li-mail,lc-address-to) "',"
            " subject => '" pc-Subject "',".
    
        IF pc-cc <> ""
            THEN PUT UNFORMATTED 
                " cc => '" DYNAMIC-FUNCTION("mlib-OutAddress",pc-cc) "',".
        
        IF pc-bcc <> ""
            AND pc-bcc <> ? 
            THEN PUT UNFORMATTED
                " bcc => '" DYNAMIC-FUNCTION("mlib-OutAddress",pc-bcc) "',".
    
        PUT UNFORMATTED
            " msg => ~"" lc-message "~","
            " file => '" pc-attachment "'" 
            " ~});" SKIP
            .
    
        OUTPUT close.
        OS-COMMAND SILENT c:\perl\bin\perl VALUE(lc-perl).
    /* os-delete value(lc-perl). */
    END.
    
    RETURN TRUE.
END FUNCTION.     
    
   
FUNCTION mlib-SendEmail RETURNS LOG
    (pc-CompanyCode AS CHARACTER,
    pc-Sender AS CHARACTER,
    pc-Subject AS CHARACTER,
    pc-Message AS CHARACTER,
    pc-To AS CHARACTER
    ):


    DEFINE VARIABLE lc-perl       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-message    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE li-loop       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-address-to AS CHARACTER NO-UNDO.
    DEFINE VARIABLE li-mail       AS INTEGER   NO-UNDO.

    
    DEFINE BUFFER company FOR company.
    FIND company 
        WHERE company.companycode = pc-companyCode NO-LOCK NO-ERROR.
    IF NOT AVAILABLE company THEN RETURN FALSE.
    IF company.smtp = "" THEN RETURN FALSE.

    IF pc-Sender = ""
        THEN ASSIGN pc-Sender = company.HelpDeskEmail.
    
    ASSIGN 
        lc-address-to = DYNAMIC-FUNCTION("mlib-OutAddress",pc-to).

    IF company.EmailFooter <> ""
        THEN ASSIGN pc-message = pc-message + "~n~n" + company.EmailFooter.
    /* 
    *** 
    *** PH - Mail::Sender can handle multiply addresss, com sep, in the 
    *** to field but for some reason it doesn't work with our mail server
    *** so send each email individually
    ***
    */
    DO li-mail = 1 TO NUM-ENTRIES(lc-address-to):
    
        ASSIGN 
            lc-perl = DYNAMIC-FUNCTION("mlib-PerlFile").
        OUTPUT to value(lc-perl).
        PUT UNFORMATTED
            "use Mail::Sender;" SKIP
            "$sender = new Mail::Sender ~{smtp => '" company.smtp "', from => '" 
            pc-Sender "'~};" SKIP
            "ref $sender->Open(~{to => '" 
            ENTRY(li-mail,lc-Address-To) 
            "', subject => '" pc-subject "'~})" SKIP
            "or die ~"Error: $Mail::Sender::Error\n~";" SKIP
            "my $FH = $sender->GetHandle();" SKIP
            "print $FH <<'*END*';" SKIP.

        DO li-loop = 1 TO NUM-ENTRIES(pc-message,'|'):
            PUT UNFORMATTED ENTRY(li-loop,pc-message,'|') SKIP.
        END.

        PUT UNFORMATTED 
            "*END*" SKIP
            "$sender->Close;" SKIP.
        OUTPUT close.
        OS-COMMAND SILENT c:\perl\bin\perl VALUE(lc-perl).
        OS-DELETE value(lc-perl).
    END.

END FUNCTION.    


/* ADDED June 2011 - DJS */
FUNCTION mlib-SendMultipartEmail RETURNS LOG
    (pc-CompanyCode AS CHARACTER,
    pc-Sender AS CHARACTER,
    pc-Subject AS CHARACTER,
    pc-Message AS CHARACTER,
    pc-H-Message AS CHARACTER,
    pc-To AS CHARACTER
    ):
                

    DEFINE VARIABLE lc-perl       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-message    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE li-loop       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-address-to AS CHARACTER NO-UNDO.
    DEFINE VARIABLE li-mail       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-boundry    AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER company FOR company.

    FIND company WHERE company.companycode = pc-companyCode NO-LOCK NO-ERROR.
    IF NOT AVAILABLE company THEN RETURN FALSE.
    IF company.smtp = "" THEN RETURN FALSE.

    IF pc-Sender = "" THEN ASSIGN pc-Sender = company.HelpDeskEmail.
    
    ASSIGN 
        lc-address-to = DYNAMIC-FUNCTION("mlib-OutAddress",pc-to).

    IF company.EmailFooter <> ""
        THEN ASSIGN pc-Message   = pc-Message + "~n~n" + company.EmailFooter
            pc-H-Message = pc-H-message + '<pre style="font-family:Verdana,Geneva,Arial,Helvetica sans-serif;font-size:12px">'
                             + company.EmailFooter + '</pre></div></body></html>'.
    ELSE ASSIGN pc-H-Message = pc-H-message + '</div></body></html>'.
    
    ASSIGN 
        lc-perl = DYNAMIC-FUNCTION("mlib-PerlFile").

    OUTPUT to value(lc-perl).

    ASSIGN 
        lc-boundry = "====" + string(RANDOM(11111111,99999999),"99999999") 
                               + string(TIME,"99999999") 
                               + string(RANDOM(11111111,99999999),"99999999")
                               + "====".
    PUT UNFORMATTED
        "use MIME::QuotedPrint;" SKIP
        "use HTML::Entities;" SKIP
        "use Mail::Sender;" SKIP
        "$sender = new Mail::Sender ~{smtp => '" company.smtp "', from => '" 
        pc-Sender "'~};" SKIP
        "ref $sender->Open(~{to => '"  lc-Address-To
        "', subject => '" pc-subject "'  , ctype => 'multipart/alternative; boundary=~"" lc-boundry "~"' ~})" SKIP
        "or die ~"Error: $Mail::Sender::Error\n~";" SKIP
        "my $FH = $sender->GetHandle();" SKIP
        "print $FH <<'*END*';" SKIP(2).

    PUT UNFORMATTED
        "--" lc-boundry SKIP
        "Content-Type: text/plain; charset=~"iso-8859-1~"" SKIP
        "Content-Transfer-Encoding: 8bit" SKIP(2).

    PUT UNFORMATTED pc-Message SKIP(2).

    PUT UNFORMATTED
        "--" lc-boundry SKIP
        "Content-Type: text/html; charset=~"iso-8859-1~"" SKIP
        "Content-Transfer-Encoding: 8bit" SKIP(2).

    PUT UNFORMATTED pc-H-Message SKIP(2).

    PUT UNFORMATTED
        "--" lc-boundry "--" SKIP(2).
        
    PUT UNFORMATTED 
        "*END*" SKIP
        "$sender->Close;" SKIP.

    OUTPUT close.
    OS-COMMAND SILENT c:\perl\bin\perl VALUE(lc-perl).
/*     os-delete value(lc-perl).                          */

END FUNCTION.     
/* ------------------------------------------------------ */


FUNCTION mlib-SendPassword RETURNS LOG ( pc-user AS CHARACTER, pc-password AS CHARACTER ):

    DEFINE VARIABLE lc-file    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE lc-smtp    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-sender  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-message AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-subject AS CHARACTER NO-UNDO.

    DEFINE VARIABLE li-count   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-line    AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-user  FOR WebUser.
    DEFINE BUFFER company FOR company.


    FIND b-user WHERE b-user.loginid = pc-user NO-LOCK NO-ERROR.

    IF b-user.email = "" THEN RETURN FALSE.

    FIND company WHERE company.companycode = b-user.company NO-LOCK NO-ERROR.
    IF company.HelpDeskEmail = "" THEN RETURN FALSE.

    ASSIGN
        lc-message = "Dear $forename,~n~nYour password has been changed for the $company HelpDesk to the following:~n~n" + 
                     "User Name: $user~n" + 
                     " Password: $password~n~n" +
                     "Once you have logged in you can change your password using the 'Change Password' option.~n~nPlease note that this password is case sensitive.~n".
    
    ASSIGN 
        lc-message = REPLACE(lc-message,"$name",
                                b-user.forename + ' ' + b-user.surname).
    ASSIGN 
        lc-message = REPLACE(lc-message,"$forename",
                                b-user.forename).
    ASSIGN 
        lc-message = REPLACE(lc-message,"$user",pc-user).
    ASSIGN 
        lc-message = REPLACE(lc-message,"$company",company.name).

    ASSIGN 
        lc-message = REPLACE(lc-message,"$password",pc-password).

    RETURN DYNAMIC-FUNCTION("mlib-SendEmail",
        b-user.companycode,
        company.HelpDeskemail,
        "Password changed",
        lc-message,
        b-user.email).
                           

    
   

END FUNCTION.
    
FUNCTION mlib-PerlFile RETURNS CHARACTER
    ():
        
    DEFINE VARIABLE lc-base AS CHARACTER NO-UNDO.
    DEFINE VARIABLE li-cnt  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-file AS CHARACTER NO-UNDO.            
                
    ASSIGN 
        lc-base = SESSION:TEMP-DIR + string(YEAR(TODAY),"9999") 
                                      + string(MONTH(TODAY),"99")
                                      + string(DAY(TODAY),"99")
                                      + "-" + string(TIME).
                
    DO WHILE TRUE:
        ASSIGN 
            li-cnt = li-cnt + 1.
        ASSIGN 
            lc-file = lc-base + string(li-cnt) + '.pl'.
        IF SEARCH(lc-file) <> ? THEN NEXT.
        LEAVE.
    END.
    RETURN lc-file.
END FUNCTION.        

FUNCTION mlib-Reader RETURNS CHARACTER
    ( pc-attachment AS CHARACTER ):
    
    
    IF pc-attachment MATCHES "*.pdf" THEN
    DO:
        RETURN "||The attachment has been created using Adode Acrobat" + 
            " and you will require the Acrobat Reader." + 
            "|This is available free of charge from www.adobe.com.".
    END.
    ELSE RETURN "".
END FUNCTION.    

/*
*** 
*** See dev 1051
***
*/
FUNCTION mlib-OutAddress RETURNS CHARACTER ( pc-out AS CHARACTER ):
    DEFINE VARIABLE lc-conv AS CHARACTER NO-UNDO.
    
    RETURN pc-out.

END FUNCTION.
&endif
