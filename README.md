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

## Generare il PDF

Requisiti: [Typst](https://typst.app/),
[Pandoc](https://pandoc.org/),
[mermaid-cli](https://github.com/mermaid-js/mermaid-cli)

```bash
./build.sh
# Output: output/testero-docs.pdf
```

## Formato

- I contenuti sono scritti in **Markdown** (leggibili su GitHub e come
  contesto AI)
- Il PDF viene generato tramite conversione Markdown → Typst → PDF
- I diagrammi di interazione usano **Mermaid** (inline nei `.md`,
  renderizzati come PNG nel PDF)

## Licenza

[GNU Affero General Public License v3.0](LICENSE)
