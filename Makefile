build-api:
	cd api && docker-compose build && docker-compose run web rails db:create db:migrate db:seed

start:
	cd api && docker-compose up

build-and-run: build-api
	cd api && docker-compose up
