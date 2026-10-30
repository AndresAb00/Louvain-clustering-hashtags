# ============================================================
# 36. NODOS PARA GEPHI

# ============================================================

nodos_gephi_peso3 <-

  tibble(

    Id = V(g_peso_3)$name,

    Label = V(g_peso_3)$name,

    tipo = "Usuario",

    comunidad = V(g_peso_3)$comunidad,

    grado = V(g_peso_3)$grado,

    fuerza = V(g_peso_3)$fuerza

  )

write_csv(

  nodos_gephi_peso3,

  "nodos_usuario_usuario_peso3_comunidades.csv"

)

# ============================================================

# 37. ARISTAS PARA GEPHI

# ============================================================

aristas_gephi_peso3 <-

  as_data_frame(

    g_peso_3,

    what = "edges"

  ) %>%

  transmute(

    Source = from,

    Target = to,

    Type = "Undirected",

    Weight = weight

  )

write_csv(

  aristas_gephi_peso3,

  "aristas_usuario_usuario_peso3.csv"

)
