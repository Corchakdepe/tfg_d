#import "@preview/cetz:0.2.2"
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import "@preview/wrap-it:0.1.1": wrap-content
#import "@preview/diagraph:0.2.5": *

#set text(spacing: 120%, lang: "es")  
#let title = "Aplicación de análisis de redes de bicicletas compartidas"
#set page(numbering: "- 1 -")

// Shows para archivos/código
#show ".csv": it => `.csv`
#show ".json": it => `.json`
#show ".xlsx": it => `.xlsx`  // Corregido "xlsl"
#show ".sql": it => `.sql`

#let fake_heading(content, level: 1) = {
  heading(outlined: false, numbering: none, level: 2 + level)[#content]
}

#let code(content, caption: content) = {
  let bg_code = rect(content, fill: rgb("#eeeded"))
  figure(
    bg_code,
    caption: caption,
    kind: "Code",
    supplement: "Código",
  )
}

// Portada (sin cambios, bien hecha)
#rect(width: 100%, height: 100%, stroke: 2pt, outset: 2%)[
  #pad(top: 50pt)[
    #align(center)[
      #grid(
        columns: 3,
        image(width: 50%, "resources/images/portada/EtsiLogo.png"), h(90pt), image(width: 70%, "resources/images/portada/UhuLogo.png"),
      )
    ]
  ]
  #v(10pt)
  #pad(x: 20pt)[
    #align(center)[
      #text(size: 20pt, weight: "bold", font: "URW Bookman")[Escuela Técnica Superior de Ingeniería. Universidad de Huelva]
    ]
  ]
  #v(40pt)
  #align(center)[ #text(size: 20pt, weight: "regular", font: "URW Bookman")[Grado en Ingeniería Informática] ]
  #v(40pt)
  #align(center)[ #text(size: 20pt, weight: "bold", font: "URW Bookman")[Trabajo Fin de Grado] ]
  #v(40pt)
  #pad(x: 10%)[
    #align(center)[ #text(size: 20pt, weight: "regular", font: "URW Bookman")[#title] ]
  ]
  #v(110pt)
  #pad(x: 10%)[
    #text(size: 16pt)[
      #align(right)[Ageu Depetris Filho]
      #align(right)[Tutor: Miguel Ángel Rodríguez Román]  // Corregido nombre
      #align(right)[Junio 2026]  // Fecha realista
    ]
  ]
]

#set par(justify: true, spacing: 1.2em * 1.2)
#set text(11pt)  // Arial-like por defecto en Typst

#pagebreak()
#fake_heading("Resumen y datos del TFG")
*Titulación*: Grado en Ingeniería Informática.  
*Área de conocimiento*: Ciencias de la Computación e Inteligencia Artificial.  // De tu propuesta [file:11]
*Tipo de TFG*: Trabajo científico-técnico en el ámbito de la ingeniería.  

*Principal competencia*: Capacidad para analizar, diseñar, construir y mantener aplicaciones de forma robusta, segura y eficiente, eligiendo el paradigma y los lenguajes más adecuados. [file:11]

*Autor*: Ageu Depetris Filho.  
*Tutor*: Miguel Ángel Rodríguez Román.  

*Palabras clave*: Redes de bicicletas compartidas, análisis de grafos, visualización interactiva, movilidad sostenible, métricas de centralidad, simulación de escenarios.  // Adaptadas al tema

*Keywords*: Bike-sharing networks, graph analysis, interactive visualization, sustainable mobility, centrality metrics, scenario simulation.

#pagebreak()
#set heading(numbering: "1.")  // Numeración global

#outline(indent: auto, title: "Índice", target: heading.where(supplement: none))
#pagebreak()
#outline(title: "Índice de figuras", target: figure.where(kind: image))
#pagebreak()
#outline(title: "Índice de códigos", target: figure.where(kind: "Code"))
#pagebreak()
#outline(title: "Índice de anexos", target: heading.where(supplement: [Anexo]))

#pagebreak()

= Introducción  // Siguiendo guía: contexto del problema aquí

== Contexto del problema

=== Movilidad urbana y retos de sostenibilidad

=== Sistemas de bicicletas compartidas en ciudades

=== Problemas operativos: saturación de estaciones, desequilibrios, planificación de flota

== Presentación del tema  // Corregido "Presetación"

=== Modelado de redes de bicicletas como grafos

=== Adecuación del análisis de grafos y visualización interactiva

== Referencias iniciales y trabajos previos

=== Ejemplo: TFG de simulación en Sevilla

=== Propuesta general del proyecto (sin detalles técnicos)

= Justificación y objetivos  // Dejar para final, como acordado

= Estado del arte  // Profundizar en lo existente

== Sistemas de bicicletas compartidas
=== Tipos (dock-based, dockless)
=== Ejemplos reales (JCDecaux, Bicing, Sevici)
=== Problemas en literatura: gestión, optimización operativa

== Fuentes de datos y tecnologías
=== Datos: JCDecaux, OpenStreetMap, APIs de movilidad
=== Cartografía: Leaflet, Mapbox
=== Stacks habituales: Python (análisis), JavaScript (front), Docker

== Metodologías clave
=== Análisis de grafos en movilidad
=== Métricas típicas (centralidad de grado, betweenness, saturación)
=== Simulación de escenarios

== Trabajos relacionados
=== TFG/TFM similares (ej. Sevilla) 
=== Hueco cubierto por este trabajo (prototipo web, matrices I/O, mapas interactivos)

= Metodologías  // Antes del Cuerpo: "cómo se aborda" 

== Fuentes de datos
=== JCDecaux (estaciones, viajes)
=== OpenStreetMap (geometría base)
=== Datos auxiliares

== Técnicas de análisis
=== Modelado como grafo dirigido/no dirigido
=== Métricas de centralidad y saturación
=== Matrices input/output (OD estación-estación, series temporales)
=== Simulaciones (cierre estaciones, aumento flota)

== Tecnologías empleadas
=== Backend: Python + NetworkX/IGraph
=== Frontend: Leaflet/Mapbox, React/Next.js
=== Infra: Docker, contenedores

== Planificación temporal  // Integrado aquí con Gantt 



= Cuerpo del trabajo  // Implementación concreta

== Requisitos del sistema  // Diferenciados claramente

=== Requisitos hardware/software
==== Servidor/máquina desarrollo (RAM, CPU)
==== Dependencias (Docker, Python 3.x, Node.js, librerías)

=== Requisitos funcionales
==== Carga/visualización datos JCDecaux
==== Generación matrices/maps/simulaciones
==== Exportar resultados

=== Requisitos no funcionales
==== Rendimiento (tiempos \<5s), memoria (\<2GB)
==== Seguridad (API keys, no datos personales)
==== Usabilidad/mantenibilidad

== Diseño y arquitectura

=== Diagramas de casos de uso

=== Diagramas de secuencia


=== Capturas UI (mapas, paneles)


== Desarrollo del prototipo
// Detalles implementación por módulos

== Resultados y experimentos
// Visualizaciones, métricas, escenarios (tablas/gráficos)

= Conclusiones  // Logros, limitaciones, futuro

= Bibliografía  // Usa Zotero/APA; sigue guía BUH 

= Anexos  // Código fuente, manual usuario, datos crudos
#heading(supplement: [Anexo A], numbering: none)[Código fuente]
#heading(supplement: [Anexo B], numbering: none)[Manual de usuario]
