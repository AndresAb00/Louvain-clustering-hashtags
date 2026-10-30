# ============================================================
# 10. MATRIZ BINARIA USUARIO-HASHTAG

# ============================================================

matriz_usuario_hashtag <-

  base_red_20 %>%

  distinct(

    usuario,

    hashtag

  ) %>%

  mutate(

    valor = 1

  ) %>%

  pivot_wider(

    names_from = hashtag,

    values_from = valor,

    values_fill = 0

  )

# ============================================================

# 11. CONVERSIÓN A MATRIZ

# ============================================================

usuarios <-

  matriz_usuario_hashtag$usuario

M <-

  matriz_usuario_hashtag %>%

  select(-usuario) %>%

  as.matrix()

rownames(M) <- usuarios

# ============================================================

# 12. PROYECCIÓN USUARIO-USUARIO

#

# El valor M %*% t(M) indica cuántos hashtags distintos

# comparte cada par de usuarios.

# ============================================================

matriz_usuario_usuario <-

  M %*% t(M)

# Eliminación de autovínculos

diag(matriz_usuario_usuario) <- 0

# ============================================================

# 13. CREACIÓN DEL GRAFO USUARIO-USUARIO

# ============================================================

g_usuarios <-

  graph_from_adjacency_matrix(

    matriz_usuario_usuario,

    mode = "undirected",

    weighted = TRUE,

    diag = FALSE

  )

# ============================================================

# 14. CARACTERÍSTICAS GENERALES DE LA RED

# ============================================================

gorder(g_usuarios)   # nodos

gsize(g_usuarios)    # vínculos

edge_density(

  g_usuarios,

  loops = FALSE

)

# Componentes

componentes <-

  components(g_usuarios)

componentes$no

max(componentes$csize)

max(componentes$csize) /

  gorder(g_usuarios)

# ============================================================

# 15. DISTRIBUCIÓN DEL PESO DE LAS ARISTAS

# ============================================================

distribucion_pesos <-

  tibble(

    peso = E(g_usuarios)$weight

  ) %>%

  count(

    peso,

    name = "cantidad_vinculos"

  ) %>%

  arrange(peso)

distribucion_pesos

# ============================================================

# 16. FUNCIÓN PARA FILTRAR LA RED SEGÚN PESO

# ============================================================

filtrar_red_por_peso <-

  function(g, peso_minimo) {

    # Eliminar relaciones por debajo del umbral

    g_filtrado <-

      delete_edges(

        g,

        E(g)[weight < peso_minimo]

      )

    # Eliminar nodos que quedan aislados

    g_filtrado <-

      delete_vertices(

        g_filtrado,

        V(g_filtrado)[

          degree(g_filtrado) == 0

        ]

      )

    return(g_filtrado)

  }

# ============================================================

# 17. REDES SEGÚN UMBRAL DE PESO

# ============================================================

g_peso_2 <-

  filtrar_red_por_peso(

    g_usuarios,

    2

  )

g_peso_3 <-

  filtrar_red_por_peso(

    g_usuarios,

    3

  )

g_peso_4 <-

  filtrar_red_por_peso(

    g_usuarios,

    4

  )

# ============================================================
