#import "./layout/ba.typ": *

#set document(title: [
  A Fluid Dynamic Model for
  Glacier Flow
])

#show: scrartcl.with(
  title: "Lazy prozedurale Weltgenerierung",
  authors: (
    (
      name: "Maarten Behn",
      email: "maarten.behn@uni-bremen.de"
    )
  ),
  supervisors: ("Name 1", "Name 2", "Name 3")
)

= Einleitung

#include "./introduktion/goal.typ"

#include "./introduktion/strukture.typ"

= Stand der Technik

== Prozedurale Generation <prozedurale_generation>

#include "./state_of_art/noise.typ"

#include "./state_of_art/model_synthesis.typ" 

#include "./state_of_art/graph_grammers.typ"

#include "./state_of_art/ai_based_procedual_generation.typ"

#include "./state_of_art/lazy_recompute.typ"

= Theoretische Grundlagen 

#include "./theory/lazy_loading.typ"

- Graph grammers
- Rust features
- Stabiele Listen
- L-Systems
- CSG
- Geometry Nodes


#include "./theory/dependencies.typ"

= Meine Arbeit

#include "./idea.typ"

#include "./framework.typ"

#include "./why_rust.typ"

#include "./implementation.typ"

== Zeigen dass es Funktioniert 
- minimal änderungen führen zu minimaler arbeit.

== Nutzungs Beispiele
- Welt editor 
- Infitie World Generation
- LOD systems 

== Visulation 

=== Direkt CSG Rendering 

=== Voxel sampeling 
#todo("Sollte ich auf die Implementation und Datenstruktur ein gehen? Warscheinlich nicht.")

- Minimale Änderungen im CSG führen zu nur minimaler Neuerrechnung des Voxel DAGs 

=== Meshing 

- Minimale Änderungen im CSG führen zu nur minimaler Neuerrechnung des Meshes


#include "./evaluation.typ" 

#include "./future_work.typ"

#bibliography("citations.bib")


#idea("Text")
#todo("Text")
#itodo("Text")
#question("Text")

#numberedBlock($
  A = pi
$)

