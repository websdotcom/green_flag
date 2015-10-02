# Contributing to GreenFlag

## Developing

We're following a pretty standard process for a Github hosted project:

- Fork the project (core team members can skip this and work directly in this repo)
- Clone to your local machine
- Create a branch for your changes
- Push your branch to Github
- Submit a PR to master.
- After code review, your PR will be merged into master for inclusion in the next release.

## Release

The `gem-release` gem is included as a development dependency.  Documented here is the "normal release" process using that gem.  More options can be found here: https://github.com/svenfuchs/gem-release

- You should be on the `master` branch, with all of the releasable code merged in.
- Run `rake spec` to make sure the specs pass.
- Run this command: `gem bump --version minor --tag`
  - That's for a "minor" version.  You can also use "major" or "patch".
  - This does the following:
    - Increments the version in `lib/green_flag/version.rb` and commits that change
    - Creates a tag for the new version
    - Pushes the commits and tag to Github
- Run this command: `gem release`
  - This actually pushes the gem to RubyGems.
- In your project that uses GreenFlag, update to the latest: `bundle update green_flag`