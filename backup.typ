#import "@preview/cetz:0.2.2"
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import "@preview/wrap-it:0.1.1": wrap-content

#import "@preview/diagraph:0.2.5": *
#bibliography("biblio.bib")
#set text(spacing: 120%, lang: "es")


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

#pagebreak()

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
\
#fake_heading[Arquitectura del sistema]
\

La arquitectura sigue el patrón de microservicios desacoplados con tres capas principales: backend de simulación (bikesim package), API REST (FastAPI) y frontend web (Next.js). El AnalysisOrchestrator centraliza la ejecución, delegando a managers especializados: MatrixManager (procesamiento CSV), ChartManager (gráficos Plotly), MapManager (Voronoi/heatmaps con Selenium), FilterManager (selección dinámica estaciones).

El frontend consume la API vía endpoints _/api/simulate_, _/api/analyze_, _/api/maps_, renderizando mapas Leaflet sobre OpenStreetMap y gráficos Recharts. Los resultados se almacenan persistentemente en el directorio.results/ con metadatos (parámetros, timestamp, dataset origen), solucionando el problema de pérdida de contexto tras inactividad. Docker Compose orquesta los servicios para despliegue reproducible.

#fake_heading[Módulos principales]

+ Carga de datos: Upload matrices CSV → validación Pydantic → almacenamiento en el directorio .uploads/

+ Procesamiento: Orchestrator ejecuta simulación → genera matrices salida (ocupación relativa, peticiones resueltas, km ficticios)

+ Visualización: Mapas interactivos (Voronoi territorios, heatmaps densidad), gráficos (barras peticiones/estación, líneas evolutivas)

+ Simulación: Algoritmo estocástico heredado de Gutiérrez 2023 + escenarios configurables (stress +20% demanda, cambio capacidades estaciones)

+ Historial: Cada resultado (mapa, gráfico, simulación) se asocia a un archivo JSON con parámetros y contexto, permitiendo al usuario entender el origen de cada resultado incluso tras semanas de inactividad.

+ Generador de datos estadisdicos: A partir de las matrices de entrada, permite crear nuevas matrices para crear una nueva simulación, por ejemplo, aumentando la agrupación de deltas o simulando 30 dias de el futuro.

+ Diferenciar directorios: permite al usuario crear una simulación a partir de 2 simulaciónes anteriores, por ejemplo, para comparar el resultado de una simulación con stress de demanda con una simulación sin stress, o para comparar el resultado de una simulación con aumento de flota con una simulación sin aumento de flota.

+ Filtrado dinámico: Permite al usuario seleccionar un subconjunto de estaciones para visualizar en el mapa o en los gráficos, facilitando el análisis focalizado en zonas específicas por conjunto de horas, porcentaje de ocupación o estaciones.



= Diagrama arquitectura

//insertar diagrama de arquitectura aquí

#fake_heading[Decisiones técnicas]


//Incluye 1-2 figuras (diagrama UML/Flowchart via Cetz, snippet código Pydantic/FastAPI). Usa listas numeradas para flujos (e.g., simulación paso a paso).
\
La arquitectura adopta microservicios desacoplados en tres capas: backend simulación (paquete bikesim, Python), API REST (FastAPI) y frontend (Next.js con TypeScript). AnalysisOrchestrator centraliza orquestación, delegando a managers: MatrixManager (CSV/Pandas/NumPy), ChartManager (Plotly/Recharts), MapManager (Folium/Selenium + Leaflet), FilterManager (subsets dinámicos). Docker Compose orquesta (volúmenes para /uploads/, /results/ persistentes).
\


= Módulos del Sistema de Simulación

#figure(
  table(
    columns: (1.2fr, 3.5fr, 2.5fr),
    rows: 9,
    inset: 8pt,
    align: (left, left, left),
    stroke: 0.5pt,
    table.header(
      [*Tab*],
      [*Función principal*],
      [*Inputs/Outputs persistentes*]
    ),
    [Dashboard], 
    [Resumen global (estaciones, bicicletas, stress, delta y distancias)],
    [`/results/ID/` (resumenEjecucion.txt)],
    
    [Simulations],
    [Ver params clave simulación actual + crear nueva (copia params base)],
    [`simulations_history.json` + nueva dir],
  
    [Analytics Graph Creator],
    [Historial gráficas + nueva (barras/líneas/frecuencia por matriz)],
    [`/results/ID/` (JSON metadata)],
    
    [Analytics Map Creator],
    [Historial mapas + nueva (Voronoi/densidad/círculos/desplazamientos)],
    [`/results/ID/` (HTML + JSON)],
    
    [Statistics Generator],
    [Genera matrices sintéticas para nuevas sims],
    [`/uploads/generated/` (CSV nuevo)],
    
    [Dir Comparison],
    [Diff 2 sims/dirs (resta matrices: peticiones_stress - baseline)],
    [`/results/ID/` (matrices nuevas)],
    
    [Filter],
    [Crea/aplica filtros (ocuación, horas, estaciones],
    [`/results/ID/` (CSV listas)],
    
    [History],
    [Listado todas sims (busca por ciudad/params/stress) + resume/retomar],
    [`simulations_history.json`],
    
  ),
  caption: [Módulos funcionales y persistencia de datos]
)
\
== Leyenda de rutas
#grid(
  columns: (auto, 1fr),
  rows: 6,
  gutter: 4pt,
  [`/results/ID/`], [Resultados de simulación por ID],

  [`/uploads/generated/`], [Matrices sintéticas generadas],
  [`simulations_history.json`], [Catálogo global de simulaciones],
)

#fake_heading[Flujo típico:] 

== 1. Frontend generar simulación

#figure(
  ```json
POST /exe/simular-json
Content-Type: application/json

{
  "params": {
    "simname": "Sevilla todos los dias",
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
  caption: [de parámetros enviado desde frontend.],
)<SimulationFlow>

== 2. Processing Pipeline
\
#align(center)[
#text(fill: blue)[Frontend] $->$ #text(fill: purple)[Orchestrator] $->$ #text(fill: red)[Simulación estocástica] $->$ #text(fill: orange)[Generación de matrices] $->$ #text(fill: green)[Almacenamiento]
]
\
Al finalizar la simulación, el backend genera matrices de salida (ocupación relativa, peticiones resueltas, km ficticios
Ocupacion Original, Ocupacion Relativa, Desplazamientos, Kilometros Coger/Dejar/Ficticios, Peticiones No Resueltas/Resueltas Reales/Ficticias, Peticiones resueltas, Resument ejecución). y las almacena en el directorio .results/ con un archivo @jsonTodasSimulaciones asociado que documenta los parámetros y contexto de la ejecución, garantizando que el usuario pueda entender el origen de cada resultado incluso tras periodos de inactividad. 
Cada simulación se asocia a un ID único (timestamp + parámetros clave) y se documenta en el historial de simulaciones, permitiendo al usuario comparar resultados entre diferentes escenarios (por ejemplo, con o sin stress de demanda) y retomar análisis previos sin pérdida de contexto como se ve en la  @SimulationParametersView. El frontend interpreta el contenido del id para representarlo de forma legible en la interfaz, mostrando el nombre de la simulación, los parámetros clave (stress, walk_cost, delta) y la fecha de creación. 

#figure(
  image("resources/images/SimulationParametersView.png"),
  caption: [Vista parámetros: frontend interpreta ID (stress, fecha, delta).],
)<SimulationParametersView>


#figure(
  ```json
{
      "simname": "Sevilla todos los dias",
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
  caption: [Entrada en simulations_history.json: metadatos por simulación.],
)<jsonTodasSimulaciones>
\


#figure(
  table(
    columns: (1fr, 3fr, 1fr),
    rows: 4,
    inset: 10pt,
    align: horizon,
    table.header(
      [*Código*],
      [*Descripción*],
      [*Ejemplo*]
    ),
    [ST], [Stress type (0: none, 1: walk, 2: bikes, 3: both)], [`ST3`],
    [S], [% Stress], [`S50.00`],
    [WC], [Walk cost %], [`WC50.00`],
    [D], [Delta minutos], [`D60`]
  ),
  caption: [Convención de nomenclatura para simulaciones]
)
Convención de estrucutura del directorio:

#quote(block: true)[
  `20260317_180047_sim_`#text(fill: blue)[`ST3`]_#text(fill: red)[`S50.00`]_#text(fill: green)[`WC50.00`]#text(fill: purple)[`D60`]
]

#grid(
  columns: (auto, auto),
  rows: (auto, auto, auto, auto),
  gutter: 5pt,
  [ #text(fill: blue)[■] ST3: ], [ Stress type 3 (both walk & bikes) ],
  [ #text(fill: red)[■] S50.00: ], [ 50% stress level ],
  [ #text(fill: green)[■] WC50.00: ], [ 50% walk cost ],
  [ #text(fill: purple)[■] D60: ], [ 60 minute delta interval ]
)

== 1. Upload & Nueva simulación:
\
  - Usuario sube CSV → validación de datos → crea entrada @jsonTodasSimulaciones (ID: timestamp_ST\#_S%_WC%\_Dmin).

  - Crea dirs: /uploads/timestampUpload + /results/ID/ (outputs: matrices + metadatos).

  #figure(
    image("resources/images/resultsDirStructure.png"),
    caption: [Estructura de directorios para resultados: /results/ID/ con matrices + metadatos.],
  )
\

Desde el Frontend la simulación se lanza mediante un formulario que recoge los parámetros clave (nombre, stress, walk cost, delta) y el archivo CSV de entrada con una interfaz web orientada a la usabilidad de manera intuitiva.

*Flujo de creación:*

1. El usuario elige un nombre para la simulación y hace upload de los datos de entrada.

#figure(
  image("resources/images/SimSteps1.png", height: 50%),
  caption: [Formulario de upload: nombre simulación + CSV entrada.],
) <UploadForm>

2. Al continuar para el segundo paso, elije los parámetros de stress para la simulación a través de un slider para que el input sea más visual e intuitivo.

#figure(
  image("resources/images/SimSteps2.png", height: 50%),
  caption: [Selección de parámetros de stress mediante sliders.],
) <SimParams>

3. Finalmente, el usuario elije el tipo de stress, el delta de la simulación y confirma los parámetros y lanza la simulación, que se ejecuta en el backend y genera los resultados asociados al ID de la simulación, quedando documentados en el historial para su consulta futura.


Para mayor facilidad de uso, el sistema se asegura que el usuario ha enviado un CSV válido comprobando la cantidad y si atiende a la convención de nombres antes de permitir avanzar a la selección de parámetros.

#figure(
  image("resources/images/uploadcomponetCheck.png", height: 50%),
  caption: [Comprobación de datos de entrada.],
) <SimLaunch>


= Post simulación:
\
== Dashboard
\
En el Dashdoard (@Dashboard) nos permite visualizar un resumen global de la simulación actual, mostrando métricas clave como el id de la simulación, el delta, stress y las distancias totales. Esta información se extrae del archivo resumenEjecucion.txt generado al finalizar cada simulación y se muestra de forma clara para que el usuario pueda entender rápidamente las características principales de la simulación que está analizando.
\
#figure(
  image("resources/images/dashBoardNosidebar.png"),
  caption: [Dashboard: resumen global de la simulación actual.],
)<Dashboard>

\
== Área de simulación

En el área de simulación, el usuario puede visualizar los resultados de la simulación actual a través de mapas interactivos y gráficos dinámicos. El mapa muestra la capacidad de cada estación, mientras que los gráficos permiten analizar el número de estaciones, la ciudad en la que se trabaja, el número de bicicletas, la capacidad total del sistema y la capacidad media. 

#figure(
  image("resources/images/SimNoSideBarpt1.png"),
  caption: [Área de simulación: mapa interactivo y resumen de métricas.],
)<SimulationArea>

Tambien podemos visualizar la performance del sistema a través de métricas como el porcentaje de stress aplicado, el número total de operaciones realizadas, la tasa de éxito general y la distancia media por operación. Estos indicadores nos permiten evaluar la eficiencia del sistema bajo diferentes escenarios de stress y entender cómo se comporta la red de bicicletas compartidas en condiciones variables usando gráficas claras.

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
    caption: [Gráficas de análisis: evolución temporal, histogramas, comparativas.],
  ) <CombinedSimViews>
]

