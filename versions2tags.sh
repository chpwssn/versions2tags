#!/bin/bash

# Versions2Tags spools through commits and when there is a new package.json version number and
# no git tag is present, it creates a new tag with that version string.
HEAD=$(git log --format="%h" -n 1)
REVCOMMITS=$(git log --format="%h" --reverse)

for COM in $REVCOMMITS
do  
    echo "Processing commit $COM"
    # Check if package.json was modified in this commit
    DELTA=$(git diff-tree --no-commit-id --name-only $COM | grep "package.json")
    if [[ $DELTA != "" ]]
    then
        echo "package.json modified in this commit..."
        git checkout $COM
        if [ -f "package.json" ]
        then
            # Fetch package.json version from the commit
            VERSION=$(cat package.json | grep version | sed "s/ *[\"']version[\"']: *[\"']\([^\"']*\)[\"']/\1/")
            echo "package.json version is: $VERSION"
            # Check to see if version is tagged at this commit
            TAGS=$(git tag -l --points-at $COM | grep "$VERSION")
            if [[ $TAGS == "" ]]
            then
                echo "No tag present for this version change, adding one."
                # No tags with that version present, create a new one
                git tag -m$VERSION $VERSION
            else
                echo "This version is already tagged."
            fi
        fi
    else
        echo "package.json not modified in this commit..."
    fi
    echo "Finished"
done

git checkout $HEAD
