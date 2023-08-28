################################################################################
# MAKEFILE
#
# @file
# @version 0.1
#
##########
# PREREQUISITES
#   - 
#   - 
################################################################################

########################
# 
########################
default: help
ACTION ?= plan

########################
# CLEAN
########################
.PHONY: clean
clean: #target ## Housekeeping


















########################
# HELP
# REF GH @ jen20/hashidays-nyc/blob/master/terraform/GNUmakefile
########################
.PHONY: help
help: #target ## Display help for this Makefile (default target).
	@echo "Valid targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

check_defined = \
		$(strip $(foreach 1,$1, \
		$(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
		$(if $(value $1),, \
		$(error Undefined $1$(if $2, ($2))))

