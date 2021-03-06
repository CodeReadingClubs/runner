# Elm project

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
- When code is merged into `main` it is deployed to [current release](https://SITENAME.netlify.app)
