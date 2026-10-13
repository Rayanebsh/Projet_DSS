#!/bin/bash
# Utilise xmllint directement s'il existe, sinon passe par WSL
if command -v xmllint >/dev/null 2>&1; then XL="xmllint"; else XL="wsl xmllint"; fi

echo "== v1 : bien formé + valide DTD =="
$XL --noout --valid observations_v1.xml && echo "OK"

echo "== v2 : valide XSD =="
$XL --noout --schema observations.xsd observations_v2.xml && echo "OK"

echo "== tests : ces fichiers DOIVENT échouer =="
for f in tests/*.xml; do
  if $XL --noout --schema observations.xsd "$f" 2>/dev/null; then
    echo "PROBLÈME : $f est accepté alors qu'il devrait être refusé"
  else
    echo "OK (refusé comme prévu) : $f"
  fi
done