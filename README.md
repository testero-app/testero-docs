# Testero — Documentazione

Documentazione funzionale e tecnica della piattaforma
[Testero](https://github.com/testero-app).

## Struttura

```
docs/
├── 00_introduzione.md              # Panoramica progetto
├── architettura/
│   ├── 01_stack_tecnologico.md      # Stack e dipendenze
│   ├── 02_architettura_generale.md  # Architettura sistema
│   └── 03_modello_dati.md          # ER diagram e entità
├── use-cases/
│   ├── UC_20.00_avvio_somministrazione.md
│   ├── UC_20.01_risposta_domande.md
│   └── ...
├── diagrams/                        # Diagrammi (PNG, Excalidraw, DrawIO)
└── legacy/                          # Documentazione precedente
```

## Formato

- I contenuti sono scritti in **Markdown** (leggibili su GitHub e come
  contesto AI)
- I diagrammi di interazione usano **Mermaid**, inline nei `.md`

## Licenza

[GNU Affero General Public License v3.0](LICENSE)
