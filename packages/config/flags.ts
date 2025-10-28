export type FlagName =
  | 'enableNewNav'
  | 'betaApi'
  | 'useEdgeCache';

const defaults: Record<FlagName, boolean> = {
  enableNewNav: false,
  betaApi: false,
  useEdgeCache: true
};

function envBool(name: string): boolean | undefined {
  const val = process.env[name];
  if (val === undefined) return undefined;
  return /^(1|true|yes|on)$/i.test(val);
}

export function isFlagEnabled(flag: FlagName): boolean {
  // ENV override convention: HARMONY_FLAG_<FLAGNAME>
  const env = envBool(`HARMONY_FLAG_${flag.toUpperCase()}`);
  if (env !== undefined) return env;
  return defaults[flag];
}

export function listFlags(): Readonly<Record<FlagName, boolean>> {
  return {
    enableNewNav: isFlagEnabled('enableNewNav'),
    betaApi: isFlagEnabled('betaApi'),
    useEdgeCache: isFlagEnabled('useEdgeCache')
  } as const;
}

