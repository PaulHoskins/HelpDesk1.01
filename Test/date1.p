
/*------------------------------------------------------------------------
    File        : date1.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : paul
    Created     : Sat Apr 18 07:22:32 BST 2015
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */



/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


FUNCTION Convert RETURNS DATE 
	(pc-date AS CHARACTER) FORWARD.


/* ***************************  Main Block  *************************** */

/* ************************  Function Implementations ***************** */


FUNCTION Convert RETURNS DATE 
	    ( pc-date AS CHARACTER  ):
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE ld-date AS DATE NO-UNDO.
    DEFINE VARIABLE li-month    AS INTEGER NO-UNDO.
    DEFINE VARIABLE li-day      AS INTEGER NO-UNDO.
    DEFINE VARIABLE li-year     AS INTEGER NO-UNDO.
    
    pc-date = REPLACE(TRIM(pc-date)," ",",").
       
    ASSIGN
        li-day = INTEGER(ENTRY(3,pc-date))
        li-year = INTEGER(ENTRY(4,pc-date))
        li-month = LOOKUP(ENTRY(2,pc-date),"Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec")
        .	
    ASSIGN
        ld-date = DATE(li-month,li-day,li-year) NO-ERROR.
        
	RETURN ld-date.
		

		
END FUNCTION.

DEFINE VARIABLE lc-date AS CHARACTER NO-UNDO.
DEFINE VARIABLE ld-date AS DATE      NO-UNDO.


lc-date = "Wed feb 12 2015 00:00:00 GMT 0100 (GMT Daylight Time)".

ld-date = CONVERT(lc-date).
DISPLAY ld-date.
