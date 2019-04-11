#!/bin/bash -e

# Enable the **/*.en.adoc below.
shopt -s globstar

# Produce the translated adoc source from the po-files.
for lang in po/??.po; do
	langcode=$(basename $lang .po)
	for doc in **/*.en.adoc; do
		po4a-translate -f asciidoc -M utf-8 -m $doc -p $lang -k 0 -l $(dirname $doc)/$(basename $doc .en.adoc).$langcode.adoc
	done
	# Convert some includes to refer to the translated versions (this needs improvement).
	perl -pi -e 's/([A-Za-z0-9_-]+).en.adoc/\1.pt.adoc/' index.$langcode.adoc
done

# Generate the output HTML and PDF.
for lang in en po/??.po; do
	langcode=$(basename $lang .po)
	asciidoctor     -a lang=$langcode index.$langcode.adoc
	asciidoctor-pdf -a lang=$langcode index.$langcode.adoc
done

# Make translation template
# po4a-gettextize -f asciidoc -M utf-8 -m index.adoc -p po/index.pot

# Update translation
# po4a-updatepo -f asciidoc -M utf-8 -m index.adoc -p po/da.po

# po4a-normalize -f asciidoc -M utf-8 po/da.po

# Translate
# po4a-translate -f asciidoc -M utf-8 -m index.adoc -p po/da.po -k 0 -l index.da.adoc
