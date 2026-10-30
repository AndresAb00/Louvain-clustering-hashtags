# Louvain clustering of hashtags

Código modular del análisis de comunidades de usuarios mediante hashtags.

## Ejecutar

1. Instalar `tidyverse`, `stringi` e `igraph`.
2. Proveer localmente `dados01.RData` (contiene un objeto `Data`), sin subirlo a GitHub.
3. Abrir RStudio con la carpeta del proyecto como directorio de trabajo.
4. Ejecutar `source("main.R", encoding = "UTF-8")`.

## Decisiones implementadas

- Selección inicial: hashtags utilizados por al menos **20 usuarios distintos** (30 hashtags en el corpus de tesis).
- Proyección usuario–usuario: cantidad de hashtags compartidos; aristas con peso ≥3.
- Detección de comunidades: Louvain ponderado, con `set.seed(123)`.
- Selección de hashtags representativos: lift >1 y al menos **5 usuarios en cada comunidad**.
- La sección original 34 conserva un **top 5 por lift** para cada comunidad; no equivale al listado completo de hashtags representativos.

**Nota:** validá la versión modular en una sesión limpia antes de considerarla reproducción verificada. Las exportaciones para Gephi se escriben en el directorio de trabajo.
