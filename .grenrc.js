module.exports = {
  dataSource: 'prs',
  prefix: '',
  onlyMilestones: false,
  ignoreIssuesWith: ['ignore-for-release'],
  ignoreLabels: [
    'semver-major',
    'semver-minor',
    'semver-patch',
    'closed',
    'breaking-change',
    'bug',
    'enhancement',
    'dependencies',
    'documentation',
    'chore',
    'new-feature',
  ],
  tags: 'all',
  override: true,
  generate: true,
  groupBy: {
    'Major Changes': ['semver-major', 'breaking-change'],
    'Minor Changes': ['semver-minor', 'enhancement', 'new-feature'],
    Dependencies: ['dependencies'],
    'Bug Fixes': ['semver-patch', 'bug'],
    Documentation: ['documentation'],
    'Technical Tasks': ['chore'],
    Other: ['...'],
  },
  changelogFilename: 'CHANGELOG.md',
  username: 'qovery',
  repo: 'qovery-openapi-spec',
  template: {
    issue: '- {{name}} [{{text}}]({{url}}) by [{{user_login}}]({{user_url}})',
    release: '## {{release}} ({{date}})\n{{body}}',
    changelogTitle: '# Changelog\n\n',
    group: function (placeholders) {
      const iconMap = {
        Enhancements: '🚀',
        'Minor Changes': '🚀',
        'Bug Fixes': '🐛',
        Documentation: '📚',
        'Technical Tasks': '⚙️',
        'Major Changes': '💣',
        Dependencies: '🔗',
      };
      const icon = iconMap[placeholders.heading] || '🙈';
      return '\n#### ' + icon + ' ' + placeholders.heading + ':\n';
    },
  },
};
