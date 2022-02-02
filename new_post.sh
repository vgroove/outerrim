#!/bin/bash

REPO_DIR=$(dirname `realpath "$0"`)

usage()
{
   echo "Creates post directory and basic header."
   echo
   echo "Syntax: new_post.sh [-h] [-n POST_DIR]"
   echo "options:"
   echo "h     Print help"
   echo "n     Name of directory containing new post"
   echo
}

while getopts ":hn:" option; do
   case $option in
      h)
         usage
         exit;;
      n)
         POST_DIR=$OPTARG;;
     \?)
         echo "Error: Invalid option"
         exit;;
   esac
done

if [[ -z $POST_DIR ]]; then
    echo "Must have post directory name with no spaces!"
    exit
fi

POST_PATH=$REPO_DIR/content/posts/$POST_DIR
mkdir -p $POST_PATH/images

cat << EOF > $POST_PATH/index.md
---
author: "vgroove"
title: ""
tags: [""]
date: # Format 2021-04-22
categories: [""]
weight: 10
resources:
- src: "images/INSERT_FILENAME.jpg"
  title: ""
  name: featured
---