import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettierRecommended from 'eslint-plugin-prettier/recommended';

import { defineConfig } from 'eslint/config';

export default defineConfig(
  eslint.configs.recommended,
  tseslint.configs.recommended,
  prettierRecommended,
  {
    ignores: [
      'dist/**',
      'coverage/**',
      'jest.config.js',
      'src/parser.js',
      'src/parser.d.ts',
      'scripts/**',
      'tmp/**',
    ],
  },
);
