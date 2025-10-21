PWSH := pwsh-preview -NoProfile
DLL := libs/NativeCommandCompleter.dll
CSharpFiles = $(shell find src \( -name ".git" -o -name "obj" -o -name "bin" \) -prune -o -name "*.cs" -print)

.ONESHELL:

$(DLL): $(CSharpFiles)
	dotnet build --nologo -c Release src

.PHONY: clean
clean:
	dotnet clean

.PHONY: build
build: $(DLL) ## Build C# Projects

.PHONY: build/zip
build/zip: build ## Create Zip archived PowerShell module files
	@$(PWSH) -File build.ps1 -CreateZip

.PHONY: help
help: ## Display this help
	@echo "Targets:"
	grep -E '^[a-zA-Z_/-]+:.*?## .*$$' /dev/null $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":|## "}; {printf "  %-20s %s\n", $$(NF-2), $$NF}'

