#!/bin/bash

cd ~/Projects/github/sargeraswang.github.com
rake generate
rake deploy
git add .
git commit -m $1
git push origin source