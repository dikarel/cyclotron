build:
	docker build -t dikarel/cyclotron .

test: build
	docker run --rm -it dikarel/cyclotron

deploy: build
	docker tag dikarel/cyclotron dikarel/cyclotron:latest
	docker push dikarel/cyclotron:latest
