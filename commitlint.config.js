module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'header-max-length': [2, 'always', 100],
    'scope-enum': [
      2, 'always',
      [
        'bazel',
        'buildifier',
        'buildozer',
        'builtin',
        'create',
        'jasmine',
        'karma',
        'labs',
        'rollup',
        'typescript',
      ]
    ]
  }
}
