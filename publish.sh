#!/bin/bash

cd ~/Projects/github/sargeraswang.github.com
git pull
rake gen_deploy
git add .
git commit -m $1
git push origin source