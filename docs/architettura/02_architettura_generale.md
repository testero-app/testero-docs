# Architettura Generale

Il sistema è composto da un **frontend** (applicazione web single-page in Next.js) e un **backend** (API REST stateless in Spring Boot), collegati tramite chiamate HTTP con autenticazione JWT. Il database è PostgreSQL.

Il backend segue il pattern **MVC con Service Layer**: i Controller gestiscono le richieste HTTP, delegano la logica ai Service, che a loro volta accedono al database tramite i Repository (Spring Data JPA). Un sistema di **eventi e scheduler** gestisce le operazioni asincrone come la chiusura automatica delle somministrazioni allo scadere del timer.

Il frontend è un'interfaccia rivolta agli studenti: permette di autenticarsi, selezionare un assessment, svolgere la verifica con timer e navigazione tra domande, consegnare e consultare i risultati. Lo stato dell'applicazione è gestito centralmente tramite React Context.

\newpage
