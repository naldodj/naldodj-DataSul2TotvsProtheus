import re

#Substituir Espaços duplos no arquivo ../datasul2Protheus/tablesdefinition/fulltablesdefinition.txt até que só fique um
#Utilizei o Notepad++ para isso.
#tentei fazer direto no Phyton mas não deu certo:
# === Emula StrReplace({"  "," "}) ===
#   ...
#   normalized = line
#   while "  " in normalized:
#      normalized = normalized.replace("  ", " ")
#      normalized = normalized.replace("  ", " ")
#countIsSpace += normalized.count(" ")          
with open('teste.txt', 'r') as file:

   countLines = 0
   countBytes = 0 
   countIsSpace = 0
   countIsEmpty = 0

   for line in file:
      countLines += 1
      countBytes += len(line.encode("utf-8"))
      if line.strip() == "":  # linha só com espaços ou vazia
         countIsEmpty += 1
      else:
         countIsSpace += sum(1 for char in line if char.isspace())          

print("Linhas totais:", countLines)
print("Bytes lidos:", countBytes)
print("Espaços:", countIsSpace)
print("Linhas vazias:", countIsEmpty)

