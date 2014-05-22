/***********************************************************************

    Program:        lib/slatt.i
    
    Purpose:             
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      Initial
    
***********************************************************************/

&if defined(slattdef-library-defined) = 0 &then

&glob slattdef-library-defined yes

def temp-table tt-sla-sched                 no-undo
    field Level         as int
    field Note          as char
    field sDate         as date
    field sTime         as int

    index Level 
            Level.

&endif
