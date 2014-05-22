/***********************************************************************

    Program:        lib/makeaudit.p
    
    Purpose:        Audit Number          
    
    Notes:
    
    
    When        Who         What
    13/04/2006  phoski      Initial
        
***********************************************************************/

def input   param pc-AuditType          as char no-undo.
def output  param pf-AuditNumber        as dec  no-undo.
  

def var li-lo as int no-undo.
def var li-hi as int no-undo.

case pc-AuditType:

    when 'DUMMY' then assign pf-AuditNumber = ?.
    
    otherwise
    do:
        assign li-lo = next-value(LoAudit)
               li-hi = current-value(HiAudit).
               
        if li-lo = 1
        then assign li-hi = next-value(HiAudit).
        
        assign pf-AuditNumber = 
                    dec(string(li-hi) + string(li-lo,"999999")).
                
    end.
end case.
