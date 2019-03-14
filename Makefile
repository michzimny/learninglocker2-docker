SHELL := /bin/bash # Use bash syntax

include .env
export

run:
	docker-compose up

down:
	docker-compose down

add-admin:
	docker-compose exec api node cli/dist/server createSiteAdmin admin@test.com MyOrganization lrs123

destroy:
	docker-compose down
	docker rmi learninglocker2-app:${DOCKER_TAG}
	docker rmi learninglocker2-nginx:${DOCKER_TAG}
	docker volume rm learninglocker2-docker_xapi-storage
	docker volume rm learninglocker2-docker_mongo-data
	docker volume rm learninglocker2-docker_ui-logs
	docker volume rm learninglocker2-docker_app-storage
