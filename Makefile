testdir := tests
builddir := build-$(FC)

features := $(wildcard $(testdir)/*)
tests := $(subst $(testdir)/,,$(foreach feature,$(features),$(wildcard $(feature)/*)))

all: $(foreach test,$(tests),$(builddir)/$(test)/RESULT)

$(builddir):
	mkdir $@

define FEATURE_DIR_RULE

$(builddir)/$(1): $(builddir)
	mkdir $(builddir)/$(1)

endef

$(foreach feature,$(features),$(eval $(call FEATURE_DIR_RULE,$(subst $(testdir)/,,$(feature)))))

define TEST_DIR_RULE

$(builddir)/$(1): $(builddir)/$(dir $(1))
	mkdir $(builddir)/$(1)

endef

$(foreach test,$(tests),$(eval $(call TEST_DIR_RULE,$(test))))

define TEST_RULE

$(builddir)/$(1)/RESULT: $(builddir)/$(1)/main.exe
	cd $(builddir)/$(1) && ./main.exe || echo FAILED > RESULT

$(builddir)/$(1)/main.exe: $(testdir)/$(1)/main.f90 $(builddir)/$(1)
	$(FC) $(testdir)/$(1)/main.f90 -o $(builddir)/$(1)/main.exe || touch $(builddir)/$(1)/main.exe

endef

$(foreach test,$(tests),$(eval $(call TEST_RULE,$(test))))

clean:
	rm -rf $(builddir)
