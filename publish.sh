#!/bin/bash

if [ !$1 ]; then
	$1 = 'auto commit by shell'
fi
cd ~/Projects/github/sargeraswang.github.com
rake generate
rake deploy
git add .
git commit -m '$1'
git push origin source