# Ubuntu Server Vagrant Box

[Vagrant](https://www.vagrantup.com/) box built using [packer](https://www.packer.io/) of an [ubuntu server](https://ubuntu.com/download/server) minimal install that is uploaded to [vagrant cloud](https://app.vagrantup.com/)

The box is uploaded to [p-matedenicolas/ubuntu-server](https://app.vagrantup.com/p-matedenicolas/boxes/ubuntu-server)

The version of the box follows the ubuntu server version used to build the box

Ubuntu server is configured with the following default user available for ssh connections

> User: `ubuntu`
>
> Password: `ubuntu`

## Setup

The following packer vars must be set

- ssh_username
- ssh_password
- ubuntu_iso_local
- ubuntu_iso_link
- ubuntu_iso_checksum
- vagrant_cloud_access_token
- vagrant_cloud_box_tag
- vagrant_cloud_version
- vagrant_cloud_version_description

A file named `*.auto.pkrvars.hcl` will automatically load vars in packer. There is an example [main.auto.pkrvars.hcl.example](main.auto.pkrvars.hcl.example) that can be renamed and set with the appropiate values to build and publish the box

## Build

Execute the following commands to initialize and build the box

```
packer init .
packer build .
```

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations (GNU GPLv3).
