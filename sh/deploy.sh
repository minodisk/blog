rm -rf public
git subtree add --prefix public https://github.com/minodisk/minodisk.github.io.git master --squash
git subtree pull --prefix=public
hugo
git add -A
git commit -m "Updating site" && git push origin master
git subtree push --prefix=public https://github.com/minodisk/minodisk.github.io.git master
