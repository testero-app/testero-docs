# Funzionalità

Questa sezione documenta le funzionalità implementate nella piattaforma. Per ogni funzionalità è descritta la logica di alto livello e il flusso operativo dettagliato.

## Autenticazione (UC 01.00)

Gli utenti accedono al sistema tramite username (o email) e password. Il sistema supporta tre profili: studente, docente e amministratore. Lo studente è associato a una classe, il docente può gestire più classi.

### Flusso

1. L'utente inserisce username o email e password nel form di login
2. Il sistema verifica le credenziali
3. Se valide, l'utente viene autenticato e reindirizzato alla selezione assessment
4. Se l'utente è uno studente, il sistema recupera anche la classe di appartenenza

In caso di credenziali errate, il sistema mostra un messaggio di errore e l'utente può riprovare. Dopo un periodo di inattività la sessione scade e l'utente deve autenticarsi nuovamente.

## Somministrazione Assessment (UC 20.00)

Il cuore della piattaforma. Lo studente seleziona un assessment disponibile per la propria classe, lo avvia e risponde alle domande entro un tempo limite configurabile dal docente. Le domande supportate sono a scelta multipla (con opzione "Nessuna delle precedenti" e campo motivazione) e a risposta aperta.

### Flusso — Avvio

1. Lo studente visualizza la lista degli assessment disponibili per la propria classe
2. Seleziona un assessment e visualizza le informazioni: titolo, durata, numero di domande, regole di punteggio
3. Preme "Inizia" e conferma
4. Il sistema crea una sessione di somministrazione e avvia il timer
5. Lo studente viene portato alla prima domanda

Se lo studente ha già una sessione in corso per lo stesso assessment (es. dopo un refresh della pagina), il sistema restituisce la sessione esistente e lo studente riprende da dove aveva lasciato.

### Flusso — Risposta a Domande (UC 20.01)

1. Il sistema mostra una domanda alla volta con una sidebar di navigazione
2. Lo studente legge la domanda e seleziona o scrive la risposta
3. Quando naviga a un'altra domanda (tramite pulsanti, sidebar o frecce da tastiera), la risposta corrente viene salvata automaticamente in background
4. Lo studente può navigare liberamente tra le domande, modificando le risposte in qualsiasi momento
5. La sidebar mostra in tempo reale: domanda corrente, risposte date, domande vuote e progresso percentuale

Le domande a **scelta multipla** presentano opzioni con lettere (A, B, C, D, E). Se presente l'opzione "Nessuna delle precedenti", selezionandola compare un campo per la motivazione. Le domande a **risposta aperta** offrono un'area di testo libero.

Il salvataggio in background è silenzioso: se fallisce per un problema di rete, lo studente non viene interrotto. Le risposte sono mantenute localmente e vengono tutte reinviate alla consegna finale.

## Consegna e Chiusura Automatica (UC 20.02)

La somministrazione si conclude in due modi: consegna volontaria da parte dello studente, oppure chiusura automatica allo scadere del timer.

### Flusso — Consegna Manuale

1. Lo studente preme "Consegna test"
2. Il sistema chiede se vuole rivedere le risposte
3. Se sì, viene mostrato un riepilogo completo di tutte le risposte
4. Dal riepilogo, lo studente può tornare al test oppure confermare la consegna
5. Alla conferma, il sistema chiude la somministrazione e calcola il punteggio
6. Lo studente viene portato alla pagina dei risultati

### Flusso — Chiusura Automatica

1. Il timer raggiunge lo zero
2. Il sistema chiude automaticamente la somministrazione
3. Il punteggio viene calcolato sulle risposte salvate fino a quel momento
4. Se non ci sono risposte salvate, il punteggio è zero

Se lo studente preme "Consegna" nello stesso istante in cui il timer scade, il sistema garantisce che solo una delle due operazioni abbia effetto.

## Recovery Sessioni Interrotte (UC 20.03)

Se il server si riavvia durante una somministrazione in corso (per deploy, crash o manutenzione), il sistema recupera automaticamente tutte le sessioni rimaste aperte.

### Meccanismi

**All'avvio dell'applicazione**: il sistema cerca tutte le somministrazioni in corso. Se il tempo è scaduto, le chiude immediatamente calcolando il punteggio. Se il tempo non è ancora scaduto, programma un nuovo task di chiusura automatica.

**Pulizia notturna**: ogni notte alle 00:01 il sistema verifica se ci sono somministrazioni ancora aperte con tempo scaduto e le chiude. Questo funge da rete di sicurezza per casi limite.

Il risultato è che nessuna somministrazione resta aperta indefinitamente.

## Snapshot Immutabili

Quando un assessment viene pubblicato per una classe, il sistema crea una copia immutabile (*snapshot*) dell'assessment, delle domande e delle opzioni. Le somministrazioni degli studenti fanno riferimento allo snapshot, non all'assessment originale.

Questo garantisce che modifiche successive all'assessment da parte del docente non alterino le verifiche già in corso o completate. Ogni pubblicazione con contenuto diverso genera una nuova versione dello snapshot; se il contenuto non è cambiato, il sistema riutilizza lo snapshot esistente.

## Calcolo Punteggio (UC 30.00)

Alla chiusura della somministrazione (manuale o automatica), il sistema calcola il punteggio.

### Regole

| Tipo domanda | Esito | Punti |
|-------------|-------|-------|
| Scelta multipla | Corretta (selezione esatta) | `pts_correct` (es. +1.0) |
| Scelta multipla | Errata (selezione diversa) | `pts_wrong` (es. -0.25) |
| Scelta multipla | Non data (nessuna selezione) | 0 |
| Risposta aperta | In attesa di correzione manuale | 0 |

I punteggi per risposta corretta e per risposta errata sono configurabili per ogni assessment. Le risposte aperte non vengono valutate automaticamente: la correzione è demandata al docente.

## Risultati e Storico (UC 30.01)

### Risultati Post-Consegna

Subito dopo la consegna, lo studente vede la pagina dei risultati con: percentuale di risposte corrette, errate e non date, e il punteggio totale. Può scaricare un file ZIP con i risultati.

### Storico

Dall'area personale, lo studente può consultare lo storico di tutte le somministrazioni completate. Per ogni somministrazione sono visibili: titolo dell'assessment, data, punteggio. Selezionando una somministrazione, lo studente accede alla revisione dettagliata che mostra ogni domanda con la risposta data, la risposta corretta e l'esito (corretta in verde, errata in rosso, non data in grigio, risposta aperta in attesa in giallo).

## Profilo Utente (UC 40.00)

L'utente autenticato può consultare i propri dati di profilo e modificare la propria password.

### Consultazione Profilo

L'endpoint `GET /users/me` restituisce: nome, username, email, classe di appartenenza (per gli studenti) e ruolo (STUDENT, TEACHER). I dati sono estratti dal database a partire dall'identità presente nel token JWT.

### Cambio Password

L'endpoint `PUT /users/me/password` permette di cambiare la propria password. La richiesta richiede la password corrente (per conferma d'identità), la nuova password e la conferma. Il sistema verifica che:

- La password corrente sia corretta
- La nuova password e la conferma corrispondano
- La nuova password sia diversa dalla precedente
- La nuova password rispetti i requisiti di sicurezza: almeno 8 caratteri, una lettera maiuscola e un numero

In caso di validazione fallita, il sistema restituisce un errore specifico per ogni caso.

## Tentativi Multipli

Lo studente può ripetere un assessment più volte. Ogni tentativo genera una somministrazione separata con il proprio punteggio, visibile nello storico.

## Export Risultati

Al termine della somministrazione, lo studente può scaricare un file ZIP contenente i risultati in formato strutturato.

\newpage
