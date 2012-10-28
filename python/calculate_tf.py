#!/usr/bin/env python

import os
import re
import argparse
import mimetypes
from collections import defaultdict

from pygments.lexers import guess_lexer_for_filename
import pygments.token

# from fileblob import FileBlob

def filter_tokens(tokens):
    return filter(lambda token: token[0] == pygments.token.Token.Name
                             or token[0] == pygments.token.Token.Literal.String.Single
                             or token[0] == pygments.token.Token.Literal.String
                             or token[0] == pygments.token.Name.Constant
                             or token[0] == pygments.token.Name.Function,
                             tokens)

def recursive_file_gen(directory):
    for root, dirs, files in os.walk(directory):
        if '.git' in dirs:
            continue # ignore .git
        for f in files:
            yield os.path.join(root, f)

class Tokenizer:
    def __init__(self):
        self.word_ptn      = re.compile(r'[A-Za-z]+')
        self.first_cap_ptn = re.compile('(.)([A-Z][a-z]+)')
        self.all_cap_ptn   = re.compile('([a-z0-9])([A-Z])')

    def calculate_tf_for_directory(self, directory):
        term_freq = defaultdict(int)

        for f in recursive_file_gen(directory):
            for token in self.get_tokens(f):
                # preprocess tokens
                tokens_preprocessed = self.preprocess(token)
                for t in tokens_preprocessed:
                    term_freq[t] += 1
        return term_freq

    def get_tokens(self, filepath):
        code = open(filepath).read()
        # blob = FileBlob(filepath)

        try:
            lexer = guess_lexer_for_filename(os.path.basename(filepath), code)
            tokens = lexer.get_tokens(code)
            tokens = filter_tokens(tokens)
            tokens =  map(lambda token: token[1], tokens)
        except:
            tokens = self.word_ptn.findall(code)
        return tokens

    def preprocess(self, token):
        retval = []

        words = self.word_ptn.findall(token) # Remove/split on alphabetical characters

        # Deal with CamelCase
        for word in words:
            s1 = self.first_cap_ptn.sub(r'\1 \2', word)
            s2 = self.all_cap_ptn.sub(r'\1 \2', s1).lower()

            s = s2.split(' ')
            retval.extend(s)
        return retval


def main():
    parser = argparse.ArgumentParser(description='Calculate term frequency')
    parser.add_argument('--input', help='input directory', required=True)
    parser.add_argument('--output', help='output file', required=True)

    args = parser.parse_args()

    tokenizer = Tokenizer()
    tf = tokenizer.calculate_tf_for_directory(args.input)

    with open(args.output, 'w') as f:
        for term in sorted(tf):
            freq = tf[term]
            f.write('%s\t%s\n' % (term, freq))

if __name__ == '__main__':
    main()
