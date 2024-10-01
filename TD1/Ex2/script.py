#!/usr/bin/env python3
import yaml
from pprint import pprint

with open('person.yaml', 'r') as yaml_file:
    ouryaml = yaml.safe_load(yaml_file)

pprint(ouryaml, sort_dicts=False)
