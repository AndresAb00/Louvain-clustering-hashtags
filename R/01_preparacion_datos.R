# ============================================================
# 0. PAQUETES Y CARGA DE DATOS

# ============================================================

library(tidyverse)

library(stringi)

library(igraph)

# Usá ASTESIANO_DATA_PATH si los datos están fuera de este proyecto.
ruta_datos <- Sys.getenv("ASTESIANO_DATA_PATH", unset = "data/dados01.RData")
if (!file.exists(ruta_datos)) {
  stop("No se encuentra la base: ", ruta_datos,
       ". Configurá ASTESIANO_DATA_PATH o ubicá la base en data/dados01.RData")
}
load(ruta_datos)

# ============================================================

# 1. SELECCIÓN DE TUITS ORIGINALES

# ============================================================

base_hashtags_originales <- Data %>%

  mutate(

    retweeted_id = as.character(`referenced_tweets.retweeted.id`),

    es_retweet = !is.na(retweeted_id) & retweeted_id != "",

    usuario = str_to_lower(`author.username`)

  ) %>%

  filter(es_retweet == FALSE) %>%

  select(

    id,

    usuario,

    entities.hashtags

  )

# ============================================================

# 2. LIMPIEZA Y NORMALIZACIÓN DE HASHTAGS

# ============================================================

base_hashtags_originales_limpia <- Data %>%

  mutate(

    retweeted_id = as.character(`referenced_tweets.retweeted.id`),

    es_retweet = !is.na(retweeted_id) & retweeted_id != "",

    usuario = str_to_lower(`author.username`)

  ) %>%

  filter(es_retweet == FALSE) %>%

  select(

    id,

    usuario,

    entities.hashtags

  ) %>%

  # Eliminación de registros sin hashtags

  filter(

    !is.na(entities.hashtags),

    entities.hashtags != "",

    entities.hashtags != "[]"

  ) %>%

  # Decodificación de Unicode y limpieza de estructura JSON

  mutate(

    entities.hashtags =

      stri_unescape_unicode(

        as.character(entities.hashtags)

      ),

    hashtags_limpios =

      str_replace_all(

        entities.hashtags,

        "\\[|\\]|\"|\\\\",

        ""

      )

  ) %>%

  # Un hashtag por fila

  separate_rows(

    hashtags_limpios,

    sep = ","

  ) %>%

  # Normalización textual

  mutate(

    hashtag =

      str_to_lower(

        str_squish(hashtags_limpios)

      ),

    hashtag =

      str_remove(

        hashtag,

        "^#"

      ),

    hashtag =

      stri_trans_general(

        hashtag,

        "Latin-ASCII"

      )

  ) %>%

  # Eliminación de ausentes o vacíos

  filter(

    !is.na(usuario),

    usuario != "",

    !is.na(hashtag),

    hashtag != ""

  ) %>%

  select(

    id,

    usuario,

    hashtag

  )

# ============================================================
