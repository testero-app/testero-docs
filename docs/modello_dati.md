# Modello Dati — Testero

Le entità sono organizzate in 4 aree:

1. **Utenti e ruoli** — chi usa il sistema
2. **Assessment** — come è strutturato un test
3. **Pubblicazione** — il meccanismo di snapshot
4. **Somministrazione** — cosa succede quando lo studente svolge il test

---

## Assessment Area

<details>
<summary><h3 style={{display: 'inline'}}>Assessment Template</h3></summary>

> **Tabella SQL:** `assessment_template`
>
> **Collegata a:** `question_template`, `assessment_template_subject`, `assessment_template_topic`, `assessment_snapshot`

| Colonna | Tipo | Vincoli | Descrizione | Esempio |
|---|---|---|---|---|
| `id` | UUID | PK | Identificativo univoco | `a1b2c3...` |
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
> **Collegata a:** `assessment_template`, `question_snapshot`, `assessment_snapshot_subject`, `class_test`, `submission`

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
| `enabled` | BOOLEAN | NN | Se il topic è visibile nella sezione Allenamento. Default true | `true` |

Il **Topic** è un macro-argomento usato nella sezione Allenamento del frontend. Rappresenta un'area didattica ampia (es. *"Fondamenti Python"*, *"Reti di Calcolatori"*) che raggruppa più **Subject** come capitoli.

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
