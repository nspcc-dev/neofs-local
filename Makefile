# Colors
B=\033[0;1m
G=\033[0;92m
R=\033[0m

# Environments paths
LOCAL=neofs-local/docker-compose.yml
LOCAL_CLI=neofs-local/docker-compose.cli.yml
LOCAL_DROP=neofs-local/docker-compose.drop.yml
LOCAL_MINIO=neofs-local/docker-compose.minio.yml
LOCAL_PRIVNET=neofs-local/docker-compose.privnet.yml
CLI=docker-compose.cli.yml

.PHONY: help

# Show this help prompt
help:
	@echo "${B}${G}=> Usage:${R}\n"
	@echo "$ make <target>\n"
	@echo "${B}${G}=> Targets:${R}\n"
	@awk '/^#/{ comment = substr($$0,3) } comment && /^[a-zA-Z][a-zA-Z0-9_-]+ ?:/{ print "   ", $$1, comment }' $(MAKEFILE_LIST) | column -t -s ':' | grep -v 'IGNORE' | sort | uniq

# IGNORE
git_info:
	@echo "Changes:"
	@git status -s
	@echo
	@echo "Log:"
	@git log --abbrev-commit --pretty=oneline

## Local environment commands:

# NeoFS local env prepare debug info for NSPCC
local_dump:
	@rm -rf ./dump
	@mkdir ./dump
	
	@echo "${B}${G}⇒ Prepare OS and Docker info ${R}"
	@uname -a >> ./dump/os_info
	@echo >> ./dump/os_info
	@docker version >> ./dump/os_info
	@echo >> ./dump/os_info
	@docker-compose version >> ./dump/os_info

	@test .git && echo "${B}${G}⇒ Dump environment info ${R}" && make git_info >> ./dump/git_info

	@echo "${B}${G}⇒ Dump environment logs ${R}"
	@docker-compose -f $(LOCAL) -f $(LOCAL_CLI) -f $(LOCAL_DROP) -f $(LOCAL_MINIO) -f $(LOCAL_PRIVNET) logs --no-color >> ./dump/current.log
	@echo "${B}${G}⇒ Thanks! Almost done... ${R}"
	@echo "${B}${G}⇒ Compress dump folder and send it to us ${R}"


# NeoFS local env up
local_up: COMPOSE_FILE=$(LOCAL)
local_up: env_up

# NeoFS local env down
local_down:
	@echo "${B}${G}⇒ Stop the world ${R}"
	@docker-compose -f $(LOCAL) -f $(LOCAL_CLI) -f $(LOCAL_DROP) -f $(LOCAL_MINIO) down

# NeoFS local env stop and remove
local_clean:
	@echo "${B}${G}⇒ Stop the world ${R}"
	@docker-compose -f $(LOCAL) -f $(LOCAL_CLI) -f $(LOCAL_DROP) -f $(LOCAL_MINIO) -f $(LOCAL_PRIVNET) down

# NeoFS local config
local_config: COMPOSE_FILE=$(LOCAL)
local_config: env_config

# NeoFS local pull-images
local_pull:
	@docker-compose -f $(LOCAL) -f $(LOCAL_CLI) -f $(LOCAL_DROP) -f ${LOCAL_MINIO} -f $(LOCAL_PRIVNET) pull

# NeoFS local privnet + np-prompt
local_privnet:
	@docker-compose -f $(LOCAL) -f $(LOCAL_PRIVNET) run np-prompt


# NeoFS local cli
local_cli:
	@docker-compose -f $(LOCAL) -f $(LOCAL_CLI) run cli

# NeoFS local cli
cli:
	@docker-compose -f $(CLI) run cli

# NeoFS local DropIn service
local_drop:
	@docker-compose -f $(LOCAL) -f $(LOCAL_DROP) up -d --no-recreate

# NeoFS local minio gate
local_minio:
	@docker-compose -f $(LOCAL) -f $(LOCAL_MINIO) up -d --no-recreate

# NeoFS local ps
local_ps:
	@docker-compose -f $(LOCAL) -f $(LOCAL_CLI) -f $(LOCAL_DROP) -f $(LOCAL_PRIVNET) ps

## Default commands:

# Generate keys:
gen_keys:
	@go run ./cmd/gen -count 20

# IGNORE
env_build:
	@echo "${B}${G}⇒ Build ${NAME} ${R}"
	@docker-compose -f $(COMPOSE_FILE) build $(NAME)

# IGNORE
env_run:
	@echo "${B}${G}⇒ Run ${NAME} ${R}"
	@docker-compose -f $(COMPOSE_FILE) up $(NAME)

# IGNORE
env_up:
	@echo "${B}${G}⇒ Up service ${NAME} ${R}"
	@docker-compose -f $(COMPOSE_FILE) up -d $(NAME)

# IGNORE
env_config:
	@echo "${B}${G}⇒ Config ${R}"
	@docker-compose -f $(COMPOSE_FILE) config

# IGNORE
env_restart:
	@echo "${B}${G}⇒ Restart ${R}"
	@docker-compose -f $(COMPOSE_FILE) restart

# IGNORE
env_deploy:
	@echo "${B}${G}⇒ Deploy ${NAME} ${R}"
	@docker-compose -f $(COMPOSE_FILE) up --build -d $(NAME)

# IGNORE
env_down:
	@echo "${B}${G}⇒ Stop the world ${R}"
	@docker-compose -f $(COMPOSE_FILE) down

# IGNORE
env_logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f --tail 100 $(SERVICE)
