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
    {
      description: "Authenticate against the ocharted OCI registry",
      matchHost: "ocharted.alexsaphir.com",
      hostType: "docker",
      username: "{{ secrets.OCHARTED_USERNAME }}",
      password: "{{ secrets.OCHARTED_PASSWORD }}",
    },
  ],
};
