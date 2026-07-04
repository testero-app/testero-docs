# Modello Dati

## Diagramma ER

Il diagramma seguente mostra le entità principali e le loro relazioni. Le frecce indicano le foreign key (dalla tabella che contiene la FK verso la tabella referenziata).

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          UTENTI E RUOLI                                │
│                                                                        │
│  ┌──────────┐    ┌──────────────┐    ┌──────────┐                      │
│  │ app_role │◄───│app_user_role │───►│ app_user │                      │
│  └──────────┘    └──────────────┘    └─────┬────┘                      │
│                                            │                           │
│                       ┌────────────────────┼──────────────────┐        │
│                       │                    │                  │        │
│                       ▼                    ▼                  ▼        │
│              ┌─────────────────┐  ┌────────────────┐  ┌────────────┐  │
│              │ teacher_profile │  │student_profile │  │notification│  │
│              └────────┬────────┘  └───────┬────────┘  │_preference │  │
│                       │                   │           └────────────┘  │
│                       ▼                   ▼                           │
│              ┌──────────────┐     ┌────────────┐                      │
│              │teacher_class │────►│ user_class │                      │
│              └──────────────┘     └────────────┘                      │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                     ASSESSMENT (template mutabili)                      │
│                                                                        │
│  ┌────────────┐    ┌──────────┐    ┌────────┐                          │
│  │ assessment │───►│ question │───►│ option │                          │
│  └─────┬──────┘    └────┬─────┘    └────────┘                          │
│        │                │                                              │
│        ▼                ▼                                              │
│  ┌─────────────┐  ┌──────────────┐    ┌─────────┐                     │
│  │ assessment  │  │question_     │───►│ subject │                     │
│  │ _subject    │  │ subject      │    └────┬────┘                     │
│  └─────────────┘  └──────────────┘         │                          │
│                                            │                          │
│  ┌───────┐    ┌───────────────┐             │                          │
│  │ topic │───►│ topic_subject │─────────────┘                          │
│  └───────┘    └───────────────┘                                        │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                     SNAPSHOT (copie immutabili)                         │
│                                                                        │
│  ┌───────────────────┐    ┌───────────────────┐    ┌────────────────┐  │
│  │assessment_snapshot│───►│question_snapshot  │───►│option_snapshot │  │
│  └────────┬──────────┘    └────────┬──────────┘    └────────────────┘  │
│           │                        │                                   │
│           ▼                        ▼                                   │
│  ┌────────────────┐    ┌─────────────────────────┐                     │
│  │class_assessment│    │question_snapshot_subject│                     │
│  └───────┬────────┘    └─────────────────────────┘                     │
│          │                                                             │
│          ▼                                                             │
│  ┌────────────┐                                                        │
│  │ user_class │                                                        │
│  └────────────┘                                                        │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                          SUBMISSION                                    │
│                                                                        │
│  ┌────────────┐    ┌─────────────┐    ┌──────────────────────────────┐ │
│  │ submission │───►│ user_answer │───►│user_answer_selected_option  │ │
│  └────────────┘    └─────────────┘    └──────────────────────────────┘ │
│        │                  │                         │                  │
│        │ FK               │ FK                      │ FK               │
│        ▼                  ▼                         ▼                  │
│  assessment_snapshot  question_snapshot       option_snapshot          │
└─────────────────────────────────────────────────────────────────────────┘
```

## Modello Relazionale

Di seguito il modello relazionale completo. Ogni tabella riporta: colonne, tipo, vincoli e chiavi.

Convenzioni:

- **PK** = Primary Key
- **FK** = Foreign Key
- **UQ** = Unique
- **NN** = Not Null
- Tutte le tabelle includono `created_at` e `updated_at` (TIMESTAMP, gestiti dal DB).

### Utenti e Ruoli

**app_user**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK |
| `name` | VARCHAR | NN |
| `username` | VARCHAR | NN, UQ |
| `password_hash` | VARCHAR | NN |
| `email` | VARCHAR | UQ |
| `must_change_password` | BOOLEAN | NN, default false |
| `password_expires_at` | TIMESTAMP | |

Esempio:

| id | name | username | email | must_change_password |
|----|------|----------|-------|---------------------|
| `a1b2...` | Alice Rossi | `a.rossi` | alice@example.com | false |
| `c3d4...` | Demo Teacher | `teacher` | NULL | false |

---

**app_role**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `name` | VARCHAR | NN, UQ |

Valori: `ADMIN`, `TEACHER`, `STUDENT`.

---

**app_user_role** (associazione M:N)

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `user_id` | UUID | PK, FK → app_user |
| `role_id` | UUID | PK, FK → app_role |

Esempio:

| user_id | role_id |
|---------|---------|
| `a1b2...` (Alice) | `r001...` (STUDENT) |
| `c3d4...` (Teacher) | `r002...` (TEACHER) |

---

**user_class**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK |
| `name` | VARCHAR | NN |

Esempio: `{ id: "cl01...", name: "SW-2026" }`

---

**student_profile**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `user_id` | UUID | NN, UQ, FK → app_user |
| `class_id` | UUID | NN, FK → user_class |

Esempio: `{ user_id: "a1b2..." (Alice), class_id: "cl01..." (SW-2026) }`

---

**teacher_profile**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `user_id` | UUID | NN, UQ, FK → app_user |

---

**teacher_class** (associazione M:N)

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `user_id` | UUID | PK, FK → app_user |
| `class_id` | UUID | PK, FK → user_class |

---

**notification_preference**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `user_id` | UUID | NN, FK → app_user |
| `type` | VARCHAR(50) | NN, enum |
| `enabled` | BOOLEAN | NN |

Valori di `type`: `EXAM_RESULT`, `DEADLINE_REMINDER`, `PRODUCT_NEWS`.

Esempio:

| user_id | type | enabled |
|---------|------|---------|
| `a1b2...` (Alice) | EXAM_RESULT | true |
| `a1b2...` (Alice) | DEADLINE_REMINDER | false |

---

### Assessment (template mutabili)

**assessment_template**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK |
| `title` | VARCHAR | NN |
| `assessment_description` | TEXT | nullable |
| `date` | DATE | NN |
| `start_time` | TIME | nullable |
| `timer_minutes` | INT | NN |
| `questions_per_assessment` | INT | NN |
| `pts_correct` | DECIMAL | NN |
| `pts_wrong` | DECIMAL | NN |
| `pts_unanswered` | DECIMAL | NN, default 0 |
| `max_attempts` | INT | nullable |
| `shuffle_questions` | BOOLEAN | NN, default true |
| `shuffle_options` | BOOLEAN | NN, default true |
| `difficulty` | VARCHAR(20) | enum, nullable |
| `type` | VARCHAR(20) | NN, default CERT_SIMULATION |
| `passing_score` | DECIMAL | |

Valori di `difficulty`: `BEGINNER`, `INTERMEDIATE`, `ADVANCED`, `EXPERT`.

Valori di `type`: `CERT_SIMULATION`, `EXAM`, `TRAINING`.

Esempio:

| id | title | difficulty | type |
|----|-------|------------|------|
| `t01...` | Reti di Calcolatori | INTERMEDIATE | CERT_SIMULATION |
| `t02...` | Basi di Dati — Allenamento | BEGINNER | TRAINING |

Dettagli `t01`: timer 30 min, domande per assessment 20, +1.00/−0.25/0 punti.

---

**question**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK |
| `assessment_template_id` | UUID | NN, FK → assessment_template |
| `type` | VARCHAR | NN |
| `text` | TEXT | NN |
| `code` | TEXT | |
| `explanation` | TEXT | |
| `position` | INT | NN |
| `points` | DECIMAL(5,2) | |
| `difficulty` | VARCHAR(20) | enum, nullable |

Esempio:

- `q01`: MULTIPLE_CHOICE, "Quale protocollo opera al livello 4 OSI?", difficulty INTERMEDIATE, assessment `t01`, posizione 1, punti default.
- `q02`: MULTIPLE_CHOICE, "Cosa restituisce ls -la?", difficulty BEGINNER, assessment `t01`, posizione 2, punti 2.00, codice `ls -la /home`.

---

**option**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK |
| `question_id` | UUID | NN, FK → question |
| `text` | VARCHAR | NN |
| `is_correct` | BOOLEAN | NN |
| `is_fallback` | BOOLEAN | NN |
| `position` | INT | NN |

Esempio (per la domanda q01):

| id | text | is_correct | is_fallback |
|----|------|------------|-------------|
| `o01...` | TCP | true | false |
| `o02...` | HTTP | false | false |
| `o03...` | ARP | false | false |
| `o04...` | Nessuna delle precedenti | false | true |

---

**subject**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK |
| `label` | VARCHAR | NN |

Esempio: `{ id: "s01...", label: "Modello OSI" }`, `{ id: "s02...", label: "Comandi Linux" }`

---

**question_subject** (associazione M:N con peso)

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `question_id` | UUID | PK, FK → question |
| `subject_id` | UUID | PK, FK → subject |
| `weight` | DECIMAL(5,2) | NN, default 1.00 |

Esempio:

| question_id | subject_id | weight |
|-------------|------------|--------|
| `q01...` (Protocollo livello 4) | `s01...` (Modello OSI) | 1.00 |
| `q02...` (ls -la) | `s02...` (Comandi Linux) | 1.00 |

---

**assessment_subject** (associazione M:N)

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `assessment_template_id` | UUID | PK, FK → assessment_template |
| `subject_id` | UUID | PK, FK → subject |

---

**topic**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `title` | VARCHAR(200) | NN |
| `description` | TEXT | |
| `abbreviation` | VARCHAR(4) | |
| `position` | INT | |
| `enabled` | BOOLEAN | NN, default true |

Esempio: `{ title: "Reti di Calcolatori", abbreviation: "RETI", position: 1, enabled: true }`

---

**topic_subject** (associazione M:N)

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `topic_id` | UUID | PK, FK → topic |
| `subject_id` | UUID | PK, FK → subject |
| `position` | INT | |

---

### Snapshot (copie immutabili)

Il meccanismo di snapshot garantisce che le somministrazioni facciano sempre riferimento a una versione congelata dell'assessment. La pubblicazione crea copie immutabili di assessment, domande, opzioni e relazioni domanda-argomento.

**assessment_snapshot**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `assessment_id` | UUID | FK → assessment_template, nullable |
| `content_hash` | VARCHAR(64) | NN |
| `version` | INT | NN |
| `title` | VARCHAR | NN |
| `timer_minutes` | INT | NN |
| `questions_per_assessment` | INT | NN |
| `pts_correct` | DECIMAL | NN |
| `pts_wrong` | DECIMAL | NN |
| `difficulty` | VARCHAR(20) | enum, nullable |
| `type` | VARCHAR(20) | NN, default CERT_SIMULATION |
| `passing_score` | DECIMAL | |
| `published_at` | TIMESTAMP | NN |

`assessment_id` è nullable per consentire sessioni di training generate dinamicamente senza un assessment padre.

Esempio:

| id | assessment_id | version | title |
|----|---------------|---------|-------|
| `snap01...` | `t01...` | 1 | Reti di Calcolatori |
| `snap02...` | NULL | 1 | Training — Modello OSI |

`snap01`: pubblicato il 2026-06-10 09:00. `snap02`: sessione training senza assessment padre.

---

**question_snapshot**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `assessment_snapshot_id` | UUID | NN, FK → assessment_snapshot |
| `original_question_id` | UUID | FK → question, nullable |
| `type` | VARCHAR | NN |
| `text` | TEXT | NN |
| `code` | TEXT | |
| `explanation` | TEXT | |
| `position` | INT | NN |
| `points` | DECIMAL(5,2) | |

---

**option_snapshot**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `question_snapshot_id` | UUID | NN, FK → question_snapshot |
| `original_option_id` | UUID | FK → option, nullable |
| `text` | VARCHAR | NN |
| `is_correct` | BOOLEAN | NN |
| `is_fallback` | BOOLEAN | NN |
| `position` | INT | NN |

---

**question_snapshot_subject** (associazione M:N con peso)

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `question_snapshot_id` | UUID | PK, FK → question_snapshot |
| `subject_id` | UUID | PK, FK → subject |
| `weight` | DECIMAL(5,2) | NN, default 1.00 |

---

**class_assessment** (tabella fisica: `class_test`, associazione M:N)

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `class_id` | UUID | PK, FK → user_class |
| `assessment_snapshot_id` | UUID | PK, FK → assessment_snapshot |
| `activated_at` | TIMESTAMP | |
| `deactivated_at` | TIMESTAMP | |

Esempio:

| class_id | assessment_snapshot_id | activated_at | deactivated_at |
|----------|----------------------|--------------|----------------|
| `cl01...` (SW-2026) | `snap01...` | 2026-06-10 09:00 | NULL |

---

### Submission

**submission**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `user_id` | UUID | NN, FK → app_user |
| `assessment_snapshot_id` | UUID | NN, FK → assessment_snapshot |
| `status` | VARCHAR | NN, default IN_PROGRESS |
| `started_at` | TIMESTAMP | |
| `submitted_at` | TIMESTAMP | |
| `score` | DOUBLE | |

Valori di `status`: `IN_PROGRESS`, `SUBMITTED`, `AUTO_CLOSED`.

Esempio:

| id | user_id | status | score |
|----|---------|--------|-------|
| `sub01...` | `a1b2...` (Alice) | SUBMITTED | 16.50 |
| `sub02...` | `a1b2...` (Alice) | AUTO_CLOSED | 12.00 |

Entrambe referenziano lo snapshot `snap01`. `sub01`: avviata 09:05, consegnata 09:28. `sub02`: avviata 10:00, chiusa automaticamente 10:30.

---

**user_answer**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `submission_id` | UUID | NN, FK → submission |
| `question_snapshot_id` | UUID | NN, FK → question_snapshot |
| `type` | VARCHAR | NN |
| `text` | TEXT | |
| `motivation` | TEXT | |
| `flagged` | BOOLEAN | NN |
| `is_correct` | BOOLEAN | |
| `points_awarded` | DOUBLE | |

Esempio:

| id | type | flagged | is_correct | points_awarded |
|----|------|---------|------------|----------------|
| `ans01...` | MULTIPLE_CHOICE | false | true | 1.00 |
| `ans02...` | MULTIPLE_CHOICE | true | false | -0.25 |

Entrambe relative alla submission `sub01`.

---

**user_answer_selected_option**

| Colonna | Tipo | Vincoli |
|---------|------|---------|
| `id` | UUID | PK, auto |
| `answer_id` | UUID | NN, FK → user_answer |
| `option_snapshot_id` | UUID | NN, FK → option_snapshot |

Vincolo UNIQUE su `(answer_id, option_snapshot_id)`.

Esempio:

| id | answer_id | option_snapshot_id |
|----|-----------|-------------------|
| `sel01...` | `ans01...` | `os01...` (TCP — corretta) |
| `sel02...` | `ans02...` | `os05...` (HTTP — errata) |

---

## Enumerazioni

- **AssessmentType**: `CERT_SIMULATION`, `EXAM`, `TRAINING` — usato in assessment_template, assessment_snapshot.
- **Difficulty**: `BEGINNER`, `INTERMEDIATE`, `ADVANCED`, `EXPERT` — usato in assessment, assessment_snapshot, question.
- **SubmissionStatus**: `IN_PROGRESS`, `SUBMITTED`, `AUTO_CLOSED` — usato in submission.
- **NotificationType**: `EXAM_RESULT`, `DEADLINE_REMINDER`, `PRODUCT_NEWS` — usato in notification_preference.

## Ciclo di Vita dell'Assessment

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

| Fase | Descrizione |
|------|-------------|
| Creato | L'assessment esiste come bozza modificabile dal docente |
| Pubblicato | È stato generato uno snapshot immutabile. Se il contenuto non è cambiato rispetto alla pubblicazione precedente, lo snapshot viene riutilizzato |
| Attivo | Lo snapshot è stato associato a una classe (data di attivazione valorizzata). Gli studenti della classe possono svolgere la verifica |
| Disattivato | L'assessment è stato rimosso dalla classe (data di disattivazione valorizzata). Gli studenti non lo vedono più, ma le somministrazioni già completate restano nello storico |

Il docente può modificare un assessment e ripubblicarlo in qualsiasi momento: questo genera una nuova versione dello snapshot senza impattare le somministrazioni già in corso o completate sulla versione precedente.

## Stati della Submission

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

| Stato | Significato |
|-------|-------------|
| IN_PROGRESS | Lo studente ha iniziato ma non ha ancora consegnato |
| SUBMITTED | Lo studente ha consegnato manualmente |
| AUTO_CLOSED | Il sistema ha chiuso la submission allo scadere del timer |

## Note di Design

- **Snapshot immutabili**: al momento della pubblicazione, assessment, domande, opzioni e relazioni domanda-argomento vengono copiati in tabelle separate. Le submission fanno sempre riferimento agli snapshot, mai ai template. Questo garantisce che modifiche successive al template non alterino i dati delle verifiche già somministrate.
- **`assessment_id` nullable**: gli snapshot generati dal training mode non hanno un assessment padre, poiché vengono creati dinamicamente aggregando domande da più assessment.
- **`is_fallback`**: le opzioni con questo flag (es. "Nessuna delle precedenti") vengono sempre posizionate in fondo durante lo shuffle, indipendentemente dalla randomizzazione.
- **`weight` nella relazione domanda-argomento**: permette di calcolare il breakdown del punteggio per argomento nella schermata dei risultati.
- **`points` per domanda**: se valorizzato, sovrascrive il punteggio globale dell'assessment (`pts_correct`). Il punteggio massimo (`max_score`) è calcolato come somma dei punti delle domande selezionate.
- **`content_hash`**: hash SHA-256 del contenuto dell'assessment. Se il contenuto non è cambiato rispetto all'ultima pubblicazione, lo snapshot esistente viene riutilizzato.

\newpage
