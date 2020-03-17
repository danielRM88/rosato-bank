build-api:
	cd api && docker-compose down && docker-compose build && docker-compose run web rails db:drop db:create db:migrate db:seed

start:
	cd api && docker-compose up

build-and-run: build-api
	cd api && docker-compose up
