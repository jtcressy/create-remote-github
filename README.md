## Create a Remote Repository on GitHub using the GitHub API

Usage: ```$ ./create-github-repo.sh <REPO NAME> [private]```

Required: Create this file: ``~/.ssh/github_token`` and insert an API token from your github account into it. (e.g. ``echo "<API_TOKEN>" > ~/.ssh/github_token && chmod 600 ~/.ssh/github_token``)

You can go to https://github.com/settings/tokens to generate a new token
