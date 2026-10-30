# ============================================================
# 18. DETECCIÓN DE COMUNIDADES CON LOUVAIN

#     RED PRINCIPAL: PESO >= 3

# ============================================================

set.seed(123)

comunidades_louvain_peso3 <-

  cluster_louvain(

    g_peso_3,

    weights = E(g_peso_3)$weight

  )

# Modularidad obtenida

modularity(

  comunidades_louvain_peso3

)

# Tamaño de las comunidades

sizes(

  comunidades_louvain_peso3

)

# ============================================================

# 19. INCORPORACIÓN DE LA COMUNIDAD COMO

#     ATRIBUTO DE LOS NODOS

# ============================================================

V(g_peso_3)$comunidad <-

  membership(

    comunidades_louvain_peso3

  )

# ============================================================

# 20. CENTRALIDADES DE LOS USUARIOS

# ============================================================

V(g_peso_3)$grado <-

  degree(

    g_peso_3

  )

V(g_peso_3)$fuerza <-

  strength(

    g_peso_3,

    weights = E(g_peso_3)$weight

  )

# ============================================================

# 21. TABLA USUARIO-COMUNIDAD

# ============================================================

usuarios_comunidades_peso3 <-

  tibble(

    usuario = V(g_peso_3)$name,

    comunidad = V(g_peso_3)$comunidad,

    grado = V(g_peso_3)$grado,

    fuerza = V(g_peso_3)$fuerza

  ) %>%

  arrange(

    comunidad,

    desc(fuerza)

  )

usuarios_comunidades_peso3 %>%

  print(n = 30)

# ============================================================

# 22. TAMAÑO DE CADA COMUNIDAD

# ============================================================

tamanio_comunidades <-

  usuarios_comunidades_peso3 %>%

  count(

    comunidad,

    name = "cantidad_usuarios"

  ) %>%

  arrange(

    desc(cantidad_usuarios)

  )

tamanio_comunidades

# ============================================================

# 23. SELECCIONAR SOLAMENTE COMUNIDADES

#     CON MÁS DE 5 USUARIOS

# ============================================================

comunidades_mayores_5 <-

  tamanio_comunidades %>%

  filter(

    cantidad_usuarios > 5

  )

comunidades_mayores_5

# ============================================================

# 24. USUARIOS DE LAS COMUNIDADES CON > 5 USUARIOS

# ============================================================

usuarios_comunidades_mayores_5 <-

  usuarios_comunidades_peso3 %>%

  semi_join(

    comunidades_mayores_5,

    by = "comunidad"

  )

usuarios_comunidades_mayores_5

# ============================================================

# 25. TOP 10 USUARIOS POR COMUNIDAD

# ============================================================

top10_usuarios_comunidad <-

  usuarios_comunidades_mayores_5 %>%

  group_by(comunidad) %>%

  arrange(

    desc(fuerza),

    desc(grado),

    .by_group = TRUE

  ) %>%

  slice_head(n = 10) %>%

  ungroup()

top10_usuarios_comunidad %>%

  arrange(

    comunidad,

    desc(fuerza)

  ) %>%

  print(n = Inf)

# ============================================================
