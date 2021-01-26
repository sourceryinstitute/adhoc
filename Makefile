FC ?= gfortran

testdir := tests
builddir := build

features := $(wildcard $(testdir)/*)
tests := $(subst $(testdir)/,,$(foreach feature,$(features),$(wildcard $(feature)/*)))

all: $(foreach test,$(tests),$(builddir)/$(test)/RESULT)

$(builddir):
	mkdir $@

define FEATURE_DIR_RULE

$(builddir)/$(dir $(1)): $(builddir)
	mkdir $@

endef

$(foreach feature,$(features),$(eval $(call FEATURE_DIR_RULE,$(feature))))

define TEST_DIR_RULE

$(builddir)/$(1): $(builddir)/$(dir $(1))
	mkdir $@

endef

$(foreach test,$(tests),$(eval $(call TEST_DIR_RULE,$(test))))

define TEST_RULE

$(builddir)/$(1)/RESULT: $(builddir)/$(1)/main.exe
	$^ || true
	$(if $(not $(exists $@)) echo "FAILED" > $@)

$(builddir)/$(1)/main.exe: $(1)/main.f90 $(builddir)/$(1)
	$FC $^ -o $@ || true
	$(if $(not $(exits $@)) touch $@)

endef

$(foreach test,$(tests),$(eval $(call TEST_RULE,$(test))))

clean:
	rm -rf $(builddir)
