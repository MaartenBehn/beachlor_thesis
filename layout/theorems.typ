#import "@preview/ctheorems:1.1.3": thmbox, thmenv, thmproof, thmrules

#let thm_inset = (left: 1em)

#let theorem = thmbox(
  "theorem",
  "Satz",
  base: "heading",
  base_level: 1,
  inset: thm_inset,
  bodyfmt: emph,
)

#let proposition = thmbox(
  "theorem",
  "Proposition",
  base_level: 1,
  inset: thm_inset,
  bodyfmt: emph,
)

#let lemma = thmbox(
  "theorem",
  "Lemma",
  base_level: 1,
  inset: thm_inset,
  bodyfmt: emph,
)

#let corollary = thmbox(
  "theorem",
  "Korollar",
  base_level: 1,
  inset: thm_inset,
  bodyfmt: emph,
)

#let definition = thmbox(
  "theorem",
  "Definition",
  base_level: 1,
  inset: thm_inset,
)

#let example = thmbox(
  "theorem",
  "Beispiel",
  base_level: 1,
  inset: thm_inset,
)

#let remark = thmbox(
  "theorem",
  "Anmerkung",
  base_level: 1,
  inset: thm_inset,
)

#let convention = thmbox(
  "theorem",
  "Konvention",
  base_level: 1,
  inset: thm_inset,
)

#let proof = thmproof(
  "proof",
  "Beweis",
  inset: thm_inset,
)
