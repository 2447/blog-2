#!/usr/bin/env python3

from os.path import abspath, dirname, basename, join, exists
from dirreplace import dirreplace

FROM_STRING = """
System.import("./_slide")
"""

TO_STRING = """
System.import("coffee/_site/edit/_slide")
"""



dirreplace(
    dirname(abspath(__file__)),
    FROM_STRING,
    TO_STRING,
)
