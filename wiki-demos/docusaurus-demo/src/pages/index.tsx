import type {ReactNode} from 'react';
import Link from '@docusaurus/Link';
import Layout from '@theme/Layout';

function HomepageHeader() {
  return (
    <header style={{
      background: '#102a43',
      padding: '72px 0 56px',
      textAlign: 'center',
    }}>
      <div className="container">
        <h1 style={{
          fontSize: '44px',
          fontWeight: 800,
          color: '#ffffff',
          letterSpacing: '-0.03em',
          marginBottom: '12px',
        }}>
          Testero
        </h1>
        <p style={{
          fontSize: '16px',
          color: '#a0c0cf',
          maxWidth: '520px',
          margin: '0 auto 28px',
          lineHeight: 1.7,
        }}>
          Piattaforma open source per la somministrazione di test e verifiche in ambito didattico.
          Allenamento per argomento, simulazioni di certificazione, esami del docente.
        </p>
        <div style={{ display: 'flex', gap: '10px', justifyContent: 'center' }}>
          <Link
            className="button button--lg"
            to="/docs/modello_dati"
            style={{
              background: '#14b8a6',
              color: '#06302c',
              border: 'none',
              fontWeight: 700,
              fontSize: '14px',
              padding: '10px 24px',
            }}>
            Modello Dati
          </Link>
          <Link
            className="button button--lg"
            to="/docs/funzionalita"
            style={{
              background: 'transparent',
              color: '#ffffff',
              border: '1px solid rgba(160,192,207,0.4)',
              fontWeight: 700,
              fontSize: '14px',
              padding: '10px 24px',
            }}>
            Funzionalità
          </Link>
          <Link
            className="button button--lg"
            to="https://github.com/testero-app"
            style={{
              background: 'transparent',
              color: '#ffffff',
              border: '1px solid rgba(160,192,207,0.4)',
              fontWeight: 700,
              fontSize: '14px',
              padding: '10px 24px',
            }}>
            GitHub
          </Link>
        </div>
      </div>
    </header>
  );
}

function About() {
  return (
    <section style={{ padding: '48px 0 16px' }}>
      <div className="container" style={{ maxWidth: '720px' }}>
        <h2 style={{ fontSize: '24px', fontWeight: 800, color: '#102a43', marginBottom: '16px' }}>
          Cos'è Testero
        </h2>
        <p style={{ fontSize: '15px', color: '#334e68', lineHeight: 1.8, marginBottom: '12px' }}>
          Testero sostituisce il ciclo <em>carta → correzione → trascrizione</em> con un flusso digitale integrato.
          Il docente prepara l'assessment, lo pubblica per una classe, e gli studenti lo svolgono online con timer,
          salvataggio automatico delle risposte e correzione immediata.
        </p>
        <p style={{ fontSize: '15px', color: '#334e68', lineHeight: 1.8 }}>
          Il sistema supporta tre tipi di assessment: <strong>simulazioni di certificazione</strong> (preparazione a esami esterni),
          <strong> esami del docente</strong> (verifiche formali) e <strong>training libero</strong> (pratica per argomento senza esito).
        </p>
      </div>
    </section>
  );
}

function DocLinks() {
  const items = [
    {
      title: '📐 Modello Dati',
      description: '27 entità in 6 aree. Template, snapshot, tassonomia, utenti, somministrazione.',
      link: '/docs/modello_dati',
    },
    {
      title: '⚙️ Funzionalità',
      description: 'Diagrammi di sequenza: login, assessment, training, risultati.',
      link: '/docs/funzionalita',
    },
  ];

  return (
    <section style={{ padding: '16px 0 48px' }}>
      <div className="container" style={{ maxWidth: '720px' }}>
        <h2 style={{ fontSize: '24px', fontWeight: 800, color: '#102a43', marginBottom: '16px' }}>
          Documentazione
        </h2>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
          {items.map((item) => (
            <Link
              key={item.title}
              to={item.link}
              style={{ textDecoration: 'none', color: 'inherit' }}>
              <div style={{
                background: '#f8fafc',
                border: '1px solid #e1e6ec',
                borderRadius: '10px',
                padding: '18px 22px',
                display: 'flex',
                alignItems: 'center',
                gap: '16px',
                transition: 'box-shadow 0.12s',
              }}>
                <div>
                  <h3 style={{
                    fontSize: '15px',
                    fontWeight: 700,
                    color: '#102a43',
                    margin: '0 0 4px',
                  }}>
                    {item.title}
                  </h3>
                  <p style={{
                    fontSize: '13px',
                    color: '#6b7a89',
                    margin: 0,
                    lineHeight: 1.5,
                  }}>
                    {item.description}
                  </p>
                </div>
                <span style={{ marginLeft: 'auto', color: '#14b8a6', fontSize: '18px' }}>→</span>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}

function Stack() {
  return (
    <section style={{ padding: '0 0 56px' }}>
      <div className="container" style={{ maxWidth: '720px' }}>
        <h2 style={{ fontSize: '24px', fontWeight: 800, color: '#102a43', marginBottom: '16px' }}>
          Stack tecnologico
        </h2>
        <div style={{
          display: 'grid',
          gridTemplateColumns: '1fr 1fr',
          gap: '12px',
          fontSize: '13.5px',
          color: '#334e68',
        }}>
          <div style={{ background: '#f8fafc', border: '1px solid #e1e6ec', borderRadius: '8px', padding: '14px 18px' }}>
            <strong style={{ color: '#102a43' }}>Backend</strong><br/>
            Spring Boot · Java 21 · PostgreSQL · Liquibase
          </div>
          <div style={{ background: '#f8fafc', border: '1px solid #e1e6ec', borderRadius: '8px', padding: '14px 18px' }}>
            <strong style={{ color: '#102a43' }}>Frontend</strong><br/>
            Next.js · React · TypeScript · CSS Modules
          </div>
          <div style={{ background: '#f8fafc', border: '1px solid #e1e6ec', borderRadius: '8px', padding: '14px 18px' }}>
            <strong style={{ color: '#102a43' }}>Infrastruttura</strong><br/>
            Supabase (DB) · Render (API) · Vercel (FE)
          </div>
          <div style={{ background: '#f8fafc', border: '1px solid #e1e6ec', borderRadius: '8px', padding: '14px 18px' }}>
            <strong style={{ color: '#102a43' }}>Licenza</strong><br/>
            AGPL-3.0 · Open source
          </div>
        </div>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  return (
    <Layout title="Testero — Documentazione" description="Documentazione di sistema per Testero">
      <HomepageHeader />
      <main>
        <About />
        <DocLinks />
        <Stack />
      </main>
    </Layout>
  );
}
