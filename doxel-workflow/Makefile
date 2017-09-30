
SUBDIRS = cmvs_pmvs-build openmvg-docker potree_converter-build

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@
