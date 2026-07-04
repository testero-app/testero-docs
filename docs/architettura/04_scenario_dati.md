# Scenario dati: dal setup alla verifica

Questo documento segue uno scenario realistico dall'inizio alla fine, mostrando esattamente quali record vengono creati in ogni tabella ad ogni passo.

Gli UUID sono abbreviati per leggibilità (es. `u-alice` invece di un vero UUID).

---

## Passo 1 — Setup: ruoli

Il sistema parte con 3 ruoli predefiniti (creati da Liquibase all'avvio).

**app_role**

| id | name |
|---|---|
| `r-admin` | ADMIN |
| `r-teacher` | TEACHER |
| `r-student` | STUDENT |

---

## Passo 2 — Creare gli utenti

L'admin inserisce un docente e 3 studenti. Le password sono hash bcrypt.

**app_user**

| id | name | username |
|---|---|---|
| `u-davide` | Davide Fella | `d.fella` |
| `u-alice` | Alice Rossi | `a.rossi` |
| `u-bob` | Bob Bianchi | `b.bianchi` |
| `u-carol` | Carol Verdi | `c.verdi` |

Password: hash bcrypt (`$2b$12$...`). Email: `d.fella@scuola.it` per Davide, `NULL` per gli studenti.

**app_user_role** — assegna i ruoli

| user_id | role_id |
|---|---|
| `u-davide` | `r-teacher` |
| `u-alice` | `r-student` |
| `u-bob` | `r-student` |
| `u-carol` | `r-student` |

---

## Passo 3 — Creare la classe e iscrivere

**user_class**

| id | name |
|---|---|
| `cl-sw26` | SW-2026 |

**teacher_profile** — il docente esiste come profilo teacher

| id | user_id |
|---|---|
| `tp-davide` | `u-davide` |

**teacher_class** — il docente insegna in SW-2026

| user_id | class_id |
|---|---|
| `u-davide` | `cl-sw26` |

**student_profile** — ogni studente è iscritto alla classe

| id | user_id | class_id |
|---|---|---|
| `sp-alice` | `u-alice` | `cl-sw26` |
| `sp-bob` | `u-bob` | `cl-sw26` |
| `sp-carol` | `u-carol` | `cl-sw26` |

> **Cosa abbiamo ora**: 4 utenti, 1 classe, 1 docente che insegna in quella classe, 3 studenti iscritti. Nessun assessment ancora.

---

## Passo 4 — Creare gli argomenti (subject) e i topic

Gli argomenti sono i "tag" che classificano le domande. I topic sono macro-contenitori usati per l'allenamento.

**subject**

| id | label |
|---|---|
| `s-osi` | Modello OSI |
| `s-tcp` | TCP/IP |
| `s-cmd` | Comandi Linux |

**topic**

| id | title | abbreviation | position | enabled |
|---|---|---|---|---|
| `t-reti` | Reti di Calcolatori | RETI | 1 | true |

**topic_subject** — il topic "Reti" contiene 2 capitoli

| topic_id | subject_id | position |
|---|---|---|
| `t-reti` | `s-osi` | 1 |
| `t-reti` | `s-tcp` | 2 |

> **Cosa abbiamo ora**: una struttura di argomenti. "Reti di Calcolatori" ha 2 capitoli: Modello OSI e TCP/IP. "Comandi Linux" esiste ma non è in nessun topic (potrebbe stare in un topic "Sistemi Operativi" futuro).

---

## Passo 5 — Creare l'assessment (bozza)

Il docente crea un assessment "Reti di Calcolatori" con 5 domande nel pool, ne estrae 3 per ogni studente, +1 punto per risposta corretta, -0.25 per errata.

**assessment_template** (tabella fisica dell'entità AssessmentTemplate)

| id | title | type | difficulty |
|---|---|---|---|
| `a-reti` | Reti di Calcolatori | CERT_SIMULATION | INTERMEDIATE |

Data: 2026-07-10. Timer 30 min, 3 domande per assessment. Punteggio: +1.00 corretta / −0.25 errata / 0 non risposta, soglia 2.00. Shuffle domande e opzioni attivi.

**assessment_subject** — l'assessment copre 2 argomenti

| assessment_template_id | subject_id |
|---|---|
| `a-reti` | `s-osi` |
| `a-reti` | `s-tcp` |

---

## Passo 6 — Creare le domande e le opzioni

5 domande nel pool, ognuna con 4 opzioni.

**question** — tutte `assessment_template_id = a-reti`, tipo MULTIPLE_CHOICE, `code = NULL`

- `q1`: "Quanti livelli ha il modello OSI?" — BEGINNER, pos. 1
- `q2`: "Quale protocollo opera al livello 4?" — INTERMEDIATE, pos. 2
- `q3`: "Cosa fa il livello di rete?" — INTERMEDIATE, pos. 3
- `q4`: "Qual è la porta standard di HTTP?" — BEGINNER, pos. 4
- `q5`: "Quale protocollo è connectionless?" — ADVANCED, pos. 5, `points = 2.00` (vale il doppio)

Le altre hanno `points = NULL` (usano `pts_correct` dell'assessment = 1.00). Ogni domanda ha un campo `explanation` visibile solo nel ripasso.

**option** (mostriamo le opzioni di q1 e q2, le altre seguono lo stesso pattern)

| id | question_id | text | is_correct |
|---|---|---|---|
| `o1a` | `q1` | 5 | false |
| `o1b` | `q1` | 7 | true |
| `o1c` | `q1` | 4 | false |
| `o1d` | `q1` | Nessuna delle precedenti | false |
| `o2a` | `q2` | HTTP | false |
| `o2b` | `q2` | TCP | true |
| `o2c` | `q2` | ARP | false |
| `o2d` | `q2` | DNS | false |

Posizioni da 1 a 4 per ogni domanda. `is_fallback = false` per tutte tranne `o1d` e `o2d` che sono fallback (`is_fallback = true`).

**question_subject** — lega ogni domanda ai suoi argomenti

| question_id | subject_id | weight |
|---|---|---|
| `q1` | `s-osi` | 1.00 |
| `q2` | `s-tcp` | 1.00 |
| `q3` | `s-osi` | 1.00 |
| `q4` | `s-tcp` | 1.00 |
| `q5` | `s-tcp` | 0.60 |
| `q5` | `s-osi` | 0.40 |

> Nota: `q5` pesa su entrambi gli argomenti (60% TCP, 40% OSI). Questo permette il breakdown del punteggio per argomento nei risultati.

> **Cosa abbiamo ora**: un assessment completo in bozza con 5 domande, 20 opzioni, legami agli argomenti. Non è ancora visibile agli studenti.

---

## Passo 7 — Pubblicare (creare lo snapshot)

Il docente clicca "Pubblica". Il sistema crea una **copia congelata** di tutto: assessment, domande, opzioni, legami argomento.

**assessment_snapshot**

| id | assessment_id | version | title |
|---|---|---|---|
| `snap-reti-v1` | `a-reti` | 1 | Reti di Calcolatori |

Content hash: `a3f8c2e1...`. Timer 30 min, 3 domande per assessment. Punteggio: +1.00 / −0.25 / 0, soglia 2.00. Tipo: CERT_SIMULATION, difficoltà: INTERMEDIATE. Pubblicato: 2026-07-10 08:00.

**question_snapshot** (copia delle 5 domande) — tutte in `snap-reti-v1`, MULTIPLE_CHOICE

| id | originale | points |
|---|---|---|
| `qs1` | `q1` | NULL |
| `qs2` | `q2` | NULL |
| `qs3` | `q3` | NULL |
| `qs4` | `q4` | NULL |
| `qs5` | `q5` | 2.00 |

Stessi testi delle domande originali, posizioni da 1 a 5.

**option_snapshot** (copia delle opzioni — mostriamo quelle di qs1)

| id | question_snapshot_id | text | is_correct |
|---|---|---|---|
| `os1a` | `qs1` | 5 | false |
| `os1b` | `qs1` | 7 | true |
| `os1c` | `qs1` | 4 | false |
| `os1d` | `qs1` | Nessuna delle precedenti | false |

Opzioni originali: `os1a`→`o1a`, `os1b`→`o1b`, `os1c`→`o1c`, `os1d`→`o1d`. Posizioni da 1 a 4. `is_fallback = true` solo per `os1d`.

**question_snapshot_subject** (copia dei legami argomento)

| question_snapshot_id | subject_id | weight |
|---|---|---|
| `qs1` | `s-osi` | 1.00 |
| `qs2` | `s-tcp` | 1.00 |
| `qs3` | `s-osi` | 1.00 |
| `qs4` | `s-tcp` | 1.00 |
| `qs5` | `s-tcp` | 0.60 |
| `qs5` | `s-osi` | 0.40 |

> **Perché lo snapshot?** Se domani il docente corregge un errore in una domanda e ripubblica, viene creato `snap-reti-v2`. Ma Alice che ha già svolto la v1 continua a vedere i suoi risultati sulla v1. Le somministrazioni sono immutabili.

---

## Passo 8 — Attivare per la classe

Il docente attiva lo snapshot per la classe SW-2026. Da questo momento gli studenti lo vedono nella sezione "Certificazioni".

**class_test**

| class_id | assessment_snapshot_id | activated_at | deactivated_at |
|---|---|---|---|
| `cl-sw26` | `snap-reti-v1` | 2026-07-10 08:00 | NULL |

> `deactivated_at = NULL` significa che è ancora attivo. Quando il docente lo disattiva, mette la data e gli studenti non lo vedono più (ma i risultati restano).

---

## Passo 9 — Alice svolge la verifica

Alice clicca "Avvia" nella sezione Certificazioni. Il sistema:
1. Estrae 3 domande random dal pool di 5 (es. q1, q2, q5)
2. Crea una submission

**submission**

| id | user_id | status | score |
|---|---|---|---|
| `sub-alice` | `u-alice` | IN_PROGRESS | NULL |

Assessment snapshot: `snap-reti-v1`. Iniziata: 2026-07-10 09:05, non ancora consegnata (`submitted_at = NULL`).

Alice risponde alle domande una alla volta. Ad ogni risposta il FE salva in background:

**user_answer** (durante lo svolgimento, prima della consegna)

| id | submission_id | question_snapshot_id | flagged | is_correct |
|---|---|---|---|---|
| `ans1` | `sub-alice` | `qs1` | false | NULL |
| `ans2` | `sub-alice` | `qs2` | true | NULL |
| `ans3` | `sub-alice` | `qs5` | false | NULL |

Tutte MULTIPLE_CHOICE. `points_awarded = NULL` durante lo svolgimento (calcolato alla consegna).

> Nota: `is_correct` e `points_awarded` sono NULL durante lo svolgimento. Vengono calcolati solo alla consegna. Alice ha flaggato la domanda 2 ("da rivedere").

**user_answer_selected_option** — le opzioni selezionate da Alice

| id | answer_id | option_snapshot_id |
|---|---|---|
| `sel1` | `ans1` | `os1b` (7 — corretta!) |
| `sel2` | `ans2` | `os2a` (HTTP — errata!) |
| `sel3` | `ans3` | `os5b` (UDP — corretta!) |

---

## Passo 10 — Alice consegna

Alice clicca "Consegna". Il server:
1. Imposta `status = SUBMITTED`, `submitted_at = now()`
2. Per ogni risposta, confronta l'opzione selezionata con quella corretta
3. Calcola `is_correct` e `points_awarded`
4. Somma il punteggio totale

**submission** (dopo la consegna)

| id | user_id | status | score |
|---|---|---|---|
| `sub-alice` | `u-alice` | SUBMITTED | 2.75 |

Assessment snapshot: `snap-reti-v1`. Iniziata: 2026-07-10 09:05, consegnata: 2026-07-10 09:28.

**user_answer** (dopo il calcolo del punteggio)

| id | is_correct | points_awarded |
|---|---|---|
| `ans1` | **true** | **1.00** |
| `ans2` | **false** | **-0.25** |
| `ans3` | **true** | **2.00** |

Tutte relative a `sub-alice`. `ans1` → `qs1`, `ans2` → `qs2`, `ans3` → `qs5`. Flagged: `ans2` era flaggata da Alice, le altre no.

> Calcolo punteggio: 1.00 + (-0.25) + 2.00 = **2.75** su un massimo di 4.00 (1+1+2).
> Soglia: 2.00 → Alice ha **superato** la verifica.

---

## Passo 11 — Alice fa un allenamento (training)

Alice va nella sezione "Allenamento", sceglie il topic "Reti di Calcolatori", seleziona solo il capitolo "Modello OSI", difficolta "tutte", 2 domande.

Il sistema:
1. Crea uno snapshot **senza assessment padre** (training mode)
2. Estrae 2 domande random che hanno `subject = s-osi`

**assessment_snapshot** (training — nota `assessment_id = NULL`)

| id | assessment_id | version | title |
|---|---|---|---|
| `snap-train-1` | NULL | 1 | Allenamento — Modello OSI |

Tipo: TRAINING, timer: 0 (senza timer), 2 domande per assessment. Pubblicato: 2026-07-10 10:00.

**submission** (training)

| id | user_id | status | score |
|---|---|---|---|
| `sub-train` | `u-alice` | IN_PROGRESS | NULL |

Assessment snapshot: `snap-train-1`. Iniziata: 2026-07-10 10:01.

> Differenze dal certification: `type = TRAINING`, `timer_minutes = 0` (senza timer), `assessment_id = NULL`. Il flusso di domande/risposte/consegna è identico.

---

## Riepilogo: quanti record per scenario

| Tabella | Record creati | Quando |
|---|---|---|
| app_role | 3 | Setup iniziale |
| app_user | 4 | Creazione utenti |
| app_user_role | 4 | Assegnazione ruoli |
| user_class | 1 | Creazione classe |
| teacher_profile | 1 | Setup docente |
| teacher_class | 1 | Docente → classe |
| student_profile | 3 | Iscrizione studenti |
| subject | 3 | Setup argomenti |
| topic | 1 | Setup topic |
| topic_subject | 2 | Capitoli del topic |
| assessment_template | 1 | Bozza assessment |
| question | 5 | Domande nel pool |
| option | 20 | 4 opzioni × 5 domande |
| question_subject | 6 | Legami domanda-argomento |
| assessment_subject | 2 | Argomenti dell'assessment |
| assessment_snapshot | 2 | 1 publish + 1 training |
| question_snapshot | 7 | 5 dal publish + 2 dal training |
| option_snapshot | 28 | 20 dal publish + 8 dal training |
| question_snapshot_subject | 8 | Copie dei legami |
| class_test | 1 | Attivazione per classe |
| submission | 2 | 1 certificazione + 1 allenamento |
| user_answer | 5 | 3 cert + 2 training |
| user_answer_selected_option | 5 | 1 per risposta |
| notification_preference | 0 | Nessuna preferenza impostata |

**Totale: ~77 record** per uno scenario minimo con 1 docente, 3 studenti, 1 assessment e 1 allenamento.

\newpage
