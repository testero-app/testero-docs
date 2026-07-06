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
> **Collegata a:** `question`, `assessment_template_subject`, `assessment_snapshot`

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

L'**Assessment Template** è il *template modificabile di un assessment* — la bozza che il docente prepara prima di pubblicarla. Contiene le regole della verifica (durata, punteggio, quante domande estrarre, se mescolare le risposte) ma non le domande stesse, che stanno nell'entità **Question**.

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
*Non confondere con **Question Subject**: quella lega una singola **Question** a un argomento (con un peso). Questa lega l'intero **Assessment Template** a un argomento. Servono a livelli diversi: **Assessment Template Subject** dice *"di cosa parla il test nel suo insieme"*, **Question Subject** dice *"di cosa parla questa domanda specifica"*. I due insiemi non sono necessariamente uguali — una domanda potrebbe coprire un sotto-argomento (es. "List comprehension") che non è nei subject dell'assessment.*
:::

Al momento della pubblicazione, le associazioni **Assessment Template Subject** vengono copiate nella tabella **Assessment Snapshot Subject**, che congela gli argomenti macro dello snapshot indipendentemente dalle domande.

</details>

---
