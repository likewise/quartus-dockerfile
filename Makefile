.ONESHELL:

build:
	docker build --network=host -t quartus .

run:
	# mounts current host directory as ~/project/ inside container
	docker run -ti --rm -e LM_LICENSE_FILE -e DISPLAY -e "QT_X11_NO_MITSHM=1" --ipc=host -v /tmp/.X11-unix:/tmp/.X11-unix -v $$PWD:/home/quartus/project -w /home/quartus/project quartus:latest

# Newer distributions might need this approach for X11
# https://stackoverflow.com/questions/16296753/can-you-run-gui-applications-in-a-linux-docker-container/25280523#25280523
new:
	XSOCK=/tmp/.X11-unix
	XAUTH=/tmp/.docker.xauth
	> /tmp/.docker.xauth
	xauth nlist $$DISPLAY| sed -e 's/^..../ffff/' | xauth -f $$XAUTH nmerge -
	docker run -ti --rm -v $$XSOCK:$$XSOCK -v $$XAUTH:$$XAUTH -e DISPLAY -e XAUTHORITY=$$XAUTH -e "QT_X11_NO_MITSHM=1" -e LM_LICENSE_FILE --ipc=host -v $$PWD:/home/quartus/project -w /home/quartus/project quartus:latest

# -v ~/.Xilinx/Xilinx.lic:/home/quartus/.Xilinx/Xilinx.lic:ro 