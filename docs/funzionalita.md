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
