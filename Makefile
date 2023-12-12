GUIX:=/usr/local/bin/guix
GUIXTM:=${GUIX} time-machine --channels=guix/channels.pinned.scm -- \
		shell --manifest=guix/manifest.scm
RSCRIPT=Rscript --vanilla
DATA:=data/extdata/cvc.csv
MANUSCRIPT:=manuscript
SECTIONDIR:=sections
OUTPUTDIR:=output
DISTDIR:=distribute
RMD=$(wildcard $(SECTIONDIR)/*.Rmd)

DATE=$(shell date +'%Y%m%d')
GITHEAD=$(shell git rev-parse --short HEAD)
GITHEADL=$(shell git rev-parse HEAD)

.DELETE_ON_ERROR:

.PHONEY: \
	clean clean-dist clean-output \
	dist guix-pin-channels \
	regenerate-data env

all: manuscript

manuscript: $(OUTPUTDIR)/$(MANUSCRIPT).html

$(OUTPUTDIR):
	@mkdir -p $(OUTPUTDIR)

$(OUTPUTDIR)/%.html: %.Rmd $(RMD) $(DATA) guix/channels.pinned.scm guix/manifest.scm | $(OUTPUTDIR)
	${GUIXTM} -- \
		${RSCRIPT} -e "rmarkdown::render('$<', output_dir = '$(OUTPUTDIR)')"

$(OUTPUTDIR)/%.docx: %.Rmd $(RMD) $(DATA) guix/channels.pinned.scm guix/manifest.scm | $(OUTPUTDIR)
	${GUIXTM} -- \
		${RSCRIPT} -e "rmarkdown::render('$<', output_format = 'bookdown::word_document2', output_dir = '$(OUTPUTDIR)')"

$(DISTDIR):
	@mkdir -p $(DISTDIR)

dist: $(OUTPUTDIR)/$(MANUSCRIPT).docx $(OUTPUTDIR)/$(MANUSCRIPT).html | $(DISTDIR)
	cp $(OUTPUTDIR)/$(MANUSCRIPT).docx $(DISTDIR)/"$(DATE)_$(GITHEAD)_$(MANUSCRIPT).docx"
	cp $(OUTPUTDIR)/$(MANUSCRIPT).html $(DISTDIR)/"$(DATE)_$(GITHEAD)_$(MANUSCRIPT).html"

## manual pinning guix channels to latest commits
guix-pin-channels: FORCE guix/channels.pinned.scm
	${GUIX} time-machine --channels=guix/channels.scm -- \
		describe -f channels > guix/channels.pinned.scm
FORCE:

guix/channels.pinned.scm: guix/channels.scm
	${GUIX} time-machine --channels=guix/channels.scm -- \
		describe -f channels > guix/channels.pinned.scm

## data/intdata and data/scripts are not part of the git repository
regenerate-data: \
	data/intdata/ZVK-Doku.xlsx \
	data/scripts/01-anonymize-and-prepare.R
	${GUIX} time-machine --channels=guix/channels.pinned.scm -- \
		shell --manifest=guix/manifest-data-preparation.scm -- \
		Rscript data/scripts/01-anonymize-and-prepare.R

gh-pages: manuscript
	git checkout gh-pages
	sed 's#</h4>#</h4> \
<div style="background-color: \#ffc107; padding: 10px; text-align: center;"> \
<strong>This manuscript is work-in-progress!</strong><br /> \
Please find details at <a href="https://github.com/umg-minai/crt">https://github.com/umg-minai/crt</a>.<br /> \
Manuscript date: $(shell date +"%Y-%m-%d %H:%M"); Version: <a href="https://github.com/umg-minai/crt/commit/$(GITHEADL)">$(GITHEAD)</a> \
</div>#' $(OUTPUTDIR)/$(MANUSCRIPT).html > index.html
	git add index.html
	git commit -m "chore: update index.html"
	git checkout main

clean: clean-dist clean-output

clean-dist:
	@rm -rf $(DISTDIR)

clean-output:
	@rm -rf $(OUTPUTDIR)
