#!/bin/sh
# ideas used from https://gist.github.com/motemen/8595451

# Based on https://github.com/eldarlabs/ghpages-deploy-script/blob/master/scripts/deploy-ghpages.sh
# Used with their MIT license https://github.com/eldarlabs/ghpages-deploy-script/blob/master/LICENSE


# abort the script if there is a non-zero error
set -e

# show where we are on the machine
pwd

remote=$(git config remote.origin.url)

siteSource="$1"

# what is this..?
if [ ! -d "$siteSource" ]
then
    echo "Usage: $0 <site source dir>"
    exit 1
fi

# make a directory to put the site branch
mkdir site
cd site
# now lets setup a new repo so we can update the site branch
git config --global user.email "action@github.com" > /dev/null 2>&1
git config --global user.name "GitHub Action" > /dev/null 2>&1
git init
git remote add --fetch origin "$remote"

# switch into the the site branch
if git rev-parse --verify origin/site > /dev/null 2>&1
then
    git checkout site
    # delete any old files as we are going to replace it
    # Note: this explodes if there aren't any, so moving it here for now
    git rm -rf .
else
    git checkout --orphan site
fi

# copy over or recompile the new site
cp -a "../${siteSource}/." .

# stage any changes and new files
git add -A
# now commit, ignoring branch site doesn't seem to work, so trying skip
git commit --allow-empty -m "Deploy to GitHub branch site [ci skip]"
