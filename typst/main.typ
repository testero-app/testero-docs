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

= Introduzione
<introduzione>
== Cos'è Testero
<cosè-testero>
Testero è una piattaforma open source per la somministrazione di test e verifiche in ambito didattico, pensata per scuole private, enti di formazione, insegnanti e formatori.

Il problema che risolve è semplice: sostituire il ciclo manuale #emph[carta → correzione → trascrizione] con un flusso di lavoro digitale integrato. Il docente prepara l'assessment, lo pubblica per una classe, e gli studenti lo svolgono online con timer, salvataggio automatico delle risposte e correzione immediata delle domande a risposta multipla.

Il progetto è rilasciato sotto licenza #strong[GNU Affero General Public License v3.0] (AGPL-3.0). Il codice sorgente è pubblico e le contribuzioni sono benvenute seguendo il modello DCO (Developer Certificate of Origin).

== Versione Corrente
<versione-corrente>
#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Componente], [Versione],),
    table.hline(),
    [#strong[Backend]], [v1.9.1],
    [#strong[Frontend]], [v1.3.0],
  )]
  , kind: table
  )

Ultimo aggiornamento: 13 giugno 2026.

== Repositories
<repositories>
#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Repository], [Descrizione],),
    table.hline(),
    [#strong[testero-backend]], [API REST e logica di business],
    [#strong[testero-web]], [Interfaccia utente per studenti],
    [#strong[testero-docs]], [Questa documentazione],
  )]
  , kind: table
  )

= Stack Tecnologico
<stack-tecnologico>
== Backend
<backend>
#figure(
  align(center)[#table(
    columns: auto,
    align: (auto,auto,auto,),
    table.header([Componente], [Tecnologia], [Descrizione],),
    table.hline(),
    [Framework], [Spring Boot], [Application framework MVC],
    [Linguaggio], [Java 21], [LTS],
    [Database], [PostgreSQL], [Qualsiasi istanza PostgreSQL compatibile],
    [Migrazioni], [Liquibase], [Versionamento schema, eseguite all'avvio],
    [Sicurezza], [Spring Security + JWT], [Autenticazione stateless],
    [Build], [Maven], [Wrapper incluso (`./mvnw`)],
    [Logging], [SLF4J + Logback], [Structured JSON (prod), console (dev), request correlation via MDC],
    [Quality], [Checkstyle, SpotBugs, JaCoCo], [CI obbligatoria],
    [Test], [JUnit 5 + Mockito], [Unit + integration],
    [API Docs], [springdoc-openapi + Swagger UI], [Documentazione interattiva, solo dev (disabilitata in prod)],
  )]
  , kind: table
  )

== Frontend
<frontend>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Componente], [Tecnologia], [Descrizione],),
    table.hline(),
    [Framework], [Next.js], [SSR/SPA],
    [UI Library], [React], [],
    [Linguaggio], [TypeScript + JavaScript], [],
    [State], [React Context + useReducer], [Stato centralizzato],
    [Quality], [ESLint + TypeScript strict], [CI obbligatoria],
  )]
  , kind: table
  )

== Infrastruttura
<infrastruttura>
#figure(
  align(center)[#table(
    columns: auto,
    align: (auto,auto,auto,),
    table.header([Componente], [Tecnologia], [Descrizione],),
    table.hline(),
    [CI/CD], [GitHub Actions], [Build, test, deploy automatizzati],
    [Versioning], [Release Please], [Changelog e tag automatici da Conventional Commits],
    [Database dev], [Docker Compose], [PostgreSQL locale per sviluppo],
    [Licenza], [AGPL-3.0], [Su tutti i repository],
  )]
  , kind: table
  )

= Architettura Generale
<architettura-generale>
Il sistema è composto da un #strong[frontend] (applicazione web single-page in Next.js) e un #strong[backend] (API REST stateless in Spring Boot), collegati tramite chiamate HTTP con autenticazione JWT. Il database è PostgreSQL.

Il backend segue il pattern #strong[MVC con Service Layer]: i Controller gestiscono le richieste HTTP, delegano la logica ai Service, che a loro volta accedono al database tramite i Repository (Spring Data JPA). Un sistema di #strong[eventi e scheduler] gestisce le operazioni asincrone come la chiusura automatica delle somministrazioni allo scadere del timer.

Il frontend è un'interfaccia rivolta agli studenti: permette di autenticarsi, selezionare un assessment, svolgere la verifica con timer e navigazione tra domande, consegnare e consultare i risultati. Lo stato dell'applicazione è gestito centralmente tramite React Context.

Ogni richiesta HTTP è tracciata da un #strong[correlation ID] (`X-Request-Id`), propagato tramite SLF4J MDC e incluso in tutti i log. In produzione i log sono emessi in formato JSON strutturato (su console e file rotante con retention di 15 giorni); in sviluppo il formato resta leggibile in chiaro.

= Modello Dati
<modello-dati>
== Diagramma ER
<diagramma-er>
Il diagramma ER completo è disponibile in `docs/diagrams/data_model_v4.png` e `docs/diagrams/data_model_v4_relational.png`.

== Entità Principali
<entità-principali>
=== Utenti e Ruoli
<utenti-e-ruoli>
#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Tabella], [Descrizione],),
    table.hline(),
    [`app_user`], [Account utente],
    [`app_role`], [Definizione ruolo],
    [`app_user_role`], [Associazione utente-ruolo (M:N)],
    [`teacher_profile`], [Profilo docente],
    [`student_profile`], [Profilo studente, associato a una classe],
    [`user_class`], [Classe o sezione],
    [`teacher_class`], [Associazione docente-classe (M:N)],
  )]
  , kind: table
  )

=== Assessment (mutabili)
<assessment-mutabili>
#figure(
  align(center)[#table(
    columns: auto,
    align: (auto,auto,),
    table.header([Tabella], [Descrizione],),
    table.hline(),
    [`assessment`], [Template dell'assessment con titolo, data, timer, difficoltà e regole di punteggio],
    [`question`], [Domanda con tipo, testo, eventuale snippet di codice, spiegazione e posizione],
    [`option`], [Opzione di risposta con testo, correttezza, flag fallback e posizione],
    [`subject`], [Materia o argomento],
    [`class_assessment`], [Pubblicazione di un assessment per una classe],
  )]
  , kind: table
  )

=== Snapshot (immutabili)
<snapshot-immutabili>
#figure(
  align(center)[#table(
    columns: auto,
    align: (auto,auto,),
    table.header([Tabella], [Descrizione],),
    table.hline(),
    [`assessment_snapshot`], [Copia congelata dell'assessment al momento della pubblicazione (include difficoltà)],
    [`question_snapshot`], [Copia congelata della domanda (include spiegazione)],
    [`option_snapshot`], [Copia congelata dell'opzione (include flag fallback)],
  )]
  , kind: table
  )

=== Submission
<submission>
#figure(
  align(center)[#table(
    columns: auto,
    align: (auto,auto,),
    table.header([Tabella], [Descrizione],),
    table.hline(),
    [`submission`], [Record della submission con stato, timestamp e punteggio],
    [`user_answer`], [Singola risposta dello studente],
    [`user_answer_selected_option`], [Opzioni selezionate dallo studente per le domande a scelta multipla],
  )]
  , kind: table
  )

== Livelli di Difficoltà
<livelli-di-difficoltà>
Il campo `difficulty` su `assessment` e `assessment_snapshot` usa un enum con 4 livelli:

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Valore], [Significato],),
    table.hline(),
    [`BEGINNER`], [Concetti introduttivi],
    [`INTERMEDIATE`], [Conoscenze consolidate],
    [`ADVANCED`], [Padronanza approfondita],
    [`EXPERT`], [Specializzazione avanzata],
  )]
  , kind: table
  )

Il campo è nullable: gli assessment creati prima dell'introduzione del campo non hanno un livello assegnato.

== Spiegazione della Risposta (explanation)
<spiegazione-della-risposta-explanation>
Il campo `explanation` su `question` e `question_snapshot` contiene la spiegazione didattica della risposta corretta. Viene mostrato nella schermata di review post-consegna ("Perché") ma #strong[mai] durante lo svolgimento del test.

- Tipo: `TEXT`, nullable
- Visibilità API: esposto solo nel `SubmissionReviewResponse`, escluso da `AssessmentQuestionsResponse`

== Flag Fallback (is\_fallback)
<flag-fallback-is_fallback>
Il campo `is_fallback` su `option` e `option_snapshot` identifica le opzioni di tipo "Nessuna delle precedenti". Queste opzioni vengono sempre posizionate in fondo durante lo shuffle delle risposte, indipendentemente dalla randomizzazione.

== Ciclo di Vita dell'Assessment
<ciclo-di-vita-dellassessment>
Un assessment attraversa diverse fasi dalla creazione alla somministrazione. Non esiste un campo di stato esplicito: il ciclo di vita è determinato dalla presenza di snapshot e dalle date di attivazione.

```
                                    per ogni classe
  ┌──────────┐    ┌─────────────┐    ┌───────────┐    ┌──────────────┐
  │  Creato   │───►│ Pubblicato  │───►│  Attivo   │───►│ Disattivato  │
  │ (bozza)   │    │ (snapshot)  │    │(per classe)│   │ (per classe) │
  └──────────┘    └─────────────┘    └───────────┘    └──────────────┘
       │                                    │
       │ modificabile                       │ gli studenti possono
       │ dal docente                        │ svolgere la verifica
       ▼                                    ▼
  nuova pubblicazione             somministrazioni in corso
  = nuovo snapshot                    fanno riferimento
  (versione successiva)              allo snapshot attivo
```

#figure(
  align(center)[#table(
    columns: auto,
    align: (auto,auto,),
    table.header([Fase], [Descrizione],),
    table.hline(),
    [Creato], [L'assessment esiste come bozza modificabile dal docente],
    [Pubblicato], [È stato generato uno snapshot immutabile. Se il contenuto non è cambiato rispetto alla pubblicazione precedente, lo snapshot viene riutilizzato],
    [Attivo], [Lo snapshot è stato associato a una classe (data di attivazione valorizzata). Gli studenti della classe possono svolgere la verifica],
    [Disattivato], [L'assessment è stato rimosso dalla classe (data di disattivazione valorizzata). Gli studenti non lo vedono più, ma le somministrazioni già completate restano nello storico],
  )]
  , kind: table
  )

Il docente può modificare un assessment e ripubblicarlo in qualsiasi momento: questo genera una nuova versione dello snapshot senza impattare le somministrazioni già in corso o completate sulla versione precedente.

== Stati della Submission
<stati-della-submission>
```
            ┌─────────────┐
   start    │ IN_PROGRESS │
──────────► │             │
            └──────┬──────┘
                   │
         ┌────────┴────────┐
         │                 │
   consegna manuale   scadenza timer
         │                 │
         ▼                 ▼
 ┌───────────┐     ┌─────────────┐
 │ SUBMITTED │     │ AUTO_CLOSED │
 └───────────┘     └─────────────┘
```

#figure(
  align(center)[#table(
    columns: auto,
    align: (auto,auto,),
    table.header([Stato], [Significato],),
    table.hline(),
    [IN\_PROGRESS], [Lo studente ha iniziato ma non ha ancora consegnato],
    [SUBMITTED], [Lo studente ha consegnato manualmente],
    [AUTO\_CLOSED], [Il sistema ha chiuso la submission allo scadere del timer],
  )]
  , kind: table
  )

= Funzionalità
<funzionalità>
Questa sezione documenta le funzionalità implementate nella piattaforma. Per ogni funzionalità è descritta la logica di alto livello e il flusso operativo dettagliato.

== Autenticazione (UC 01.00)
<autenticazione-uc-01.00>
Gli utenti accedono al sistema tramite username (o email) e password. Il sistema supporta tre profili: studente, docente e amministratore. Lo studente è associato a una classe, il docente può gestire più classi.

=== Flusso
<flusso>
+ L'utente inserisce username o email e password nel form di login
+ Il sistema verifica le credenziali
+ Se valide, l'utente viene autenticato e reindirizzato alla selezione assessment
+ Se l'utente è uno studente, il sistema recupera anche la classe di appartenenza

In caso di credenziali errate, il sistema mostra un messaggio di errore e l'utente può riprovare. Dopo un periodo di inattività la sessione scade e l'utente deve autenticarsi nuovamente.

== Somministrazione Assessment (UC 20.00)
<somministrazione-assessment-uc-20.00>
Il cuore della piattaforma. Lo studente seleziona un assessment disponibile per la propria classe, lo avvia e risponde alle domande entro un tempo limite configurabile dal docente. Le domande supportate sono a scelta multipla (con opzione "Nessuna delle precedenti" e campo motivazione) e a risposta aperta.

=== Flusso --- Avvio
<flusso-avvio>
+ Lo studente visualizza la lista degli assessment disponibili per la propria classe
+ Seleziona un assessment e visualizza le informazioni: titolo, durata, numero di domande, regole di punteggio
+ Preme "Inizia" e conferma
+ Il sistema crea una sessione di somministrazione e avvia il timer
+ Lo studente viene portato alla prima domanda

Se lo studente ha già una sessione in corso per lo stesso assessment (es. dopo un refresh della pagina), il sistema restituisce la sessione esistente e lo studente riprende da dove aveva lasciato.

=== Flusso --- Risposta a Domande (UC 20.01)
<flusso-risposta-a-domande-uc-20.01>
+ Il sistema mostra una domanda alla volta con una sidebar di navigazione
+ Lo studente legge la domanda e seleziona o scrive la risposta
+ Quando naviga a un'altra domanda (tramite pulsanti, sidebar o frecce da tastiera), la risposta corrente viene salvata automaticamente in background
+ Lo studente può navigare liberamente tra le domande, modificando le risposte in qualsiasi momento
+ La sidebar mostra in tempo reale: domanda corrente, risposte date, domande vuote e progresso percentuale

Le domande a #strong[scelta multipla] presentano opzioni con lettere (A, B, C, D, E). Se presente l'opzione "Nessuna delle precedenti", selezionandola compare un campo per la motivazione. Le domande a #strong[risposta aperta] offrono un'area di testo libero.

Il salvataggio in background è silenzioso: se fallisce per un problema di rete, lo studente non viene interrotto. Le risposte sono mantenute localmente e vengono tutte reinviate alla consegna finale.

== Consegna e Chiusura Automatica (UC 20.02)
<consegna-e-chiusura-automatica-uc-20.02>
La somministrazione si conclude in due modi: consegna volontaria da parte dello studente, oppure chiusura automatica allo scadere del timer.

=== Flusso --- Consegna Manuale
<flusso-consegna-manuale>
+ Lo studente preme "Consegna test"
+ Il sistema chiede se vuole rivedere le risposte
+ Se sì, viene mostrato un riepilogo completo di tutte le risposte
+ Dal riepilogo, lo studente può tornare al test oppure confermare la consegna
+ Alla conferma, il sistema chiude la somministrazione e calcola il punteggio
+ Lo studente viene portato alla pagina dei risultati

=== Flusso --- Chiusura Automatica
<flusso-chiusura-automatica>
+ Il timer raggiunge lo zero
+ Il sistema chiude automaticamente la somministrazione
+ Il punteggio viene calcolato sulle risposte salvate fino a quel momento
+ Se non ci sono risposte salvate, il punteggio è zero

Se lo studente preme "Consegna" nello stesso istante in cui il timer scade, il sistema garantisce che solo una delle due operazioni abbia effetto.

== Recovery Sessioni Interrotte (UC 20.03)
<recovery-sessioni-interrotte-uc-20.03>
Se il server si riavvia durante una somministrazione in corso (per deploy, crash o manutenzione), il sistema recupera automaticamente tutte le sessioni rimaste aperte.

=== Meccanismi
<meccanismi>
#strong[All'avvio dell'applicazione]: il sistema cerca tutte le somministrazioni in corso. Se il tempo è scaduto, le chiude immediatamente calcolando il punteggio. Se il tempo non è ancora scaduto, programma un nuovo task di chiusura automatica.

#strong[Pulizia notturna]: ogni notte alle 00:01 il sistema verifica se ci sono somministrazioni ancora aperte con tempo scaduto e le chiude. Questo funge da rete di sicurezza per casi limite.

Il risultato è che nessuna somministrazione resta aperta indefinitamente.

== Snapshot Immutabili
<snapshot-immutabili>
Quando un assessment viene pubblicato per una classe, il sistema crea una copia immutabile (#emph[snapshot]) dell'assessment, delle domande e delle opzioni. Le somministrazioni degli studenti fanno riferimento allo snapshot, non all'assessment originale.

Questo garantisce che modifiche successive all'assessment da parte del docente non alterino le verifiche già in corso o completate. Ogni pubblicazione con contenuto diverso genera una nuova versione dello snapshot; se il contenuto non è cambiato, il sistema riutilizza lo snapshot esistente.

== Calcolo Punteggio (UC 30.00)
<calcolo-punteggio-uc-30.00>
Alla chiusura della somministrazione (manuale o automatica), il sistema calcola il punteggio.

=== Regole
<regole>
#figure(
  align(center)[#table(
    columns: auto,
    align: (auto,auto,auto,),
    table.header([Tipo domanda], [Esito], [Punti],),
    table.hline(),
    [Scelta multipla], [Corretta (selezione esatta)], [`pts_correct` (es. +1.0)],
    [Scelta multipla], [Errata (selezione diversa)], [`pts_wrong` (es. -0.25)],
    [Scelta multipla], [Non data (nessuna selezione)], [0],
    [Risposta aperta], [In attesa di correzione manuale], [0],
  )]
  , kind: table
  )

I punteggi per risposta corretta e per risposta errata sono configurabili per ogni assessment. Le risposte aperte non vengono valutate automaticamente: la correzione è demandata al docente.

== Risultati e Storico (UC 30.01)
<risultati-e-storico-uc-30.01>
=== Risultati Post-Consegna
<risultati-post-consegna>
Subito dopo la consegna, lo studente vede la pagina dei risultati con: percentuale di risposte corrette, errate e non date, e il punteggio totale. Può scaricare un file ZIP con i risultati.

=== Storico
<storico>
Dall'area personale, lo studente può consultare lo storico di tutte le somministrazioni completate. Per ogni somministrazione sono visibili: titolo dell'assessment, data, punteggio. Selezionando una somministrazione, lo studente accede alla revisione dettagliata che mostra ogni domanda con la risposta data, la risposta corretta e l'esito (corretta in verde, errata in rosso, non data in grigio, risposta aperta in attesa in giallo).

== Profilo Utente (UC 40.00)
<profilo-utente-uc-40.00>
L'utente autenticato può consultare i propri dati di profilo e modificare la propria password.

=== Consultazione Profilo
<consultazione-profilo>
L'endpoint `GET /users/me` restituisce: nome, username, email, classe di appartenenza (per gli studenti) e ruolo (STUDENT, TEACHER). I dati sono estratti dal database a partire dall'identità presente nel token JWT.

=== Cambio Password
<cambio-password>
L'endpoint `PUT /users/me/password` permette di cambiare la propria password. La richiesta richiede la password corrente (per conferma d'identità), la nuova password e la conferma. Il sistema verifica che:

- La password corrente sia corretta
- La nuova password e la conferma corrispondano
- La nuova password sia diversa dalla precedente
- La nuova password rispetti i requisiti di sicurezza: almeno 8 caratteri, una lettera maiuscola e un numero

In caso di validazione fallita, il sistema restituisce un errore specifico per ogni caso.

== Tentativi Multipli
<tentativi-multipli>
Lo studente può ripetere un assessment più volte. Ogni tentativo genera una somministrazione separata con il proprio punteggio, visibile nello storico.

== Export Risultati
<export-risultati>
Al termine della somministrazione, lo studente può scaricare un file ZIP contenente i risultati in formato strutturato.

