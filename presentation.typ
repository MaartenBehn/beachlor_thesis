#import "@preview/touying:0.7.4": *
#import themes.university: *
#import "@preview/cetz:0.5.2"
#import "@preview/fletcher:0.5.8" as fletcher: node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.6.0": *
#import cosmos.clouds: *
#show: show-theorion

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#show: university-theme.with(
  aspect-ratio: "16-9",
  // align: horizon,
  // config-common(handout: true),
  config-common(frozen-counters: (theorem-counter,)),  // freeze theorem counter for animation
  config-info(
    title: [Beachlorarbeit],
    subtitle: [Minimale Neuberechnung Abhängigkeits-Graph basierter Regeln zur prozeduralen Welten-Generation],
    author: [Maarten Behn],
    date: [ 08.09.2026],
    institution: [CGVR Universität Bremen],
    logo: image("./layout/UHB_Logo_4c.svg", height: 18.5mm),
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()


= Problemstellung

= Prozedurale Generation 

= Kern Idee 

== Algorithmus als Funktion

== Funktion als Template Graph speichern 

== Das aktuelle Template mit dem neuen vergleichen

= Implementierung

== Graphen im Speicher darstellen 

== Template aus Editor erstellen 

== Templates vergleichen 

== Template auf alte Welt anwenden 

== Welt anpassen

= Ausgabe Datenstruktur

= Leitungs Erkenntnisse 

= Vorteile 

= Nachteile


= Mögliche Fragen

== KI

