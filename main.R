# Ejecutar desde la raíz del proyecto Louvain-clustering-hashtags.
# Antes de ejecutar, proporcionar la base original:
# 1) en data/dados01.RData (no publicar); o
# 2) Sys.setenv(ASTESIANO_DATA_PATH = "C:/ruta/privada/dados01.RData")

source("R/01_preparacion_datos.R", encoding = "UTF-8")
source("R/02_frecuencias.R", encoding = "UTF-8")
source("R/03_matrices_y_grafos.R", encoding = "UTF-8")
source("R/04_louvain.R", encoding = "UTF-8")
source("R/05_analisis_hashtags.R", encoding = "UTF-8")
source("R/06_exportacion_gephi.R", encoding = "UTF-8")
