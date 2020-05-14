import json
import collections
import argparse
from conllulex2json import load_sents

parser = argparse.ArgumentParser(description='Augment Data')
parser.add_argument("conllulex", type=str, help="Augment CoNLL-U/CoNLL-U-Lex/JSON file")
parser.add_argument("mrp", type=str, help="Input MRP file")
parser.add_argument("output", type=str, help="Output Augmented file")
args = parser.parse_args()

conlllex_file = args.conllulex
mrp_file = args.mrp
out_file = args.output

with open(conlllex_file, 'r', encoding='utf8') as f_c:
    augs = {sent["sent_id"].replace("reviews-", ""): sent for sent in load_sents(f_c)}
with open(mrp_file, 'r', encoding='utf8') as f_in, open(out_file, 'w', encoding='utf8') as f_out:
    for line in f_in:
        mrp = json.loads(line, object_pairs_hook=collections.OrderedDict)
        sent_id = mrp['id']
        if sent_id not in augs:
            print("id:{} not in companion".format(sent_id))
        else:
            mrp['companion'] = augs[sent_id]
            f_out.write((json.dumps(mrp) + '\n'))
