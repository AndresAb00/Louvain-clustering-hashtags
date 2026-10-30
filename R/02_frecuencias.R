# ============================================================
# 3. FRECUENCIA USUARIO-HASHTAG

# ============================================================

frecuencia_usuario_hashtag <-

  base_hashtags_originales_limpia %>%

  count(

    usuario,

    hashtag,

    name = "frecuencia"

  )

# ============================================================

# 4. FRECUENCIA GLOBAL DE LOS HASHTAGS

# ============================================================

frecuencia_total_hashtags <-

  frecuencia_usuario_hashtag %>%

  group_by(hashtag) %>%

  summarise(

    frecuencia_total =

      sum(frecuencia, na.rm = TRUE),

    usuarios_distintos =

      n_distinct(usuario),

    .groups = "drop"

  ) %>%

  arrange(

    desc(frecuencia_total)

  )

# ============================================================

# 5. EVALUACIÓN DE UMBRALES

# ============================================================

hashtags_recorte_10 <-

  frecuencia_total_hashtags %>%

  filter(

    usuarios_distintos >= 10

  )

hashtags_recorte_20 <-

  frecuencia_total_hashtags %>%

  filter(

    usuarios_distintos >= 20

  )

hashtags_recorte_30 <-

  frecuencia_total_hashtags %>%

  filter(

    usuarios_distintos >= 30

  )

# ============================================================

# 6. SELECCIÓN DEFINITIVA:

#    HASHTAGS UTILIZADOS POR >= 20 USUARIOS

# ============================================================

frecuencia_total_hashtags_recorte <-

  frecuencia_total_hashtags %>%

  filter(

    usuarios_distintos >= 20

  ) %>%

  arrange(

    desc(frecuencia_total)

  )

# ============================================================

# 7. BASE PARA LA CONSTRUCCIÓN DE LA RED

# ============================================================

base_red_20 <-

  frecuencia_usuario_hashtag %>%

  semi_join(

    frecuencia_total_hashtags_recorte %>%

      select(hashtag),

    by = "hashtag"

  )

# ============================================================

# 8. DESCRIPCIÓN GENERAL DEL RECORTE

# ============================================================

resumen_base_red_20 <-

  base_red_20 %>%

  summarise(

    usuarios_distintos =

      n_distinct(usuario),

    hashtags_distintos =

      n_distinct(hashtag),

    registros_usuario_hashtag =

      n(),

    frecuencia_total =

      sum(frecuencia, na.rm = TRUE)

  )

resumen_base_red_20

# ============================================================

# 9. ACTIVIDAD DE LOS USUARIOS

# ============================================================

actividad_usuarios <-

  base_red_20 %>%

  group_by(usuario) %>%

  summarise(

    frecuencia_total_usuario =

      sum(frecuencia, na.rm = TRUE),

    hashtags_distintos_usuario =

      n_distinct(hashtag),

    .groups = "drop"

  ) %>%

  arrange(

    desc(frecuencia_total_usuario)

  )

actividad_usuarios %>%

  print(n = 20)

# ============================================================
