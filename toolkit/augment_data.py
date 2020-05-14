import json
import collections
import argparse
from conllulex2json import load_sents

def add_token_ranges(toks, text):
    """
    For each token, add TokenRange to the MISC field.
    The format of the TokenRange field (inspired by Python) is TokenRange=start:end, where start is a zero-based
    document-level index of the start of the token (counted in Unicode characters) and end is a zero-based
    document-level index of the first character following the token (i.e., the length of the token is end-start).
    See http://ufal.mff.cuni.cz/udpipe/users-manual#run_udpipe_tokenizer_ranges
    :param toks: list of dicts for each token, modified in-place
    :param text: raw text of the sentence
    """
    start = end = 0
    for tok in toks:
        end += len(tok["word"])
        assert text[start:end] == tok["word"], (text[start:end], tok["word"], text, start, end, tok)
        misc = tok.get("misc")
        tok["misc"] = {"TokenRange": f"{start}:{end}"}
        if misc != "SpaceAfter=No":
            end += 1
        start = end


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
        aug = augs[sent_id]
        if aug is None:
            print("id:{} not in companion".format(sent_id))
        else:
            add_token_ranges(aug["toks"], aug["text"])
            mrp['companion'] = aug
            f_out.write((json.dumps(mrp) + '\n'))
