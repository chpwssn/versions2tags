# versions2tags

This script is allows you to spool through a git repository, checking package.json along the way, and adding a git tag to that commit if the `version` has been updated and there is no tag present. 

This script is useful for those developers who allow NPM to keep track of version tagging but do not have git tags created.