import js from '@eslint/js'
import globals from 'globals'
import reactHooks from 'eslint-plugin-react-hooks'
import reactRefresh from 'eslint-plugin-react-refresh'
import tseslint from 'typescript-eslint'
import { defineConfig, globalIgnores } from 'eslint/config'

// A function that drops its argument and does nothing: an empty body, or an arrow that only
// yields undefined or null.
const SILENT_HANDLER =
  ":matches(ArrowFunctionExpression, FunctionExpression):matches([body.type='BlockStatement'][body.body.length=0], [body.type='Identifier'][body.name='undefined'], [body.type='Literal'][body.raw='null'])"
const SILENT_CATCH_MESSAGE =
  'A silent .catch hides a failure. Show it with <LoadError onRetry={...} /> (components/ui/LoadError) or an inline notice; if silence is intended, add an eslint-disable-next-line comment saying why.'

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      js.configs.recommended,
      tseslint.configs.recommended,
      reactHooks.configs.flat.recommended,
      reactRefresh.configs.vite,
    ],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
    rules: {
      // React Compiler-era rules flag long-standing fetch-in-effect and
      // context-file patterns across most pages. Kept visible as warnings
      // until those are refactored; errors still fail CI.
      'react-hooks/set-state-in-effect': 'warn',
      'react-hooks/refs': 'warn',
      'react-refresh/only-export-components': 'warn',
      // A request that fails must say so (PRODUCT.md principle 2). Show the shared LoadError
      // (or an inline notice with Try again). A catch that stays silent on purpose needs a
      // disable comment on the line above it saying why.
      'no-restricted-syntax': [
        'error',
        ...[
          // .catch(() => {}), .catch(function () {}), .catch(() => undefined), .catch(() => null)
          `CallExpression[callee.property.name='catch'] > ${SILENT_HANDLER}.arguments`,
          // .then(onOk, () => {}) and the like: a rejection handler that swallows the failure
          `CallExpression[callee.property.name='then'] > ${SILENT_HANDLER}.arguments:nth-child(2)`,
        ].map((selector) => ({ selector, message: SILENT_CATCH_MESSAGE })),
      ],
      '@typescript-eslint/no-unused-vars': [
        'error',
        { argsIgnorePattern: '^_', varsIgnorePattern: '^_', destructuredArrayIgnorePattern: '^_' },
      ],
    },
  },
])
