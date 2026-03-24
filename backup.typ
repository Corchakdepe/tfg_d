#import "@preview/cetz:0.2.2"
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import "@preview/wrap-it:0.1.1": wrap-content

#import "@preview/diagraph:0.2.5": *
#bibliography("biblio.bib")
#set text(spacing: 120%, lang: "es")
#set text(
  lang: "sp"
)

#let title = "Aplicación de analisis de redes de bicicletas compartidas"
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
        image(width: 50%, "assests/portada/EtsiLogo.png"), h(90pt), image(width: 70%, "assests/portada/UhuLogo.png"),
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

= Introducción <intro>
\
La creciente presión sobre los sistemas de transporte urbano ha impulsado la búsqueda de alternativas más sostenibles, flexibles y eficientes que complementen al vehículo privado y al transporte público tradicional. En este contexto, los sistemas de bicicletas compartidas se han consolidado en numerosas ciudades como una solución de micromovilidad que favorece la reducción de emisiones, mejora la calidad del aire y promueve hábitos de vida más saludables. No obstante, la gestión operativa de estas redes plantea retos significativos relacionados con el dimensionamiento de las estaciones, el equilibrio dinámico de la flota y la respuesta ante patrones de demanda altamente variables en el espacio y en el tiempo.
\
Desde el punto de vista de la ingeniería informática, estos sistemas generan grandes volúmenes de datos geoespaciales y temporales (ocupaciones de estaciones, trayectos, horarios, eventos urbanos) que pueden ser explotados mediante técnicas avanzadas de análisis de datos, modelado de grafos y simulación estocástica. Disponer de herramientas que integren estos datos, los procesen de forma automatizada y los representen sobre mapas interactivos facilita la identificación de cuellos de botella, la evaluación de configuraciones alternativas de la red y el apoyo a la toma de decisiones en políticas de movilidad sostenible. Además, la combinación de representaciones gráficas (gráficos de barras, mapas de densidad, diagramas de Voronoi) con métricas cuantitativas (ocupación relativa, peticiones resueltas, kilómetros recorridos) permite comunicar los resultados tanto a perfiles técnicos como a responsables de planificación urbana.

En este Trabajo Fin de Grado se propone el desarrollo de una aplicación web para el análisis y simulación de redes de bicicletas compartidas basada en datos reales procedentes de proveedores como JCDecaux e información cartográfica de OpenStreetMap. La aplicación integra un motor de simulación y análisis reutilizable (paquete bikesim) con una interfaz web moderna, desacoplando la lógica de cálculo del _Frontend_ de visualización y permitiendo ejecutar experimentos de forma interactiva sin necesidad de recurrir a la línea de comandos. Sobre esta plataforma se diseñan y ejecutan distintos escenarios (por ejemplo, cierre de estaciones, aumento de flota o aplicación de “stress” de demanda en zonas concretas) con el objetivo de extraer métricas clave que ayuden a evaluar la robustez, la eficiencia y el nivel de servicio de la red de bicicletas compartidas.

#pagebreak()

#fake_heading()[Abstract]

Bike-sharing systems have become a key component of sustainable urban mobility, but their effective management is challenging due to highly dynamic, spatially heterogeneous demand patterns and limited station capacity. This Bachelor’s Thesis presents a web-based platform for the analysis and simulation of bike-sharing networks using real operational data from providers such as JCDecaux, combined with cartographic information from OpenStreetMap. The system models the network as a graph, computes indicators such as station occupancy, centrality and flows, and generates interactive visualizations on maps to support the identification of congested or underused areas. A modular backend, implemented as the bikesim package, exposes a stochastic simulation engine and advanced analysis tools through a REST API, while a Next.js frontend offers an intuitive interface that removes the need for terminal-based interaction. A persistent results-history module associates each map, chart and simulation run with its input parameters and data sources, enabling users to understand and resume their work even after long periods of inactivity. The platform is evaluated through a set of case studies that explore scenarios such as station closures, fleet increases and demand stress in specific zones, demonstrating its usefulness as a decision-support tool for urban planners and mobility researchers.

#pagebreak()

= Motivación del proyecto
\
La motivación principal de este trabajo surge de la necesidad de dotar a gestores públicos, investigadores y técnicos de herramientas accesibles que permitan analizar el comportamiento de redes de bicicletas compartidas a partir de datos reales. Experiencias previas, como el desarrollo de simulaciones específicas para la red de bicicletas públicas de Sevilla, han demostrado el potencial del enfoque basado en simulación y análisis masivo de datos, pero también han puesto de manifiesto limitaciones en términos de usabilidad, acoplamiento tecnológico y dificultad para extender los experimentos a otros contextos urbanos.
\
Este proyecto plantea una evolución de dichas herramientas hacia una plataforma modular, _dockerizada_ y orientada a servicios, en la que el motor de simulación se expone mediante una _API REST_ y el usuario interactúa a través de una interfaz web con mapas y paneles de control. De este modo, se reduce la barrera de entrada técnica y se facilita la reutilización de la infraestructura de análisis para diferentes ciudades, conjuntos de datos o hipótesis de planificación, manteniendo al mismo tiempo un enfoque científico-técnico que permita reproducir los experimentos y validar los resultados.

= Objetivos del proyecto
\
El objetivo general de este Trabajo Fin de Grado es diseñar, implementar y validar una aplicación de análisis de redes de bicicletas compartidas que integre datos reales, modelos de simulación y visualizaciones interactivas para apoyar la toma de decisiones en movilidad urbana sostenible, garantizando al mismo tiempo que cada mapa o simulación quede asociado a un historial explícito de parámetros y acciones que facilite retomar el trabajo tras periodos de inactividad.


+ Integrar y depurar datos reales de redes de bicicletas compartidas, con especial énfasis en los datasets públicos de JCDecaux y la cartografía de OpenStreetMap.

+ Modelar la red de estaciones como un grafo, calculando métricas de centralidad, ocupación relativa, flujos de demanda y otros indicadores relevantes para la evaluación del sistema.

+ Desarrollar un motor de simulación capaz de reproducir el comportamiento de la red bajo diferentes configuraciones (capacidad de estaciones, distribución de bicicletas, patrones de demanda) y escenarios de “stress”.

+ Diseñar y desplegar una interfaz web interactiva que permita al usuario cargar datos, lanzar simulaciones, explorar resultados y visualizar métricas sobre mapas dinámicos, utilizando tecnologías como Leaflet o Mapbox.

+ Incorporar un sistema de gestión de resultados con historial persistente, de modo que cada ejecución (mapa, gráfico o simulación) almacene de forma legible los parámetros utilizados, el contexto de los datos y las acciones realizadas, permitiendo a un usuario que regresa tras varios días comprender fácilmente de dónde procede cada resultado.

+ Definir y ejecutar una batería de experimentos de caso de estudio, analizando el impacto de cambios estructurales en la red (por ejemplo, cierre temporal de estaciones o aumento de flota en zonas de alta demanda) y extrayendo conclusiones cuantitativas.

+ Documentar de forma sistemática la arquitectura, las decisiones de diseño y la metodología de análisis seguida, de manera que el trabajo pueda ser reproducible y sirva de base para futuras extensiones en el ámbito de la movilidad sostenible.

#pagebreak()


= Requisitos técnicos
#linebreak()

La plataforma desarrollada se apoya en una arquitectura web cliente–servidor, por lo que requiere un conjunto de herramientas para el despliegue del backend de simulación, del frontend de visualización y de los servicios auxiliares de generación de mapas.

Requisitos de software:

+ Docker y Docker Compose, recomendados como método principal para orquestar los contenedores de backend y frontend y simplificar el despliegue reproducible del sistema.

+ Python 3.9 o superior, necesario para la ejecución local del backend implementado con FastAPI y del paquete de simulación bikesim.

+ Node.js 20 o superior, empleado para la compilación y ejecución del frontend desarrollado con Next.js 15.

+ Navegador Chromium o Google Chrome, requerido para la generación automática de mapas estáticos mediante Selenium en el módulo de visualización geoespacial.

Requisitos de bibliotecas y frameworks

+ Backend: FastAPI para la exposición de la API REST, Pandas y NumPy para el procesamiento de matrices y métricas, Folium, Geovoronoi, Shapely y OpenRouteService para el soporte geoespacial.

+ Frontend: Next.js con TypeScript, Tailwind CSS, Radix UI y Lucide Icons para la interfaz de usuario, junto con Leaflet y React Leaflet para la renderización de mapas interactivos y Recharts o Chart.js para la generación de gráficos.

+ Internacionalización: i18next para ofrecer la interfaz en al menos español, portugués e inglés, facilitando la extensión del sistema a distintos contextos.


#fake_heading[Decisiones técnicas]

Desde el punto de vista técnico, la elección de FastAPI se justifica por su integración con Pydantic para la validación de datos, su facilidad para definir endpoints REST y su capacidad para estructurar el backend de forma clara y extensible. En el frontend, Next.js con TypeScript permite organizar la interfaz en componentes reutilizables, mejorando la mantenibilidad del código y la consistencia de la experiencia de usuario.

En la capa de análisis y representación se han seleccionado bibliotecas específicas según el tipo de salida. Pandas y NumPy se utilizan para el tratamiento de matrices y cálculos numéricos; Folium, Geovoronoi y Shapely se emplean para las operaciones geoespaciales; y bibliotecas como Recharts, Plotly o Leaflet se integran para la construcción de gráficos y mapas interactivos.

Por su parte, Docker y Docker Compose se han adoptado como mecanismo de despliegue reproducible, encapsulando backend, frontend y dependencias auxiliares en contenedores aislados. Esto simplifica la puesta en marcha del sistema, reduce problemas de configuración entre entornos y facilita la futura distribución del proyecto.

#figure(
  table(
    columns: (1.5fr, 2fr, 2.8fr),
    inset: 8pt,
    stroke: 0.5pt,
    table.header(
      [*Tecnología*],
      [*Capa*],
      [*Motivo de elección*]
    ),
    [FastAPI], [Backend/API], [Definición clara de endpoints REST, validación de entrada y buena integración con Pydantic],
    [Next.js + TypeScript], [Frontend], [Componentización, mantenibilidad y construcción de interfaz moderna],
    [Pandas + NumPy], [Procesamiento], [Manipulación eficiente de matrices y operaciones numéricas],
    [Leaflet + Folium], [Visualización geoespacial], [Representación flexible de mapas interactivos y generación de salidas cartográficas],
    [Docker Compose], [Despliegue], [Reproducibilidad, aislamiento de dependencias y facilidad de configuración]
  ),
  caption: [Principales decisiones tecnológicas adoptadas en el desarrollo del sistema.],
)<TechDecisions>
#fake_heading[Alcance funcional de la implementación]

La versión final de la aplicación implementa de forma integrada los bloques principales necesarios para el análisis de redes de bicicletas compartidas: carga y validación de datos de entrada, ejecución de simulaciones, generación de matrices derivadas, persistencia de resultados, análisis gráfico, visualización cartográfica, comparación entre escenarios, filtrado de estaciones y generación estadística de nuevos datos.

Desde el punto de vista funcional, el sistema permite trabajar sobre una simulación activa y reutilizar su contexto en todas las vistas de la aplicación. Esto evita la fragmentación del análisis y garantiza que cualquier mapa, gráfico, filtro o comparación quede asociado a un identificador de simulación concreto. Como consecuencia, el usuario puede retomar el trabajo en sesiones posteriores sin perder el contexto de los parámetros utilizados ni el origen de los datos procesados.

La implementación desarrollada también mejora varios aspectos respecto a herramientas previas centradas en ejecución local o uso por línea de comandos. En particular, se ha reforzado la usabilidad mediante una interfaz web guiada, se ha incorporado persistencia explícita del historial de simulaciones y se ha unificado en una única plataforma el conjunto de utilidades de simulación, análisis y exploración visual, ampliando así el alcance práctico del sistema @gutierrez2023.

Además, la estructura modular adoptada permite incorporar futuras extensiones sin necesidad de rediseñar el sistema completo. La separación entre frontend, API REST y backend de simulación facilita tanto la sustitución de componentes concretos como la integración de nuevas fuentes de datos, métricas analíticas o técnicas de predicción sobre el comportamiento de la red.

#fake_heading[Transición a la evaluación experimental]

Una vez descrita la arquitectura, el flujo interno de ejecución, la organización persistente de resultados y los principales módulos funcionales, el siguiente paso consiste en evaluar la utilidad de la plataforma sobre escenarios concretos de análisis. Para ello, en la siguiente sección se presentan distintos experimentos realizados sobre datos reales, donde la aplicación se utiliza como herramienta para diagnosticar el estado de la red, visualizar patrones espaciales y temporales, comparar configuraciones alternativas y estudiar el impacto de diferentes escenarios de stress, modificación de capacidades o generación sintética de movimientos.

De este modo, la sección siguiente no se centra ya en cómo está construida la aplicación, sino en qué conocimiento permite extraer y en qué medida los resultados obtenidos pueden servir como apoyo a la toma de decisiones en contextos de movilidad urbana sostenible.

\
= Estado del arte

#fake_heading[Sistemas de bicicletas compartidas]

Los sistemas de bicicletas compartidas han experimentado una rápida evolución desde sus inicios en la década de 1960. La primera generación, implementada en Ámsterdam en 1965 con las *Witte Fietsen* (bicicletas blancas de uso libre), derivó en vandalismo masivo y rápida obsolescencia @wittefietsen1965. La segunda generación, en los años 90 (ejemplo: *Bycyklen* en Copenhague, 1995), introdujo mecanismos de depósito, pero aún sufría hurtos sistemáticos. La tercera generación, consolidada desde 1998 en Rennes (*Vélos à la carte*), incorporó tecnologías de identificación electrónica (RFID, cuentas de usuario), multiplicando su implantación hasta 712 ciudades en 2014 @fishman2014.

Estos sistemas operan mediante redes de estaciones fijas donde los usuarios retiran y depositan bicicletas en intervalos discretos (deltas de 5–15 minutos), generando matrices de movimientos (positivos para depósitos, negativos para retiros), vectores de capacidades y datos geoespaciales. Proveedores como JCDecaux, con plataformas como *Cyclocity* y *Vélib'* en París (lanzado en 2007 con 6.000 bicicletas), exponen datos en tiempo real vía API pública, incluyendo ocupación, trayectos y estado de estaciones @jcdecauxapi.

#fake_heading[Herramientas de análisis y visualización de redes]

El análisis modela la red como grafo dirigido (estaciones como nodos, flujos como aristas), computando métricas como centralidad (degree, betweenness, closeness, eigenvector), entropía (desequilibrio espacial) y ocupación relativa @froehlich2012 @newman2010. Bibliotecas como NetworkX facilitan estos cálculos, con Pandas/NumPy para matrices temporales @networkxdocs @pandaspy.

La visualización usa Leaflet/Mapbox sobre OpenStreetMap, con técnicas como Voronoi (territorios de influencia), heatmaps de densidad y mapas de desplazamientos @leafletjs @mapboxgl. Gráficos (barras de peticiones, líneas evolutivas, histogramas) se generan con Plotly/Matplotlib, integrando filtros dinámicos @plotlypy @matplotlib.

#fake_heading[Trabajos relacionados]

El TFG de Luis Gutiérrez Jerez (2023, Universidad de Huelva) desarrolló un simulador para la red de Sevilla, con algoritmos estocásticos basados en matrices de deltas, tendencias, capacidades y distancias precalculadas, generando visualizaciones (Voronoi, evolutivas) y análisis de stress @gutierrez2023. Este trabajo hereda directamente esa lógica algorítmica y formato de matrices en el paquete *bikesim*, refactorizándola para robustez y exponiéndola vía FastAPI, pero priorizando una interfaz web *user-friendly* que elimina comandos terminales y añade historial persistente.

Otros trabajos como los de @sergiomacias2025 abordan la recompilación y ETL de datos de movilidad urbana, planteando infraestructuras para ingesta continua de fuentes heterogéneas. Aunque no se integra directa ni indirectamente en la lógica del sistema desarrollado (que asume datos ya procesados de JCDecaux), representa una línea futura de extensión para automatizar la preparación de datasets.

En literatura, Soriguera et al. (2020) presentan modelos de simulación continua @soriguera2020, y Alvarez-Valdés et al. (2016) algoritmos heurísticos para reposicionamiento @alvarez2016. La plataforma combina precisión algorítmica con interactividad web @kdd2016rebalancing.


= Desarrollo de la aplicación

#fake_heading[Arquitectura del sistema]

La aplicación desarrollada sigue una arquitectura cliente-servidor desacoplada, organizada en tres capas principales: un frontend web implementado con Next.js, una API REST construida con FastAPI y un backend de análisis y simulación encapsulado en el paquete `bikesim`.

Esta separación permite aislar la lógica de presentación de la lógica de negocio y del procesamiento de datos, facilitando tanto el mantenimiento del sistema como la reutilización del motor de simulación en otros contextos. El frontend actúa como punto de interacción con el usuario, permitiendo cargar conjuntos de datos, configurar parámetros de simulación y consultar resultados mediante mapas y gráficos interactivos. La API REST funciona como capa intermedia, recibiendo las peticiones del cliente, validando los parámetros de entrada y coordinando la ejecución de los distintos procesos internos. Finalmente, el backend ejecuta las tareas de simulación, análisis, generación de matrices y construcción de artefactos gráficos o geoespaciales.

La coordinación interna del sistema se centraliza en un componente orquestador denominado `AnalysisOrchestrator`, que delega el trabajo en distintos módulos especializados. Entre ellos destacan `MatrixManager`, encargado del procesamiento de matrices; `ChartManager`, responsable de la generación de gráficos; `MapManager`, que construye las salidas cartográficas; y `FilterManager`, que aplica consultas y selecciones sobre subconjuntos de estaciones. Esta distribución modular permite extender el sistema de forma progresiva sin introducir un fuerte acoplamiento entre componentes.

El frontend consume la API mediante distintos endpoints, entre ellos _/exe/simulate_json_, _/exe/analyze_json_ y renderiza los resultados mediante Leaflet, gráficos dinámicos y componentes de interfaz desarrollados con TypeScript. Los resultados se almacenan de forma persistente en el directorio `.results/`, junto con los metadatos necesarios para reconstruir el contexto de ejecución, evitando así la pérdida de información tras periodos de inactividad.

//figura de la arquiterura aqui



#fake_heading[Flujo de ejecución de una simulación]

El flujo principal de uso comienza cuando el usuario crea una nueva simulación desde el frontend. Para ello, introduce un nombre identificativo (opcional), selecciona los ficheros de entrada y configura parámetros como el porcentaje de stress, el coste de caminar, el tipo de stress aplicado y el valor de delta temporal. Una vez confirmados estos datos, el frontend envía una petición HTTP al backend en formato `.json`.

#figure(
  ```json
POST /exe/simular-json
Content-Type: application/json

{
  "params": {
    "simname": "Sevilla todos los días",
    "stress": 50,
    "walk_cost": 50,
    "delta": 60,
    "stress_type": 3,
    "ruta_entrada": "uploads/upload_20260317_180037",
    "ruta_salida": "",
    "dias": null
  }
}
```,
  supplement: ".JSON",
  caption: [Petición enviada desde el frontend para lanzar una nueva simulación.],
)<SimulationFlow>

La API recibe la petición, valida su estructura y la transfiere al orquestador principal, que inicia el flujo de simulación correspondiente.

#align(center)[
  #text(fill: blue)[Frontend]
  $arrow.r$
  #text(fill: purple)[Orchestrator]
  $arrow.r$
  #text(fill: red)[Simulación estocástica]
  $arrow.r$
  #text(fill: orange)[Generación de matrices]
  $arrow.r$
  #text(fill: green)[Almacenamiento]
]

Durante la ejecución, el sistema procesa las matrices de entrada, aplica el algoritmo estocástico heredado del trabajo de Gutiérrez Jerez @gutierrez2023 y genera como salida un conjunto de matrices derivadas que describen el comportamiento del sistema. Entre estas salidas se incluyen la ocupación original, la ocupación relativa, la matriz de desplazamientos, los kilómetros producidos al coger o dejar bicicletas, los kilómetros ficticios asociados a tendencias no satisfechas, las matrices de peticiones resueltas y no resueltas —tanto reales como ficticias— y un fichero de resumen de ejecución.

#fake_heading[Persistencia y organización de resultados]

Uno de los objetivos principales del sistema es evitar la pérdida de contexto entre sesiones de trabajo. Para ello, cada simulación ejecutada genera un identificador único compuesto por una marca temporal y una codificación compacta de los parámetros más relevantes, como el tipo de stress, el porcentaje aplicado, el coste de caminar y el delta temporal. Esta convención de nombres permite reconocer rápidamente las características principales de una ejecución sin necesidad de abrir manualmente sus archivos asociados.

#figure(
  image("resources/images/SimulationParametersView.png"),
  caption: [Visualización de los parámetros de una simulación a partir del identificador asociado.],
)<SimulationParametersView>

#figure(
  ```json
{
  "simname": "Sevilla todos los días",
  "simfolder": "20260317_180130_sim_ST3_S50.00_WC50.00_D60",
  "simdataId": "20260317_180130_sim_ST3_S50.00_WC50.00_D60",
  "cityname": "Sevilla",
  "numberOfStations": 260,
  "numberOfBikes": 2512,
  "total_capacity": 5089.0,
  "avg_capacity": 19.573076923076922,
  "min_capacity": 10.0,
  "max_capacity": 40.0,
  "coordinates": {
    "avg_lat": 37.38890088461538,
    "avg_lon": -5.977624423076923
  },
  "simdata": {
    "stress_type": 3,
    "stress": 50.0,
    "walk_cost": 50.0,
    "delta": 60,
    "dias": []
  },
  "path": "results/20260317_180130_sim_ST3_S50.00_WC50.00_D60",
  "created": "2026-03-17T18:01:31.998931"
}
```,
  supplement: ".JSON",
  caption: [Entrada en `simulations_history.json` con los metadatos de una simulación.],
)<jsonTodasSimulaciones>

Además, el sistema mantiene un fichero global denominado `simulations_history.json`, que actúa como catálogo general de simulaciones. En él se registran datos como el nombre de la simulación, el identificador interno, la ciudad, el número de estaciones, el número de bicicletas, la capacidad total, las coordenadas medias y los parámetros concretos utilizados.

#figure(
  table(
    columns: (1fr, 3fr, 1fr),
    inset: 10pt,
    align: horizon,
    table.header(
      [*Código*],
      [*Descripción*],
      [*Ejemplo*]
    ),
    [ST], [Tipo de stress aplicado (0: none, 1: walk, 2: bikes, 3: both)], [`ST3`],
    [S], [Porcentaje de stress], [`S50.00`],
    [WC], [Walk cost], [`WC50.00`],
    [D], [Delta temporal en minutos], [`D60`]
  ),
  caption: [Convención de nomenclatura empleada en los identificadores de simulación.],
)<SimulationNaming>

Convención de estructura del directorio:

#quote(block: true)[
  `20260317_180047_sim_`#text(fill: blue)[`ST3`]_#text(fill: red)[`S50.00`]_#text(fill: green)[`WC50.00`]#text(fill: purple)[`D60`]
]

#grid(
  columns: (auto, auto),
  rows: (auto, auto, auto, auto),
  gutter: 5pt,
  [#text(fill: blue)[■] ST3:], [Tipo de stress 3 (walk + bikes)],
  [#text(fill: red)[■] S50.00:], [50% de stress],
  [#text(fill: green)[■] WC50.00:], [50% de coste de caminata],
  [#text(fill: purple)[■] D60:], [Delta de 60 minutos]
)

A nivel de almacenamiento, el sistema crea dos tipos de directorios. Por un lado, en `.uploads/` se conserva la entrada original asociada a la ejecución. Por otro, en `.results/` se almacena un directorio específico para la simulación, que contiene tanto las matrices generadas como los metadatos necesarios para su trazabilidad.
Aunque la aplicacion sea web, la versión actual esta pensaba para trabajar localmente, por lo que conserva los ficheros de upload, en una aplicacion desplegada en un servidor remoto, tener todos los uploads de diferentes simulaciones almacenados. En una versión futura, se podría plantear un sistema de almacenamiento en la nube o una base de datos para gestionar estos archivos de forma más escalable y segura, especialmente si se prevé un uso concurrente por parte de múltiples usuarios.

#figure(
  image("resources/images/resultsDirStructure.png"),
  caption: [Estructura de directorios de resultados y metadatos asociados a una simulación.],
)<ResultsStructure>


= Interfaz de usuario

#fake_heading[Módulos funcionales de la aplicación]

Una vez seleccionada una simulación, la aplicación ofrece un conjunto de módulos funcionales organizados en distintas áreas de trabajo. Todos ellos comparten la misma idea de persistencia: cualquier artefacto generado queda asociado a la simulación activa y puede recuperarse posteriormente desde el historial.

#figure(
  table(
    columns: (1.3fr, 3.4fr, 2.4fr),
    inset: 8pt,
    align: (left, left, left),
    stroke: 0.5pt,
    table.header(
      [*Módulo*],
      [*Función principal*],
      [*Persistencia*]
    ),
    [Dashboard],
    [Resumen global de la simulación actual: estaciones, bicicletas, stress, delta y distancias],
    [`/results/ID/` (`resumenEjecucion.txt`)],

    [Simulations],
    [Consulta de parámetros de la simulación actual y creación de nuevas simulaciones a partir de una base],
    [`simulations_history.json` + nuevo directorio],

    [Analytics Graph Creator],
    [Historial y generación de nuevas gráficas a partir de matrices de salida],
    [`/results/ID/` (metadatos `.json`)],

    [Analytics Map Creator],
    [Historial y generación de nuevos mapas: Voronoi, densidad, círculos y desplazamientos],
    [`/results/ID/` (`.html` + `.json`)],

    [Statistics Generator],
    [Generación de matrices sintéticas para futuras simulaciones],
    [`/uploads/generated/` (`.csv`)],

    [Dir Comparison],
    [Comparación entre dos simulaciones mediante diferencia de matrices],
    [`/results/ID/` (matrices derivadas)],

    [Filter],
    [Aplicación de filtros por ocupación, horas o subconjuntos de estaciones],
    [`/results/ID/` (listas `.csv`)],

    [History],
    [Listado global de simulaciones y recuperación del contexto de trabajo],
    [`simulations_history.json`]
  ),
  caption: [Módulos funcionales de la aplicación y persistencia de datos asociada.],
)<ModulesTable>

== Dashboard

El módulo Dashboard permite visualizar un resumen global de la simulación actual, mostrando métricas clave como el identificador de la simulación, el delta temporal, el nivel de stress y las distancias totales recorridas. Esta información se extrae del fichero `resumenEjecucion.txt` generado al finalizar cada ejecución y se presenta de forma sintética para proporcionar contexto inmediato sobre la simulación que se está analizando.

#figure(
  image("resources/images/dashBoardNosidebar.png"),
  caption: [Dashboard con resumen global de la simulación activa.],
)<Dashboard>

== Área principal de simulación

En el área principal de simulación, el usuario puede visualizar los resultados a través de mapas interactivos y gráficos dinámicos. El mapa muestra la capacidad de cada estación y su distribución espacial, mientras que los paneles laterales resumen datos como el número de estaciones, la ciudad, el número de bicicletas, la capacidad total del sistema y la capacidad media.

#figure(
  image("resources/images/SimNoSideBarpt1.png"),
  caption: [Área principal de simulación con mapa interactivo y métricas agregadas.],
)<SimulationArea>

Además, se representan indicadores de rendimiento como el porcentaje de stress aplicado, el número total de operaciones realizadas, la tasa de éxito general y la distancia media por operación. Estos elementos permiten evaluar el comportamiento del sistema bajo distintos escenarios y facilitan la interpretación comparativa de los resultados.

#align(center)[
  #figure(
    grid(
      columns: (1fr, 1fr),
      gutter: 20pt,
      [
        #image("resources/images/SimNoSideBarpt2.png", width: 100%)
      ],
      [
        #image("resources/images/SimNoSideBarpt3.png", width: 100%)
      ]
    ),
    caption: [Gráficas de análisis asociadas a la simulación: comparativas, evolución temporal e indicadores agregados.],
  )<CombinedSimViews>
]


La interfaz web se ha diseñado con un enfoque orientado a la usabilidad, reduciendo la barrera de entrada para usuarios no técnicos. El flujo de creación de una simulación se organiza en varios pasos guiados.

Desde el frontend, la simulación se lanza mediante un formulario que recoge los parámetros clave —nombre, stress, walk cost y delta— junto con el fichero `.csv` de entrada. El proceso de creación se articula del siguiente modo:

1. El usuario asigna un nombre a la simulación y realiza la carga de los ficheros de entrada.

#figure(
  image("resources/images/SimSteps1.png", height: 50%),
  caption: [Formulario inicial para la creación de una simulación.],
)<UploadForm>

2. En un segundo paso, ajusta los parámetros de stress mediante controles visuales tipo slider, con el objetivo de hacer la interacción más intuitiva.

#figure(
  image("resources/images/SimSteps2.png", height: 50%),
  caption: [Selección visual de parámetros de stress mediante sliders.],
)<SimParams>

3. Finalmente, selecciona el tipo de stress, el delta temporal y confirma la configuración antes de lanzar la simulación.

#figure(
  image("resources/images/SimStepsLast.png", height: 50%),
  caption: [Confirmación final de parámetros antes de ejecutar la simulación.],
)<SimLaunch>

Para mejorar la robustez del flujo de entrada, el sistema comprueba automáticamente que los ficheros cargados cumplen la convención esperada y que su estructura es válida antes de permitir avanzar a la configuración de parámetros.

#figure(
  image("resources/images/uploadcomponetCheck.png", height: 50%),
  caption: [Validación automática de los ficheros de entrada antes de iniciar la simulación.],
)<InputValidation>

Una vez finalizada la ejecución, el usuario accede a un conjunto de vistas asociadas a la simulación activa.

= Resultados y experimento


