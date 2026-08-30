#import "@preview/touying:0.7.4": *
#import themes.university: *
#import "@preview/cetz:0.5.2"
#import "@preview/fletcher:0.5.8" as fletcher: node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.6.0": *
#import cosmos.clouds: *
#import "@preview/lilaq:0.6.0" as lq
#show: show-theorion

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#set heading(numbering: none)

#show: university-theme.with(
  aspect-ratio: "16-9",
  header: utils.display-current-heading(level: 2, style: auto, numbered: false),
  header-right: self => (
    self.info.logo
  ),
  config-common(
    frozen-counters: (theorem-counter,),
    new-section-slide-fn: new-section-slide.with(numbered: false),
    show-notes-on-second-screen: right,
  ),   
  config-info(
    title: [Beachlorarbeit],
    subtitle: [Minimale Neuberechnung Abhängigkeits-Graph basierter Regeln zur prozeduralen Welten-Generation],
    author: [Maarten Behn],
    date: [ 08.09.2026],
    institution: [CGVR Universität Bremen],
    logo: image("./layout/UHB_Logo_4c.svg", height: 18.5mm),
  ),
  config-colors(
    primary: rgb("#04364A"),
    secondary: rgb("#176B87"),
    tertiary: rgb("#448C95"),
    neutral-lightest: rgb("#ffffff"),
    neutral-darkest: rgb("#000000"),
  )
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()


= Problemstellung

= Kern Idee

#speaker-note[
- Angenommen es gibt eine prozedurale Welt 
- Dann gibt es im Code den Spiels ein Haufen Funktionen der eine neue Welt erzeugen kann bzw neue Bereiche errechnet.
Bild von Minecraft
- Mann kann diesen Code als auch als eine Funktion verstehen 
- Input alle Parameter der Welt 
- Eine Spielwelt 
- Da viel Zufälligkeit genutzt wird gibt es eine Menge an Welten die generiert werden kann. 
- Eine Welt die in dieser Menge ist nenne ich valide

- Wenn nun der Algorithmus geändert wird ändert sich damit die Menge der validen Welten 
- ABER: Es ist kann trotzdem gut sein dass eine Welt immer noch komplett oder zu großen Teilen valide ist. 

- Daher meine Frage: 
- Ist es möglich ein System zu entwickeln, dass dann von einer vorhandenen Welt nur die Bestandteile neu berechnet, 
die nicht mehr valide sind. 
]

= Was ich gebaut habe 

#speaker-note[
- Kurzes Video 
  - Zeigt wie man im Editor eine Welt erstellt und sich diese live im Renderer angezeigt wird.
]

= Bestandteile 

#speaker-note[
- Editor, Template, Generator
]

= Struktur des Templates 

== Graphen im Speicher Darstellen 

#cols(lazy-layout: true)[
```rust

enum TemplateValue {
    Number(NumberValue),
    Position(PositionValue),
    Volume(VolumeValue),
...
```
][
```rust

enum PositionValue {
  Add((PosIndex, PosIndex)),
  Sub((PosIndex, PosIndex)),
  Numbers([NumberIndex; 3]),
...
```]

#v(1cm)

```rust
let values: Vec<TemplateValue>
```
#cetz-canvas({
  import cetz.draw: *

  let items = (
    (orange, 1),   (orange, 0.5), (orange, 0.2), (orange, 0.8),
    (orange, 0.3), (orange, 0.9), (orange, 0.4), (orange, 0.3)
  )
  
  for (i, (fill, full)) in items.enumerate() { 
    let w = 3
    let h = 2
    let x = i * w
    let inset = 0.5
    fill = fill.desaturate(60%)

    group(name: "block-" + str(i), {
      rect((x, 0), (x + inset, h), fill: fill, stroke: 0.8pt)
      rect((x + inset, 0), (x + inset * 2, h), fill: fill, stroke: 0.8pt)

      let y = x + inset * 2 
      rect((y, 0), (y + (w - inset * 2) * full, h), fill: fill, stroke: none)
      rect((x, 0), (x + w, h), stroke: 2pt)
    })  
  }

  let connect-blocks(from-idx, to-idx, label: none, offset: 0.6) = {
    let start-node = "block-" + str(from-idx) + ".south"
    let end-node = "block-" + str(to-idx) + ".south"

    line(
      start-node,
      (rel: (0, -offset), to: start-node),
      (rel: (0, -offset), to: end-node),
      end-node,
      mark: (end: ">", fill: black),
      stroke: 1.5pt
    )
  }

  connect-blocks(0, 2, offset: 1.5)
  connect-blocks(3, 1, offset: 1)
  connect-blocks(7, 4, offset: 1.5)
  connect-blocks(5, 6, offset: 1)
})


#speaker-note[
- Listen an typed union (enum mit daten)
- Jede union nutzt so viel speicher wie die größte variation benötigt. 
- Gute cache Lokalität gegen heap Alloctions und pointer
]

= Das Template besteht aus zwei Graphen 

#speaker-note[
- Bild der beiden Graphen 

- Einer der den Algorithmus darstellt 
- Eine Kante zu jedem Wert den es als Input nutzt (abhängt)

- Und einer der nur ein Knoten pro gecachten Knoten in dem Algorithmus enthält. 
] 

== Cache Graph

#figure(
  image("assets/cache_graph_2.svg", width: 90%),
)

== Templates vergleichen 

== Template auf alte Welt anwenden 

== Abhängigkeits-Werte finden 

#v(1cm)

#figure(
  image("assets/relative_schritte.svg", width: 100%),
) 

= Ausgabe Datenstruktur

= Neuberechnungszeit

== Overhead

#lq.diagram(
  lq.hviolin(
    (684, 701, 718, 662, 697, 672, 705, 675, 672, 692, 708, 645, 684, 702, 694, 719, 684, 702, 694, 719, 729),
    (694, 719, 684, 702, 694, 719, 729, 672, 692, 608, 645, 684, 682, 694, 719, 684, 702, 694, 719, 679),
    (180, 150, 174, 166, 132, 178, 184, 153, 162, 180, 200, 170, 177, 182, 160, 158),
    y: (3, 2, 1),
    extrema: false,
    boxplot: none,
    trim: false,
  ),
  title: [Höhlen-Beispiel (Kreuzungen: $500$)],
  xlabel: [Berechnungszeit (ms)],
  yaxis: (
    ticks: range(1, 4).zip(([direkt implementiert], [ohne Generator], [mein System])),
    subticks: none,
  ),
  width: 100%,
  height: 100%
)

#lq.diagram(
  lq.hviolin(
    (434, 546, 401, 489, 627, 598, 587, 577, 533, 490, 550, 460, 547, 541, 580, 543, 470, 569, 496, 523),
    (533, 490, 550, 460, 547, 541, 580, 490, 532, 567, 568, 450, 423, 589, 532,  598, 587, 577, 533, 542),
    (100, 112, 160, 98, 77, 102, 110, 90, 130),
    y: (3, 2, 1),
    extrema: false,
    boxplot: none,
    trim: false,
  ),
  title: [Insel-Beispiel (Bereich: $20000^2$m)],
  xlabel: [Berechnungszeit (ms)],
  yaxis: (
    ticks: range(1, 4).zip(([direkt implementiert], [ohne Generator], [mein System])),
    subticks: none,
  ),
  width: 100%,
  height: 100%
)

= Vorteile 

= Nachteile

= Mögliche Fragen

== KI

== Output Datenstruktur

