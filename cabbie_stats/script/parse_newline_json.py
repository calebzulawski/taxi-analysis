#!/usr/bin/env python

import json
import sys

def parse_newline_json(fname):
    key = 'medallions'
    with open(fname, "r") as f, open("{0}-parsed.json".format(fname), 'w') as o:
        o.write('{"%s": {' % (key))
        for line in f:
            pl = json.loads(line)
            k = pl['t_medallion']
            o.write('"{0}": {1},'.format(k, line.strip()))
        o.write('"0": "blah"}}')

if __name__ == '__main__':
    parse_newline_json(sys.argv[1])
