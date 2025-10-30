'use client';

import React from 'react';
import generateEmbedding from '../../actions/generate-embedding.action';

type FormState =
  | { pending: false; dimension?: number; error?: string }
  | { pending: true; dimension?: number; error?: string };

export default function EmbeddingsPage(): JSX.Element {
  const [state, formAction] = React.useActionState(
    async (prev: FormState, formData: FormData): Promise<FormState> => {
      const input = String(formData.get('input') || '');
      const model = String(formData.get('model') || '');

      const res = await generateEmbedding({
        input,
        model: model || undefined
      });

      if (!res.ok) {
        return { pending: false, error: res.error };
      }

      const dimension = Array.isArray(res.data.embedding) ? res.data.embedding.length : 0;
      return { pending: false, dimension };
    },
    { pending: false }
  );

  return (
    <main style={{ display: 'grid', gap: 16, maxWidth: 760 }}>
      <h1>Embeddings</h1>
      <form action={formAction} style={{ display: 'grid', gap: 12 }}>
        <textarea name="input" rows={6} placeholder="Text to embed..." required />
        <div style={{ display: 'flex', gap: 12 }}>
          <input name="model" placeholder="Model (optional)" />
        </div>
        <button type="submit" disabled={state.pending}>
          {state.pending ? 'Embedding…' : 'Generate Embedding'}
        </button>
      </form>
      {state.error && <p style={{ color: 'crimson' }}>{state.error}</p>}
      {typeof state.dimension === 'number' && !state.pending && (
        <section>
          <h2>Embedding</h2>
          <p>Vector dimension: {state.dimension}</p>
        </section>
      )}
    </main>
  );
}


