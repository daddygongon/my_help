paper.dvi: sample.tex
	platex $< && platex $<

paper.pdf: sample.dvi
	xdvipdfmx $<

.PHONY: clean
clean:
	rm -rf *.log *.aux *.toc *.dvi *.bbl *.blg *.lot *.lof *.out

.PHONY: bibcom
bibcom:
	rm -f *.log *.toc *.dvi && \
	bibtex sample.aux

