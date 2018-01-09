#!/usr/bin/env python3


def parse(vue):
    vue = vue.replace('methods', 'func')
    return vue

URL = "https://raw.githubusercontent.com/vuejs/vue/dev/dist/vue.js"

import requests
from os.path import dirname, join

ROOT = dirname(__file__)


def main():
    vue = requests.get(URL).content.decode('utf-8','ignore')

    with open(join(ROOT, 'vue.js'),"w") as f:
        f.write(parse(vue))

main()
