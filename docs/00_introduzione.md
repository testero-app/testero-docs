# Introduzione

## Cos'è Testero

Testero è una piattaforma open source per la somministrazione di test e verifiche in ambito didattico, pensata per scuole private, enti di formazione, insegnanti e formatori.

Il problema che risolve è semplice: sostituire il ciclo manuale *carta → correzione → trascrizione* con un flusso di lavoro digitale integrato. Il docente prepara l'assessment, lo pubblica per una classe, e gli studenti lo svolgono online con timer, salvataggio automatico delle risposte e correzione immediata delle domande a risposta multipla.

Il progetto è rilasciato sotto licenza **GNU Affero General Public License v3.0** (AGPL-3.0). Il codice sorgente è pubblico e le contribuzioni sono benvenute seguendo il modello DCO (Developer Certificate of Origin).

## Versione Corrente

| Componente | Versione |
|------------|----------|
| **Backend** | v1.9.1 |
| **Frontend** | v1.3.0 |

Ultimo aggiornamento: 13 giugno 2026.

## Repositories

| Repository | Descrizione |
|------------|-------------|
| **testero-backend** | API REST e logica di business |
| **testero-web** | Interfaccia utente per studenti |
| **testero-docs** | Questa documentazione |

## Contratto API

Il confine fra i due repository è descritto da un unico artefatto: la specifica OpenAPI
pubblicata dal backend in `docs/openapi.json`.

Il file viene rigenerato dall'applicazione in esecuzione a ogni `./mvnw test` e va committato
insieme alla modifica che lo cambia; la CI del backend fallisce se resta indietro. Il frontend
non descrive più a mano le forme dei payload: genera i propri tipi TypeScript da quella
specifica (`npm run sync:openapi && npm run generate:api-types`), e anche lì la CI fallisce se
il file generato è disallineato.

La specifica dichiara, per ogni campo di risposta, se è garantito e se può valere `null`:
poiché nessun DTO usa `@JsonInclude`, ogni campo è sempre serializzato ed è quindi `required`,
mentre quelli che possono essere nulli sono marcati `nullable`. È ciò che permette al frontend
di trattare un cambio di contratto come errore di compilazione anziché come bug a runtime.

\newpage
