Tornade
==============

[![License GPL 3][badge-license]][COPYING]

## Description

A PAAS using [Deis][] (with [Docker][] and [CoreOS][])


## Installation

* Add to `/etc/hosts` the Tornade host:
```bash
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
fe80::1%lo0	localhost

172.17.8.100    tornade.deisapp.com
```

* Setup local environment variables:

        $ tornade.sh build
        $ tornade.sh init



## License

Tornade is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

Tornade is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

See [COPYING][] for the complete license.


## Support

Feel free to ask question or make suggestions in our [Issue Tracker][].


## Changelog

A changelog is available [here](ChangeLog.md).


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>



[Tornade]: https://github.com/nlamirault/tornade
[COPYING]: https://github.com/nlamirault/tornade/blob/master/COPYING
[Issue tracker]: https://github.com/nlamirault/tornade/issues

[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg?style=flat

[Docker]: https://www.docker.io
[CoreOS]: https://coreos.com
[Vagrant]: http://www.vagrantup.com
[Virtualbox]: https://www.virtualbox.org
