# dtn (data transfer node)

Dockerfiles with configurable bandwidth-limited TCP traffic.

[Globus Personal endpoint](https://www.globus.org/globus-connect-personal)
software is also downloaded and ready for configuration.


## Usage

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
sudo ./bwlimit.bash 100mbit
```
then set up and start a new Globus personal endpoint:
```
cd globusconnectpersonal-2.2.1
./globusconnect -setup 01234567-abcd-ef89-01234567abcd
./globusconnect -start -restrict-paths /xfer
```

### Actual throughput

The effective throughput observed so far has been between 1/3 and 3/5 of
the configured nominal limit.  It's not yet clear what's causing the
discrepancy but it is not a high-priority issue as long as the effective
rate is no greater than the nominal rate.


## References

* [Bandwidth limiting in Globus/GridFTP](http://toolkit.globus.org/toolkit/data/gridftp/bwlimit.html)
* [ESnet Dockerfiles](https://github.com/esnet/docker) also run Globus/GridFTP endpoints
