#!/usr/bin/env python3

from os.path import abspath, dirname, basename, join, exists
from dirreplace import dirreplace

FROM_STRING = """
coffee/_site/edit/_box/dir
"""

TO_STRING = """
coffee/_site/edit/blog/_box/dir
"""



dirreplace(
    dirname(abspath(__file__)),
    FROM_STRING,
    TO_STRING,
)
