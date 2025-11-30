module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
    "/node_modules/**",
    "jest.config.js",
    "babel.config.js",
  ],
  plugins: ["@typescript-eslint", "import", "unused-imports", "prettier", "prefer-arrow"],
  rules: {
    // default linter
    // error rules
    "no-debugger": "error",
    "no-var": "error",
    "no-irregular-whitespace": [
      "error",
      {
        skipStrings: true,
        skipComments: true,
        skipRegExps: true,
        skipTemplates: true,
      },
    ],

    // warn, ignore rules
    "no-console": ["warn", { allow: ["error", "warn", "info"] }],
    "generator-star-spacing": ["warn", { before: false, after: true }],
    "prefer-const": "warn",
    "padded-blocks": [
      "off",
      {
        blocks: "always",
        classes: "always",
        switches: "never",
      },
    ],
    "no-multi-spaces": "warn",
    "comma-dangle": "warn",
    "no-trailing-spaces": "warn",
    indent: ["warn", 2, { SwitchCase: 1, ignoredNodes: ["ConditionalExpression", "MemberExpression"] }],
    semi: ["warn", "always"],
    "comma-spacing": "warn",
    "max-len": [
      "warn",
      {
        code: 120,
        ignoreStrings: true,
      },
    ],
    "space-before-blocks": "warn",
    quotes: ["warn", "double"],
    "object-curly-spacing": ["warn", "always"],
    "keyword-spacing": "warn",
    "no-empty": "warn",
    // スペースに関する警告は、prettier に任せる。
    "space-before-function-paren": "off",
    "brace-style": "off",
    capIsNew: 0,
    "quote-props": ["warn", "as-needed"],
    capIsNewExceptions: 0,
    "eol-last": ["warn", "always"],
    "operator-linebreak": ["warn", "after", { overrides: { "?": "before", ":": "before" } }],
    // jsdoc-plugin に設定を依存する
    "valid-jsdoc": [0],
    "require-jsdoc": [0],

    // plugin linter

    // prettier
    "prettier/prettier": [
      "warn",
      {
        semi: true,
        singleQuote: false,
        trailingComma: "es5",
        printWidth: 120,
        tabWidth: 2,
        bracketSpacing: true,
        bracketSameLine: true,
        useTabs: false,
      },
    ],

    // typescript
    "@typescript-eslint/no-unused-vars": "off",
    "@typescript-eslint/no-non-null-assertion": "off",
    "@typescript-eslint/no-namespace": [0],
    "@typescript-eslint/ban-types": ["error", { types: { "{}": false } }],
    "@typescript-eslint/no-empty-function": ["warn", { allow: ["private-constructors", "protected-constructors"] }],

    // import
    "import/order": [
      "warn",
      {
        groups: ["builtin", "external", ["internal", "parent", "sibling", "index", "object", "type"]],
        "newlines-between": "always",
        pathGroupsExcludedImportTypes: ["builtin"],
        alphabetize: { order: "asc", caseInsensitive: true },
        pathGroups: [{ pattern: "src/config.ts", group: "external", position: "before" }],
      },
    ],
    "import/no-unresolved": 0,
    "import/prefer-default-export": 0,

    // unused-import
    "unused-imports/no-unused-imports": "warn",

    // prefer-arrow
    // アロー関数を強制させるために導入
    // eslint デフォルトの prefer-arrow-callback では、クラスメソッドを強制できないので、プラグインを使用している
    "prefer-arrow/prefer-arrow-functions": [
      "error",

      // 個人による作成で、思わぬ挙動が多いので、デフォルト値であっても、全てのオプションを明示的に定義している
      // https://github.com/TristonJ/eslint-plugin-prefer-arrow#configuration
      {
        disallowPrototype: false,
        // true にすれば、このルールを、return １行のみの関数にだけ適応させるようにするオプション
        //   👎 : function () { return 1; }
        //   👍 : () => 1
        // これを true にすると、他のオプションが上書きされるので false に設定する。
        singleReturnOnly: false,
        // このプラグインを導入する理由。クラスメソッドの定義をアロー関数に強制する。
        classPropertiesAllowed: true,
        // グローバル定義の場合、アロー関数を矯正するかどうか。
        // グローバルでは、可読性のため、function 定義を推奨したいので true。
        allowStandaloneDeclarations: true,
      },
    ],
  },
};
