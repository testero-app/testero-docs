# Modello Dati

## Diagramma ER

Il diagramma ER completo è disponibile in `docs/diagrams/data_model_v4.png` e `docs/diagrams/data_model_v4_relational.png`.

## Entità Principali

### Utenti e Ruoli

| Tabella | Descrizione |
|---------|-------------|
| `app_user` | Account utente |
| `app_role` | Definizione ruolo |
| `app_user_role` | Associazione utente-ruolo (M:N) |
| `teacher_profile` | Profilo docente |
| `student_profile` | Profilo studente, associato a una classe |
| `user_class` | Classe o sezione |
| `teacher_class` | Associazione docente-classe (M:N) |

### Assessment (mutabili)

| Tabella | Descrizione |
|---------|-------------|
| `assessment` | Template dell'assessment con titolo, data, timer, difficoltà e regole di punteggio |
| `question` | Domanda con tipo, testo, eventuale snippet di codice e posizione |
| `option` | Opzione di risposta con testo, correttezza e posizione |
| `subject` | Materia o argomento |
| `class_assessment` | Pubblicazione di un assessment per una classe |

### Snapshot (immutabili)

| Tabella | Descrizione |
|---------|-------------|
| `assessment_snapshot` | Copia congelata dell'assessment al momento della pubblicazione |
| `question_snapshot` | Copia congelata della domanda |
| `option_snapshot` | Copia congelata dell'opzione |

### Submission

| Tabella | Descrizione |
|---------|-------------|
| `submission` | Record della submission con stato, timestamp e punteggio |
| `user_answer` | Singola risposta dello studente |
| `user_answer_selected_option` | Opzioni selezionate dallo studente per le domande a scelta multipla |

## Livelli di Difficoltà

Il campo `difficulty` su `assessment` e `assessment_snapshot` usa un enum con 4 livelli:

| Valore | Significato |
|--------|-------------|
| `BEGINNER` | Concetti introduttivi |
| `INTERMEDIATE` | Conoscenze consolidate |
| `ADVANCED` | Padronanza approfondita |
| `EXPERT` | Specializzazione avanzata |

Il campo è nullable: gli assessment creati prima dell'introduzione del campo non hanno un livello assegnato.

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

\newpage
