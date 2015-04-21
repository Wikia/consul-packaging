Consul Packaging
================
Makefile and templates for creating deb packages for [Consul](https://consul.io).

Uses [fpm](https://github.com/jordansissel/fpm) for building the packages and a Vagrant VM to build them in.

Packages built
--------------

- consul
- consul-replicate
- consul-template
- consul-webui
- envconsul

Usage
-----

```bash
vagrant box add hashicorp/precise64
vagrant up
vagrant ssh

cd src
make
```

Edit the ``Makefile`` to change the version or architecture of the packages.
