
/*------------------------------------------------------------------------
    File        : TEST-REP
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : paul
    Created     : Sat Nov 22 09:40:25 GMT 2014
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */



/* ********************  Preprocessor Definitions  ******************** */

{rep/engrep01-build.i}

/* ***************************  Main Block  *************************** */
 RUN rep/engrep01-build.p
        (
        "OURITDEPT",
        "1",
        "2",
        "1",
        "all" ,
        "ALL" ,
        "ALL-2014",
        OUTPUT TABLE tt-IssRep,
        OUTPUT TABLE tt-IssTime,
        OUTPUT TABLE tt-IssTotal,
        OUTPUT TABLE tt-IssUser,
        OUTPUT TABLE tt-IssCust,
        OUTPUT TABLE tt-IssTable,
        OUTPUT TABLE tt-ThisPeriod
        ).
        
        