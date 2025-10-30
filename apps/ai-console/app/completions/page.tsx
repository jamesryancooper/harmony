'use client';

import React from 'react';
import generateCompletion from '../../actions/generate-completion.action';

type FormState =
  | { pending: false; result?: string; tokens?: number; error?: string }
  | { pending: true; result?: string; tokens?: number; error?: string };

export default function CompletionsPage(): JSX.Element {
  const [state, formAction] = React.useActionState(
    async (prev: FormState, formData: FormData): Promise<FormState> => {
      const prompt = String(formData.get('prompt') || '');
      const model = String(formData.get('model') || '');
      const temperature = Number(formData.get('temperature') || NaN);
      const maxTokens = Number(formData.get('maxTokens') || NaN);

      const res = await generateCompletion({
        prompt,
        model: model || undefined,
        temperature: Number.isFinite(temperature) ? temperature : undefined,
        maxTokens: Number.isFinite(maxTokens) ? maxTokens : undefined
      });

      if (!res.ok) {
        return { pending: false, error: res.error };
      }

      return {
        pending: false,
        result: res.data.output,
        tokens: res.data.totalTokens
      };
    },
    { pending: false }
  );

  return (
    <main style={{ display: 'grid', gap: 16, maxWidth: 760 }}>
      <h1>Completions</h1>
      <form action={formAction} style={{ display: 'grid', gap: 12 }}>
        <textarea name="prompt" rows={6} placeholder="Enter a prompt..." required />
        <div style={{ display: 'flex', gap: 12 }}>
          <input name="model" placeholder="Model (optional)" />
          <input name="temperature" type="number" step={0.1} min={0} max={2} placeholder="0.7" />
          <input name="maxTokens" type="number" min={1} max={8192} placeholder="512" />
        </div>
        <button type="submit" disabled={state.pending}>
          {state.pending ? 'Generating…' : 'Generate'}
        </button>
      </form>
      {state.error && <p style={{ color: 'crimson' }}>{state.error}</p>}
      {state.result && (
        <section>
          <h2>Output</h2>
          <pre>{state.result}</pre>
          {!!state.tokens && <small>Tokens: {state.tokens}</small>}
        </section>
      )}
    </main>
  );
}


