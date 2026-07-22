# Funzionalità di Sistema — Testero

Questa pagina documenta le funzionalità principali del sistema con diagrammi di sequenza.

---

## Autenticazione

<details>
<summary><h3 style={{display: 'inline'}}>Login</h3></summary>

```mermaid
sequenceDiagram
    participant S as Studente
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database

    S->>FE: Inserisce username e password
    FE->>BE: POST /api/auth/login
    BE->>DB: SELECT app_user WHERE username = ?
    DB-->>BE: App User record

    alt Utente non trovato o non attivo
        BE-->>FE: 401 Unauthorized
        FE-->>S: "Credenziali non valide"
    else Password errata
        BE-->>FE: 401 Unauthorized
        FE-->>S: "Credenziali non valide"
    else Credenziali valide
        BE->>BE: Genera JWT token
        BE-->>FE: 200 OK + token + user info (first_name, last_name, ...)
        FE->>FE: Salva token in memoria
        FE-->>S: Redirect a /allenamento
    end
```

**Entità coinvolte:** **App User**, **App User Role**, **App Role**

Il sistema verifica in ordine:

1. L'utente esiste? (lookup per `username` o `email`)
2. L'account è attivo? (`is_active = true`)
3. La password è corretta? (bcrypt match)
4. Deve cambiare password? (`must_change_password` o `password_expires_at` scaduto)

Se deve cambiare password, il BE genera un token limitato che permette solo `POST /api/auth/set-password`.

</details>

---

## Assessment

<details>
<summary><h3 style={{display: 'inline'}}>Avvio assessment (CERT_SIMULATION / EXAM)</h3></summary>

```mermaid
sequenceDiagram
    participant S as Studente
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database

    S->>FE: Apre sezione Certificazioni
    FE->>BE: GET /api/assessments
    BE->>DB: SELECT snapshot via class_assessment_assignment<br/>WHERE class_id = ? AND within availability window
    DB-->>BE: Lista snapshot disponibili
    BE-->>FE: Assessment list

    S->>FE: Clicca "Avvia" su un assessment
    FE->>FE: Mostra modale di conferma
    S->>FE: Conferma

    FE->>BE: POST /api/assessments/{snapshotId}/start
    BE->>DB: INSERT submission (status = IN_PROGRESS)
    BE->>DB: SELECT question_snapshot random (N domande)
    DB-->>BE: Domande + opzioni
    BE-->>FE: submissionId + questions + options

    FE->>FE: Avvia timer
    FE-->>S: Mostra prima domanda
```

**Entità coinvolte:** **Class Assessment Assignment**, **Assessment Snapshot**, **Question Snapshot**, **Option Snapshot**, **Submission**

Il sistema:
1. Mostra solo gli assessment assegnati alla classe dello studente e dentro la finestra di disponibilità
2. Alla conferma, crea una **Submission** con stato `IN_PROGRESS`
3. Estrae N domande random dal pool dello snapshot (`questions_per_assessment`)
4. Avvia il timer del FE (basato su `timer_minutes` dello snapshot)

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Svolgimento e salvataggio risposte</h3></summary>

```mermaid
sequenceDiagram
    participant S as Studente
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database

    loop Per ogni domanda
        S->>FE: Seleziona un'opzione (o scrive risposta)
        S->>FE: Naviga alla domanda successiva

        FE->>BE: PUT /api/submissions/{id}/answers/{questionSnapshotId}
        Note over FE,BE: Fire-and-forget (non blocca la UI)
        BE->>DB: UPSERT user_answer
        BE->>DB: UPSERT user_answer_selected_option
    end

    opt Lo studente segna "da rivedere"
        S->>FE: Toggle flag sulla domanda
        FE->>FE: Aggiorna stato locale (flagged = true)
    end
```

**Entità coinvolte:** **Submission**, **User Answer**, **User Answer Selected Option**, **Question Snapshot**, **Option Snapshot**

Il salvataggio è **incrementale e in background**: ogni volta che lo studente cambia domanda, il FE invia la risposta corrente al BE senza bloccare la navigazione. Se la connessione cade, le risposte già inviate sono salve nel DB.

I campi `is_correct` e `points_awarded` sulla **User Answer** restano NULL durante lo svolgimento — vengono calcolati solo alla consegna.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Consegna e scoring</h3></summary>

```mermaid
sequenceDiagram
    participant S as Studente
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database

    alt Consegna manuale
        S->>FE: Clicca "Consegna"
        FE->>FE: Mostra modale di conferma
        S->>FE: Conferma
    else Timer scaduto
        FE->>FE: Timer raggiunge 0
        FE->>FE: Redirect automatico a recap
    end

    FE->>BE: PUT /api/submissions/{id}
    BE->>BE: Imposta status = SUBMITTED (o AUTO_CLOSED)
    BE->>BE: Imposta submitted_at = now()

    loop Per ogni User Answer
        BE->>DB: SELECT option_snapshot WHERE is_correct = true
        BE->>BE: Confronta con opzione selezionata
        alt Risposta corretta
            BE->>DB: UPDATE user_answer SET is_correct = true, points_awarded = pts_correct
        else Risposta errata
            BE->>DB: UPDATE user_answer SET is_correct = false, points_awarded = pts_wrong
        else Non risposta
            BE->>DB: UPDATE user_answer SET is_correct = false, points_awarded = pts_unanswered
        end
    end

    BE->>BE: score = SUM(points_awarded)
    BE->>DB: UPDATE submission SET score = ?, status = ?
    BE-->>FE: SubmissionFeedbackResponse (score, dettagli)
    FE-->>S: Pagina risultati
```

**Entità coinvolte:** **Submission**, **User Answer**, **User Answer Selected Option**, **Option Snapshot**, **Assessment Snapshot**

Il punteggio è calcolato interamente dal server:
- Per ogni domanda, confronta l'opzione selezionata con `is_correct` sull'**Option Snapshot**
- Assegna `pts_correct`, `pts_wrong` o `pts_unanswered` (dallo snapshot)
- Se la domanda ha `points` personalizzati, quelli sovrascrivono `pts_correct`
- Il `score` sulla **Submission** è la somma di tutti i `points_awarded`

Il risultato è **irreversibile**: una volta consegnato, lo stato non torna a `IN_PROGRESS`.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Training (pratica libera)</h3></summary>

```mermaid
sequenceDiagram
    participant S as Studente
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database

    S->>FE: Apre sezione Allenamento
    FE->>BE: GET /api/topics
    BE-->>FE: Lista topic con capitoli

    S->>FE: Seleziona topic e capitoli
    S->>FE: Sceglie difficoltà e n. domande
    S->>FE: Clicca "Inizia"

    FE->>BE: POST /api/training/start
    BE->>DB: SELECT domande WHERE subject IN (capitoli selezionati)
    BE->>BE: Seleziona N domande random
    BE->>DB: INSERT assessment_snapshot (type = TRAINING, assessment_template_id = NULL)
    BE->>DB: INSERT question_snapshot + option_snapshot (copie)
    BE->>DB: INSERT submission (status = IN_PROGRESS)
    BE-->>FE: submissionId + snapshotId

    Note over FE: Da qui il flusso è identico<br/>a svolgimento + consegna
```

**Entità coinvolte:** **Topic**, **Topic Subject**, **Subject**, **Question Template Subject**, **Assessment Snapshot**, **Question Snapshot**, **Option Snapshot**, **Submission**

La differenza rispetto a CERT_SIMULATION/EXAM:
- Lo snapshot viene creato **dinamicamente** al momento dell'avvio, non da un publish del docente
- `assessment_template_id` è **NULL** (nessun template padre)
- `type = TRAINING`
- `timer_minutes = 0` (nessun timer, a meno che lo studente lo attivi nel configuratore)
- Non c'è esito formale (superato/non superato)

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Visualizzazione risultati e ripasso</h3></summary>

```mermaid
sequenceDiagram
    participant S as Studente
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database

    S->>FE: Apre sezione "I miei risultati"
    FE->>BE: GET /api/submissions/mine
    BE->>DB: SELECT submission WHERE user_id = ?
    DB-->>BE: Lista submission con score e stato
    BE-->>FE: Storico risultati

    S->>FE: Clicca su una submission
    FE-->>S: Mostra dettaglio (score, corrette/errate)

    S->>FE: Clicca "Rivedi gli errori"
    FE->>BE: GET /api/submissions/{id}/review
    BE->>DB: SELECT user_answer + question_snapshot + option_snapshot
    DB-->>BE: Domande con risposte date, corrette, explanation
    BE-->>FE: SubmissionReviewResponse

    FE-->>S: Mostra ogni domanda con:<br/>risposta data, risposta corretta, spiegazione
```

**Entità coinvolte:** **Submission**, **User Answer**, **User Answer Selected Option**, **Question Snapshot**, **Option Snapshot**, **Question Snapshot Subject**

Il ripasso mostra per ogni domanda:
- Il testo della domanda e le opzioni (dallo snapshot)
- Quale opzione ha selezionato lo studente
- Quale era la risposta corretta
- La spiegazione didattica (`explanation` dal **Question Snapshot**)
- Gli argomenti della domanda (dal **Question Snapshot Subject**) per il breakdown per argomento

</details>

---

## Notifiche

<details>
<summary><h3 style={{display: 'inline'}}>Notifiche in-app</h3></summary>

```mermaid
sequenceDiagram
    participant S as Studente
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database

    Note over S,DB: Dopo la consegna di un EXAM/CERT_SIMULATION

    BE->>DB: SELECT notification_preference<br/>WHERE user_id = ? AND event = ? AND channel = IN_APP
    DB-->>BE: Preference (o default = enabled)

    alt IN_APP abilitato
        BE->>DB: INSERT notification (title, message, read=false)
    end

    Note over S,DB: Lo studente naviga a un'altra pagina

    FE->>BE: GET /api/notifications/count
    BE->>DB: COUNT notification WHERE user_id = ? AND read = false
    DB-->>BE: count
    BE-->>FE: { count: N }
    FE->>FE: Mostra badge con N sulla campanella

    S->>FE: Clicca sulla campanella
    FE->>BE: GET /api/notifications/unread
    BE-->>FE: Lista notifiche non lette
    FE-->>S: Pannello con notifiche

    S->>FE: Clicca su una notifica
    FE->>BE: PUT /api/notifications/{id}/read
    FE->>FE: Aggiorna badge count
```

**Entità coinvolte:** **Notification**, **Notification Preference**, **Submission**, **Assessment Snapshot**

Le notifiche vengono generate dal server dopo il completamento di un assessment (non per training). Il FE non fa polling: carica il conteggio delle notifiche non lette ad ogni cambio pagina.

Il sistema controlla le **Notification Preference** dell'utente prima di creare la notifica. Se l'utente ha disattivato il canale IN_APP per quell'evento, la notifica non viene creata.

</details>

---

## Competenze

<details>
<summary><h3 style={{display: 'inline'}}>Mastery per argomento</h3></summary>

```mermaid
sequenceDiagram
    participant S as Studente
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database

    S->>FE: Apre sezione Competenze
    FE->>BE: GET /api/competencies?from=...&to=...
    Note over FE,BE: I parametri from e to sono opzionali<br/>(filtro per data submission)
    BE->>DB: SELECT submission WHERE user_id = ?<br/>AND status IN (SUBMITTED, AUTO_CLOSED)<br/>AND submitted_at BETWEEN from AND to (se presenti)
    BE->>DB: SELECT assessment_snapshot WHERE type != TRAINING
    Note over BE: Filtra solo EXAM e CERT_SIMULATION

    BE->>DB: SELECT user_answer per le submission valide
    BE->>DB: SELECT question_snapshot_subject (subject + weight)
    BE->>DB: SELECT question_snapshot (difficulty per pesatura)
    BE->>DB: SELECT topic con gerarchia (parent_id)
    BE->>DB: SELECT topic_subject (topic → subject)

    BE->>BE: Per ogni Subject:<br/>mastery pesata per difficoltà domanda:<br/>BEGINNER/null = peso 1.0<br/>INTERMEDIATE = peso 1.5<br/>ADVANCED = peso 2.0
    BE->>BE: Per ogni Topic:<br/>mastery = media dei subject figli
    BE->>BE: Costruisce albero gerarchico

    BE-->>FE: { topics: [ { title, mastery, children, subjects } ] }
    FE-->>S: Albero con barre di progresso per topic e subject
```

**Entità coinvolte:** **Submission**, **User Answer**, **Question Snapshot**, **Question Snapshot Subject**, **Subject**, **Topic**, **Topic Subject**

La pagina Competenze mostra la padronanza dello studente per argomento, calcolata dalle submission passate:

- Solo **EXAM** e **CERT_SIMULATION** contano — il **training** è escluso
- L'endpoint `GET /api/competencies` accetta i parametri opzionali `from` e `to` (date ISO) per filtrare le submission per intervallo temporale. Se omessi, considera tutte le submission
- La mastery per **Subject** è **pesata per difficoltà della domanda**: ogni risposta corretta contribuisce con un peso che dipende dal campo `difficulty` del **Question Snapshot** — `BEGINNER` o `null` = 1.0, `INTERMEDIATE` = 1.5, `ADVANCED` = 2.0. La formula è: `mastery = somma(peso delle corrette) / somma(peso di tutte) × 100`
- La mastery per **Topic** = media delle mastery dei subject figli
- I **Topic** sono organizzati in una gerarchia ad albero (es. *"Python"* → *"Fondamenti"* → subject)

Se lo studente non ha ancora completato nessuna verifica, la pagina mostra un messaggio invitandolo a completarne una.

</details>

---

## Convenzioni API

<details>
<summary><h3 style={{display: 'inline'}}>Paginazione</h3></summary>

Gli endpoint che restituiscono liste supportano la paginazione tramite query parameter:

| Parametro | Default | Descrizione |
|-----------|---------|-------------|
| `page` | 0 | Numero della pagina (zero-based) |
| `size` | 20 | Numero di elementi per pagina |

La risposta affianca alla lista un oggetto `pagination` con i metadati:

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `total_elements` | long | Numero totale di elementi |
| `total_pages` | int | Numero totale di pagine |
| `page` | int | Pagina corrente |
| `size` | int | Dimensione della pagina |

Esempio di risposta di `GET /api/assessments`:

```json
{
  "assessments": [ ... ],
  "pagination": {
    "total_elements": 42,
    "total_pages": 3,
    "page": 0,
    "size": 20
  }
}
```

Endpoint paginati: `GET /api/assessments` e `GET /api/submissions/mine`. Senza parametri restituiscono la prima pagina con 20 elementi, quindi la paginazione è retrocompatibile per i client già esistenti.

</details>

---
