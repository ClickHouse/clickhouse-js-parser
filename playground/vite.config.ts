import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// GitHub Pages for this repo (ClickHouse/clickhouse-js-parser) serves the site
// from the `/clickhouse-js-parser/` sub-path. Override with PLAYGROUND_BASE when
// hosting elsewhere (e.g. `PLAYGROUND_BASE=/ npm run build` for a root deploy).
const base = process.env.PLAYGROUND_BASE ?? '/clickhouse-js-parser/';

export default defineConfig({
  base,
  plugins: [react()],
});
