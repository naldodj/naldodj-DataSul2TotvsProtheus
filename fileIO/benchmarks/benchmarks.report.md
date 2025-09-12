# Relatório de Análise de Performance de Leitura de Arquivos

**DataSul2TotvsProtheus**  
**Data**: 11 de Setembro de 2025

## 1. Introdução

Este relatório analisa o arquivo de log `fileioperform.20250911.064809.b36abc66f48ef011bd7cc88a9a3bc27e.log`, com foco em:

- **Performance**: Tempos de processamento (`PartialTimeProc`, em segundos) por reader, arquivo e modo (Sequential).
- **Consistência**: Média e desvio padrão dos tempos.
- **Processos Desqualificados**: Identificados por `IsDisqualifiedByTimeOut = 1` (timeout).
- **Integridade dos Dados**: Verificada via `StrHash` (mesmo hash para leituras consistentes).
- **Gráficos Comparativos**: Sugestões de visualizações (bar charts e boxplots).

## 2. Estatísticas Gerais (Média e Desvio Padrão)

A tabela a seguir resume a média e o desvio padrão dos tempos de processamento (em segundos) por arquivo, modo, owner e reader. A coluna "Contagem" indica o número de execuções. Caminhos de arquivos foram abreviados para clareza.

| Arquivo                     | Modo       | Owner   | Reader          | Média (s) | Desvio Padrão (s) | Contagem |
|-----------------------------|------------|---------|-----------------|-----------|-------------------|----------|
| MOVTO_CALCUL_FUNC.csv       | Sequential | DNATech | FILENAVIGATOR   | 2982.93   | 228.19            | 2        |
| MOVTO_CALCUL_FUNC.csv       | Sequential | DNATech | FILENAVIGATOR_2 | 3041.79   | 219.10            | 2        |
| MOVTO_CALCUL_FUNC.csv       | Sequential | DNATech | FILEREADER_FILE | 3341.61   | 155.09            | 2        |
| MOVTO_CALCUL_FUNC.csv       | Sequential | DNATech | TFILEREAD       | 3753.96   | 185.55            | 2        |
| MOVTO_CALCUL_FUNC.csv       | Sequential | TOTVS   | FT              | 7026.29   | 5638.03           | 2        |
| MOVTO_CALCUL_FUNC.csv       | Sequential | TOTVS   | FWFILEREADER    | 3589.51   | 83.32             | 2        |
| CTA_MDO_EFP.csv             | Sequential | DNATech | FILENAVIGATOR   | 11.05     | 1.16              | 2        |
| CTA_MDO_EFP.csv             | Sequential | DNATech | FILENAVIGATOR_2 | 11.16     | 2.05              | 2        |
| CTA_MDO_EFP.csv             | Sequential | DNATech | FILEREADER_FILE | 53.53     | 69.75             | 2        |
| CTA_MDO_EFP.csv             | Sequential | DNATech | TFILEREAD       | 15.65     | 15.08             | 2        |
| CTA_MDO_EFP.csv             | Sequential | TOTVS   | FT              | 14.44     | 0.13              | 2        |
| CTA_MDO_EFP.csv             | Sequential | TOTVS   | FWFILEREADER    | 12.68     | 1.41              | 2        |
| MARCAC_PTOELET.csv          | Sequential | DNATech | FILENAVIGATOR   | 32856.79  | 10704.52          | 3        |
| MARCAC_PTOELET.csv          | Sequential | DNATech | FILENAVIGATOR_2 | 34930.03  | 10751.58          | 3        |
| MARCAC_PTOELET.csv          | Sequential | DNATech | FILEREADER_FILE | 56422.98  | 3719.26           | 3        |
| MARCAC_PTOELET.csv          | Sequential | DNATech | TFILEREAD       | 54854.98  | 11805.52          | 3        |
| MARCAC_PTOELET.csv          | Sequential | TOTVS   | FT              | 14415.73  | 5910.05           | 3        |
| MARCAC_PTOELET.csv          | Sequential | TOTVS   | FWFILEREADER    | 90975.63  | 97958.33          | 3        |

**Observações**: Readers DNATech (ex.: FILENAVIGATOR) têm tempos menores e baixa variabilidade em arquivos pequenos/médios. TOTVS FWFILEREADER apresenta alta variabilidade em arquivos grandes, indicando instabilidade.

## 3. Processos Desqualificados por Timeout

Os processos abaixo excederam o limite de tempo (3781,79 s).

| Arquivo                     | Modo       | Owner | Reader       | Tempo (s) | Linhas | Tamanho (bytes) |
|-----------------------------|------------|-------|--------------|-----------|--------|-----------------|
| SIT_AFAST_FUNC.csv          | Sequential | TOTVS | FT           | 3781.86   | 31981  | 17355910        |
| MOVTO_CALCUL_FUNC.csv       | Sequential | TOTVS | FT           | 3781.89   | 28150  | 98192062        |
| MOVTO_CALCUL_FUNC.csv       | Sequential | TOTVS | FT           | 3781.86   | 27366  | 98192062        |
| MARCAC_PTOELET.csv          | Sequential | TOTVS | FT           | 3781.79   | 32178  | 454902021       |
| MARCAC_PTOELET.csv          | Sequential | TOTVS | FWFILEREADER | 3781.79   | 1372211| 454902021       |
| MARCAC_PTOELET.csv          | Sequential | TOTVS | FWFILEREADER | 6993.62   | 1      | 454902021       |
| MARCAC_PTOELET.csv          | Sequential | TOTVS | FT           | 3781.93   | 26936  | 454902021       |

**Observações**: Todos os processos desqualificados são da TOTVS, especialmente em arquivos grandes (MARCAC_PTOELET.csv, ~455 MB), sugerindo dificuldades com volumes altos.

## 4. Integridade dos Dados (Baseado em StrHash)

**Consistência**: Verdadeiro se todos os readers com `StrHash` não-zero têm o mesmo hash para o mesmo arquivo/modo.

| Arquivo                     | Modo       | Consistente |
|-----------------------------|------------|-------------|
| MOVTO_CALCUL_FUNC.csv       | Sequential | Não         |
| MARCAC_PTOELET.csv          | Sequential | Não         |
| SIT_AFAST_FUNC.csv          | Sequential | Não         |

| Arquivo                     | Modo       | Hashes Únicos |
|-----------------------------|------------|---------------|
| MOVTO_CALCUL_FUNC.csv       | Sequential | 4             |
| MARCAC_PTOELET.csv          | Sequential | 3             |
| SIT_AFAST_FUNC.csv          | Sequential | 2             |

**Observações**: Hashes inconsistentes indicam leituras parciais, especialmente em processos desqualificados da TOTVS. Hashes zero sugerem falhas ou leituras vazias.

## 5. Melhores Performances

Readers com menor tempo médio e sem desqualificações:

| Arquivo                     | Modo       | Owner   | Reader          | Média (s) | Desvio Padrão (s) | Contagem | Desqualificações |
|-----------------------------|------------|---------|-----------------|-----------|-------------------|----------|------------------|
| CTA_MDO_EFP.csv             | Sequential | DNATech | FILENAVIGATOR   | 11.05     | 1.16              | 2        | 0                |
| PTOELET_MARCAC.csv          | Sequential | DNATech | FILENAVIGATOR_2 | 8.81      | 2.72              | 2        | 0                |
| MOVTO_CALCUL_FUNC.csv       | Sequential | DNATech | FILENAVIGATOR   | 2982.93   | 228.19            | 2        | 0                |
| MARCAC_PTOELET.csv          | Sequential | DNATech | FILENAVIGATOR   | 32856.79  | 10704.52          | 3        | 0                |
| MARCAC_PTOELET.csv          | Sequential | DNATech | FILENAVIGATOR_2 | 34930.03  | 10751.58          | 3        | 0                |

**Observações**: DNATech domina em arquivos pequenos, médios e grandes, com consistência (sem desqualificações). TOTVS FT foi excluído para MARCAC_PTOELET.csv devido a falhas por timeout.

## 6. Gráficos Comparativos

Os gráficos sugeridos podem ser gerados com Matplotlib e inseridos no Word.

### 6.1 Tempo Médio de Processamento por Reader (Bar Chart)
- **Eixo X**: Readers (FILENAVIGATOR, FILENAVIGATOR_2, FILEREADER_FILE, TFILEREAD, FT*, FWFILEREADER*).
- **Eixo Y**: Tempo Médio (segundos).
- **Dados**:

| Reader          | Tempo Médio (s) |
|-----------------|-----------------|
| FILENAVIGATOR   | 8167.08         |
| FILENAVIGATOR_2 | 8614.12         |
| FILEREADER_FILE | 13694.42        |
| TFILEREAD       | 13411.91        |
| FT*             | 8281.48         |
| FWFILEREADER*   | 28325.58        |
| * indica readers com desqualificações. |

- **Estilo**: Barras verdes para readers sem desqualificações (DNATech), vermelhas para com desqualificações (TOTVS).

### 6.2 Performance por Arquivo (Boxplot)
- **Eixo X**: Arquivos (abreviados: CTA_MDO_EFP, PTOELET_MARCAC, MOVTO_CALCUL_FUNC, MARCAC_PTOELET).
- **Eixo Y**: Tempo de Processamento (segundos).
- **Grupos**: Separar por Owner (DNATech vs. TOTVS).
- **Estilo**: Pontos vermelhos para processos desqualificados.

### 6.3 Integridade - Hashes Únicos por Arquivo (Bar Chart)
- **Eixo X**: Arquivos (MOVTO_CALCUL_FUNC, MARCAC_PTOELET, SIT_AFAST_FUNC).
- **Eixo Y**: Número de Hashes Únicos.
- **Dados**: Ver tabela de variações de hash.
- **Estilo**: Barras roxas para valores > 1 (inconsistência).

## 7. Conclusões e Recomendações
- **Melhor Performance**: DNATech (ex.: FILENAVIGATOR, FILENAVIGATOR_2) é ideal para arquivos pequenos, médios e grandes devido à consistência e ausência de desqualificações.
- **Consistência**: DNATech tem menor variabilidade (100–10.000 s) comparado a TOTVS (5.000–98.000 s).
- **Processos Desqualificados**: TOTVS (ex.: FT, FWFILEREADER) falha frequentemente em arquivos grandes (ex.: MARCAC_PTOELET.csv), tornando-o menos confiável.
- **Integridade**: Hashes inconsistentes em arquivos grandes sugerem leituras parciais. Verificar readers TOTVS.
- **Recomendações**:
  - Priorize DNATech para performance e confiabilidade em todos os tamanhos de arquivo.
  - Otimize TOTVS FT/FWFILEREADER para arquivos grandes, ajustando timeouts ou buffers.
  - Inclua validação de hashes em processos críticos para garantir integridade.