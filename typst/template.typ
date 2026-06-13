// ============================================================
// Testero — Template Documentazione
// ============================================================

// Metadata
#let project-title = "Testero"
#let project-subtitle = "Documentazione Funzionale e Tecnica"
#let project-version = "v0.1.0"
#let project-date = "Giugno 2026"
#let project-team = "Testero Team"

// Colors
#let color-primary = rgb("#1a1a2e")
#let color-accent = rgb("#e94560")
#let color-heading = rgb("#16213e")
#let color-subheading = rgb("#0f3460")
#let color-muted = rgb("#808090")
#let color-bg-light = luma(248)
#let color-border = luma(200)

// ============================================================
// Document settings
// ============================================================
#set document(
  title: project-title + " — " + project-subtitle,
  author: project-team,
)
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  header: context {
    if counter(page).get().first() > 2 {
      set text(size: 9pt, fill: luma(140))
      [#project-title — #project-subtitle #h(1fr) #project-version]
      v(2pt)
      line(length: 100%, stroke: 0.4pt + color-border)
    }
  },
  footer: context {
    if counter(page).get().first() > 1 {
      line(length: 100%, stroke: 0.4pt + color-border)
      v(4pt)
      set text(size: 9pt, fill: luma(140))
      h(1fr)
      counter(page).display()
      h(1fr)
    }
  },
)
#set text(font: "Helvetica", size: 11pt, lang: "it")
#set heading(numbering: "1.1")
#set par(justify: true, leading: 0.65em)
#set list(indent: 1em)
#set enum(indent: 1em)

// ============================================================
// Heading styles
// ============================================================
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.5em)
  text(size: 22pt, weight: "bold", fill: color-primary, it)
  v(0.5em)
}
#show heading.where(level: 2): it => {
  v(0.8em)
  text(size: 15pt, weight: "bold", fill: color-heading, it)
  v(0.3em)
}
#show heading.where(level: 3): it => {
  v(0.5em)
  text(size: 12pt, weight: "bold", fill: color-subheading, it)
  v(0.2em)
}
#show heading.where(level: 4): it => {
  v(0.4em)
  text(size: 11pt, weight: "bold", fill: color-subheading, it)
  v(0.15em)
}

// ============================================================
// Code blocks
// ============================================================
#show raw.where(block: true): it => {
  set text(size: 9pt)
  block(
    fill: color-bg-light,
    inset: 12pt,
    radius: 4pt,
    width: 100%,
    it,
  )
}
#show raw.where(block: false): it => {
  box(
    fill: luma(235),
    inset: (x: 4pt, y: 2pt),
    radius: 2pt,
    text(size: 10pt, it),
  )
}

// ============================================================
// Tables
// ============================================================
#set table(
  stroke: 0.5pt + color-border,
  inset: 8pt,
  fill: (x, y) => if y == 0 { color-primary } else if calc.odd(y) { luma(248) } else { white },
)
#show table.cell.where(y: 0): set text(fill: white, weight: "bold")
#show table: set text(size: 10pt)
#show table.cell: set par(justify: false)
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: table): set align(center)


// ============================================================
// Pandoc compatibility
// ============================================================
#let horizontalrule = line(length: 100%, stroke: 0.5pt + luma(200))

// ============================================================
// Cover page
// ============================================================
#page(
  header: none,
  footer: none,
  margin: 0pt,
)[
  #block(
    width: 100%,
    height: 100%,
    fill: color-primary,
  )[
    #align(center + horizon)[
      #block(width: 80%)[
        #line(length: 60%, stroke: 3pt + color-accent)
        #v(30pt)
        #text(size: 46pt, weight: "bold", fill: white)[#project-title]
        #v(14pt)
        #text(size: 18pt, fill: rgb("#a0a0c0"))[
          #project-subtitle
        ]
        #v(40pt)
        #line(length: 60%, stroke: 3pt + color-accent)
        #v(30pt)
        #text(size: 13pt, fill: color-muted)[
          #project-team — #project-date — #project-version
        ]
      ]
    ]
  ]
]

// ============================================================
// Table of contents
// ============================================================
#page(header: none)[
  #text(size: 22pt, weight: "bold", fill: color-primary)[Indice]
  #v(1em)
  #outline(title: none, indent: 1.5em, depth: 3)
]
