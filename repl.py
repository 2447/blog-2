#!/usr/bin/env python3

from os.path import abspath, dirname, basename, join, exists
from dirreplace import dirreplace

FROM_STRING = """
"""

TO_STRING = """
"""



dirreplace(
    dirname(abspath(__file__)),
    FROM_STRING,
    TO_STRING,
)
