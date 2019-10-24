.PHONY: build run it

build:
	docker build --rm -t testsrc .

run:
	# Terminate server with `Ctrl + C`.
	docker run --rm -p 8000:8000 testsrc

it:
	# 1. Adjust manifest using vim.
	# 2. Run `./server.py` afterwards.
	docker run --rm -it testsrc /bin/sh