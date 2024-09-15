rand := $(shell openssl rand -hex 6)
ORG_NAME := scriptonbasestar
REPO_PREFIX := ory-

.PHONY: build-sdk
build-sdk:
	(cd $$KRATOS_DIR; make sdk)
	cp $$KRATOS_DIR/spec/api.json ./contrib/sdk/api.json
	npx @openapitools/openapi-generator-cli generate -i "./contrib/sdk/api.json" \
		-g typescript-axios \
		-o "./contrib/sdk/generated" \
		--git-user-id ory \
		--git-repo-id sdk \
		--git-host github.com \
		-c ./contrib/sdk/typescript.yml
	(cd ./contrib/sdk/generated; npm i; npm run build)
	rm -rf node_modules/@ory/kratos-client/*
	cp -r ./contrib/sdk/generated/* node_modules/@ory/client

.PHONY: clean-sdk
clean-sdk:
	rm -rf node_modules/@ory/client/
	npm i

.PHONY: docker-dev-build
docker-dev-build:
	docker build -f ./Dockerfile-dev -t kratos-ui-next-dev . --platform linux/amd64 --platform linux/arm64
	docker tag kratos-ui-next-dev ${ORG_NAME}/${REPO_PREFIX}kratos-selfservice-ui-nextjs:dev

docker-dev-deploy:
	docker push ${ORG_NAME}/${REPO_PREFIX}kratos-selfservice-ui-nextjs:dev

.PHONY: docker-build
docker-build:
	docker build -t kratos-ui-next . --platform linux/amd64 --platform linux/arm64
	docker tag kratos-ui-next ${ORG_NAME}/${REPO_PREFIX}kratos-selfservice-ui-nextjs:prd 

docker-deploy:
	docker push ${ORG_NAME}/${REPO_PREFIX}kratos-selfservice-ui-nextjs:prd
