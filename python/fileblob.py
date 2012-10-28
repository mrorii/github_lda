#!/usr/bin/env python

import os

MEGABYTE = 1024 * 1024

class FileBlob:
    def __init__(self, path):
        self.path = path

    def data(self):
        return open(self.path).read()

    def size(self):
        try:
            return os.path.getsize(self.path)
        except os.error:
            return 0

    def extname(self):
        _, ext = os.path.splitext(self.path)
        return ext

    def _mime_type(self):
        pass

    def mime_type(self):
        pass

    def content_type(self):
        pass

    def encoding(self):
        pass

    def is_binary(self):
        pass

    def is_text(self):
        pass

    def is_image(self):
        self.extname() in ['.png', '.jpg', '.jpeg', '.gif', '.tif', 'tiff']

    def is_large(self):
        self.size() > MEGABYTE

    def is_safe_to_tokenize(self):
        return not self.is_large() and self.is_text() and not self.high_ratio_of_long_lines()

    def high_ratio_of_long_lines(self):
        if self.loc() == 0:
            return false
        return self.size() /  > 5000

    def loc(self):
        return len(self.lines())

    def lines(self):
        pass

    def is_viewable(self):
        pass

    def line_split_character(self):
        pass

