# Stack Tecnologico

## Backend

| Componente | Tecnologia | Descrizione |
|------------|------------|-------------|
| Framework | Spring Boot | Application framework MVC |
| Linguaggio | Java 21 | LTS |
| Database | PostgreSQL | Qualsiasi istanza PostgreSQL compatibile |
| Migrazioni | Liquibase | Versionamento schema, eseguite all'avvio |
| Sicurezza | Spring Security + JWT | Autenticazione stateless |
| Build | Maven | Wrapper incluso (`./mvnw`) |
| Quality | Checkstyle, SpotBugs, JaCoCo | CI obbligatoria |
| Test | JUnit 5 + Mockito | Unit + integration |

## Frontend

| Componente | Tecnologia | Descrizione |
|------------|------------|-------------|
| Framework | Next.js | SSR/SPA |
| UI Library | React | |
| Linguaggio | TypeScript + JavaScript | |
| State | React Context + useReducer | Stato centralizzato |
| Quality | ESLint + TypeScript strict | CI obbligatoria |

## Infrastruttura

| Componente | Tecnologia | Descrizione |
|------------|------------|-------------|
| CI/CD | GitHub Actions | Build, test, deploy automatizzati |
| Versioning | Release Please | Changelog e tag automatici da Conventional Commits |
| Database dev | Docker Compose | PostgreSQL locale per sviluppo |
| Licenza | AGPL-3.0 | Su tutti i repository |

\newpage
