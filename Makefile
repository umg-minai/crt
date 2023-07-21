GUIX:=/usr/local/bin/guix
GUIXTM:=${GUIX} time-machine --channels=guix/channels.scm -- \
		shell --manifest=guix/manifest.scm
DATA:=data/extdata/cvc.csv

.DELETE_ON_ERROR:

.PHONEY: clean guix-pin-channels work

all: work

## start guix development environment
work: guix/channels.pinned.scm
	${GUIXTM}

## pinning guix channels to latest commits
guix-pin-channels: guix/channels.pinned.scm

guix/channels.pinned.scm: guix/channels.scm
	${GUIX} time-machine --channels=guix/channels.scm -- \
		describe -f channels > guix/channels.pinned.scm

## data/intdata and data/scripts are not part of the git repository
anonymize-data: $(DATA)

$(DATA): \
	data/intdata/ZVK-Doku.xlsx \
	data/scripts/01-anonymize-and-prepare.R
	${GUIX} time-machine --channels=guix/channels.scm -- \
		shell --manifest=guix/manifest-data-preparation.scm -- \
		Rscript data/scripts/01-anonymize-and-prepare.R

clean:
