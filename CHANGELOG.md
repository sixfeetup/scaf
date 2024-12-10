# Changelog

## [1.20.0](https://github.com/sixfeetup/scaf/compare/v1.19.1...v1.20.0) (2024-12-10)

### Features

* add documentation commands to Makefile ([#431](https://github.com/sixfeetup/scaf/issues/431)) ([824e1d6](https://github.com/sixfeetup/scaf/commit/824e1d66f8ed6bfe8ecdb25dd66191db35db2698))

### Documentation

* add qa markdown page ([#427](https://github.com/sixfeetup/scaf/issues/427)) ([0e8c0fe](https://github.com/sixfeetup/scaf/commit/0e8c0fec2037f551bd577d75ec42548e80bedc3f))
* reorganize next steps and dependencies sections + fix typos ([#426](https://github.com/sixfeetup/scaf/issues/426)) ([a7e8af6](https://github.com/sixfeetup/scaf/commit/a7e8af6c8993c3361c4269db5c0c4c71030dfa97))

## [1.19.1](https://github.com/sixfeetup/scaf/compare/v1.19.0...v1.19.1) (2024-11-20)

### Bug Fixes

* close readiness conneciton ([#423](https://github.com/sixfeetup/scaf/issues/423)) ([eee9948](https://github.com/sixfeetup/scaf/commit/eee9948738570fc4c7d680f85b43ee23dd6370dd))

## [1.19.0](https://github.com/sixfeetup/scaf/compare/v1.18.0...v1.19.0) (2024-11-08)

### Features

* enable prometheus metrics retention for 90 days ([#401](https://github.com/sixfeetup/scaf/issues/401)) ([dc36f45](https://github.com/sixfeetup/scaf/commit/dc36f45c9157f0d5680cf7bdf1f9a3390f2b2b8c))

## [1.18.0](https://github.com/sixfeetup/scaf/compare/v1.17.2...v1.18.0) (2024-11-01)

### Features

* Gfranxman/345 ensure latest version of rsync ([#400](https://github.com/sixfeetup/scaf/issues/400)) ([8dbc784](https://github.com/sixfeetup/scaf/commit/8dbc784b8e3cfac363d36592103bde49c4d9ed55))

## [1.17.2](https://github.com/sixfeetup/scaf/compare/v1.17.1...v1.17.2) (2024-10-30)

### Bug Fixes

* Do not change the ownership of the bind mounted directory ([#414](https://github.com/sixfeetup/scaf/issues/414)) ([2b4469e](https://github.com/sixfeetup/scaf/commit/2b4469e669ffefdf0370d688c727db14ae7f995e)), closes [#413](https://github.com/sixfeetup/scaf/issues/413)

### Documentation

* change readme structure ([#369](https://github.com/sixfeetup/scaf/issues/369)) ([abd3b64](https://github.com/sixfeetup/scaf/commit/abd3b649852e7bccced5d5fbc38147e4a3f4280a)), closes [#365](https://github.com/sixfeetup/scaf/issues/365)

## [1.17.1](https://github.com/sixfeetup/scaf/compare/v1.17.0...v1.17.1) (2024-10-11)

### Bug Fixes

* updating tests in install.sh to detect missing preferred bin folder. ([#404](https://github.com/sixfeetup/scaf/issues/404)) ([e694307](https://github.com/sixfeetup/scaf/commit/e694307e18357461e7bacffe157916573e8eac48)), closes [#403](https://github.com/sixfeetup/scaf/issues/403)

## [1.17.0](https://github.com/sixfeetup/scaf/compare/v1.16.1...v1.17.0) (2024-10-05)

### Features

* deploy apps with ArgoCD ([6938661](https://github.com/sixfeetup/scaf/commit/69386611ee96ec2e0278fbf57717db10bc484c7e))

## [1.16.1](https://github.com/sixfeetup/scaf/compare/v1.16.0...v1.16.1) (2024-09-25)

### Bug Fixes

* entrypoint.sh: Reorder commands so UID and GID checks work ([#395](https://github.com/sixfeetup/scaf/issues/395)) ([bd8e647](https://github.com/sixfeetup/scaf/commit/bd8e6470260a087ea639ad52eb735d7065fe6f88))

## [1.16.0](https://github.com/sixfeetup/scaf/compare/v1.15.1...v1.16.0) (2024-09-23)

### Features

* update text references to refer to Scaf instead of Sixie ([#393](https://github.com/sixfeetup/scaf/issues/393)) ([5288cf0](https://github.com/sixfeetup/scaf/commit/5288cf0ac843d7c474e6e16232b65795581f198f))

## [1.15.1](https://github.com/sixfeetup/scaf/compare/v1.15.0...v1.15.1) (2024-09-21)

### Bug Fixes

* check for python commands, fallback to python3 refs [#386](https://github.com/sixfeetup/scaf/issues/386) ([#389](https://github.com/sixfeetup/scaf/issues/389)) ([7510477](https://github.com/sixfeetup/scaf/commit/7510477414c60b35a517c1416137164e98e7a5d8))

## [1.15.0](https://github.com/sixfeetup/scaf/compare/v1.14.0...v1.15.0) (2024-09-21)

### Features

* added local registry support and improved setup (close [#353](https://github.com/sixfeetup/scaf/issues/353)) ([32de8c7](https://github.com/sixfeetup/scaf/commit/32de8c76b260f81774e087dc221c237767a0049a))
* Gfranxman/313 prefer dotlocalbin as install location ([#342](https://github.com/sixfeetup/scaf/issues/342)) ([dbb3556](https://github.com/sixfeetup/scaf/commit/dbb3556e7258a57e5105f80063f95f3222d3fd6a))
* implement s3 storage for static and media files on production ([#339](https://github.com/sixfeetup/scaf/issues/339)) ([76afd23](https://github.com/sixfeetup/scaf/commit/76afd23da1aa0867422249584a3156f43b7b974e))
* implement scaf challenge for session recording ([#379](https://github.com/sixfeetup/scaf/issues/379)) ([0c091af](https://github.com/sixfeetup/scaf/commit/0c091afbd574632350f2c4cdb43420fadb8eb317))
* **install.sh:** force re-download of Scaf on each install ([#338](https://github.com/sixfeetup/scaf/issues/338)) ([f7ef3e3](https://github.com/sixfeetup/scaf/commit/f7ef3e3ac0876c70f4c6f3e1f34a41386321e9a3))
* op inject secrets (close [#368](https://github.com/sixfeetup/scaf/issues/368)) ([58090b5](https://github.com/sixfeetup/scaf/commit/58090b56f65f35cb2c68258f0aa4f3aaf8509417))
* reorder environment variables in k8s django config ([#350](https://github.com/sixfeetup/scaf/issues/350)) ([f2cb234](https://github.com/sixfeetup/scaf/commit/f2cb2349666ecd46f24145c49b5f42bbc189c9b4))
* script to test cookiecutter part of Scaf ([952e276](https://github.com/sixfeetup/scaf/commit/952e276852afe84cdbfca062da65fcae6cad6bc8))

### Bug Fixes

* Fixes frontend tests ([#363](https://github.com/sixfeetup/scaf/issues/363)) ([4a2a5b2](https://github.com/sixfeetup/scaf/commit/4a2a5b254891fd4b1688499d17240aa93356ce81))
* mailhog port config (closes [#249](https://github.com/sixfeetup/scaf/issues/249)) ([cea1602](https://github.com/sixfeetup/scaf/commit/cea1602d99e5a03e63fc8cffcc842844bf648897))
* Specify the full container path, including the host. ([#309](https://github.com/sixfeetup/scaf/issues/309)) ([2fa7276](https://github.com/sixfeetup/scaf/commit/2fa727672fc6b8ab2a0c40550f63cf27ba3b859c)), closes [#308](https://github.com/sixfeetup/scaf/issues/308)
* Update logo ([#373](https://github.com/sixfeetup/scaf/issues/373)) ([afe2d84](https://github.com/sixfeetup/scaf/commit/afe2d849ad6db3ca05d812d1da12c02a9f127b96))
* use GitHub token for semantic release workflow ([b5eef60](https://github.com/sixfeetup/scaf/commit/b5eef607dbc4b7bad9a6037bb8bc30dd81c100d2))

### Documentation

* add disk space warning to README ([#385](https://github.com/sixfeetup/scaf/issues/385)) ([4262b2d](https://github.com/sixfeetup/scaf/commit/4262b2d0868edf3dd1b22a6aef5aac78ae203afb))
* update related to optional GraphQL ([#366](https://github.com/sixfeetup/scaf/issues/366)) ([92bfc8d](https://github.com/sixfeetup/scaf/commit/92bfc8d61f53d9845a3d7e952c96225b22e95a3d)), closes [#290](https://github.com/sixfeetup/scaf/issues/290)

## [1.14.0](https://github.com/sixfeetup/scaf/compare/v1.13.2...v1.14.0) (2024-09-04)

### Features

* update docker build-push-action to v5 and utilize github's ([#352](https://github.com/sixfeetup/scaf/issues/352)) ([cf0b2e4](https://github.com/sixfeetup/scaf/commit/cf0b2e4d0a47c6d584bcc4d76dac40bf7c538175))

## [1.13.2](https://github.com/sixfeetup/scaf/compare/v1.13.1...v1.13.2) (2024-08-28)

### Bug Fixes

* local.txt should include stuff from base ([#361](https://github.com/sixfeetup/scaf/issues/361)) ([33fbac5](https://github.com/sixfeetup/scaf/commit/33fbac5d63ff2e2fd79a8f0495eb5bc4488fd759))

## [1.13.1](https://github.com/sixfeetup/scaf/compare/v1.13.0...v1.13.1) (2024-08-28)

### Bug Fixes

* move flower to its own deployment refs [#89](https://github.com/sixfeetup/scaf/issues/89) ([#105](https://github.com/sixfeetup/scaf/issues/105)) ([8ff7033](https://github.com/sixfeetup/scaf/commit/8ff7033f115c4a79792c1cf0883798ef3d792c3a))

## [1.13.0](https://github.com/sixfeetup/scaf/compare/v1.12.0...v1.13.0) (2024-08-27)

### Features

* add automatic git remote configuration ([#336](https://github.com/sixfeetup/scaf/issues/336)) ([23e39af](https://github.com/sixfeetup/scaf/commit/23e39af0ef5bd0eaf2f808d4204d1a1cfde73e18))
* add function to check for necessary dependencies in install.sh ([#320](https://github.com/sixfeetup/scaf/issues/320)) ([4da9d4f](https://github.com/sixfeetup/scaf/commit/4da9d4fb6b9e23cf6ca3ae2720698d224c44cc66))
* add party_popper function to enhance project initiation experience ([#340](https://github.com/sixfeetup/scaf/issues/340)) ([61da47b](https://github.com/sixfeetup/scaf/commit/61da47bf8939e8824e413af5e30669138c2c0e24))
* added make setup target ([#359](https://github.com/sixfeetup/scaf/issues/359)) ([31a835b](https://github.com/sixfeetup/scaf/commit/31a835bf5815351fe35938c232c438c0deb5e6f1))
* allow hyphens and underscores in project slugs ([#341](https://github.com/sixfeetup/scaf/issues/341)) ([2d51499](https://github.com/sixfeetup/scaf/commit/2d51499dbcf09ecaf79e73a19d6bb8d4e1425392))
* improve installation script to handle preferred bin folder ([#321](https://github.com/sixfeetup/scaf/issues/321)) ([0ed6ac1](https://github.com/sixfeetup/scaf/commit/0ed6ac1dab2b419a5eda1219292f24149530729f))

## [1.12.0](https://github.com/sixfeetup/scaf/compare/v1.11.0...v1.12.0) (2024-07-29)

### Features

* add compilation step after cluster creation ([027dfb2](https://github.com/sixfeetup/scaf/commit/027dfb22e1126c10781cc1b28f2569cab81a9a4a))

## [1.11.0](https://github.com/sixfeetup/scaf/compare/v1.10.0...v1.11.0) (2024-07-27)

### Features

* simplify config options ([4b2f31e](https://github.com/sixfeetup/scaf/commit/4b2f31e1d00c5cfec9a7f4ae1ba310a89709958a))

## [1.10.0](https://github.com/sixfeetup/scaf/compare/v1.9.0...v1.10.0) (2024-07-26)

### Features

* upgrade django and python to latest stable versions ([116f41b](https://github.com/sixfeetup/scaf/commit/116f41b4ef827fe088e4ef4884eaf921a742288b))

### Documentation

* use repo_url variable for git clone example ([#288](https://github.com/sixfeetup/scaf/issues/288)) ([e12e06f](https://github.com/sixfeetup/scaf/commit/e12e06ffd5e0c44ad58a59367fc971ab65cb0df1))

## [1.9.0](https://github.com/sixfeetup/scaf/compare/v1.8.1...v1.9.0) (2024-07-23)

### Features

* added support for debuggers, with initial support for pycharm (close [#277](https://github.com/sixfeetup/scaf/issues/277)) ([c2392cb](https://github.com/sixfeetup/scaf/commit/c2392cb63c8d960f8f89b38171465039ed26a9ae))

### Documentation

* Make the generated README more contributor oriented ([#230](https://github.com/sixfeetup/scaf/issues/230)) ([3b3e63d](https://github.com/sixfeetup/scaf/commit/3b3e63df7655b070c50265f7f5e6a87aa56acacc))

## [1.8.1](https://github.com/sixfeetup/scaf/compare/v1.8.0...v1.8.1) (2024-07-09)

### Bug Fixes

* add missing semantic-release-replace-plugin ([4f99fa2](https://github.com/sixfeetup/scaf/commit/4f99fa28ee82402b11807a97aff2ae28ebe3a4fe))
* semantic release not updating version in package.json ([70cea4b](https://github.com/sixfeetup/scaf/commit/70cea4b82c8ff55eaa8e918eb2c97021ab908b01))

## [1.8.0](https://github.com/sixfeetup/scaf/compare/v1.7.1...v1.8.0) (2024-07-08)

### Features

* Adds apollo graphql ([#275](https://github.com/sixfeetup/scaf/issues/275)) ([c3d4f20](https://github.com/sixfeetup/scaf/commit/c3d4f200efbcfaa17774e793b25cd6b6bd958df9))

## [1.7.1](https://github.com/sixfeetup/scaf/compare/v1.7.0...v1.7.1) (2024-07-08)

### Bug Fixes

* keep postgres pvc across tilt restarts ([#274](https://github.com/sixfeetup/scaf/issues/274)) ([9d66187](https://github.com/sixfeetup/scaf/commit/9d66187b1deafc2fb9d153fcc74106e528979939))

## [1.7.0](https://github.com/sixfeetup/scaf/compare/v1.6.0...v1.7.0) (2024-07-08)

### Features

* upgrade to postgres 16 ([#271](https://github.com/sixfeetup/scaf/issues/271)) ([92bf493](https://github.com/sixfeetup/scaf/commit/92bf4939e2de918194e8e65d0f2121d4f20ef4b3))

## [1.6.0](https://github.com/sixfeetup/scaf/compare/v1.5.0...v1.6.0) (2024-07-08)

### Features

* use dynamic volume provisioning for postgres pvc ([#270](https://github.com/sixfeetup/scaf/issues/270)) ([c9566fd](https://github.com/sixfeetup/scaf/commit/c9566fd42eccd339a143c049b05a511d7d360d5a))

## [1.5.0](https://github.com/sixfeetup/scaf/compare/v1.4.0...v1.5.0) (2024-07-08)

### Features

* migrate to talos linux ([#252](https://github.com/sixfeetup/scaf/issues/252)) ([6437c73](https://github.com/sixfeetup/scaf/commit/6437c73242b02d8f6e00525d46ca0432e46f9f16))

## [1.4.0](https://github.com/sixfeetup/scaf/compare/v1.3.1...v1.4.0) (2024-07-08)

### Features

* Add credentials allow settings for CORS ([#272](https://github.com/sixfeetup/scaf/issues/272)) ([841c73e](https://github.com/sixfeetup/scaf/commit/841c73edec3faaab6d09131eb759c78eb59d6f22))

## [1.3.1](https://github.com/sixfeetup/scaf/compare/v1.3.0...v1.3.1) (2024-07-08)

### Bug Fixes

* run PR lint action in dev environment ([332465a](https://github.com/sixfeetup/scaf/commit/332465afad80ac37fecac1dce546c18d0c68b774))

## [1.3.0](https://github.com/sixfeetup/scaf/compare/v1.2.0...v1.3.0) (2024-07-08)

### Features

* Add Django Cors Headers ([#269](https://github.com/sixfeetup/scaf/issues/269)) ([641d5dc](https://github.com/sixfeetup/scaf/commit/641d5dcf227dc54789c89b782f7d98ec145bb639))

## [1.2.0](https://github.com/sixfeetup/scaf/compare/v1.1.0...v1.2.0) (2024-07-08)

### Features

* Update deployment manifest ([#264](https://github.com/sixfeetup/scaf/issues/264)) ([c73a6b9](https://github.com/sixfeetup/scaf/commit/c73a6b96648867038896fddd8a082e01475aeb61))

## [1.1.0](https://github.com/sixfeetup/scaf/compare/v1.0.0...v1.1.0) (2024-07-08)

### Features

* validate PR title ([6511d39](https://github.com/sixfeetup/scaf/commit/6511d39e00d91ef4d0a3c690fc94ad7ef3f3bb2d))

## 1.0.0 (2024-06-28)

### Features

* add .envrc for reading from 1Password and update readme [#78](https://github.com/sixfeetup/scaf/issues/78) ([b622f52](https://github.com/sixfeetup/scaf/commit/b622f52a4aea6c4066d474e6d8b9f262c136236b))
* add acm for cloudfront [#67](https://github.com/sixfeetup/scaf/issues/67) ([58617c2](https://github.com/sixfeetup/scaf/commit/58617c2a2559d6923d3ffb476e1eb8f60c3cb39a))
* add application module for shared manifests [#92](https://github.com/sixfeetup/scaf/issues/92) ([c6b55ff](https://github.com/sixfeetup/scaf/commit/c6b55ff0bfb86945c61eccf0c731d5bd0e93b1e6))
* add argocd controlplane [#77](https://github.com/sixfeetup/scaf/issues/77) ([e34f85d](https://github.com/sixfeetup/scaf/commit/e34f85daa63bd9f7240fa5c33e9011775e149df1))
* add aws_s3_custom_domain ([cc22cc2](https://github.com/sixfeetup/scaf/commit/cc22cc2579b97983f3c6c7e0d604853bf136304d))
* add aws_s3_custom_domain to backend ([6faafc6](https://github.com/sixfeetup/scaf/commit/6faafc6c5cdf89ce35f9005af204ac2116b4bbb5))
* add cloudfront manifests [#67](https://github.com/sixfeetup/scaf/issues/67) ([d291d18](https://github.com/sixfeetup/scaf/commit/d291d18246bb12ab86bfbcc319596c5ff66d0e8d))
* add daphne to requirements [#71](https://github.com/sixfeetup/scaf/issues/71) ([b1e1c6b](https://github.com/sixfeetup/scaf/commit/b1e1c6bbf64b320d1d79921fa9c50b0af63a9558))
* add Dockerfile ([c6389e7](https://github.com/sixfeetup/scaf/commit/c6389e749117f8431d8f5d339e09c37ea79efc72))
* add dotenv file [#108](https://github.com/sixfeetup/scaf/issues/108) ([ce65257](https://github.com/sixfeetup/scaf/commit/ce652575bc5a3a642d83c28c2abdc0c52ab1e514))
* add frontend Dockerfile ([5d387e3](https://github.com/sixfeetup/scaf/commit/5d387e38948e54984ee2cececb0c98fd3b51526b))
* add frontend tests ([f38b7d5](https://github.com/sixfeetup/scaf/commit/f38b7d5c804da2589e5e8a65f970e21208f8c895))
* add iam user with bucket access policy [#86](https://github.com/sixfeetup/scaf/issues/86) ([b2c0d3c](https://github.com/sixfeetup/scaf/commit/b2c0d3ccb0b27d90cd166eb996da864f6688decf))
* add liveness and readiness probes ([cd2f504](https://github.com/sixfeetup/scaf/commit/cd2f504adba9852f623d759dd69e4017a3a22813))
* add mailhog kustomization layer for reuse in local and sandbox ([1d7d9c7](https://github.com/sixfeetup/scaf/commit/1d7d9c7fc042eff52a938cb16626bbb36175d6b0))
* add management and ECR manifests [#74](https://github.com/sixfeetup/scaf/issues/74) ([21d58fc](https://github.com/sixfeetup/scaf/commit/21d58fcf51e519fbfb5872eb3892d18b7d47370e))
* add manifests to create ec2 instance with k3s [#66](https://github.com/sixfeetup/scaf/issues/66) ([1c4c023](https://github.com/sixfeetup/scaf/commit/1c4c0230e1f5cacd96181cfb1e1ba89b70362448))
* add Nix Flake development environment ([391ce10](https://github.com/sixfeetup/scaf/commit/391ce10e9fc12afb49092a18c44d698cb8cb9a62))
* add Nix Flake for development on Scaf ([fd7d759](https://github.com/sixfeetup/scaf/commit/fd7d759540cf416b8b7278d689a21a3f67238051))
* add route53 for prod and sandbox [#68](https://github.com/sixfeetup/scaf/issues/68) ([cd0e6cc](https://github.com/sixfeetup/scaf/commit/cd0e6cccd3324f9dc7f738c8d33b574a7844e3e3))
* add s3 storage for static content [#86](https://github.com/sixfeetup/scaf/issues/86) ([8d1f3fd](https://github.com/sixfeetup/scaf/commit/8d1f3fd62274725386f4ef52b125f2bbea52fdf5))
* add s3 storage to Django media uploads and static resources ([efd5e02](https://github.com/sixfeetup/scaf/commit/efd5e02fea39275052f28f75f0dde159fe56dd4d))
* add sealed secrets template to k8s [#78](https://github.com/sixfeetup/scaf/issues/78) ([07d92e0](https://github.com/sixfeetup/scaf/commit/07d92e0a2412a9675980c489c355c8cd3fbfc810))
* add semantic release ([805b566](https://github.com/sixfeetup/scaf/commit/805b56607be5a3b507efed3050a7b36b055faf88))
* add sentry to configmap [#76](https://github.com/sixfeetup/scaf/issues/76) ([9b7c60d](https://github.com/sixfeetup/scaf/commit/9b7c60d500d3757ed75e8f022abd97c83f2018a4))
* add sentry to react frontend [#108](https://github.com/sixfeetup/scaf/issues/108) ([50e811e](https://github.com/sixfeetup/scaf/commit/50e811e5af1d6d1eaba5485b6f33fee28d03d37e))
* add template for control plane [#78](https://github.com/sixfeetup/scaf/issues/78) ([75ebafd](https://github.com/sixfeetup/scaf/commit/75ebafdbc6eb2f914e41afee812352bb55d41c0a))
* add templates for argocd application [#77](https://github.com/sixfeetup/scaf/issues/77) ([26cba6d](https://github.com/sixfeetup/scaf/commit/26cba6d9f799c17961ddd893654b656503d9a261))
* add Tilt support. Close [#58](https://github.com/sixfeetup/scaf/issues/58) ([7c60bed](https://github.com/sixfeetup/scaf/commit/7c60bedfc90c043aa8fea5d0d689645ccc327a96))
* add Tilt support. Close [#58](https://github.com/sixfeetup/scaf/issues/58) ([5d45522](https://github.com/sixfeetup/scaf/commit/5d45522356b6a5204dd61532e3f26d8ed5a17d15))
* allow overriding template path ([d10e46a](https://github.com/sixfeetup/scaf/commit/d10e46a1ca6563ad21031b273e135dfd020d817f))
* allow public access to static s3 [#86](https://github.com/sixfeetup/scaf/issues/86) ([2895c91](https://github.com/sixfeetup/scaf/commit/2895c91e27ea8b760f70dabf6a8341ed4a3fb401))
* change service type to ClusterIP ([03b757b](https://github.com/sixfeetup/scaf/commit/03b757beb4e8b2a8eb7795c790a1cd32940bbfad))
* clean up terraform plan for scaf ([371649e](https://github.com/sixfeetup/scaf/commit/371649e3a75bdef93a87bf64e9b5101edba154c5))
* configure django for s3 storage [#86](https://github.com/sixfeetup/scaf/issues/86) ([6b363ed](https://github.com/sixfeetup/scaf/commit/6b363ed5ddefaf930616ab72a353109d846c2ba4))
* extend with cookiecutter options ([c58881a](https://github.com/sixfeetup/scaf/commit/c58881aee90047795f4efd7627ba2576bf7f9b5d))
* github actions workflow to test scaf project create ([79ed57b](https://github.com/sixfeetup/scaf/commit/79ed57b8b8009b101055e3ddb7ffbf28253cddad))
* initialize cluster with kind ([79a5d51](https://github.com/sixfeetup/scaf/commit/79a5d510a8b09bc0aaca31c20194c0ba3a36164f))
* install cert manager into cluster [#70](https://github.com/sixfeetup/scaf/issues/70) ([e4e130e](https://github.com/sixfeetup/scaf/commit/e4e130e0ef23119c844651abfed44f2321597299))
* install kubectl, kind and tilt ([899b742](https://github.com/sixfeetup/scaf/commit/899b7424bca11c8ca5152614744f873e8d6f8bc2))
* install script ([21d5839](https://github.com/sixfeetup/scaf/commit/21d5839165fb5816167bab4dcd85ffe273c6bb71))
* keep PVs across tilt restart. closes [#124](https://github.com/sixfeetup/scaf/issues/124) ([507e116](https://github.com/sixfeetup/scaf/commit/507e1167feb8d7b3988f4f6f6f6b084cd67f5393))
* keep PVs across tilt restart. closes [#124](https://github.com/sixfeetup/scaf/issues/124) ([a244ba2](https://github.com/sixfeetup/scaf/commit/a244ba22fc3a9e83d17de5519d39b84239f126bc))
* make sentry optional ([21c48ea](https://github.com/sixfeetup/scaf/commit/21c48ea98f76fe8c2b329b8e4d48bced245ed7ac))
* make sentry optional (close [#177](https://github.com/sixfeetup/scaf/issues/177)) ([b1e8c38](https://github.com/sixfeetup/scaf/commit/b1e8c388d5b7871dbc3e6e591ebf1f7d52d2c8b0))
* patch daphne into prod and sandbox manifests [#71](https://github.com/sixfeetup/scaf/issues/71) ([ea71d1f](https://github.com/sixfeetup/scaf/commit/ea71d1f0551b72f9dc3a6b12d0061f1a5893bad2))
* remove need for base64 encoded values [#78](https://github.com/sixfeetup/scaf/issues/78) ([331afaf](https://github.com/sixfeetup/scaf/commit/331afaf87e1e3d584700468ab990a7ced479da72))
* run migrations as init container ([7da6182](https://github.com/sixfeetup/scaf/commit/7da6182bc31779afd5b06843b4193b9c197bede5))
* run migrations as init container ([355e41d](https://github.com/sixfeetup/scaf/commit/355e41d3d6704215098c6f220337ebd620e3b939))
* run scaf using IMAGE_TAG environment variable ([77a2e01](https://github.com/sixfeetup/scaf/commit/77a2e010990d321d3d3becb4f7577f78de44637a))
* scaf script. WIP ([fdb17a0](https://github.com/sixfeetup/scaf/commit/fdb17a0f4b66e60b4b7d84c74fc6f63d1bdc3ab2))
* semantic-release github workflow ([6ee3021](https://github.com/sixfeetup/scaf/commit/6ee3021150d662bd00f351143d42c95f545ca6a1))
* serve static content from static_storage bucket ([c5af2e1](https://github.com/sixfeetup/scaf/commit/c5af2e159ecf16a7bc7dd8f16ae73aaf2a233d84))
* set SCAF_SCRIPT_BRANC ([b5991fb](https://github.com/sixfeetup/scaf/commit/b5991fb806ce1268cb9af911c36972fa08a1ccd6))
* simplify install, rename project and update docs. closes [#157](https://github.com/sixfeetup/scaf/issues/157) closes [#130](https://github.com/sixfeetup/scaf/issues/130) ([8585799](https://github.com/sixfeetup/scaf/commit/85857995224c593d55ae596d7aa63d6a3fe0446a))
* terraform config to set up k3s on an aws ec2 instance ([9152972](https://github.com/sixfeetup/scaf/commit/91529722f0fd1bb80ae55e7f09e2a37e5b52685e))
* tilt console output recommendation ([4e916e0](https://github.com/sixfeetup/scaf/commit/4e916e07e250b0e80e8af14f6c06f0e1fe745d4a))
* update ingress to use ingressroute [#70](https://github.com/sixfeetup/scaf/issues/70) ([4a37b2d](https://github.com/sixfeetup/scaf/commit/4a37b2da0ff21a2d3710ddc0a3589dcc02101b01))
* update k8s deployment ([2d8ded9](https://github.com/sixfeetup/scaf/commit/2d8ded90e2c5a4477d44ef1e9f1ba990677e05f0))
* use entrypoint to match host and container scaf user ([e64aace](https://github.com/sixfeetup/scaf/commit/e64aace2f712b4b17f0be2ca226b3113e1e13b2d))
* use k8s_resource to create port forwards ([6dda6cc](https://github.com/sixfeetup/scaf/commit/6dda6cc586e4923d206e10575cbb193b675f2f05))
* use semantic-release for versioning ([958917d](https://github.com/sixfeetup/scaf/commit/958917df50d7cbbdbadb491671e1c9ece7913ce5))
* use sentry/react [#108](https://github.com/sixfeetup/scaf/issues/108) ([83eacda](https://github.com/sixfeetup/scaf/commit/83eacda011c6c40ef0d6265a3f94a23027dc6205))
* use template for unencrypted secrets [#78](https://github.com/sixfeetup/scaf/issues/78) ([7bc1d37](https://github.com/sixfeetup/scaf/commit/7bc1d3770762affd2179514729812f8f2e864382))
* validate project_slug ([b4f1728](https://github.com/sixfeetup/scaf/commit/b4f172828a6794f7637781591e9df39b5c787b86))
* verify npm package integrity ([6366828](https://github.com/sixfeetup/scaf/commit/63668287ac40d7bbc18a0dd3c349a227c41f0e91))

### Bug Fixes

* add additional use_sentry checks ([9feded1](https://github.com/sixfeetup/scaf/commit/9feded1c68a632d58395a7391baccf903d576456))
* add database url to the environment ([9ad13f9](https://github.com/sixfeetup/scaf/commit/9ad13f9d3fea0a871213ee8d830160effe368786))
* add missing dependencies ([eeb9ff7](https://github.com/sixfeetup/scaf/commit/eeb9ff7a6688ec010750474f0c21095d2a550963))
* add missing env for pg_isready ([d05c074](https://github.com/sixfeetup/scaf/commit/d05c074ee7911e18bd12ad966a626254254a043c))
* add organisation to image url ([487dc9c](https://github.com/sixfeetup/scaf/commit/487dc9cad2628a4ca16987f39564d394a38b2b0b))
* add postgres host environment variable ([fbab221](https://github.com/sixfeetup/scaf/commit/fbab22182fd9a2c89ea6b9c8def8d49fae7bbd83))
* add quotes to region name ([04e0cb2](https://github.com/sixfeetup/scaf/commit/04e0cb207c7040fda2ef58ef396f788535538428))
* add secrets-config secret for local dev. close [#175](https://github.com/sixfeetup/scaf/issues/175) ([cef62cc](https://github.com/sixfeetup/scaf/commit/cef62cce756b8f5f8f33fa5eba9614f3a83d7b85))
* add secrets-config secret for local dev. close [#175](https://github.com/sixfeetup/scaf/issues/175) ([e76fb96](https://github.com/sixfeetup/scaf/commit/e76fb96089a77c60e3f43bc3e5743351fd36ec45))
* add sentry to requirements [#76](https://github.com/sixfeetup/scaf/issues/76) [#55](https://github.com/sixfeetup/scaf/issues/55) ([0bf9b6a](https://github.com/sixfeetup/scaf/commit/0bf9b6ad0e1d1dcbac4e058981eefab5f71dc873))
* add terraform to project gitignore ([344b1b3](https://github.com/sixfeetup/scaf/commit/344b1b3737ca6503abd9757736a0d5b36fca9cfc))
* ami_id output working ([3aac541](https://github.com/sixfeetup/scaf/commit/3aac54124cdad4f97f2904b09c7d47abc807a44e))
* broken install ([75a90d5](https://github.com/sixfeetup/scaf/commit/75a90d520c2ed3ae7aaa90bcdc8de5c34802df6c))
* broken kustomization yaml (closes [#218](https://github.com/sixfeetup/scaf/issues/218)) ([5e420b7](https://github.com/sixfeetup/scaf/commit/5e420b7a6006238f9e7fe9212c9324435af07de5))
* broken kustomization yaml again (closes [#218](https://github.com/sixfeetup/scaf/issues/218)) ([3e85ab6](https://github.com/sixfeetup/scaf/commit/3e85ab6af6a8765ca265de573e67882e47f40523))
* build database_url from user and password [#78](https://github.com/sixfeetup/scaf/issues/78) ([120d624](https://github.com/sixfeetup/scaf/commit/120d6245c6b285c61ebef2553101ac73ab9410a0))
* cd into project dir when running unit tests ([4976a47](https://github.com/sixfeetup/scaf/commit/4976a474c6be1a48551e5b2b4aed4914e4d8b2dc))
* change ownership after fixing scaf uid and gid ([4d1684e](https://github.com/sixfeetup/scaf/commit/4d1684eab6b28cf7700a5baa2246ff59f979f0ef))
* clean up k8s setup ([ea13adc](https://github.com/sixfeetup/scaf/commit/ea13adc588dab3d4bf78f27ac172c11e9d4645cd))
* clean up patches ([c56732d](https://github.com/sixfeetup/scaf/commit/c56732d019d981b125c1e1c409c53b6d1a3eb1d2))
* clean up sandbox, inherit from prod, patch sandbox ([06f18db](https://github.com/sixfeetup/scaf/commit/06f18db536fd353ed78c77824669fc3bb47e489b))
* cleanup new line ([2538410](https://github.com/sixfeetup/scaf/commit/253841002bbac35613581c8eaba2195667fcf6e8))
* consolidate all cookiecutter variables ([ff41d58](https://github.com/sixfeetup/scaf/commit/ff41d587d3ac28bdd630b67c5aede8b50dd1d007))
* consolidate how to read postgres_host variable ([f1697ac](https://github.com/sixfeetup/scaf/commit/f1697acfce99265298d1b3a26fdbcfd92226feed))
* create project with --no-input ([aa6cb34](https://github.com/sixfeetup/scaf/commit/aa6cb3484acc9702e84d580395617442e12cbcce))
* delete readme ([0b92814](https://github.com/sixfeetup/scaf/commit/0b92814787c549d7d796f4ef4fa7a44cc0c51e27))
* download script from branch that triggered workflow ([a0e2ae4](https://github.com/sixfeetup/scaf/commit/a0e2ae48ed09f2800aa74f805e175df5085645ab))
* export SCAF_SCRIPT_BRANCH to make it avaiable in subshells ([0b7889c](https://github.com/sixfeetup/scaf/commit/0b7889c33aa3657f9db39df6318c6c596bdc836e))
* fix copy paste ([4d657eb](https://github.com/sixfeetup/scaf/commit/4d657ebc8a9a587a3ef3f01649fe83742b3deb9f))
* fix for lint and formatting checks ([084d317](https://github.com/sixfeetup/scaf/commit/084d317f9dc75d3a13c16cd49e2c5d6b7dcdd1fc))
* fix path ([5b52a4c](https://github.com/sixfeetup/scaf/commit/5b52a4c08af45e406c4bf96a83668e83df04da08))
* groupmod: GID '20' already exists on MacOS ([191fa59](https://github.com/sixfeetup/scaf/commit/191fa59e315479fde1f1dca6b89da07a11a46057))
* include test dependencies ([2c0ff33](https://github.com/sixfeetup/scaf/commit/2c0ff33c366a029e817f5b2ea5bfe22cc6b2344a))
* install requirements before cd ([e5e284c](https://github.com/sixfeetup/scaf/commit/e5e284cac263bd5263acada0ecd3c7c16e36e53b))
* install requirements from backend dir ([635e41b](https://github.com/sixfeetup/scaf/commit/635e41b98bdee8d655b8f439b5d0badc54295a72))
* install without checking out ([342d9f2](https://github.com/sixfeetup/scaf/commit/342d9f26a1c3066aa93ff18a945d3aa7ea86d947))
* make tags mutable ([5c32917](https://github.com/sixfeetup/scaf/commit/5c3291743ad6783e1914edd1690ae3683a48028a))
* method name ([df9138c](https://github.com/sixfeetup/scaf/commit/df9138c8ade962155fa6b9a89175e196429db805))
* no need to shared with other containers ([ec92a0c](https://github.com/sixfeetup/scaf/commit/ec92a0c66a3f458a72986e744f0753f13b8c1944))
* non-interactive docker run option ([8afba7e](https://github.com/sixfeetup/scaf/commit/8afba7e7604cd69093fd3c00343471580c5b28b0))
* npm clean-install ([c44c205](https://github.com/sixfeetup/scaf/commit/c44c205b402902a607255a63f9bad6c0ac16c47d))
* only create cluster if project is created successfully ([b7e6d19](https://github.com/sixfeetup/scaf/commit/b7e6d196a7cdde451313a1d6613c22954ae95be0))
* only run on push ([b24f123](https://github.com/sixfeetup/scaf/commit/b24f123a780f8bfb99be624f0cf6de5d2e9d7bba))
* pin urllib3. Fixes [#60](https://github.com/sixfeetup/scaf/issues/60) ([fe1ba78](https://github.com/sixfeetup/scaf/commit/fe1ba78fde1f215bb65899f7e09fe62c26323fa1))
* pin urllib3. Fixes [#60](https://github.com/sixfeetup/scaf/issues/60) ([505d34e](https://github.com/sixfeetup/scaf/commit/505d34e3233c41124b5303653e12dae3a211a7b1))
* recreate readme with proper capitalization ([4a4b9b0](https://github.com/sixfeetup/scaf/commit/4a4b9b0d4bf2610ec5b93691d40397bf025864a4))
* refactor cloudfront deprecated attributes [#86](https://github.com/sixfeetup/scaf/issues/86) ([5196a32](https://github.com/sixfeetup/scaf/commit/5196a326dfae997c12199b21d66a77a8b1d8fece))
* reference sha using github context property ([6f39226](https://github.com/sixfeetup/scaf/commit/6f39226f4e330d86d495ef2487c341f4260a9c95))
* reference to branch name ([78a2f5e](https://github.com/sixfeetup/scaf/commit/78a2f5e48781a3c6163c0e0fc43409239ed428f2))
* reference to GITHUB_SHA ([d4ca3ab](https://github.com/sixfeetup/scaf/commit/d4ca3abb2eeaae4e10973f6280ade2c66637ed19))
* remove -t for non-interactive session ([d55e683](https://github.com/sixfeetup/scaf/commit/d55e68349d46f51c8106675056b8fe43a75a2970))
* remove 1pass ([be4932e](https://github.com/sixfeetup/scaf/commit/be4932e65095b555ca59268435ac06508710dfbe))
* remove build from `migrate` docker compose service ([bfb3651](https://github.com/sixfeetup/scaf/commit/bfb3651b51b0c0475f990d1c15096aad59e08ef5))
* remove control_plane files [#78](https://github.com/sixfeetup/scaf/issues/78) ([75f9924](https://github.com/sixfeetup/scaf/commit/75f99241200f57f59f021c24f040c6288723d0dc))
* remove duplicate cnpg files ([577f245](https://github.com/sixfeetup/scaf/commit/577f245d1faf5289f86f0ef30fa7a5003ac0386e))
* remove duplicate from merge ([84c32f7](https://github.com/sixfeetup/scaf/commit/84c32f70cc330fff110738b1518667be37a27882))
* remove mailhog from prod manifests [#80](https://github.com/sixfeetup/scaf/issues/80) ([14a72f2](https://github.com/sixfeetup/scaf/commit/14a72f2970a55ee8722d663daff7b563ef5bafbb))
* remove port since it defaults to 5432 ([f9a95b4](https://github.com/sixfeetup/scaf/commit/f9a95b41ffbee34aced60300c328a0a877d4c690))
* remove using patchesStrategicMerge [#80](https://github.com/sixfeetup/scaf/issues/80) ([0a81aad](https://github.com/sixfeetup/scaf/commit/0a81aade7ac312e763b9660363d7c0610c3654d3))
* rename file and policy [#86](https://github.com/sixfeetup/scaf/issues/86) ([64660ac](https://github.com/sixfeetup/scaf/commit/64660acd544e1053591c0705d3304d27c20ec290))
* rename front-end to frontend ([6706d11](https://github.com/sixfeetup/scaf/commit/6706d11b626ba012853feaece8cb3ee61e0178bb))
* rename variable ([a4348c9](https://github.com/sixfeetup/scaf/commit/a4348c9174ec977a5603e74696883707d2df67be))
* run test commands directly when CI=true ([08e96ce](https://github.com/sixfeetup/scaf/commit/08e96ce5497fe37393f87cd2492bee4c80486531))
* scaf repository url ([6e08e78](https://github.com/sixfeetup/scaf/commit/6e08e7860c03cf02e2b75a10ff5b2e0fa250f7ae))
* set POSTGRES_HOST for database url [#78](https://github.com/sixfeetup/scaf/issues/78) ([61b5782](https://github.com/sixfeetup/scaf/commit/61b57826684b0392096339dd65e3d9a99fa6e2cb))
* split os and arch in kubectl download url ([d82da68](https://github.com/sixfeetup/scaf/commit/d82da68d0b88402162f6b77c8b74977009df2825))
* step title ([63aa0b4](https://github.com/sixfeetup/scaf/commit/63aa0b4ad9ad90faa190e0f50db4970a5eaa4e19))
* strip whitespace and base64 encode env vars [#78](https://github.com/sixfeetup/scaf/issues/78) ([c72604a](https://github.com/sixfeetup/scaf/commit/c72604a28b2c398e0d486f87a756743fd1fa2030))
* update allowed hosts ([9a5a2b8](https://github.com/sixfeetup/scaf/commit/9a5a2b84d08cd7568f1223e2e63f447b797d9d3f))
* update cookiecutter template rendering ([05c4012](https://github.com/sixfeetup/scaf/commit/05c40120a7bb9fcaa6859098ef0926e85668ccf2))
* update django-storages ([d6d32d7](https://github.com/sixfeetup/scaf/commit/d6d32d71d719f499d6f8bbb6a621e0dc90b60db4))
* update formatting in readme [#78](https://github.com/sixfeetup/scaf/issues/78) ([6daa86b](https://github.com/sixfeetup/scaf/commit/6daa86bb307c8d003e4297e8b1aae8260bfc91f0))
* update gitignore ([2d1c74c](https://github.com/sixfeetup/scaf/commit/2d1c74c7fd1039bb6ac930d34943b2740bacdbd9))
* update images tag for sandbox ([171ca98](https://github.com/sixfeetup/scaf/commit/171ca985a3598657d96ccda1b854e9e21c8258a0))
* update liveliness and readiness probes, fix runserver host ([7cc5440](https://github.com/sixfeetup/scaf/commit/7cc54407e76e46a89c9abf1a40aa63c010b571d0))
* update pre_gen_project.py to also use higher python versions ([fc128e3](https://github.com/sixfeetup/scaf/commit/fc128e3010dff687b8f1562b08ff3f74b0006943))
* update sandbox dns name [#70](https://github.com/sixfeetup/scaf/issues/70) ([1364a91](https://github.com/sixfeetup/scaf/commit/1364a911adb6eb44a15c1a5e7636ffd25b0d0723))
* update script URLs to simplify testing ([e58f8b3](https://github.com/sixfeetup/scaf/commit/e58f8b3a76966ffbf3641a33126bc2992b32c62b))
* updates for s3 static storage, consolidate variables ([daac26b](https://github.com/sixfeetup/scaf/commit/daac26babe37fe31ab6c483d04395377952aa541))
* use "command -v" to check if command exists ([0c21b4a](https://github.com/sixfeetup/scaf/commit/0c21b4a9f8566ba1a319d841b78798ad74015a4d))
* use command -v to check if command exists ([96f2a6a](https://github.com/sixfeetup/scaf/commit/96f2a6a8a2eaf1edb2e6230ad72d1310933bfa96))
* use COPY instead of ADD ([860d0f6](https://github.com/sixfeetup/scaf/commit/860d0f62c1d04be28b0b167eff6aab3a60c4b3b9))
* use correct application name ([849d9d6](https://github.com/sixfeetup/scaf/commit/849d9d6826558b4a47ae63c8ab2276ef4cb3877a))
* use letsencrypt-staging by default [#70](https://github.com/sixfeetup/scaf/issues/70) ([04a2e7c](https://github.com/sixfeetup/scaf/commit/04a2e7c91244f7cd94133089efb358109d3e4979))
* use NAMESPACE in secrets template ([9aa3450](https://github.com/sixfeetup/scaf/commit/9aa3450aae0630c36d2f5a7cf0f85b0ba373fe64))
* use one template for kubeseal secrets [#78](https://github.com/sixfeetup/scaf/issues/78) ([b702e38](https://github.com/sixfeetup/scaf/commit/b702e38b5a98746ae8d7c6e9ffb555d689c0058b))
* use postgress password in place of token [#78](https://github.com/sixfeetup/scaf/issues/78) ([04e477e](https://github.com/sixfeetup/scaf/commit/04e477e910573a11c512984eb47c2cbb4c3daa7f))
* use project_dash for namespace ([3b6c5a9](https://github.com/sixfeetup/scaf/commit/3b6c5a9762a0bdc15e21616983a89cdc36bab3e6))
* use project-dash for buckets ([eaf0266](https://github.com/sixfeetup/scaf/commit/eaf0266abdb6e7f93570be0aa9b5f9e95aecae9a))
* validate terraform ([764e4dc](https://github.com/sixfeetup/scaf/commit/764e4dc84b863b78edc8276509cc8266a92d72be))
* wait for docker to be ready ([13f2067](https://github.com/sixfeetup/scaf/commit/13f20678f3f381cff4da67187ee9dd392fa166e1))
* white-space breaks yaml file ([aabf1ad](https://github.com/sixfeetup/scaf/commit/aabf1ad2885f5a3e64be7c51325dd24f2ea87a34))
* whitespace issue fixed in build-dev ([6f449bb](https://github.com/sixfeetup/scaf/commit/6f449bbcebe396aa58a6c389c91345dd68b8c943))

### Documentation

* add detailed sentry steps to docs/sentry.md [#76](https://github.com/sixfeetup/scaf/issues/76) ([248e178](https://github.com/sixfeetup/scaf/commit/248e178f814e4ea8971d76e348f1f78406c67b89))
* add explanation of what the makefile targets do [#78](https://github.com/sixfeetup/scaf/issues/78) ([411415b](https://github.com/sixfeetup/scaf/commit/411415b91fe88d8f75f84e828bf5ed927e70f2db))
* add more detailed sealedsecrets instructions [#78](https://github.com/sixfeetup/scaf/issues/78) ([0961058](https://github.com/sixfeetup/scaf/commit/0961058f7b0fedf3a73859eacb868c398c3558b3))
* add project name as arg to scaf command ([f5cd9b6](https://github.com/sixfeetup/scaf/commit/f5cd9b646731ae90e2b7f6c62aae05cb9b91788f))
* move kubernetes docs to generated project ([0f3f6ed](https://github.com/sixfeetup/scaf/commit/0f3f6ed27ff9487ea0d4d30d283cd2bf0a74f907))
* react setup docs. closes [#286](https://github.com/sixfeetup/scaf/issues/286) ([510fc38](https://github.com/sixfeetup/scaf/commit/510fc38b7399db2b8eeeb8dc450f84216eb17ca2))
* reformat and add a few missing steps ([29a008e](https://github.com/sixfeetup/scaf/commit/29a008ed468eb6fd70c1c050203ee48583e0b60f))
* remove CHANGEME from sentry variable [#76](https://github.com/sixfeetup/scaf/issues/76) ([1e3bc58](https://github.com/sixfeetup/scaf/commit/1e3bc58d4046dab800d3eb90532db173e6b28c0b))
* remove controlplane section [#78](https://github.com/sixfeetup/scaf/issues/78) ([bd0210e](https://github.com/sixfeetup/scaf/commit/bd0210e4ee6812f9f42d4a9df4d2577a3cd5cdf0))
* remove make target and link to using direnv 78 ([6ceec55](https://github.com/sixfeetup/scaf/commit/6ceec5523e6280efd300f24f5a72264d982d819a))
* remove skaffold from ec2-cluster readme [#78](https://github.com/sixfeetup/scaf/issues/78) ([2234c5d](https://github.com/sixfeetup/scaf/commit/2234c5da1bb583343c7e6360ffc7339a2db779db))
* update contributor instructions ([567f28d](https://github.com/sixfeetup/scaf/commit/567f28dc2fa3395c919420296fb01d9ff6a3a692))
* update doc strings ([3733db7](https://github.com/sixfeetup/scaf/commit/3733db7049dd7f8d09445804d6adc729bd342a2d))
* update intro, fix typos ([894ca8d](https://github.com/sixfeetup/scaf/commit/894ca8d7d86bf0a4511f54c9a2c6e85995f7458f))
* update readme ([1c1d0fd](https://github.com/sixfeetup/scaf/commit/1c1d0fd061cf86d28308d4ff1a2c64f16f38b93a))
* update readme [#76](https://github.com/sixfeetup/scaf/issues/76) ([51514d9](https://github.com/sixfeetup/scaf/commit/51514d999b382f87f0e8c92976ae1b28bf283fb6))
* update README [#77](https://github.com/sixfeetup/scaf/issues/77) ([b6f1030](https://github.com/sixfeetup/scaf/commit/b6f103097780b3a72305bb60256c934233a3d37b))
* update README [#78](https://github.com/sixfeetup/scaf/issues/78) ([e0f2cce](https://github.com/sixfeetup/scaf/commit/e0f2ccecf23e76528ce0ef7e32f6457547260645))
* update readme for creating argocd application [#77](https://github.com/sixfeetup/scaf/issues/77) ([1973e32](https://github.com/sixfeetup/scaf/commit/1973e324783fd68573d5dc4d98122b3891da3ea0))
* update readme for sealedsecrets [#78](https://github.com/sixfeetup/scaf/issues/78) ([37982f6](https://github.com/sixfeetup/scaf/commit/37982f6e43e44cb72d167d25957c4d7c10b51cab))
* update readme with Sentry instructions [#76](https://github.com/sixfeetup/scaf/issues/76) ([0b2f159](https://github.com/sixfeetup/scaf/commit/0b2f1599b17d671084bd763983486b82753f7853))
* update with new name and overview of included features ([751b599](https://github.com/sixfeetup/scaf/commit/751b59937ad8fa6e4c37c16206d44b688e093c4e))

### Refactors

* cleanup unneeded configs ([b339523](https://github.com/sixfeetup/scaf/commit/b3395234889ce71fbbc12a1c7c47360f99b4c80b))
* move argocd folder to k8s [#77](https://github.com/sixfeetup/scaf/issues/77) ([7cd8425](https://github.com/sixfeetup/scaf/commit/7cd8425044f9b867bf75834a645274e15ea638bf))
* move init backend manifest ([41de452](https://github.com/sixfeetup/scaf/commit/41de452308e9bd296ff1ceb23fa8acb3e102fd52))
* move shared manifests to module [#92](https://github.com/sixfeetup/scaf/issues/92) ([890e3db](https://github.com/sixfeetup/scaf/commit/890e3db5861e481d4502ff80c547c7f8a22af53b))
* remove argocd changes [#78](https://github.com/sixfeetup/scaf/issues/78) ([c6d9978](https://github.com/sixfeetup/scaf/commit/c6d99788dc03de899272a956278e117e422e0ee3))
