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

def stream mlib-s.

FUNCTION mlib-SendAttEmail returns log
    (pc-companyCode as char,
     pc-Sender as char,
     pc-Subject as char,
     pc-Message as char,
     pc-To as char,
     pc-cc as char,
     pc-Bcc as char,
     pc-Attachment as char):
     
    def var lc-perl             as char no-undo.
    def var lc-message          as char no-undo.
    def var li-loop             as int no-undo.
    def var li-mail             as int no-undo.
    def var lc-address-to       as char no-undo.

    def buffer company  for company.
    find company 
        where company.companycode = pc-companyCode no-lock no-error.
    if not avail company then return false.
    if company.smtp = "" then return false.

    assign pc-subject = replace(pc-subject,"~"","").
    assign pc-subject = replace(pc-subject,"'","").
    
    assign pc-message = replace(pc-message,"~"","").
    assign pc-message = replace(pc-message,"'","").
    
    if company.EmailFooter <> ""
    then assign pc-message = pc-message + "~n~n" + company.EmailFooter.

    if pc-Sender = ""
    then assign pc-Sender = company.HelpDeskEmail.
    
    assign pc-message = pc-message + "~n~n"
        + dynamic-function("mlib-Reader",pc-attachment).

    do li-loop = 1 to num-entries(pc-message,'|'):
    
        if li-loop = 1
        then assign lc-message = entry(1,pc-message,'|').
        else assign lc-message = lc-message + "\n" 
                                + entry(li-loop,pc-message,'|').
    end.

    assign lc-address-to = dynamic-function("mlib-OutAddress",pc-to).
    
    do li-mail = 1 to num-entries(lc-address-to):
        assign lc-perl = dynamic-function("mlib-PerlFile").
        output to value(lc-perl).
        put unformatted
            "use Mail::Sender;" skip
            "$sender = new Mail::Sender ~{ smtp => '" company.smtp "',"
                " from => '" pc-Sender "'~};" skip.
   

        put unformatted
            "$sender->MailFile(~{to =>'" entry(li-mail,lc-address-to) "',"
            " subject => '" pc-Subject "',".
    
        if pc-cc <> ""
        then put unformatted 
            " cc => '" dynamic-function("mlib-OutAddress",pc-cc) "',".
        
        if pc-bcc <> ""
        and pc-bcc <> ? 
        then put unformatted
            " bcc => '" dynamic-function("mlib-OutAddress",pc-bcc) "',".
    
        put unformatted
            " msg => ~"" lc-message "~","
            " file => '" pc-attachment "'" 
            " ~});" skip
            .
    
        output close.
        os-command silent c:\perl\bin\perl value(lc-perl).
        /* os-delete value(lc-perl). */
    end.
    
    return true.
END FUNCTION.     
    
   
FUNCTION mlib-SendEmail returns log
    (pc-CompanyCode as char,
     pc-Sender as char,
     pc-Subject as char,
     pc-Message as char,
     pc-To as char
     ):


    def var lc-perl         as char no-undo.
    def var lc-message      as char no-undo.
    def var li-loop         as int no-undo.
    def var lc-address-to   as char no-undo.
    def var li-mail         as int no-undo.

    
    def buffer company  for company.
    find company 
        where company.companycode = pc-companyCode no-lock no-error.
    if not avail company then return false.
    if company.smtp = "" then return false.

    if pc-Sender = ""
    then assign pc-Sender = company.HelpDeskEmail.
    
    assign lc-address-to = dynamic-function("mlib-OutAddress",pc-to).

    if company.EmailFooter <> ""
    then assign pc-message = pc-message + "~n~n" + company.EmailFooter.
    /* 
    *** 
    *** PH - Mail::Sender can handle multiply addresss, com sep, in the 
    *** to field but for some reason it doesn't work with our mail server
    *** so send each email individually
    ***
    */
    do li-mail = 1 to num-entries(lc-address-to):
    
        assign lc-perl = dynamic-function("mlib-PerlFile").
        output to value(lc-perl).
        put unformatted
            "use Mail::Sender;" skip
            "$sender = new Mail::Sender ~{smtp => '" company.smtp "', from => '" 
                pc-Sender "'~};" skip
            "ref $sender->Open(~{to => '" 
                entry(li-mail,lc-Address-To) 
                "', subject => '" pc-subject "'~})" skip
            "or die ~"Error: $Mail::Sender::Error\n~";" skip
            "my $FH = $sender->GetHandle();" skip
            "print $FH <<'*END*';" skip.

        do li-loop = 1 to num-entries(pc-message,'|'):
            put unformatted entry(li-loop,pc-message,'|') skip.
        end.

        put unformatted 
            "*END*" skip
            "$sender->Close;" skip.
        output close.
        os-command silent c:\perl\bin\perl value(lc-perl).
        os-delete value(lc-perl).
    end.

END FUNCTION.    


/* ADDED June 2011 - DJS */
FUNCTION mlib-SendMultipartEmail returns log
    (pc-CompanyCode as char,
     pc-Sender as char,
     pc-Subject as char,
     pc-Message as char,
     pc-H-Message as char,
     pc-To as char
     ):
                

    def var lc-perl         as char no-undo.
    def var lc-message      as char no-undo.
    def var li-loop         as int no-undo.
    def var lc-address-to   as char no-undo.
    def var li-mail         as int no-undo.
    def var lc-boundry      as char no-undo.
    
    def buffer company  for company.

    find company where company.companycode = pc-companyCode no-lock no-error.
    if not avail company then return false.
    if company.smtp = "" then return false.

    if pc-Sender = "" then assign pc-Sender = company.HelpDeskEmail.
    
    assign lc-address-to = dynamic-function("mlib-OutAddress",pc-to).

    if company.EmailFooter <> ""
    then assign pc-Message   = pc-Message + "~n~n" + company.EmailFooter
                pc-H-Message = pc-H-message + '<pre style="font-family:Verdana,Geneva,Arial,Helvetica sans-serif;font-size:12px">'
                             + company.EmailFooter + '</pre></div></body></html>'.
    else assign pc-H-Message = pc-H-message + '</div></body></html>'.
    
    assign lc-perl = dynamic-function("mlib-PerlFile").

    output to value(lc-perl).

    assign lc-boundry = "====" + string(random(11111111,99999999),"99999999") 
                               + string(time,"99999999") 
                               + string(random(11111111,99999999),"99999999")
                               + "====".
    put unformatted
      "use MIME::QuotedPrint;" skip
      "use HTML::Entities;" skip
      "use Mail::Sender;" skip
      "$sender = new Mail::Sender ~{smtp => '" company.smtp "', from => '" 
          pc-Sender "'~};" skip
      "ref $sender->Open(~{to => '"  lc-Address-To
          "', subject => '" pc-subject "'  , ctype => 'multipart/alternative; boundary=~"" lc-boundry "~"' ~})" skip
      "or die ~"Error: $Mail::Sender::Error\n~";" skip
      "my $FH = $sender->GetHandle();" skip
      "print $FH <<'*END*';" skip(2).

    put unformatted
      "--" lc-boundry skip
      "Content-Type: text/plain; charset=~"iso-8859-1~"" skip
      "Content-Transfer-Encoding: 8bit" skip(2).

    put unformatted pc-Message skip(2).

    put unformatted
      "--" lc-boundry skip
      "Content-Type: text/html; charset=~"iso-8859-1~"" skip
      "Content-Transfer-Encoding: 8bit" skip(2).

    put unformatted pc-H-Message skip(2).

    put unformatted
      "--" lc-boundry "--" skip(2).
        
    put unformatted 
        "*END*" skip
        "$sender->Close;" skip.

    output close.
    os-command silent c:\perl\bin\perl value(lc-perl).
/*     os-delete value(lc-perl).                          */

END FUNCTION.     
/* ------------------------------------------------------ */


function mlib-SendPassword returns log ( pc-user as char, pc-password as char ):

    def var lc-file     as char no-undo.

    def var lc-smtp     as char no-undo.
    def var lc-sender   as char no-undo.
    def var lc-message  as char no-undo.
    def var lc-subject  as char no-undo.

    def var li-count    as int no-undo.
    def var lc-line     as char no-undo.


    def buffer b-user   for WebUser.
    def buffer company  for company.


    find b-user where b-user.loginid = pc-user no-lock no-error.

    if b-user.email = "" then return false.

    find company where company.companycode = b-user.company no-lock no-error.
    if company.HelpDeskEmail = "" then return false.

    assign
        lc-message = "Dear $forename,~n~nYour password has been changed for the $company HelpDesk to the following:~n~n" + 
                     "User Name: $user~n" + 
                     " Password: $password~n~n" +
                     "Once you have logged in you can change your password using the 'Change Password' option.~n~nPlease note that this password is case sensitive.~n".
    
    assign lc-message = replace(lc-message,"$name",
                                b-user.forename + ' ' + b-user.surname).
    assign lc-message = replace(lc-message,"$forename",
                                b-user.forename).
    assign lc-message = replace(lc-message,"$user",pc-user).
    assign lc-message = replace(lc-message,"$company",company.name).

    assign lc-message = replace(lc-message,"$password",pc-password).

    return dynamic-function("mlib-SendEmail",
                            b-user.companycode,
                            company.HelpDeskemail,
                            "Password changed",
                            lc-message,
                            b-user.email).
                           

    
   

end function.
    
FUNCTION mlib-PerlFile returns char
        ():
        
    def var lc-base as char no-undo.
    def var li-cnt  as int  no-undo.
    def var lc-file as char no-undo.            
                
    assign lc-base = session:temp-dir + string(year(today),"9999") 
                                      + string(month(today),"99")
                                      + string(day(today),"99")
                                      + "-" + string(time).
                
    do while true:
        assign li-cnt = li-cnt + 1.
        assign lc-file = lc-base + string(li-cnt) + '.pl'.
        if search(lc-file) <> ? then next.
        leave.
    end.
    return lc-file.
END FUNCTION.        

FUNCTION mlib-Reader returns char
    ( pc-attachment as char ):
    
    
    if pc-attachment matches "*.pdf" then
    do:
        return "||The attachment has been created using Adode Acrobat" + 
               " and you will require the Acrobat Reader." + 
               "|This is available free of charge from www.adobe.com.".
    end.
    else return "".
END FUNCTION.    

/*
*** 
*** See dev 1051
***
*/
FUNCTION mlib-OutAddress returns char ( pc-out as char ):
    def var lc-conv as char no-undo.
    
    return pc-out.

END FUNCTION.
&endif
