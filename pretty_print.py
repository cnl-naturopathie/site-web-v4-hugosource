#!/usr/bin/env python
# -*- coding: utf-8 -*-

# conda install -c conda-forge htmlmin

import glob
from bs4 import BeautifulSoup
import htmlmin


HTMLfiles = glob.glob("../site-web-v4/**/*.html",  recursive=True)

# for HTMLfile in HTMLfiles:
#     file = open(HTMLfile, "r")
#     soup = BeautifulSoup(file, "html.parser").prettify()
#     file.close()
#     file = open(HTMLfile, "w")
#     file.write(soup)
#     file.close()

for HTMLfile in HTMLfiles:
    file = open(HTMLfile, "r")
    minified = htmlmin.minify(file.read())
    file.close()

    file = open(HTMLfile, "w")
    file.write(minified)
    file.close()
