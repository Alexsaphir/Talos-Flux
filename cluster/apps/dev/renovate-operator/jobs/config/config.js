module.exports = {
  requireConfig: 'required',
  onboardingNoDeps: 'auto',
  onboardingConfigFileName: '.gitlab/renovate.json5',

  hostRules: [
    {
      hostType: 'docker',
      matchHost: 'docker.io',
      username: process.env.DOCKER_HUB_USER,
      password: process.env.DOCKER_HUB_PASSWORD,
    },
  ],
  registryAliases: {
    '$CI_SERVER_FQDN': process.env.$CI_SERVER_FQDN,
  }
};
