import React from 'react';
import Link from 'next/link';

export default function HomePage(): JSX.Element {
  return (
    <main style={{ display: 'grid', gap: 12 }}>
      <h1>Harmony AI Console</h1>
      <p>Select a tool:</p>
      <ul style={{ display: 'grid', gap: 8, listStyle: 'none', padding: 0 }}>
        <li>
          <Link href="/completions">Completions Playground</Link>
        </li>
        <li>
          <Link href="/embeddings">Embeddings Playground</Link>
        </li>
        <li>
          <Link href="/status">System Status</Link>
        </li>
      </ul>
    </main>
  );
}


