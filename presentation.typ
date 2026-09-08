#import "@preview/touying:0.7.4": *
#import themes.university: *
#import "@preview/cetz:0.5.2"
#import "@preview/fletcher:0.5.8" as fletcher: node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.6.0": *
#import cosmos.clouds: *
#import "@preview/lilaq:0.6.0" as lq
#import "layout/trimmed_image.typ": *
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
    //show-notes-on-second-screen: right,
  ),   
  config-info(
    title: [Bachelorarbeit],
    subtitle: [Minimale Neuberechnung Abhängigkeits-Graph basierter Regeln zur prozeduralen Welten-Generation],
    author: [Maarten Behn],
    date: [ 8.9.2026],
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


= Fragestellung

== Fragestellung

#place(
  left + horizon,
  image("assets/minecraft.jpg", width: 60%),
)

#place(left + top, dy: 1cm, [Generierte Welt])

#place(right + horizon, dy: -4cm, dx: -1cm, [Generationsschritte])

#place(
  right + horizon,
  dy: 2cm, dx: -2cm,
  image("assets/generations_schritte.svg", width: 25%),
)

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

= Related Work

== Prozedurale Generierung

#place(
  center + top, dx: 3cm,
  image("assets/layered_noise_2.png", width: 60%),
)

#place(
  left + bottom, dx: 1cm,
  image("assets/l_system_trees.png", width: 50%),
)

#place(
  right + bottom,
  box(width: 40%, trimmed-image("../assets/tarrain_diffusion.jpeg", trim: (left: 50%)))
)

#place(right + top, dx: -3cm, dy: 3.5cm, [Layered Noise])
#place(left + top, dx: 6cm, dy: 4cm, [L-Systems])
#place(right + bottom, dx: -2cm, dy: -6cm, [Tarrain Diffusion])

== Houdini & Blender 

#place(
  right + bottom,
  box(width: 60%, trimmed-image("../assets/blender.webp", trim: (right: 19%)))
)

#place(
  left + top,
  image("assets/houdini.jpg", width: 60%),
)

= Mein Lösungsansatz 


#speaker-note[
- Kurzes Video 
  - Zeigt wie man im Editor eine Welt erstellt und sich diese live im Renderer angezeigt wird.
]


#v(2cm)

#figure(
  image("assets/overview_diagramm.svg", width: 100%),
)

#speaker-note[
- Editor, Template, Generator
]

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

#figure(
  image("assets/template_changed.svg", width: 70%),
)

== Laufzeit-Unterscheid

#place(
  top + left,
  image("assets/laufzeit.svg", width: 60%),
)

#place(top + right, dy: 3cm, dx: 0cm, 
  align(left)[
  Cache-Fraktor: $c_f := a/c$ \
  Branch-Fraktor: $b_f$ \
  Neuberechnungsfaktor: $g_f$
  ])

#place(bottom + center, dy: -3cm, dx: 2cm, $O(n) = O((g_f c_f a)^(b_f)) = O(a^(b_f))$) 


== Abhängigkeits-Werte finden 

#v(1cm)

#figure(
  image("assets/relative_schritte.svg", width: 100%),
)

= Analyse

== Beispiele 

#place(image("assets/full.png", width: 80%))
#place(right + bottom, image("assets/cave.png", width: 70%))
#place(top + right, dy: 2cm, dx: 0cm, [Insel-Beispiel]) 
#place(bottom + left, dy: -2cm, dx: 1cm, [Höhlen-Beispiel]) 

== Neuberechnungszeit

#let place_marker(dx: relative, dy: relative, body) = place(alignment.top, dy: dy, dx: dx, 
  circle(
    {set align(center + horizon); body},
    fill: white, 
    stroke: black, 
    inset: 1pt,
  )
)

#lq.diagram(
  lq.hviolin(
    (15, 18, 16, 14, 18, 23, 20, 21, 17, 21),
    (11, 17, 16, 18, 22, 18, 14, 18, 17),
    (5, 4.5, 6.1, 5.4, 4, 5, 5.8, 4.6, 6),
    (4, 5, 4.9, 7.7, 4.6, 4.4, 9, 4.5, 5.3, 5.5),
    y: (4, 3, 2, 1),
    extrema: false,
    boxplot: none,
    trim: false,
  ),
  title: [Insel-Beispiel (Generationsbereich: $2000^2$m)],
  xlabel: [Neuberechnungszeit (ms)],
  ylabel: [Geänderte Knoten],
  yaxis: (
    ticks: range(1, 5).zip(([D], [C], [B], [A])),
    subticks: none,
  ),
  width: 100%,
  height: 100%
)

#place(right + bottom, dy: -2.5cm, box(
  fill: white,
  stroke: black,
  {
    image("./assets/full_graph.png", width: 50%)
    place_marker(dy: 2.3cm, dx: 0.3cm, [A])
    place_marker(dy: 0.6cm, dx: 5.3cm, [B])
    place_marker(dy: 2.6cm, dx: 4.7cm, [C])
    place_marker(dy: 0.6cm, dx: 12cm, [D])
  }))

#lq.diagram(
  lq.hviolin(
    (547, 541, 580, 543, 470, 569, 496, 523),
    (535, 527, 518, 544, 553, 512, 562, 470),
    (239, 243, 235, 228, 229, 232, 223, 221, 227, 234),
    (223, 227, 228, 224, 224, 224, 229, 237, 221),
    y: (4, 3, 2, 1),
    extrema: false,
    boxplot: none,
    trim: false,
  ),
  title: [Insel-Beispiel (Generationsbereich: $20000^2$m)],
  xlabel: [Neuberechnungszeit (ms)],
  ylabel: [Geänderter Knoten],
  yaxis: (
    ticks: range(1, 5).zip(([D], [C], [B], [A])),
    subticks: none,
  ),
  width: 100%,
  height: 100%
)

#place(right + bottom, dx: 0.3cm, dy: -2.5cm, box(
  fill: white,
  stroke: black,
  {
    image("./assets/full_graph.png", width: 50%)
    place_marker(dy: 2.3cm, dx: 0.3cm, [A])
    place_marker(dy: 0.6cm, dx: 5.3cm, [B])
    place_marker(dy: 2.6cm, dx: 4.7cm, [C])
    place_marker(dy: 0.6cm, dx: 12cm, [D])
  }))


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
  title: [Höhlen-Beispiel],
  xlabel: [Berechnungszeit (ms)],
  xaxis: (
    exponent: none,
  ),
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
  title: [Insel-Beispiel],
  xlabel: [Berechnungszeit (ms)],
  xaxis: (
    exponent: none,
  ),
  yaxis: (
    ticks: range(1, 4).zip(([direkt implementiert], [ohne Generator], [mein System])),
    subticks: none,
  ),
  width: 100%,
  height: 100%
)

== Future Work

#v(1cm)

- Skalierung von sehr große Welten 
#v(0.5cm)

- Integration in bestehende Game Engines 
#v(0.5cm)
- Parallelisierung der Generierung
#v(0.5cm)
- Automatische Cache-Optimierung
#v(0.5cm)
- Kreis-Abhängigkeiten & Leere Lösungen
#v(0.5cm)
- Experten-Meinungen zur Bewertung der Nützlichkeit

= Beispiel Videos

= Vielen Dank. \ Fragen?

#show: appendix


== Graphen im Speicher darstellen 

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

== Template bauen

```rust
fn make_position(child_node: &EditorNode, 
                 in_index: usize) -> PosIndex {

let node = child_node.inputs[in_index];
let value = match &node.data_type {
  EditorNodeType::Add => {
    let a = make_position(node, 0, ...);
    let b = make_position(node, 1, ...);
    
    TemplateValue::Position(PositionValue::Add((a, b)))
  }, 
  EditorNodeType::Sub => ...
}


```

== Template errechnen

#v(1cm)
```rust
fn calc_position(index: PosIndex) -> SmallVec<Vec3> {
  
  match values[index] {
    PositionValue::Add((a_index, b_index)) => {
      let a = calc_position(a_index);
      let b = calc_position(b_index);

      return a.cartesian_product(b)
               .map(|(a_v, b_v)| a_v + b_v);
    },
    PositionValue::Sub => ...
}
```

== Bilder-Quellen

- Minecraft: #text(size: 0.7em, [eigener Screenshot])
- Layered Noise: #text(size: 0.7em, [https://velog.velcdn.com/images/suhan0304/post/5decd2a9-bbfa-43fc-9cb1-b17b6c4944e5/image.png])
- Blender: #text(size: 0.7em, [https://www.reddit.com/media?url=https%3A%2F%2Fpreview.redd.it%2Fneed-some-clouds-geometry-nodes-v0-vt96ocz4z7w91.jpg%3Fauto%3Dwebp%26s%3D5eb3063e5dfc3694d7b99f80a96bdbfc42583c8c])
- Houdini: #text(size: 0.7em, [https://i.pinimg.com/originals/45/8c/29/458c298b4ee094cf161f8e32f88d5505.jpg])
- Tarrain diffusion: #text(size: 0.7em, [https://github.com/xandergos/terrain-diffusion])
Zugegriffen am: 7.9.2026 19 Uhr


