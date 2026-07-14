# TODO — Funzionalità future

## Code Execution Sandbox

Implementare un sistema che esegue codice Python lato server e verifica l'output dello studente.

**Caso d'uso:** lo studente scrive codice in un editor, il sistema lo esegue in un ambiente isolato (container/sandbox) e confronta l'output con quello atteso.

**Requisiti:**
- Ambiente di esecuzione isolato (Docker container o simile)
- Timeout per evitare loop infiniti
- Restrizioni di sicurezza (no accesso filesystem, rete, ecc.)
- Supporto per più linguaggi (Python inizialmente, poi JavaScript, Java...)
- Nuovo tipo di domanda: `CODE_EXECUTION` con campi `expected_output` e `test_cases`

**Complessità:** Alta — richiede infrastruttura dedicata per l'esecuzione sicura del codice.

---
