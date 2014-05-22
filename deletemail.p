

DEF VAR vx AS INT.
FOR EACH EmailH  no-lock
        where EmailH.CompanyCode = "ouritdept"
          and EmailH.Email > ""
          .
    vx = vx + 1.
END.
MESSAGE vx VIEW-AS ALERT-BOX.


/* FOR EACH EmailH                                                  */
/*         where EmailH.CompanyCode = "ouritdept"                   */
/*           and EmailH.Email > ""                                  */
/*        :                                                         */
/*             for each doch exclusive-lock                         */
/*                 where doch.CompanyCode = "ouritdept"             */
/*                   and doch.RelType     = "EMAIL"                 */
/*                   and doch.RelKey      = string(emailh.EmailID): */
/*                 for each docl of doch exclusive-lock:            */
/*                     delete docl.                                 */
/*                 end.                                             */
/*                 delete doch.                                     */
/*             end.                                                 */
/*  DELETE emailh.                                                  */
/* END.                                                             */
/*                                                                  */
/*                                                                  */
