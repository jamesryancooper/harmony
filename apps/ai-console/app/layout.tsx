import React from 'react';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Harmony AI Console',
  description: 'Internal console for AI completions and embeddings'
};

export default function RootLayout({
  children
}: {
  children: React.ReactNode;
}): JSX.Element {
  return (
    <html lang="en">
      <body suppressHydrationWarning style={{ fontFamily: 'system-ui, sans-serif', margin: 24 }}>
        {children}
      </body>
    </html>
  );
}


