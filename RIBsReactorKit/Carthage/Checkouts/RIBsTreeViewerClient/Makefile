.PHONY: help
.DEFAULT_GOAL := help
 
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

setup: ## setup
	@carthage update --platform iOS --no-use-binaries 

generate_xcframeworks: ## Generate XCFrameworks.
	@./scripts/generate_xcframeworks.sh
