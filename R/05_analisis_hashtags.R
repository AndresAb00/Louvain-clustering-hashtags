# ============================================================
# 26. VINCULAR LOS HASHTAGS CON LA COMUNIDAD

#     DE CADA USUARIO

# ============================================================

base_comunidades_hashtags <-

  base_red_20 %>%

  # Solo usuarios presentes en g_peso_3

  semi_join(

    usuarios_comunidades_peso3 %>%

      select(usuario),

    by = "usuario"

  ) %>%

  # Agregar comunidad

  left_join(

    usuarios_comunidades_peso3 %>%

      select(

        usuario,

        comunidad

      ),

    by = "usuario"

  )

# ============================================================

# 27. TAMAÑO DE LAS COMUNIDADES

# ============================================================

tamanio_comunidades_lift <-

  usuarios_comunidades_peso3 %>%

  count(

    comunidad,

    name = "usuarios_totales_comunidad"

  )

# ============================================================

# 28. PRESENCIA DE CADA HASHTAG EN CADA COMUNIDAD

# ============================================================

hashtags_por_comunidad <-

  base_comunidades_hashtags %>%

  group_by(

    comunidad,

    hashtag

  ) %>%

  summarise(

    frecuencia_total_comunidad =

      sum(frecuencia, na.rm = TRUE),

    usuarios_distintos_comunidad =

      n_distinct(usuario),

    .groups = "drop"

  ) %>%

  left_join(

    tamanio_comunidades_lift,

    by = "comunidad"

  ) %>%

  mutate(

    proporcion_comunidad =

      usuarios_distintos_comunidad /

      usuarios_totales_comunidad,

    porcentaje_usuarios_comunidad =

      proporcion_comunidad * 100

  )

# ============================================================

# 29. TOTAL DE USUARIOS DE LA RED PESO >= 3

# ============================================================

total_usuarios_red_peso3 <-

  n_distinct(

    usuarios_comunidades_peso3$usuario

  )

total_usuarios_red_peso3

# ============================================================

# 30. PRESENCIA GLOBAL DE CADA HASHTAG

#     ENTRE LOS USUARIOS DE g_peso_3

# ============================================================

usuarios_hashtag_red_peso3 <-

  base_comunidades_hashtags %>%

  group_by(hashtag) %>%

  summarise(

    usuarios_distintos_total =

      n_distinct(usuario),

    frecuencia_total_red =

      sum(frecuencia, na.rm = TRUE),

    .groups = "drop"

  ) %>%

  mutate(

    proporcion_total_red =

      usuarios_distintos_total /

      total_usuarios_red_peso3,

    porcentaje_usuarios_red =

      proporcion_total_red * 100

  )

# ============================================================

# 31. CÁLCULO DEL LIFT

#

# lift =

# proporción de usuarios de una comunidad que usa el hashtag

# ----------------------------------------------------------

# proporción de usuarios de toda la red que usa el hashtag

# ============================================================

lift_hashtags_comunidad <-

  hashtags_por_comunidad %>%

  left_join(

    usuarios_hashtag_red_peso3,

    by = "hashtag"

  ) %>%

  mutate(

    lift =

      proporcion_comunidad /

      proporcion_total_red

  ) %>%

  # Solo comunidades con más de 5 usuarios

  semi_join(

    comunidades_mayores_5,

    by = "comunidad"

  ) %>%

  arrange(

    comunidad,

    desc(lift),

    desc(usuarios_distintos_comunidad)

  )

lift_hashtags_comunidad %>%

  print(n = Inf)

# ============================================================

# 32. HASHTAGS SOBRERREPRESENTADOS

#

# Lift > 1:

# más presentes en esa comunidad que en el conjunto de la red

# ============================================================

hashtags_sobrerrepresentados <-

  lift_hashtags_comunidad %>%

  filter(

    lift > 1

  ) %>%

  arrange(

    comunidad,

    desc(lift),

    desc(usuarios_distintos_comunidad)

  )

hashtags_sobrerrepresentados %>%

  print(n = Inf)

# ============================================================

# 33. HASHTAGS REPRESENTATIVOS CON UN MÍNIMO

#     DE 5 USUARIOS DENTRO DE LA COMUNIDAD

#

# Esto evita lifts muy altos producidos por casos

# extremadamente minoritarios.

# ============================================================

hashtags_representativos <-

  lift_hashtags_comunidad %>%

  filter(

    lift > 1,

    usuarios_distintos_comunidad >= 5

  ) %>%

  arrange(

    comunidad,

    desc(lift),

    desc(usuarios_distintos_comunidad)

  )

hashtags_representativos %>%

  print(n = Inf)

# ============================================================

# 34. TOP 5 HASHTAGS POR LIFT EN CADA COMUNIDAD

# ============================================================

top5_lift_comunidad <-

  hashtags_representativos %>%

  group_by(comunidad) %>%

  slice_max(

    order_by = lift,

    n = 5,

    with_ties = FALSE

  ) %>%

  ungroup() %>%

  arrange(

    comunidad,

    desc(lift)

  )

top5_lift_comunidad

# ============================================================

# 35. TABLA RESUMIDA PARA INTERPRETACIÓN

# ============================================================

tabla_lift_final <-

  top5_lift_comunidad %>%

  select(

    comunidad,

    hashtag,

    usuarios_distintos_comunidad,

    usuarios_totales_comunidad,

    porcentaje_usuarios_comunidad,

    usuarios_distintos_total,

    porcentaje_usuarios_red,

    frecuencia_total_comunidad,

    lift

  )

tabla_lift_final

# ============================================================
