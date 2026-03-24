#import "@preview/cetz:0.2.2"
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import "@preview/wrap-it:0.1.1": wrap-content

#import "@preview/diagraph:0.2.5": *

#set text(spacing: 120%, lang: "sp")


#let title = "Aplicación de análisis de redes de bicicletas compartidas"
#set page(numbering: "- 1 -")

/* Palabras wapas wapas */

#show ".csv": it => `.csv`
#show ".json": it => `.json`
#show ".excel": it => `.excel`
#show ".sql": it => `.sql`
#show ".xlsl": it => `.xlsl`

#show "nifi.properties": it => [#emph(it)]
#show "zookeeper.properties": it => [#emph(it)]
#show "state-management.xml": it => [#emph(it)]

#show "myid": it => `myid`

#show "ExecuteScript": it => `ExecuteScript`

#rect(width: 100%, height: 100%, stroke: 2pt, outset: 2%)[
  #pad(top: 50pt)[
    #align(center)[
      #grid(
        columns: 3,
        image(width: 50%, "resources/images/portada/EtsiLogo.png"), h(90pt), image(width: 70%, "resources/images/portada/UhuLogo.png"),
      )
    ]]

  #v(10pt)
  #pad(x: 20pt)[
    #align(center)[
      #text(
        size: 20pt,
        weight: "bold",
        font: "URW Bookman",
      )[Escuela Técnica Superior de Ingeniería Universidad de Huelva]
    ]
  ]

  #v(40pt)
  #align(center)[
    #text(size: 20pt, weight: "regular", font: "URW Bookman")[Grado en Ingeniería Informática]
  ]

  #v(40pt)
  #align(center)[
    #text(size: 20pt, weight: "bold", font: "URW Bookman")[Trabajo Fin de Grado/Máster]
  ]

  #v(40pt)
  #pad(x: 10%)[
    #align(center)[
      #text(size: 20pt, weight: "regular", font: "URW Bookman")[
        #title
      ]
    ]]


  #v(110pt)
  #pad(x: 10%)[
    #text(size: 16pt)[
      #align(right)[Ageu Depetris Filho]
      #align(right)[Tutor:  Miguel Ángel Rodríguez Roman]
      #align(right)[06/05/2026]
    ]]


]


#set par(justify: true, spacing: 1.2em * 1.2)



#let fake_heading(content, level: 1) = {
  heading(outlined: false, numbering: none, level: 2 + level)[#content]
}

#let code(content, caption: content) = {
  let bg_code = rect(content, fill: rgb("#eeeded"))

  figure(
    bg_code,
    caption: caption,
    kind: "Code",
    supplement: "Code",
  )
}

#pagebreak()
#fake_heading()[]
\ \
*Titulación*: Grado en Ingeniería Informática. \
*Área de conocimiento*: Ingeniería del Software. \
*Tipo de TFG/TFM*: Trabajo científico-técnico en el ámbito de la ingeniería. \ \

*Principal competencia a desarrollar*: Capacidad para analizar, diseñar, construir y mantener aplicaciones de forma robusta, segura y eficiente, eligiendo el
paradigma y los lenguajes de programación más adecuados. \ \

*Autor*: Ageu Depetris Filho. \
*Tutor*: Miguel Ángel Rodríguez Roman. \

*Escuela Técnica Superior de Ingeniería. Universidad de Huelva.* \
*Junio 2026* \ \

*Palabras Clave*: ETL, Procesado de Datos, Big Data, Docker, NiFi, Data Visualization,
StreamFlow programming, Smart Cities.

*Keywords*: ETL, Data Processing, Big Data, Docker, NiFi, Data Visualization,
StreamFlow Programming, Smart Cities.

#pagebreak()

#set heading(numbering: "1.1")

#outline(
  indent: auto,
  title: "Índice",
  target: heading.where(supplement: [Sección]),
)
#pagebreak()
#outline(title: "Índice de figuras", target: figure.where(kind: image))
#pagebreak()
#outline(title: "Índice de códigos", target: figure.where(kind: "Code"))
#pagebreak()
#outline(title: "Anexo", target: heading.where(supplement: [Anexo]))

#set text(11pt)
#pagebreak()

= Introducción  // Siguiendo guía: contexto del problema aquí

En las ciudades contemporáneas, la movilidad urbana enfrenta desafíos críticos derivados del crecimiento demográfico, la congestión vial y la necesidad de reducir emisiones para cumplir con los objetivos climáticos globales. En 2026, las Zonas de Bajas Emisiones (ZBE) se han consolidado como norma en España, impulsando la transición hacia modelos sostenibles que prioricen el transporte público, la micromovilidad y los desplazamientos activos @imasdetres2026. Este contexto posiciona a los sistemas de bicicletas compartidas como una solución clave para fomentar la sostenibilidad y mejorar la habitabilidad urbana @witam2026.

== Contexto del problema



=== Movilidad urbana y retos de sostenibilidad

Las metropoles europeas, incluyendo las españolas, generan el 30% de las emisiones de CO$\_2$ atraves del transporte, con un impacto agravado por la electrificación incompleta y la dependencia del vehículo privado @otle2020. En la actualidad, regulaciones como las ZBE obligan a las zonas urbanas a elaborar planes de movilidad sostenible, priorizando alternativas bajas en carbono. 

#figure(
  image("resources/images/fig1-emisiones-urbanas.png"),  // Inserta gráfico emisiones transporte UE/España
  caption: [Emisiones de GEI procedentes del transporte en relación con otros sectores. España y Unión Europea (UE-28). 2018
  Fuente: @otle2020.],
  supplement: "Figura"
)

=== Sistemas de bicicletas compartidas en ciudades

Los sistemas de bicicletas públicas (BSP) han proliferado desde 2007, con JCDecaux como referente en ciudades como Sevilla o Valencia. En España, superan las 10.000 unidades, reduciendo emisiones en un 15-20% en rutas cortas. Sin embargo, su escalabilidad depende de análisis predictivos para optimizar flotas.

=== Problemas operativos: saturación de estaciones, desequilibrios, planificación de flota

La saturación de estaciones genera frustración en usuarios y costes de rebalanceo. En BiciMAD (Madrid), fallos en apps y bases incompatibles colapsan el sistema. Desequilibrios OD (origen-destino) y redistribución manual elevan costes operativos. Estudios en Valencia destacan la necesidad de la ampliación de los sistemas y la necesidad de un nuevo marco regulatorio que incentive su uso @seifert2023.

== Presentación del tema  // Corregido "Presetación"

=== Modelado de redes de bicicletas mediante matrices

Las redes de bicicletas compartidas se representan mediante *matrices de origen-destino (OD)*, donde filas y columnas corresponden a estaciones y valores indican flujos de viajes @guti2023. Se calculan métricas sobre estas matrices desde datos de JCDecaux que permiten analizar el comportamiento del sistema.

=== Adecuación del análisis de MATRICES y visualización interactiva

En este Trabajo Fin de Grado se plantea el desarrollo de una aplicación orientada al análisis de redes de bicicletas compartidas a partir de datos estructurados en matrices, especialmente matrices de movimientos, ocupación, distancias y relaciones origen-destino. Este enfoque permite estudiar el comportamiento del sistema sin necesidad de modelarlo formalmente como un grafo, centrándose en métricas operativas como la saturación de estaciones, los desequilibrios espaciales, la eficiencia del servicio y el impacto de distintos escenarios de uso.

Junto al análisis numérico, el proyecto incorpora visualización interactiva sobre mapas y gráficos con el objetivo de facilitar la interpretación de patrones espaciales y temporales. De este modo, la aplicación no solo servirá para procesar datos reales de redes de bicicletas compartidas, sino también para apoyar la identificación de cuellos de botella, zonas con déficit de servicio y posibles decisiones de planificación en el ámbito de la movilidad sostenible.

== Referencias iniciales y trabajos previos

=== TFG de simulación en Sevilla @guti2023

Como referencia próxima al presente trabajo, resulta especialmente relevante el TFG desarrollado sobre la red pública de bicicletas de Sevilla. En dicho trabajo se diseña una herramienta de simulación y análisis capaz de procesar datos reales del sistema, empleando matrices de movimientos, tendencias, capacidades, coordenadas y distancias, y generando como salida indicadores operativos y visualizaciones cartográficas.

Este antecedente resulta útil por dos motivos. En primer lugar, demuestra la viabilidad de abordar el estudio de redes de bicicletas compartidas desde una perspectiva computacional aplicada, combinando tratamiento de datos, simulación y análisis visual. En segundo lugar, ofrece un marco metodológico transferible, especialmente en lo relativo al uso de matrices temporales y espaciales para detectar estaciones vulnerables, estimar distancias generadas por relocalizaciones y comparar configuraciones alternativas del sistema.

No obstante, el enfoque del presente TFG se diferencia de ese antecedente en que prioriza una plataforma orientada a la visualización interactiva y al análisis aplicado sobre datos reales contemporáneos de redes compartidas, con especial atención a la interpretación de resultados en mapas y a la extracción de métricas útiles para la movilidad urbana sostenible. Por tanto, el trabajo de Sevilla puede entenderse como una referencia metodológica y funcional, pero no como un modelo idéntico a reproducir.


=== Propuesta general del proyecto

El presente proyecto propone el desarrollo de una aplicación para analizar redes de bicicletas compartidas en entornos urbanos a partir de datos reales de operación. Su finalidad es facilitar la comprensión del funcionamiento de estas redes mediante el procesamiento de información sobre estaciones, movimientos y ocupación, así como mediante la representación visual de los resultados sobre mapas interactivos.
​
Desde un punto de vista académico y aplicado, el trabajo se sitúa en la intersección entre ingeniería del software, análisis de datos y movilidad sostenible. El interés del proyecto reside en que los sistemas de bicicleta compartida constituyen una pieza cada vez más relevante dentro de las políticas de movilidad urbana, y su evaluación requiere herramientas que permitan identificar patrones de uso, desequilibrios territoriales y posibles mejoras en la planificación del servicio.

En este contexto, el TFG persigue construir una base analítica que permita estudiar el comportamiento de la red y simular escenarios alternativos con valor para la toma de decisiones. Así, más que limitarse a una descripción estática del sistema, el proyecto busca aportar una herramienta de apoyo al análisis, útil tanto para la exploración visual como para la evaluación comparativa de situaciones distintas dentro de una red de bicicletas compartidas.

#bibliography("biblio.bib")

