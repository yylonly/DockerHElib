# DockerHElib

## Build Image helib and Run Container helib
- docker build . -t helib
- docker run --rm --name helib -v /yourpath:/sourcerepo -p 10000:22 -it helib

## ReAttach
- docker start helib
- docker attach helib
