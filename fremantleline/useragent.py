# -*- coding: utf-8 -*-
#    Fremantle Line: Transperth trains live departure information
#    Copyright (C) 2011  Matt Austin
from urllib import FancyURLopener


class URLOpener(FancyURLopener):
    version = 'FremantleLine/0.1 (Fremantle Line; ' \
        '+https://gitorious.org/fremantle-line)'

