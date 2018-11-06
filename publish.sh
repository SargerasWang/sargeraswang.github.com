#!/bin/bash

cd ~/Projects/github/sargeraswang.github.com
rake gen_deploy
git add .
git commit -m $1
git push origin source