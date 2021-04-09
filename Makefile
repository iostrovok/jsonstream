CURDIR := $(shell pwd)
GOBIN := $(CURDIR)/bin/
ENV:=GOBIN=$(GOBIN)
DIR:=FILE_DIR=$(CURDIR)/testfiles TEST_SOURCE_PATH=$(CURDIR)
GODEBUG:=GODEBUG=gocacheverify=1
LOCDIR:=$(PWD)

##
## List of commands:
##

## default:
all: mod deps fmt lint test

all-deps: mod deps

deps:
	@echo "======================================================================"
	@echo 'MAKE: deps...'
	@mkdir -p $(GOBIN)
	@$(ENV) go get -u golang.org/x/lint/golint


test:
	@echo "======================================================================"
	@echo "Run race 'test' for ./"
	cd $(LOCDIR) && $(DIR) $(GODEBUG) go test --check.format=teamcity -cover -race .



lint:
	@echo "======================================================================"
	@echo "Run golint..."
	$(GOBIN)golint ./

fmt:
	@echo "======================================================================"
	@echo "Run go fmt..."
	@go fmt ./

mod:
	@echo "======================================================================"
	@echo "Run MOD"
# 	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod verify
	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod tidy
	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod vendor
	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod download
	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod verify


clean-cache:
	@echo "clean-cache started..."
	go clean -cache
	go clean -testcache
	@echo "clean-cache complete!"
	@echo "clean-cache complete!"


mock-gen:
	GO111MODULE=on ./bin/mockgen -package mmock bitbucket.org/sourcingline/aws-support/db/tables IPortfolio > ./db/mmock/db_portfolio_mock.go
	GO111MODULE=on ./bin/mockgen -package mmock bitbucket.org/sourcingline/aws-support/db/tables IProviderSlug > ./db/mmock/db_provider_slug_mock.go
	GO111MODULE=on ./bin/mockgen -package mmock bitbucket.org/sourcingline/aws-support/db/tables IVerificationData > ./db/mmock/db_verification_data_mock.go
	GO111MODULE=on ./bin/mockgen -package mmock bitbucket.org/sourcingline/aws-support/db/tables IVerification > ./db/mmock/db_verification_mock.go
	GO111MODULE=on ./bin/mockgen -package mmock bitbucket.org/sourcingline/aws-support/db/tables IProvider > ./db/mmock/db_provider_mock.go
	GO111MODULE=on ./bin/mockgen -package mmock bitbucket.org/sourcingline/aws-support/db/tables IReview > ./db/mmock/db_review_mock.go
	GO111MODULE=on ./bin/mockgen -package mmock bitbucket.org/sourcingline/aws-support/db/common IDB > ./db/common/mmock/db_idb_mock.go

# example: go run ./console/linters/linters.go --path=/Users/vlad/clutch/aws-support/console/
linters:
	@echo "go run ./console/linters/linters.go --path=$(LOCDIR)"
	go run ./console/linters/linters.go --path=$(LOCDIR)