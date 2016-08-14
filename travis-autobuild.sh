#!/bin/bash
set -e

function createBuildPage {
	echo -e "Building build page"
	echo -e "---\ntitle: $GH_REPO Nightlies\n---" > build/index.md
	echo -e "# Automatic Build System for [$GH_REPO](https://github.com/$GH_REPO) Nightlies\n\nNightly builds are generated automatically through [Travis-CI](https://travis-ci.org/) whenever a new commit is pushed on \`$GH_CI_BRANCH\`.\n" >> build/index.md
	echo -e "## Warning: These builds may be unstable and may contain bugs. If you use these builds and find any problems, please open a new Issue at [https://github.com/$GH_REPO/issues](https://github.com/$GH_REPO/issues)\n" >> build/index.md
	echo -e "Latest commit: [#`echo $TRAVIS_COMMIT | cut -c 1-7`](https://github.com/$GH_REPO/commit/$TRAVIS_COMMIT)<br>" >> build/index.md
	echo -e "Build date: `date`\n" >> build/index.md
	echo -e "| Download Link | File Size |\n|---------------|-----------|" >> build/index.md
	cd build
	GH_REPO_ARR=(${GH_REPO//\//\ })
	GH_REPO_USER=${GH_REPO_ARR[0]}
	GH_REPOSITORY=${GH_REPO_ARR[1]}
	shopt -s nullglob
	for f in *.3ds *.3dsx *.cia *.tar *.gz *.zip; do
		echo -e "| [$f](https://$GH_REPO_USER.github.io/$GH_REPOSITORY/build/$f) | `du -h $f | cut -f1` |" >> index.md
	done
	cd ..
	echo -e "\nQR Code for Homebr3w.cia Build:<br>![QR Code](https://$GH_REPO_USER.github.io/$GH_REPOSITORY/build/QRCode.jpg)" >> build/index.md
}

if [ "$TRAVIS_REPO_SLUG" == "$GH_REPO" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "$GH_CI_BRANCH" ]; then
  echo -e "Trying to push new commit to gh_pages\n"

  git config --global user.email "travis@travis-ci.org" || true
  git config --global user.name "travis-ci" || true
  git remote set-branches --add origin gh-pages
  git fetch
  git checkout -f -t -b gh-pages origin/gh-pages
  git merge --no-commit --no-ff $GH_CI_BRANCH -m "Merge $GH_CI_BRANCH $TRAVIS_COMMIT"
  git reset
  make tarzip
  git add -f build
  git diff --staged --quiet build || {
	createBuildPage
	git add -f build/index.md
    git commit -m "Pushing build based on commit $TRAVIS_COMMIT"
	git push -fq https://"$GH_TOKEN"@github.com/"$GH_REPO" gh-pages > /dev/null
	echo -e "Pushed new build to gh_pages.\n"
	exit 0
  }
  echo -e "Nothing to commit."
fi
