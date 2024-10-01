#!/usr/bin/env python3
import yaml as y

with open('myfile.yaml', 'r') as yaml_file:
    ouryaml = y.safe_load(yaml_file)

print(ouryaml)
