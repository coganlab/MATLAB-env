# MATLAB-env
environment in which most of the cogan lab MATLAB scripts are run
## Cloning
Since this repo used github's large file storage, I recommend running the `git lfs clone <repo address>` instead of the regular `git clone` command
## Startup Code
```
path = fullfile(userpath, 'MATLAB-env');
addpath(genpath(path));
```
## Test Functionality
`testfunction(struct())`
