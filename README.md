Find your Unix user ID by running `id -u` .  Edit `Dockerfile`, changing
the value of the `uid` environment variable at the top to your user ID.
Then build the image as
```
docker build -t `whoami`-dtn .
```
(which names the image based on your username).  Now run the container
with administrative network privileges (to enable the bandwidth limit):
```
mkdir /tmp/`whoami`-xfer
docker run -v /tmp/`whoami`-xfer:/xfer:z --cap-add=NET_ADMIN -it `whoami`-dtn
```
Inside the container, first enable the bandwidth limit:
```
sudo ./bwlimit.bash 8mbit
```
then set up and start a new Globus personal endpoint:
```
cd globusconnectpersonal-2.2.1
./globusconnect -setup 01234567-abcd-ef89-01234567abcd
./globusconnect -start -restrict-paths /xfer
```
