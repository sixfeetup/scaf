'use strict';

module.exports = {
  branches: ['main'],
  plugins: [
    [
      '@semantic-release/commit-analyzer',
      {
        preset: 'conventionalcommits',
      },
    ],
    [
      '@semantic-release/release-notes-generator',
      {
        preset: 'conventionalcommits',
        presetConfig: {
          types: [
            { type: 'feat', section: 'Features' },
            { type: 'fix', section: 'Bug Fixes' },
            { type: 'chore', hidden: true },
            { type: 'docs', section: 'Documentation' },
            { type: 'style', hidden: true },
            { type: 'refactor', section: 'Refactors' },
            { type: 'perf', section: 'Performance' },
            { type: 'test', hidden: true },
            { type: 'depr', section: 'Deprecations' },
          ],
        },
      },
    ],
    [
      '@semantic-release/changelog',
      {
        changelogFile: 'CHANGELOG.md',
        changelogTitle: '# Changelog',
      },
    ],
    [
      'semantic-release-replace-plugin',
      {
        replacements: [
          {
            files: ['backend/{{ cookiecutter.project_slug }}/__init__.py'],
            from: '__version__ = ".*"',
            to: '__version__ = "${nextRelease.version}"',
            results: [
              {
                file: 'backend/{{ cookiecutter.project_slug }}/__init__.py',
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
            ],
            countMatches: true,
          },
        ],
      },
    ],
    [
      '@semantic-release/git',
      {
        assets: ['backend/{{ cookiecutter.project_slug }}/__init__.py', 'CHANGELOG.md'],
        message:
          'chore(release): ${nextRelease.version}\n\n${nextRelease.notes}',
      },
    ],
    '@semantic-release/github',
  ],
};
