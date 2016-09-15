# dtn (data transfer node)

[![dtn build status](https://api.travis-ci.org/cjmay/dtn.png?branch=master)](https://travis-ci.org/cjmay/dtn)

Dockerfiles with configurable bandwidth-limited TCP traffic.

[Globus Personal endpoint](https://www.globus.org/globus-connect-personal)
software is also downloaded and ready for configuration.


## Usage

Simply run
```
make
```
to build a personalized Dockerfile and run it.
If you are trying to transfer existing files *off* of this machine, set the directory to mount via variable DIR:
```
make DIR=${DIR}
```
If you are transferring file *to* this machine, you can still set `DIR`, but it also has a default value of `/tmp/$(whoami)-xfer`.
See additional information via `make help`.

Once in the container, view the file `container_readme.md` (which will also be printed to the screen) and follow its instructions.
You will need to know (generate) an endpoint id: you can create one at https://www.globus.org/app/endpoints/create-gcp.

### Actual throughput

The effective throughput observed so far has been between 1/3 and 3/5 of
the configured nominal limit.  It's not yet clear what's causing the
discrepancy but it is not a high-priority issue as long as the effective
rate is no greater than the nominal rate.


## References

* [Bandwidth limiting in Globus/GridFTP](http://toolkit.globus.org/toolkit/data/gridftp/bwlimit.html)
* [ESnet Dockerfiles](https://github.com/esnet/docker) also run Globus/GridFTP endpoints
