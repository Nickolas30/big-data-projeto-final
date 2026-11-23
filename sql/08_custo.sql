-- Fase 3: Custo e desempenho (Passo A.5)
-- Versao 1 (so estimativa, nao executada): 23,15 GB
-- SELECT * FROM bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2016

-- Versao 2 (executada): 4,89 GB processados e faturados
SELECT pickup_datetime, trip_distance, fare_amount
FROM bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2016
