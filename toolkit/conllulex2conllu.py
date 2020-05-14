#!/usr/bin/env python3
"""
Given a .conllulex file, remove all STREUSLE columns
(the last one).

Args: inputfile
"""

import os, sys, fileinput, re, json, csv
from collections import defaultdict
from itertools import chain

CONLLU = ('ID', 'FORM', 'LEMMA', 'UPOS', 'XPOS', 'FEATS', 'HEAD', 'DEPREL', 'DEPS', 'MISC')
         # 1     2       3        4       5       6        7       8         9       10
STREUSLE = ('SMWE', 'LEXCAT', 'LEXLEMMA', 'SS', 'SS2', 'WMWE', 'WCAT', 'WLEMMA', 'LEXTAG')
           # 11      12        13          14    15     16      17      18        19

FIELDS = CONLLU + STREUSLE


def simplify_to_conllu(conllulexF):
    """
    Given a .conllulex file (or iterable over lines), clear the 9 columns
    containing MWE and supersense information, and the lextag column at the end.
    """
    result = ''
    for ln in conllulexF:
        row = ln.strip()
        if row and not row.startswith('#'):
            row = row.split('\t')
            row[10:] = ['']*8
            row = '\t'.join(row)
        result += row + '\n'
    return result


if __name__=='__main__':
    inFname, = sys.argv[1:]

    with open(inFname, encoding='utf-8') as inF:
        print(simplify_to_conllu(inF), end='')
