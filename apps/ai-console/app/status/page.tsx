import React from 'react';
import { getFlagSnapshot } from '../../lib/flags';

export default function StatusPage(): JSX.Element {
  const flags = getFlagSnapshot();

  return (
    <main style={{ display: 'grid', gap: 16 }}>
      <h1>System Status</h1>
      <section>
        <h2>Flags</h2>
        <ul>
          {Object.entries(flags).map(([k, v]) => (
            <li key={k}>
              <code>{k}</code>: <strong>{String(v)}</strong>
            </li>
          ))}
        </ul>
      </section>
    </main>
  );
}


