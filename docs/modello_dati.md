# Modello Dati — Testero

Le entità sono organizzate in 6 aree:

1. **Assessment** — come è strutturato un test
2. **Pubblicazione** — il meccanismo di snapshot immutabili
3. **Tassonomia** — argomenti, topic e gerarchia didattica
4. **Utenti e ruoli** — chi usa il sistema, credenziali, notifiche
5. **Somministrazione** — assegnazione, svolgimento e risposte

---

## Assessment Area

<details>
<summary><h3 style={{display: 'inline'}}>Assessment Template</h3></summary>

> **Tabella SQL:** `assessment_template`
>
> **Collegata a:** `app_user` (proprietario), `question_template`, `assessment_template_subject`, `assessment_template_topic`, `assessment_snapshot`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Identificativo univoco | `a1b2c3...` |
| `owner_id` | UUID | FK → `app_user`, NL, ON DELETE SET NULL | Docente proprietario. `NULL` = contenuto di piattaforma, gestito solo da un Admin | `d4e5f6...` |
| `title` | VARCHAR | NN | Titolo dell'assessment | *"Python Foundation"* |
| `timer_minutes` | INT | NN | Durata in minuti. 0 = senza timer | `30` |
| `questions_per_assessment` | INT | NN | Domande estratte dal pool per ogni studente | `20` |
| `pts_correct` | DECIMAL | NN | Punti per risposta corretta | `1.00` |
| `pts_wrong` | DECIMAL | NN | Punti per risposta errata | `-0.25` |
| `pts_unanswered` | DECIMAL | NN | Punti per risposta non data. Default 0 | `0` |
| `difficulty` | VARCHAR(20) | NL | Livello di difficoltà globale | `INTERMEDIATE` |
| `type` | VARCHAR(20) | NN | Tipo di assessment | `CERT_SIMULATION` |
| `passing_score` | DECIMAL | NL | Soglia sufficienza | `12.00` |
| `max_attempts` | INT | NL | Tentativi massimi. NULL = illimitato | `NULL` |
| `shuffle_questions` | BOOLEAN | NN | Mescola l'ordine delle domande. Default true | `true` |
| `shuffle_options` | BOOLEAN | NN | Mescola le opzioni di risposta. Default true | `true` |
| `assessment_description` | TEXT | NL | Descrizione visibile allo studente prima di iniziare | *"Simulazione esame..."* |

L'**Assessment Template** è il *template modificabile di un assessment* — la bozza che il docente prepara prima di pubblicarla. Contiene le regole della verifica (durata, punteggio, quante domande estrarre, se mescolare le risposte) ma non le domande stesse, che stanno nell'entità **QuestionTemplate**.

Un assessment può essere di tre tipi:

- **CERT_SIMULATION** — simulazione di certificazione esterna della scuola. Lo studente si esercita su domande pensate per un esame di certificazione specifico. Timer attivo, esito con soglia di superamento. Ripetibile.
- **TRAINING** — pratica libera per argomento. Lo studente sceglie cosa esercitare, nessun timer, nessun esito formale.
- **EXAM** — prova formale del docente, in aula o a casa. Checkpoint periodico con timer, esito. Sta al docente deciderne la valenza.

Il docente può modificare liberamente un **Assessment Template** finché non decide di pubblicarlo. Al momento della pubblicazione, il sistema crea una *copia congelata* di quel template — chiamata **Assessment Snapshot** — che diventa la versione somministrata agli studenti.

:::tip
*Immagina una fotocopia: il template è il foglio originale che il docente può correggere e riscrivere quante volte vuole. Quando decide che è pronto, il sistema "fotocopia" tutto — domande, opzioni, punteggi — in uno snapshot immutabile. Gli studenti svolgono la verifica sulla fotocopia, non sull'originale. Se il docente modifica l'originale dopo e ripubblica, viene creata una nuova versione dello snapshot (v2, v3...) senza toccare le verifiche già fatte sulla versione precedente.*
:::

#### Pool di domande

Il docente inserisce N domande nell'assessment (es. 50). Il campo `questions_per_assessment` dice quante di quelle 50 vengono pescate a caso per ogni studente (es. 20). Così ogni studente riceve un sottoinsieme diverso — meno possibilità di copiare. Se il docente vuole che tutti facciano le stesse identiche domande, gli basta impostare `questions_per_assessment` uguale al numero totale di domande inserite.

#### Proprietà e permessi

Ogni assessment appartiene 1:1 al docente che l'ha creato, tramite `owner_id`. La
proprietà è ciò che decide chi può agire sull'assessment:

- il **proprietario** può modificarlo e pubblicarlo;
- un **Admin** può agire su qualsiasi assessment, incluso il contenuto di piattaforma;
- ogni altro utente — studenti compresi — non può.

`owner_id = NULL` significa **contenuto di piattaforma**: assessment forniti con il
sistema (es. la simulazione *Python Certification*) che nessun docente possiede e che
solo un Admin gestisce. Lo stesso vale per un assessment rimasto orfano: se il docente
proprietario cancella il proprio account, `owner_id` diventa `NULL` automaticamente
(`ON DELETE SET NULL`) e l'assessment passa sotto la gestione dell'Admin, senza perdere
gli snapshot già pubblicati né le verifiche già svolte.

:::note
La pubblicazione è un'azione riservata: solo il docente proprietario (o un Admin) può
pubblicare uno snapshot. Uno studente non può in nessun caso pubblicare un assessment.
:::

#### Note

- Quando `shuffle_questions = false` e `shuffle_options = false`, l'assessment è identico per tutti — utile per un EXAM in aula dove il docente vuole lo stesso ordine.
- `max_attempts = 1` rende l'assessment one-shot (tipico per EXAM). `NULL` = illimitato (tipico per TRAINING e CERT_SIMULATION).
- La finestra di disponibilità (quando gli studenti possono accedere) non è su questa tabella: è sulla tabella **Class Test**, che rappresenta l'assegnazione di uno snapshot a una classe. Questo permette di assegnare lo stesso test con finestre diverse per classi diverse.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Assessment Template Subject</h3></summary>

> **Tabella SQL:** `assessment_template_subject`
>
> **Collegata a:** `assessment_template`, `subject`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `assessment_template_id` | UUID | PK, FK | Riferimento all'**Assessment Template** | `a-python` |
| `subject_id` | UUID | PK, FK | Riferimento al **Subject** | `s-variables` |

L'**Assessment Template Subject** è una tabella di join che lega un **Assessment Template** ai suoi argomenti macro. Serve a dichiarare *"questo assessment copre questi argomenti"* — ad esempio *"Python Foundation"* copre *"Variabili e tipi"*, *"Controllo di flusso"*, *"Funzioni"*.

La chiave primaria è composta da entrambe le FK — un assessment non può essere legato due volte allo stesso argomento. La relazione è M:N: un assessment copre più argomenti, e uno stesso argomento può appartenere a più assessment.

:::tip
*Non confondere con **QuestionTemplateSubject**: quella lega una singola **QuestionTemplate** a un argomento (con un peso). Questa lega l'intero **Assessment Template** a un argomento. Servono a livelli diversi: **Assessment Template Subject** dice *"di cosa parla il test nel suo insieme"*, **QuestionTemplateSubject** dice *"di cosa parla questa domanda specifica"*. I due insiemi non sono necessariamente uguali — una domanda potrebbe coprire un sotto-argomento (es. "List comprehension") che non è nei subject dell'assessment.*
:::

Al momento della pubblicazione, le associazioni **Assessment Template Subject** vengono copiate nella tabella **Assessment Snapshot Subject**, che congela gli argomenti macro dello snapshot indipendentemente dalle domande.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Question Template</h3></summary>

> **Tabella SQL:** `question_template`
>
> **Collegata a:** `assessment_template`, `option_template`, `question_template_subject`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Identificativo univoco | `q-01` |
| `assessment_template_id` | UUID | NN, FK | Riferimento all'**Assessment Template** | `a-python` |
| `type` | VARCHAR | NN | Tipo di domanda | `MULTIPLE_CHOICE` |
| `text` | TEXT | NN | Testo della domanda | *"Quale keyword definisce una funzione?"* |
| `code` | TEXT | NL | Snippet di codice allegato | *"def hello(): ..."* |
| `explanation` | TEXT | NL | Spiegazione didattica, visibile solo nel ripasso | *"La keyword def si usa per..."* |
| `position` | INT | NN | Ordine della domanda nel pool | `1` |
| `points` | DECIMAL | NL | Punti personalizzati. Se NULL usa `pts_correct` dell'assessment | `2.00` |
| `difficulty` | VARCHAR(20) | NL | Difficoltà della singola domanda | `INTERMEDIATE` |

La **QuestionTemplate** è una singola domanda nel pool di un **Assessment Template**. Contiene il testo, un eventuale snippet di codice (per le domande di programmazione), la spiegazione didattica e la posizione nell'ordine.

Il campo `type` definisce il formato della domanda:

- **MULTIPLE_CHOICE** — scelta multipla con opzioni predefinite (le opzioni stanno nell'entità **OptionTemplate**)
- **SHORT_ANSWER** — risposta aperta testuale

Il campo `points` permette di assegnare un punteggio diverso a domande specifiche. Se è NULL, la domanda usa il punteggio globale dell'assessment (`pts_correct`). Questo consente di creare domande *"bonus"* o domande che valgono il doppio.

Il campo `explanation` contiene la spiegazione didattica della risposta corretta. Non viene mai mostrata durante lo svolgimento del test — appare solo nella fase di ripasso post-consegna, per aiutare lo studente a capire dove ha sbagliato.

Ogni **QuestionTemplate** può essere legata a uno o più argomenti tramite **QuestionTemplateSubject** (con un peso), e ha una o più **OptionTemplate** (le risposte selezionabili).

Al momento della pubblicazione, le domande vengono copiate nella tabella **Question Snapshot**.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Option Template</h3></summary>

> **Tabella SQL:** `option_template`
>
> **Collegata a:** `question_template`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Identificativo univoco | `o-01` |
| `question_template_id` | UUID | NN, FK | Riferimento alla **QuestionTemplate** | `q-01` |
| `text` | VARCHAR | NN | Testo dell'opzione | *"def"* |
| `is_correct` | BOOLEAN | NN | Se questa è la risposta corretta | `true` |
| `is_fallback` | BOOLEAN | NN | Se è un'opzione tipo *"Nessuna delle precedenti"* | `false` |
| `position` | INT | NN | Ordine dell'opzione | `1` |

L'**OptionTemplate** è una singola opzione di risposta per una domanda a scelta multipla (**MULTIPLE_CHOICE**). Ogni **QuestionTemplate** ha tipicamente 4 opzioni, di cui una sola corretta.

Il campo `is_fallback` identifica le opzioni tipo *"Nessuna delle precedenti"*. Queste opzioni vengono sempre posizionate in fondo quando il sistema mescola le risposte (`shuffle_options = true`), indipendentemente dalla randomizzazione delle altre.

Al momento della pubblicazione, le opzioni vengono copiate nella tabella **Option Snapshot**.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Question Template Subject</h3></summary>

> **Tabella SQL:** `question_template_subject`
>
> **Collegata a:** `question_template`, `subject`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `question_template_id` | UUID | PK, FK | Riferimento alla **QuestionTemplate** | `q-01` |
| `subject_id` | UUID | PK, FK | Riferimento al **Subject** | `s-functions` |
| `weight` | DECIMAL(5,2) | NN | Peso della domanda sull'argomento. Default 1.00 | `0.60` |

Il **QuestionTemplateSubject** lega una **QuestionTemplate** a uno o più **Subject** con un peso. Il peso serve per il breakdown del punteggio per argomento nei risultati.

Una domanda può pesare su più argomenti contemporaneamente — ad esempio una domanda su *"List comprehension con condizioni"* potrebbe pesare 60% su *"Liste"* e 40% su *"Controllo di flusso"*.

Al momento della pubblicazione, queste associazioni vengono copiate nella tabella **Question Snapshot Subject** con gli stessi valori di peso.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Assessment Template Topic</h3></summary>

> **Tabella SQL:** `assessment_template_topic`
>
> **Collegata a:** `assessment_template`, `topic`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `assessment_template_id` | UUID | PK, FK | Riferimento all'**Assessment Template** | `a-fullstack` |
| `topic_id` | UUID | PK, FK | Riferimento al **Topic** | `t-python` |

L'**Assessment Template Topic** lega un **Assessment Template** a uno o più **Topic**. Serve a dichiarare *"questo assessment fa parte di questi percorsi didattici"* — ad esempio *"Esame intermedio Full Stack"* copre i topic *"Fondamenti Python"* e *"Fondamenti JavaScript"*.

La relazione è M:N: un assessment può appartenere a più topic, e un topic può avere più assessment collegati. Lo studente che apre un topic vede sia i capitoli per allenarsi sia gli assessment associati (simulazioni, esami).

Al momento della pubblicazione, queste associazioni vengono copiate nella tabella **Assessment Snapshot Topic** con il titolo del topic congelato.

</details>

---

## Pubblicazione Area

<details>
<summary><h3 style={{display: 'inline'}}>Assessment Snapshot</h3></summary>

> **Tabella SQL:** `assessment_snapshot`
>
> **Collegata a:** `assessment_template`, `question_snapshot`, `assessment_snapshot_subject`, `class_assessment_assignment`, `submission`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `snap-01` |
| `assessment_template_id` | UUID | NL, FK | Riferimento all'**Assessment Template** di origine. NULL per training | `a-python` |
| `content_hash` | VARCHAR(64) | NN | SHA-256 del contenuto. Se identico, lo snapshot viene riusato | `a3f8c2e1...` |
| `title` | VARCHAR | NN | Titolo congelato | *"Python Foundation"* |
| `timer_minutes` | INT | NN | Durata congelata | `30` |
| `questions_per_assessment` | INT | NN | Domande per studente congelate | `20` |
| `pts_correct` | DECIMAL | NN | Punti per corretta congelati | `1.00` |
| `pts_wrong` | DECIMAL | NN | Punti per errata congelati | `-0.25` |
| `difficulty` | VARCHAR(20) | NL | Difficoltà congelata | `INTERMEDIATE` |
| `type` | VARCHAR(20) | NN | Tipo congelato | `CERT_SIMULATION` |
| `passing_score` | DECIMAL | NL | Soglia sufficienza congelata | `12.00` |
| `published_at` | TIMESTAMP | NN | Quando è stato pubblicato | `2026-07-10 08:00` |

L'**Assessment Snapshot** è la *copia congelata e immutabile* di un **Assessment Template** al momento della pubblicazione. È il record a cui fanno riferimento tutte le somministrazioni — gli studenti non interagiscono mai con il template, solo con lo snapshot.

Ogni campo dell'**Assessment Template** viene copiato qui al momento del publish: titolo, timer, punteggi, difficoltà, tipo, soglia. Da quel momento i valori sono congelati — se il docente modifica il template e ripubblica, viene creato un nuovo snapshot senza alterare il precedente.

Il campo `assessment_template_id` è **nullable**: gli snapshot generati dal training mode non hanno un **Assessment Template** padre, perché vengono creati dinamicamente aggregando domande da più assessment.

Il campo `content_hash` è un hash SHA-256 del contenuto completo (template + domande + opzioni + subject). Se il docente pubblica senza aver cambiato nulla, il sistema rileva che l'hash è identico e riusa lo snapshot esistente invece di crearne uno nuovo.

:::tip
*Lo snapshot è la "fotocopia" di cui parlavamo nell'**Assessment Template**: una volta creata, nessuno può modificarla. Anche se il docente cancellasse l'originale, gli snapshot e le submission restano intatti.*
:::

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Question Snapshot</h3></summary>

> **Tabella SQL:** `question_snapshot`
>
> **Collegata a:** `assessment_snapshot`, `question_template`, `option_snapshot`, `question_snapshot_subject`, `user_answer`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `qs-01` |
| `assessment_snapshot_id` | UUID | NN, FK | Riferimento all'**Assessment Snapshot** | `snap-01` |
| `original_question_id` | UUID | NL, FK | Riferimento alla **QuestionTemplate** originale | `q-01` |
| `type` | VARCHAR | NN | Tipo congelato | `MULTIPLE_CHOICE` |
| `text` | TEXT | NN | Testo congelato | *"Quale keyword definisce una funzione?"* |
| `code` | TEXT | NL | Snippet di codice congelato | *"def hello(): ..."* |
| `explanation` | TEXT | NL | Spiegazione congelata | *"La keyword def si usa per..."* |
| `position` | INT | NN | Posizione congelata | `1` |
| `points` | DECIMAL | NL | Punti personalizzati congelati | `2.00` |
| `difficulty` | VARCHAR(20) | NL | Difficoltà congelata dal template | `BEGINNER` |

Il **Question Snapshot** è la copia congelata di una **QuestionTemplate**. Viene creato al momento della pubblicazione copiando tutti i campi dalla domanda originale.

Il campo `original_question_id` mantiene il riferimento alla domanda originale nel template. È nullable perché il template potrebbe essere eliminato senza impattare lo snapshot.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Option Snapshot</h3></summary>

> **Tabella SQL:** `option_snapshot`
>
> **Collegata a:** `question_snapshot`, `option_template`, `user_answer_selected_option`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `os-01` |
| `question_snapshot_id` | UUID | NN, FK | Riferimento al **Question Snapshot** | `qs-01` |
| `original_option_id` | UUID | NL, FK | Riferimento all'**OptionTemplate** originale | `o-01` |
| `text` | VARCHAR | NN | Testo congelato | *"def"* |
| `is_correct` | BOOLEAN | NN | Se è la risposta corretta | `true` |
| `is_fallback` | BOOLEAN | NN | Se è un'opzione fallback | `false` |
| `position` | INT | NN | Posizione congelata | `1` |

L'**Option Snapshot** è la copia congelata di una **OptionTemplate**. Stessa logica del **Question Snapshot**: ogni campo viene copiato e da quel momento è immutabile.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Assessment Snapshot Subject</h3></summary>

> **Tabella SQL:** `assessment_snapshot_subject`
>
> **Collegata a:** `assessment_snapshot`, `subject`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `assessment_snapshot_id` | UUID | PK, FK | Riferimento all'**Assessment Snapshot** | `snap-01` |
| `subject_id` | UUID | PK, FK | Riferimento al **Subject** | `s-variables` |
| `label` | VARCHAR | NL | Label del subject congelato al momento del publish | *"Variabili e tipi"* |

L'**Assessment Snapshot Subject** è la copia congelata delle associazioni **Assessment Template Subject**. Registra quali argomenti macro copriva l'assessment al momento della pubblicazione.

Il campo `label` congela il nome del subject al momento del publish. Se il subject viene successivamente rinominato o eliminato, lo snapshot mantiene il nome originale.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Question Snapshot Subject</h3></summary>

> **Tabella SQL:** `question_snapshot_subject`
>
> **Collegata a:** `question_snapshot`, `subject`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `question_snapshot_id` | UUID | PK, FK | Riferimento al **Question Snapshot** | `qs-01` |
| `subject_id` | UUID | PK, FK | Riferimento al **Subject** | `s-functions` |
| `weight` | DECIMAL(5,2) | NN | Peso congelato. Default 1.00 | `0.60` |
| `label` | VARCHAR | NL | Label del subject congelato al momento del publish | *"Funzioni"* |

Il **Question Snapshot Subject** è la copia congelata delle associazioni **QuestionTemplateSubject**. Conserva i pesi originali di ogni domanda sui suoi argomenti e il label congelato, usati per calcolare il breakdown del punteggio per argomento nei risultati.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Assessment Snapshot Topic</h3></summary>

> **Tabella SQL:** `assessment_snapshot_topic`
>
> **Collegata a:** `assessment_snapshot`, `topic`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `assessment_snapshot_id` | UUID | PK, FK | Riferimento all'**Assessment Snapshot** | `snap-01` |
| `topic_id` | UUID | PK, FK | Riferimento al **Topic** | `t-python` |
| `title` | VARCHAR(200) | NL | Titolo del topic congelato al momento del publish | *"Fondamenti Python"* |

L'**Assessment Snapshot Topic** è la copia congelata delle associazioni **Assessment Template Topic**. Registra a quali topic era collegato l'assessment al momento della pubblicazione, con il titolo congelato per accuratezza storica.

</details>

---

## Tassonomia

<details>
<summary><h3 style={{display: 'inline'}}>Subject</h3></summary>

> **Tabella SQL:** `subject`
>
> **Collegata a:** `assessment_template_subject`, `question_template_subject`, `assessment_snapshot_subject`, `question_snapshot_subject`, `topic_subject`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Identificativo univoco | `s-variables` |
| `label` | VARCHAR | NN | Nome dell'argomento | *"Variabili e tipi"* |

Il **Subject** è un argomento o tag che classifica i contenuti del sistema. Rappresenta un concetto didattico — ad esempio *"Variabili e tipi"*, *"Controllo di flusso"*, *"Funzioni"*, *"Modello OSI"*.

I **Subject** sono entità stabili e condivise: non vengono mai duplicati nello snapshot. Sono referenziati sia dai template (`assessment_template_subject`, `question_template_subject`) sia dagli snapshot (`assessment_snapshot_subject`, `question_snapshot_subject`) tramite FK.

Un **Subject** può essere usato a due livelli diversi:
- **Livello assessment** — tramite **Assessment Template Subject**, per dichiarare *"questo test copre questi argomenti macro"*
- **Livello domanda** — tramite **QuestionTemplateSubject**, per dichiarare *"questa domanda specifica riguarda questo argomento"* (con un peso)

I **Subject** possono anche essere raggruppati in **Topic** tramite la tabella **Topic Subject**, per organizzare la sezione Allenamento.

:::tip
*Al momento della pubblicazione il `label` del subject viene congelato nelle tabelle snapshot subject. Se il subject viene rinominato o eliminato in futuro, i risultati delle verifiche passate continuano a mostrare il nome originale.*
:::

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Topic</h3></summary>

> **Tabella SQL:** `topic`
>
> **Collegata a:** `topic_subject`, `assessment_template_topic`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `t-python` |
| `title` | VARCHAR(200) | NN | Titolo del topic | *"Fondamenti Python"* |
| `description` | TEXT | NL | Descrizione opzionale | *"Variabili, tipi, controllo di flusso..."* |
| `abbreviation` | VARCHAR(4) | NL | Sigla breve | *"Py"* |
| `position` | INT | | Ordine nella lista | `1` |
| `parent_id` | UUID | NL, FK | Riferimento al **Topic** padre. NULL = topic radice | `t-python` |
| `enabled` | BOOLEAN | NN | Se il topic è visibile nella sezione Allenamento. Default true | `true` |

Il **Topic** è un contenitore organizzativo che supporta una gerarchia ad albero tramite il campo `parent_id`. Un topic può contenere sotto-topic e **Subject** come foglie.

Esempio di gerarchia:
- *"Programmazione Software"* (radice, parent = NULL)
  - *"Python"* (parent = "Programmazione Software")
    - *"Fondamenti I"* (parent = "Python") → contiene Subject *"Variabili"*, *"Controllo di flusso"*
  - *"JavaScript"* (parent = "Programmazione Software")
    - *"Basi"* (parent = "JavaScript") → contiene Subject *"DOM"*, *"Eventi"*

Lo studente nella sezione Allenamento vede la lista dei **Topic** attivi, ognuno con i suoi capitoli (**Subject**). Può selezionare un topic, scegliere quali capitoli esercitare, e avviare una sessione di training.

Il campo `enabled` permette di nascondere un topic dalla lista senza eliminarlo — utile per topic in preparazione.

:::tip
*Il **Topic** è un contenitore organizzativo per la navigazione, non un'entità del modello assessment. Un **Subject** come *"Variabili e tipi"* può appartenere al topic *"Fondamenti Python"* per l'allenamento, e contemporaneamente essere usato come tag su domande di assessment diversi.*
:::

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Topic Subject</h3></summary>

> **Tabella SQL:** `topic_subject`
>
> **Collegata a:** `topic`, `subject`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `topic_id` | UUID | PK, FK | Riferimento al **Topic** | `t-python` |
| `subject_id` | UUID | PK, FK | Riferimento al **Subject** | `s-variables` |
| `position` | INT | | Ordine del capitolo nel topic | `1` |

Il **Topic Subject** lega un **Topic** ai suoi capitoli (**Subject**). La relazione è M:N: un topic contiene più subject, e uno stesso subject può appartenere a più topic.

Il campo `position` definisce l'ordine in cui i capitoli appaiono all'interno del topic nella sezione Allenamento.

</details>

---

## Utenti e Ruoli

<details>
<summary><h3 style={{display: 'inline'}}>App User</h3></summary>

> **Tabella SQL:** `app_user`
>
> **Collegata a:** `app_user_role`, `student_profile`, `teacher_profile`, `teacher_class`, `notification_preference`, `submission`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Identificativo univoco | `u-alice` |
| `first_name` | VARCHAR | NN | Nome | *"Alice"* |
| `last_name` | VARCHAR | NN | Cognome | *"Rossi"* |
| `username` | VARCHAR | NN, UQ | Identificativo di login (read-only, assegnato dalla scuola) | *"a.rossi"* |
| `password_hash` | VARCHAR | NN | Hash bcrypt della password | `$2b$12$...` |
| `email` | VARCHAR | UQ | Email, opzionale, editabile dallo studente | *"alice@scuola.it"* |
| `must_change_password` | BOOLEAN | NN | Se true, forza il cambio al primo login | `false` |
| `is_active` | BOOLEAN | NN | Se false, il login viene rifiutato. Default true | `true` |
| `password_expires_at` | TIMESTAMP | NL | Scadenza della password | `NULL` |

L'**App User** è l'entità centrale del sistema: ogni persona — admin, docente o studente — ha esattamente un record qui. Contiene le credenziali di accesso e i dati anagrafici minimi.

I campi `first_name`, `last_name` e `username` sono **assegnati dalla scuola** e non modificabili dallo studente. Il campo `email` è l'unico dato personale che lo studente può aggiornare tramite la pagina Profilo (`PUT /api/users/me`).

Il campo `password_hash` contiene l'hash bcrypt della password — il sistema non conosce mai la password in chiaro.

Il campo `must_change_password` viene impostato a `true` quando l'admin crea un utente con una password temporanea. Al primo login il sistema forza lo studente a scegliere una nuova password. Il campo `password_expires_at` permette di impostare una scadenza — se la password scade, lo studente deve cambiarla al login successivo.

Il campo `is_active` permette di disattivare un account senza eliminarlo. Un utente disattivato non può fare login, ma i suoi risultati e le submission passate restano intatti nel sistema.

L'**App User** da solo non ha un ruolo — il ruolo viene assegnato tramite **App User Role**. L'appartenenza a una classe è gestita da **Student Profile** (per gli studenti) o **Teacher Class** (per i docenti).

:::tip
*Per il GDPR, la cancellazione di un account non è un delete fisico ma un'anonimizzazione: i campi personali (name, username, email) vengono sovrascritti, `is_active` viene messo a false, ma le submission e i risultati restano come record anonimi.*
:::

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>App Role</h3></summary>

> **Tabella SQL:** `app_role`
>
> **Collegata a:** `app_user_role`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `r-student` |
| `name` | VARCHAR | NN, UQ | Nome del ruolo | *"STUDENT"* |

L'**App Role** definisce i ruoli disponibili nel sistema. I valori sono fissi, creati all'avvio tramite Liquibase:

- **ADMIN** — gestisce il sistema
- **TEACHER** — crea assessment, gestisce classi
- **STUDENT** — svolge assessment, si allena

Non vengono mai modificati a runtime.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>App User Role</h3></summary>

> **Tabella SQL:** `app_user_role`
>
> **Collegata a:** `app_user`, `app_role`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `user_id` | UUID | PK, FK | Riferimento all'**App User** | `u-alice` |
| `role_id` | UUID | PK, FK | Riferimento all'**App Role** | `r-student` |

L'**App User Role** è la tabella di join che assegna un ruolo a un utente. La chiave primaria composta impedisce di assegnare lo stesso ruolo due volte allo stesso utente.

La relazione è M:N: un utente può tecnicamente avere più ruoli (es. ADMIN + TEACHER). Nell'uso attuale ogni utente ha un solo ruolo.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Notification Preference</h3></summary>

> **Tabella SQL:** `notification_preference`
>
> **Collegata a:** `app_user`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `np-01` |
| `user_id` | UUID | NN, FK | Riferimento all'**App User** | `u-alice` |
| `event` | VARCHAR(50) | NN | Cosa è successo (enum) | `EXAM_RESULT` |
| `channel` | VARCHAR(20) | NN | Dove notificare (enum) | `IN_APP` |
| `enabled` | BOOLEAN | NN | Se la notifica è attiva | `true` |

La **Notification Preference** memorizza le preferenze di notifica per ciascun utente, separando *cosa* notificare (evento) da *come* (canale).

**Eventi disponibili:**

| Evento | Chi | Descrizione |
|---|---|---|
| `EXAM_RESULT` | Studente | Risultato di un esame del docente |
| `CERT_SIMULATION_RESULT` | Studente | Risultato di una simulazione di certificazione |
| `NEW_ASSESSMENT` | Studente | Nuovo assessment assegnato alla classe |
| `DEADLINE_REMINDER` | Studente | Scadenza imminente |
| `ALL_SUBMITTED` | Docente | Tutti gli studenti hanno consegnato |

Il training non genera notifiche — lo studente lo fa per sé e vede il risultato subito.

**Canali disponibili:**

| Canale | Descrizione | Default |
|---|---|---|
| `IN_APP` | Notifica visibile dentro l'applicazione | Attivo |
| `EMAIL` | Email inviata all'utente | Disattivato |

I record vengono creati solo quando l'utente modifica le preferenze nella pagina Impostazioni. Se non ha mai interagito, il sistema applica i valori di default (IN_APP attivo, EMAIL disattivato per tutti gli eventi).

Il vincolo UNIQUE su `(user_id, event, channel)` impedisce duplicati.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Notification</h3></summary>

> **Tabella SQL:** `notification`
>
> **Collegata a:** `app_user`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `n-01` |
| `user_id` | UUID | NN, FK | Destinatario — riferimento all'**App User** | `u-alice` |
| `event` | VARCHAR(50) | NN | Tipo di evento che ha generato la notifica | `EXAM_RESULT` |
| `title` | VARCHAR(255) | NN | Titolo breve | *"Risultato esame disponibile"* |
| `message` | TEXT | NL | Messaggio dettagliato | *"Python Foundation: 18 punti"* |
| `read` | BOOLEAN | NN | Se lo studente l'ha letta. Default false | `false` |

La **Notification** è un record di notifica in-app generato dal sistema quando si verifica un evento significativo. Viene creata solo se l'utente ha il canale IN_APP attivo per quell'evento (controllato tramite **Notification Preference**).

Il FE carica le notifiche non lette ad ogni cambio pagina (`GET /api/notifications/unread`) e mostra un badge con il conteggio nella top bar. Lo studente può cliccare per aprire il pannello, leggere le notifiche e segnarle come lette.

**Eventi che generano notifiche:**

| Evento | Quando | Destinatario |
|---|---|---|
| `EXAM_RESULT` | Lo studente completa un esame | Lo studente |
| `CERT_SIMULATION_RESULT` | Lo studente completa una simulazione | Lo studente |
| `NEW_ASSESSMENT` | Il docente assegna un assessment alla classe | Gli studenti della classe |
| `DEADLINE_REMINDER` | 24h prima della scadenza | Studenti che non hanno completato |
| `ALL_SUBMITTED` | Tutti gli studenti della classe hanno consegnato | I docenti della classe |

Il training non genera notifiche.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>User Class</h3></summary>

> **Tabella SQL:** `user_class`
>
> **Collegata a:** `student_profile`, `teacher_class`, `class_assessment_assignment`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Identificativo univoco | `cl-sw26` |
| `name` | VARCHAR | NN | Nome della classe | *"SW-2026"* |

La **User Class** rappresenta una classe o sezione scolastica — ad esempio *"SW-2026"*, *"DS-2025"*. È il contenitore organizzativo a cui vengono iscritti gli studenti e a cui il docente assegna gli assessment.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Student Profile</h3></summary>

> **Tabella SQL:** `student_profile`
>
> **Collegata a:** `app_user`, `user_class`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `sp-alice` |
| `user_id` | UUID | NN, UQ, FK | Riferimento all'**App User** | `u-alice` |
| `class_id` | UUID | NN, FK | Riferimento alla **User Class** | `cl-sw26` |

Lo **Student Profile** collega un utente con ruolo STUDENT alla sua classe. La relazione con **App User** è 1:1 (vincolo UNIQUE su `user_id`): ogni studente ha un solo profilo e appartiene a una sola classe.

Se uno studente cambia classe (es. trasferimento), si aggiorna il `class_id` — non si crea un nuovo profilo.

:::tip
*Lo studente appartiene a **una sola** classe. Questa scelta semplifica il modello: quando il sistema deve mostrare gli assessment disponibili, basta guardare la classe dello studente e trovare gli snapshot assegnati a quella classe tramite **Class Test**.*
:::

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Teacher Profile</h3></summary>

> **Tabella SQL:** `teacher_profile`
>
> **Collegata a:** `app_user`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `tp-davide` |
| `user_id` | UUID | NN, UQ, FK | Riferimento all'**App User** | `u-davide` |

Il **Teacher Profile** segna un utente come docente. La relazione con **App User** è 1:1. A differenza dello studente, il docente non ha un `class_id` diretto: le classi in cui insegna sono gestite dalla tabella **Teacher Class**.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Teacher Class</h3></summary>

> **Tabella SQL:** `teacher_class`
>
> **Collegata a:** `app_user`, `user_class`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `user_id` | UUID | PK, FK | Riferimento all'**App User** (docente) | `u-davide` |
| `class_id` | UUID | PK, FK | Riferimento alla **User Class** | `cl-sw26` |

La **Teacher Class** è la tabella di join M:N tra docente e classi. Un docente può insegnare in più classi; una classe può avere più docenti.

:::tip
*Perché lo studente ha `class_id` diretto e il docente no? Lo studente appartiene a **una sola** classe → basta una FK in **Student Profile**. Il docente insegna in **più classi** → serve una tabella di join **Teacher Class** (relazione M:N). Entrambi puntano a **User Class**, ma con meccanismi diversi.*
:::

</details>

---

## Somministrazione Area

<details>
<summary><h3 style={{display: 'inline'}}>Class Assessment Assignment</h3></summary>

> **Tabella SQL:** `class_assessment_assignment`
>
> **Collegata a:** `user_class`, `assessment_snapshot`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `class_id` | UUID | PK, FK | Riferimento alla **User Class** | `cl-sw26` |
| `assessment_snapshot_id` | UUID | PK, FK | Riferimento all'**Assessment Snapshot** | `snap-01` |
| `available_from` | TIMESTAMP | NL | Da quando gli studenti possono accedere. NULL = subito | `2026-07-10 08:00` |
| `available_until` | TIMESTAMP | NL | Fino a quando. NULL = nessuna scadenza | `2026-07-12 23:59` |

La **Class Assessment Assignment** è il ponte tra *"il test è pronto"* e *"gli studenti lo vedono"*. Assegna un **Assessment Snapshot** a una **User Class** con una finestra di disponibilità.

Il docente pubblica uno snapshot, poi lo attiva per una o più classi. Da quel momento gli studenti di quelle classi vedono l'assessment nella sezione Certificazioni o Esami.

I campi `available_from` e `available_until` definiscono quando l'assessment è accessibile:

| Scenario | available_from | available_until |
|---|---|---|
| Solo nel weekend | ven 18:00 | dom 23:59 |
| Un giorno specifico | 10 lug 10:00 | 10 lug 12:00 |
| Da una certa data in poi | 10 lug 08:00 | NULL |
| Sempre disponibile | NULL | NULL |

La stessa snapshot può essere assegnata a classi diverse con finestre diverse — ad esempio *"SW-2026 fa il test questa settimana, SW-2025 la prossima"*.

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>Submission</h3></summary>

> **Tabella SQL:** `submission`
>
> **Collegata a:** `app_user`, `assessment_snapshot`, `user_answer`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `sub-01` |
| `user_id` | UUID | NN, FK | Chi sta svolgendo — riferimento all'**App User** | `u-alice` |
| `assessment_snapshot_id` | UUID | NN, FK | Quale snapshot — riferimento all'**Assessment Snapshot** | `snap-01` |
| `status` | VARCHAR | NN | Stato corrente (enum) | `IN_PROGRESS` |
| `started_at` | TIMESTAMP | NL | Quando lo studente ha cliccato *"Avvia"* | `2026-07-10 09:05` |
| `submitted_at` | TIMESTAMP | NL | Quando ha consegnato o il timer è scaduto | `2026-07-10 09:28` |
| `score` | DOUBLE | NL | Punteggio totale, calcolato alla consegna | `16.50` |

La **Submission** rappresenta una singola somministrazione: uno studente che svolge un assessment. Nasce quando lo studente clicca *"Avvia"* e attraversa 3 stati:

- **IN_PROGRESS** — lo studente sta svolgendo, le risposte vengono salvate in background
- **SUBMITTED** — lo studente ha consegnato manualmente
- **AUTO_CLOSED** — il timer è scaduto, il sistema ha chiuso automaticamente

Il campo `score` è NULL durante lo svolgimento — viene calcolato dal server alla consegna come somma dei `points_awarded` di tutte le **User Answer**. È un campo ridondante per performance: la fonte di verità è sempre ricostruibile dagli snapshot.

La **Submission** fa sempre riferimento a un **Assessment Snapshot**, mai al template. Questo garantisce che i risultati riflettano la versione esatta del test come è stato somministrato.

:::tip
*Tutte le entità della somministrazione (Submission, User Answer, User Answer Selected Option) puntano alle tabelle snapshot, non ai template. È il principio di immutabilità: il test che lo studente ha svolto non può cambiare retroattivamente, anche se il docente modifica il template e ripubblica.*
:::

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>User Answer</h3></summary>

> **Tabella SQL:** `user_answer`
>
> **Collegata a:** `submission`, `question_snapshot`, `user_answer_selected_option`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `ans-01` |
| `submission_id` | UUID | NN, FK | Riferimento alla **Submission** | `sub-01` |
| `question_snapshot_id` | UUID | NN, FK | Quale domanda — riferimento al **Question Snapshot** | `qs-01` |
| `type` | VARCHAR | NN | Tipo di risposta | `MULTIPLE_CHOICE` |
| `text` | TEXT | NL | Risposta testuale (per domande aperte) | *"La keyword def..."* |
| `motivation` | TEXT | NL | Motivazione aggiuntiva | *"Perché def è..."* |
| `flagged` | BOOLEAN | NN | Lo studente l'ha segnata *"da rivedere"* | `false` |
| `is_correct` | BOOLEAN | NL | Correttezza, calcolata alla consegna. NULL durante lo svolgimento | `true` |
| `points_awarded` | DOUBLE | NL | Punti assegnati, calcolati alla consegna. NULL durante lo svolgimento | `1.00` |

La **User Answer** è la risposta dello studente a una singola domanda. Viene creata o aggiornata ad ogni salvataggio automatico durante lo svolgimento.

I campi `is_correct` e `points_awarded` sono **NULL durante lo svolgimento** — vengono calcolati dal server al momento della consegna:

- Risposta corretta → `points_awarded = pts_correct` dello snapshot (o `points` della domanda se personalizzati)
- Risposta errata → `points_awarded = pts_wrong`
- Non risposta → `points_awarded = pts_unanswered`

Per le domande a scelta multipla, il server confronta le opzioni selezionate (in **User Answer Selected Option**) con quelle corrette nello snapshot. Per le domande aperte, il campo `text` contiene la risposta e la correzione è manuale.

Il campo `flagged` permette allo studente di segnare una domanda come *"da rivedere"* — appare come chip colorato nella mappa domande durante lo svolgimento.

:::tip
*Sia `is_correct` che `points_awarded` sono ridondanti: sono derivabili dai dati dello snapshot. Vengono persistiti per evitare di ricalcolare ad ogni lettura, ma la fonte di verità è sempre ricostruibile.*
:::

</details>

---

<details>
<summary><h3 style={{display: 'inline'}}>User Answer Selected Option</h3></summary>

> **Tabella SQL:** `user_answer_selected_option`
>
> **Collegata a:** `user_answer`, `option_snapshot`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Auto-generato | `sel-01` |
| `answer_id` | UUID | NN, FK | Riferimento alla **User Answer** | `ans-01` |
| `option_snapshot_id` | UUID | NN, FK | Quale opzione selezionata — riferimento all'**Option Snapshot** | `os-01` |

La **User Answer Selected Option** registra quale opzione lo studente ha selezionato per una domanda a scelta multipla. Il vincolo UNIQUE su `(answer_id, option_snapshot_id)` impedisce di selezionare la stessa opzione due volte.

Per ogni **User Answer** di tipo MULTIPLE_CHOICE c'è tipicamente un solo record qui (selezione singola). Il modello supporta anche la selezione multipla — in quel caso ci sarebbero più record con lo stesso `answer_id`.

Al momento della consegna, il server confronta l'`option_snapshot_id` selezionato con il campo `is_correct` dell'**Option Snapshot** per determinare se la risposta è giusta.

</details>

---
