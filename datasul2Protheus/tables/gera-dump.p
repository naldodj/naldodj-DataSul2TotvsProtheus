input from c:\temp\export\novo\lst-tabelas.csv.
def var c-tabela as char .

output to c:\temp\export\novo\programa-dump.p.
repeat:

import c-tabela.

put 

"output to  c:\temp\export\novo\" + c-tabela + ".csv." format "x(80)" skip
"for each  hcm." + c-tabela + ":" format "x(80)" skip
"   export delimiter ';' "  + c-tabela + "." format "x(80)"
skip
"end." skip (2).






end.

