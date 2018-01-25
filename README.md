# DockerHElib

## Build Image helib and Run Container helib
- docker build . -t helib
- docker run --rm --name helib -v /yourpath:/sourcerepo -p 10000:22 -itd helib

## using SSH to connect you container
- ssh root@127.0.0.1 -p 10000 (password:xpp)

## Support
