# Projeto Final de Big Data - UNINASSAU

Análise das corridas de táxi amarelo de Nova York (2016) com BigQuery e Looker Studio (Trilha A).

Disciplina: Big Data | Curso: Análise e Desenvolvimento de Sistemas

## Integrantes
- Anyta da Silva Queiroz
- Jamylle da Silva Santana
- Maria Biatriz Ramos Rodrigues
- Nickolas Eduardo Gonçalves de Oliveira
- Nicolas Carneiro de Lima

## Pergunta de negócio
Em que dias a frota de táxis deve ser reforçada?

## Base de dados
- Tabela: `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2016`
- Linhas: 131.131.794 corridas, de 01/01/2016 a 31/12/2016
- Colunas: 20
- Tamanho: 23,15 GB (estimativa do BigQuery para `SELECT *`)

## Trilha e método
Trilha A: BigQuery + Looker Studio.

1. Exploração da tabela: contagem de corridas e primeira e última data.
2. Quatro consultas, uma por categoria de analytics:
   - Descritiva: corridas por dia da semana e hora, para achar os horários de maior demanda.
   - Diagnóstica: correlação entre distância e tarifa.
   - Preditiva: previsão por média móvel dos 7 dias anteriores.
   - Prescritiva: regra de decisão (reforçar a frota acima de 1,25 vez a média, reduzir abaixo de 0,5 vez a média, manter nos demais casos), aplicada por dia (tabela `resumo_diario`) e por dia da semana e hora.
3. Tabela de resultados `projeto_final.resumo_diario`: 366 linhas e 17,2 KB, criada com uma única leitura da base.
4. Painel no Looker Studio lendo apenas a tabela pequena, não a base inteira.

## Principais resultados
- Dos 366 dias, 359 ficam em MANTER, 4 em REFORCAR FROTA e 3 em REDUZIR FROTA.
- Os 4 dias de reforço são sábados: 13/02, 05/03, 09/04 e 16/04.
- As corridas diárias oscilam entre 300 mil e 450 mil, com queda em janeiro.
- A média diária tem pico em março e abril e cai no segundo semestre.
- Sexta-feira tem a maior média de corridas e segunda-feira a menor.
- O painel mostra 131.041.657 corridas porque a tabela de resultados usa o filtro `fare_amount > 0`, que exclui 90.137 corridas (cerca de 0,07%).

## Custo e desempenho
Otimização: selecionar só as colunas necessárias em vez de `SELECT *`.

| Versão da consulta | Estimativa (GB) | Bytes processados |
|---|---|---|
| `SELECT *` | 23,15 | não executada (apenas estimativa) |
| `pickup_datetime, trip_distance, fare_amount` | 4,89 | 4,89 GB |

Redução de 78,9% na estimativa. O BigQuery cobra só pelas colunas lidas, então pedir 3 colunas em vez de todas reduz os dados lidos e o custo.

Efeito adicional: o painel lê `resumo_diario` (366 linhas, 17,2 KB) em vez das 131 milhões de linhas da base.

## Premissas da regra de decisão
Os limites de 1,25 e 0,5 são premissas de negócio, não resultados dos dados. Acima de 125% da média diária, a demanda passa do que um dia típico exige da frota; abaixo de 50% da média, há capacidade ociosa. Os valores foram adotados a partir do roteiro do projeto. Com eles, apenas 4 dias (todos sábados) pedem reforço e 3 pedem redução. Um limite de reforço mais baixo aumentaria o número de dias de reforço.

## Limites
- A tabela de resultados exclui corridas com tarifa zero ou negativa (0,07% da base).
- Correlação não é causa: a relação entre distância e tarifa não explica sozinha a demanda.
- A previsão por média móvel é simples e não considera feriados nem clima.

## Estrutura do repositório
```
sql/                  consultas SQL, numeradas na ordem de execução
docs/evidencias/      prints e saídas usados no relatório
README.md
```

## Como reproduzir
1. Criar um projeto no Google Cloud (modo sandbox é suficiente) e abrir o BigQuery.
2. Criar o dataset na localização da base pública:
   ```sql
   CREATE SCHEMA IF NOT EXISTS `SEU_PROJETO.projeto_final`
   OPTIONS (location = 'US');
   ```
3. Executar os arquivos de `sql/` na ordem, trocando `SEU_PROJETO` pelo ID do seu projeto.
4. No Looker Studio, conectar ao BigQuery e usar a tabela `projeto_final.resumo_diario`.

## Links
- Painel no Looker Studio (somente leitura): [colar o link]
- Relatório (PDF): [colar o link ou caminho]
