#let note(
  note_title: "Notiz",
  note_color: rgb("#abbec6"),
  note_content
) = align(center)[
  #block(
    width: 80%,
    fill: note_color,
    radius: 3pt,
    inset: 5pt
  )[
    *#note_title:*\
    #align(left)[
      #note_content
    ]
  ]
]

#let idea(idea_content) = note(
  note_title: "Idee",
  note_color: rgb("#efdba0")
)[#idea_content]

#let todo(todo_content) = note(
  note_title: "ToDo",
  note_color: rgb("#ff5f5f")
)[#todo_content]

#let question(question_content) = note(
  note_title: "Frage",
  note_color: rgb("#87d39d")
)[#question_content]

#let itodo(todo_content) = text[#highlight(
  fill: rgb("#ff5f5f"),
)[*TODO:* #todo_content]]