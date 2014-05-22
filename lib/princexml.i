/***********************************************************************

    Program:        lib/princexml.i
    
    Purpose:             
    
    Notes:
    
    
    When        Who         What
    11/04/2006  phoski      Initial
    
    03/08/2010  DJS         3665 - Changed to putput only the html file
                            for the email
    20/06/2011  DJS         Changed to output as complete HTML email
    
***********************************************************************/

&if defined(princexml-library-defined) = 0 &then

&glob princexml-library-defined yes

&global-define prince put stream s-prince unformatted 

def stream s-prince.
def var lc-prince-exec  as char initial
    '"C:\Program Files (x86)\Prince\engine\bin\prince.exe"'   no-undo.

def temp-table tt-pxml      no-undo
    field   PageOrientation     as char
    . 




function pxml-Convert       returns log ( pc-html as char , pc-pdf as char):

    os-command silent value(lc-prince-exec + " " + pc-html + " " + pc-pdf ).

    return search(pc-pdf) <> ?.

end function.



function pxml-Initialise    returns log ():
    empty temp-table tt-pxml.

end function.



function pxml-Safe returns char ( p_in as char ):
    ASSIGN
        p_in = REPLACE(p_in, "&":U, "&amp~;":U)       /* ampersand */
        p_in = REPLACE(p_in, "~"":U, "&quot~;":U)     /* quote */
        p_in = REPLACE(p_in, "<":U, "&lt~;":U)        /* < */
        p_in = REPLACE(p_in, ">":U, "&gt~;":U).       /* > */

    RETURN p_in.

end function.



function pxml-StandardHTMLBegin returns log ():

    {&prince}
        '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">' skip
        '<html>' skip
        '<head>' skip
        .
    return true.

end function.

function pxml-StandardBody returns log ():

    {&prince}
        '</head>' skip
        '<body>' skip.

    return true.


end function.



function pxml-Header        returns log (pc-companyCode as char):


    def buffer b-company for Company.


    dynamic-function("pxml-StandardHTMLBegin").

    dynamic-function("pxml-StyleSheet",pc-companyCode).
    
    find company where company.Companycode = pc-companyCode no-lock no-error.

    dynamic-function("pxml-StandardBody").

    
    if not avail Company then
    {&prince}
        '<div class="heading">' skip
        '   Micar Computer Systems Limited - HelpDesk' skip.
    else
    {&prince}
        '<div class="heading">' skip
        '   ' dynamic-function("pxml-Safe",Company.Name) ' - HelpDesk' skip.
    
    dynamic-function("pxml-Logo",pc-companyCode).
        
    {&prince}
        '   <span style="float: right">' string(today,"99/99/9999") '</span>' skip
        '</div>' skip
        '<div id="content">' skip.


    return true.

end function.


/* ADDED June 2011 - DJS */
function pxml-Email-Header        returns char (pc-companyCode as char):
def var lc-output       as char   no-undo.
def var lc-use          as char   no-undo.


def buffer b-company for Company.




lc-output =  '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">' +
        '<html>' +
        '<head>'
        .

    find company where company.Companycode = pc-companyCode no-lock no-error.

lc-output = lc-output +
      '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">' +
      '<title>' + company.Name + '</title>'  .



lc-output = lc-output +
      '</head>' +
      '<body>' +
      '<div >' +
      '<table style="position:relative;flow:static(header);width:100%;font-size:15px; ">' +
      '<tr>' +
      '</tr>' +
      '<td>' .



if pc-companyCode = "micar" then
do:
  lc-use = "http://micar.com/resources/template/header_logo.gif".
  lc-output = lc-output + '<img src="' + lc-use + '" height=113px width=160px style="float: left; padding-right: 10px;">' .
end.
else
do:
  lc-use = "http://www.ouritdept.co.uk/files/main_logo.jpg".
  lc-output = lc-output + '<img src="' + lc-use + '" height=70px width=160px style="float: left; padding-right: 10px;">' .
end.



lc-output = lc-output +
      '</td>' +
      '<td>' +
      '</td>' +
      '<tr>' +
      '<td align="left">' .

    if not avail Company then
lc-output = lc-output +
        '<div class="heading">' +
        '   Micar Computer Systems Limited - HelpDesk' .
    else
lc-output = lc-output +
        '<div class="heading">' +
        dynamic-function("pxml-Safe",Company.Name) + ' - HelpDesk' .

lc-output = lc-output +
      '</td>' +
      '<td align="right">' + string(today,"99/99/9999") + '</td>' +
      '</tr>' +
      '</table>' +
      '</div>' .



return lc-output.

end function.

/* ------------------------------------------------------------- */

function pxml-PrePrintFooter returns log ( pc-companyCode as char ):

    def buffer b-Company for Company.

    find Company 
        where Company.CompanyCode = pc-CompanyCode no-lock no-error.

    if not avail Company then return true.

    {&prince}
        '<style>' skip
        '@page ~{' skip
        '@bottom ~{' skip
        'font-size: 8px;' skip
        'content: "' Company.name '";' skip
        'border-top: 1px solid black;' skip
        '~}' skip
        '~}' skip
        '</style>' skip.

    return true.
end function.


function pxml-Footer returns log ( pc-companycode as char ):

    {&prince}
        '</div>' skip
        '</body>' skip
        '</html>' skip.

    return true.

end function.


function pxml-FileNameLogo returns char ( pc-CompanyCode as char ):

    def var lc-style        as char extent 2    no-undo.
    def var li-loop         as int              no-undo.
    def var lc-use          as char             no-undo.

    assign
        lc-style[1] = "prince/" + lc(pc-companyCode) + "/logo.gif"
        lc-style[2] = "prince/default/logo.gif".

    do li-loop = 1 to 2:
        assign lc-style[li-loop] = search((lc-style[li-loop])).
        if lc-style[li-loop] = ? then next.
        assign
            lc-use = lc-style[li-loop].
        leave.
    end.

    if lc-use <> ? then
    do:
        file-info:file-name = lc-use.
        assign lc-use = file-info:full-pathname.
    end.

    return lc-use.

end function.


function pxml-Logo    returns log ( pc-companyCode as char ):

    def var lc-use          as char             no-undo.

    if pc-companyCode = "micar" then 
    do:
      
      lc-use = "http://micar.com/resources/template/header_logo.gif".

        {&prince} 
            '<img src="' lc-use '" height=113px width=160px style="float: left; padding-right: 10px;">' skip. 
    end.
    else
    do:
      
      lc-use = "http://www.ouritdept.co.uk/files/main_logo.jpg".

        {&prince} 
            '<img src="' lc-use '" height=70px width=160px style="float: left; padding-right: 10px;">' skip. 
    end.

    return true.

end function.


function pxml-StyleSheet    returns log ( pc-companyCode as char ):

    def buffer b-tt-pxml    for tt-pxml.
    def var lc-style        as char extent 2    no-undo.
    def var li-loop         as int              no-undo.
    def var lc-use          as char             no-undo.
    def var lc-css          as char initial "prince.css".
    def var cTextLine       as char             no-undo.

    find first tt-pxml no-lock no-error.
    if avail tt-pxml
    and tt-pxml.PageOrientation = "LANDSCAPE"
    then assign lc-css = "landscape" + lc-css.

    assign
        lc-style[1] = "prince/" + lc(pc-companyCode) + "/" + lc-css
        lc-style[2] = "prince/default/" + lc-css.

    do li-loop = 1 to 2:
        assign lc-style[li-loop] = search((lc-style[li-loop])).
        if lc-style[li-loop] = ? then next.
        assign
            lc-use = lc-style[li-loop].
        leave.
    end.

    if lc-use <> ? then
    do:
        file-info:file-name = lc-use.
        assign lc-use = file-info:full-pathname.
        {&prince} 
          '<style type="text/css"> ' skip.
           input from value( lc-use ) no-echo. /* read in the stylesheet */
           repeat:
            import unformatted cTextLine.      /* read the whole text line... */
           {&prince} cTextLine skip.
            end.
        {&prince} 
          '</style> ' skip.
    end.

    return true.

end function.


function pxml-DocumentStyleSheet    returns log ( pc-Document as char ,
                                                  pc-companyCode as char ):

    def buffer b-tt-pxml    for tt-pxml.
    def var lc-style        as char extent 2    no-undo.
    def var li-loop         as int              no-undo.
    def var lc-use          as char             no-undo.
    def var lc-css          as char initial "prince.css".

    assign 
        lc-css = lc(pc-document) + ".css".

    find first tt-pxml no-lock no-error.
    if avail tt-pxml
    and tt-pxml.PageOrientation = "LANDSCAPE"
    then assign lc-css = "landscape" + lc-css.

    assign
        lc-style[1] = "prince/" + lc(pc-companyCode) + "/" + lc-css
        lc-style[2] = "prince/default/" + lc-css.

    do li-loop = 1 to 2:
        assign lc-style[li-loop] = search((lc-style[li-loop])).
        if lc-style[li-loop] = ? then next.
        assign
            lc-use = lc-style[li-loop].
        leave.
    end.

    if lc-use <> ? then
    do:
        file-info:file-name = lc-use.
        assign lc-use = file-info:full-pathname.
        {&prince} 
            '<link rel="stylesheet" href="' lc-use '" type="text/css">' skip.

    end.

    return true.

end function.


function pxml-OpenStream    returns log ( pc-filename as char ):

    output stream s-prince to value(pc-filename).
    
end function.


function pxml-CloseStream   returns log ():

    output stream s-prince close.

end function.

&endif
