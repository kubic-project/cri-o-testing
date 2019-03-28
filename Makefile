TF := terraform
TF_ARGS := --auto-approve

.PHONY: init apply destroy

define run_test
	$(TF) apply $(TF_ARGS) --target module.$(1); \
		(ret=$$?; $(TF) destroy $(TF_ARGS); exit $$ret)
endef

init:
	$(TF) init

destroy: init
	$(TF) destroy $(TF_ARGS)

setup: init
	$(TF) apply $(TF_ARGS) --target module.setup

unit: init
	$(call run_test,unit)

critest: init
	$(call run_test,critest)

integration: init
	$(call run_test,integration)

e2e-node: init
	$(call run_test,e2e-node)
