# Code Reading Club runner

[![Netlify Status](https://api.netlify.com/api/v1/badges/2a347c8e-886e-44fc-9518-52f0a2a00d64/deploy-status)](https://app.netlify.com/sites/code-reading-runner/deploys)

[Latest Release](https://runner.codereading.club)

### Prerequisites
Follow official install instructions for your setup:
- [Elm](http://elm-lang.org/) 0.19
- node
- yarn

### Development build
- `yarn start` for a hot-reload dev server

### Tests
- `yarn test`

### Production build
- `yarn build`

### Deployment
#### Needs to be configured in settings
- When a pull request is created against `main`, netlify builds a preview site
- When code is merged into `main` it is deployed to [current release](https://code-reading-runner.netlify.app)
