// ============================================================
// Testero — Modello Dati
// ============================================================

#let navy = rgb("#102a43")
#let teal = rgb("#14b8a6")
#let teal-bg = rgb("#e6fcfa")
#let teal-dark = rgb("#0e7c7b")
#let muted = rgb("#6b7a89")
#let border = rgb("#e1e6ec")
#let bg-light = rgb("#f8fafc")
#let amber = rgb("#f59e0b")
#let amber-bg = rgb("#fef3e2")

#set document(title: "Testero — Modello Dati")
#set page(
  paper: "a4",
  margin: (x: 2.4cm, y: 2.4cm),
  header: context {
    if counter(page).get().first() > 2 {
      set text(size: 8pt, fill: muted, font: "Inter")
      [Testero #h(1fr) Modello Dati]
      v(2pt)
      line(length: 100%, stroke: 0.3pt + border)
    }
  },
  footer: context {
    if counter(page).get().first() > 1 {
      line(length: 100%, stroke: 0.3pt + border)
      v(3pt)
      set text(size: 8pt, fill: muted, font: "Inter")
      h(1fr)
      counter(page).display()
      h(1fr)
    }
  },
)
#set text(font: "Inter", size: 10.5pt, lang: "it", fill: rgb("#334e68"))
#set par(justify: true, leading: 0.72em)
#set list(indent: 0.8em)

#show heading.where(level: 1): it => {
  v(0.2em)
  text(size: 26pt, weight: "bold", fill: navy, font: "Inter", it)
  v(0.15em)
}
#show heading.where(level: 2): it => {
  v(0.5em)
  text(size: 15pt, weight: "bold", fill: navy, font: "Inter", it)
  v(0.15em)
}
#show heading.where(level: 3): it => {
  v(0.35em)
  text(size: 11.5pt, weight: "bold", fill: navy, font: "Inter", it)
  v(0.1em)
}

#show raw.where(block: false): it => {
  box(
    fill: rgb("#f0f4f8"),
    inset: (x: 3.5pt, y: 1.5pt),
    radius: 3pt,
    text(size: 9pt, font: "JetBrains Mono", fill: navy, it),
  )
}

#show raw.where(block: true): it => {
  block(
    fill: rgb("#f0f4f8"),
    inset: 12pt,
    radius: 5pt,
    width: 100%,
    text(size: 8.5pt, font: "JetBrains Mono", fill: navy, it),
  )
}

#set table(stroke: 0.4pt + border, inset: 7pt)

// Helpers
#let schema-table(..rows) = {
  let cells = rows.pos()
  table(
    columns: (auto, auto, 1fr),
    fill: (x, y) => if y == 0 { navy } else if calc.odd(y) { bg-light } else { white },
    table.cell(fill: navy)[#text(fill: white, weight: "bold", size: 9pt)[Colonna]],
    table.cell(fill: navy)[#text(fill: white, weight: "bold", size: 9pt)[Tipo]],
    table.cell(fill: navy)[#text(fill: white, weight: "bold", size: 9pt)[Descrizione]],
    ..cells,
  )
}

#let data-table(headers, ..rows) = {
  let h = headers
  let r = rows.pos()
  table(
    columns: h.len(),
    fill: (x, y) => if y == 0 { teal-dark } else if calc.odd(y) { teal-bg.lighten(60%) } else { white },
    ..h.map(hh => table.cell(fill: teal-dark)[#text(fill: white, weight: "bold", size: 8.5pt)[#hh]]),
    ..r,
  )
}

#let nota(body) = {
  block(
    fill: teal-bg,
    inset: 11pt,
    radius: 5pt,
    width: 100%,
    stroke: 0.4pt + teal.lighten(60%),
  )[
    #set text(size: 9.5pt, fill: teal-dark)
    #text(weight: "bold")[Nota ] #body
  ]
}

#let entity-header(name, table-name, connections) = {
  block(
    fill: bg-light,
    inset: (x: 16pt, y: 12pt),
    radius: 6pt,
    width: 100%,
    stroke: 0.4pt + border,
  )[
    #set text(size: 9.5pt)
    #grid(
      columns: (auto, 1fr),
      gutter: 8pt,
      [#text(weight: "bold", fill: muted)[Tabella SQL]],
      [#raw(table-name)],
      [#text(weight: "bold", fill: muted)[Collegata a]],
      [#connections],
    )
  ]
}

// ============================================================
// COVER
// ============================================================
#page(header: none, footer: none, margin: 0pt)[
  #block(width: 100%, height: 100%, fill: navy)[
    #align(center + horizon)[
      #block(width: 75%)[
        #line(length: 40%, stroke: 2pt + teal)
        #v(20pt)
        #text(size: 44pt, weight: "bold", fill: white, font: "Inter")[Testero]
        #v(6pt)
        #text(size: 18pt, fill: rgb("#a0c0cf"), font: "Inter")[Modello Dati]
        #v(28pt)
        #line(length: 40%, stroke: 2pt + teal)
        #v(16pt)
        #text(size: 10pt, fill: muted, font: "Inter")[
          Luglio 2026
        ]
      ]
    ]
  ]
]

// ============================================================
// TOC
// ============================================================
#page(header: none)[
  #text(size: 22pt, weight: "bold", fill: navy, font: "Inter")[Indice]
  #v(0.8em)
  #outline(title: none, indent: 1.5em, depth: 2)
]

// ============================================================
// INTRO
// ============================================================

= Panoramica

Le entità del sistema sono organizzate in 4 aree:

+ *Utenti e ruoli* — chi usa il sistema
+ *Assessment* — come è strutturato un test
+ *Pubblicazione* — il meccanismo di snapshot
+ *Somministrazione* — cosa succede quando lo studente svolge il test

#pagebreak()

// ============================================================
// ASSESSMENT TEMPLATE
// ============================================================

= Assessment Template

#entity-header(
  "Assessment Template",
  "assessment_template",
  [`question`, `assessment_subject`, `assessment_snapshot`],
)

#v(8pt)

L'Assessment Template è il *template modificabile di un assessment* — la bozza che il docente prepara prima di pubblicarla. Contiene le regole della verifica (durata, punteggio, quante domande estrarre, se mescolare le risposte) ma non le domande stesse, che stanno nell'entità Question.

== Tipi di assessment

- *CERT_SIMULATION* — simulazione di certificazione esterna della scuola. Lo studente si esercita su domande pensate per un esame di certificazione specifico. Timer attivo, esito con soglia di superamento. Ripetibile.
- *TRAINING* — pratica libera per argomento. Lo studente sceglie cosa esercitare, nessun timer, nessun esito formale.
- *EXAM* — prova formale del docente, in aula o a casa. Checkpoint periodico con timer, esito. Sta al docente deciderne la valenza.

== Il meccanismo template → snapshot

Il docente può modificare questo record finché non lo pubblica. Al momento della pubblicazione il sistema crea una *copia congelata* chiamata Assessment Snapshot.

Immagina una fotocopia: il template è il foglio originale che il docente può correggere e riscrivere quante volte vuole. Quando decide che è pronto, il sistema "fotocopia" tutto — domande, opzioni, punteggi — in uno snapshot immutabile. Gli studenti svolgono la verifica sulla fotocopia, non sull'originale. Se il docente modifica l'originale dopo e ripubblica, viene creata una nuova versione dello snapshot (v2, v3...) senza toccare le verifiche già fatte sulla versione precedente.

== Il pool di domande

Il docente inserisce N domande nell'assessment (es. 50). Il campo `questions_per_assessment` dice quante di quelle 50 vengono pescate a caso per ogni studente (es. 20). Così ogni studente riceve un sottoinsieme diverso — meno possibilità di copiare. Se il docente vuole che tutti facciano le stesse identiche domande, gli basta impostare `questions_per_assessment` uguale al numero totale di domande inserite.

#pagebreak()

== Colonne

#schema-table(
  [`id`], [UUID], [PK],
  [`title`], [VARCHAR], [NN — titolo. Es: "Reti di Calcolatori"],
  [`timer_minutes`], [INT], [NN — durata in minuti. 0 = senza timer],
  [`questions_per_assessment`], [INT], [NN — quante domande estrarre dal pool],
  [`pts_correct`], [DECIMAL], [NN — punti per risposta corretta. Es: 1.00],
  [`pts_wrong`], [DECIMAL], [NN — punti per risposta errata. Es: -0.25],
  [`pts_unanswered`], [DECIMAL], [NN, default 0 — punti per risposta non data],
  [`difficulty`], [VARCHAR(20)], [BEGINNER | INTERMEDIATE | ADVANCED | EXPERT],
  [`type`], [VARCHAR(20)], [NN — CERT_SIMULATION | TRAINING | EXAM],
  [`passing_score`], [DECIMAL], [Soglia di sufficienza. Nullable],
  [`max_attempts`], [INT], [Tentativi massimi. NULL = illimitato],
  [`shuffle_questions`], [BOOLEAN], [NN, default true — mescola le domande],
  [`shuffle_options`], [BOOLEAN], [NN, default true — mescola le opzioni],
  [`assessment_description`], [TEXT], [Descrizione per lo studente. Nullable],
)

== Esempio

Un docente crea una simulazione di certificazione su reti: 5 domande nel pool, ne estrae 3 per studente, 30 minuti, +1.00/−0.25/0 punti, soglia 2.00.

#data-table(
  ("id", "title", "type", "difficulty"),
  [`a-reti`], [Reti di Calcolatori], [CERT_SIMULATION], [INTERMEDIATE],
)

Timer 30 min, 3 domande per assessment. Punteggio: +1.00 corretta / −0.25 errata / 0 non risposta. Soglia 2.00. Shuffle domande e opzioni attivi. Tentativi illimitati.

== Note

- Quando `shuffle_questions = false` e `shuffle_options = false`, l'assessment è identico per tutti — utile per un EXAM in aula.
- `max_attempts = 1` rende l'assessment one-shot (tipico per EXAM). `NULL` = illimitato (tipico per TRAINING e CERT_SIMULATION).
- La finestra di disponibilità (quando gli studenti possono accedere) non è su questa tabella: sta sulla tabella `class_test`, che assegna uno snapshot a una classe. Questo permette finestre diverse per classi diverse.
