# dockyindock docker image
docky from Akretion, but operating in a container, for instance on CoreOS


Execute following commands to install voodoo in a container on CoreOS
$ curl -L --fail https://github.com/whulshof/dockyindock/releases/download/v1.1/docky.sh > ~/voodoo
$ sudo mkdir -p /opt/bin
$ sudo mv ~/docky /opt/bin/
$ sudo chown root:root /opt/bin/docky
$ sudo chmod +x /opt/bin/docky

Execute following commands to install docky in a container on MacOS
$ curl -L --fail https://github.com/whulshof/dockyindock/releases/download/v1.1/docky-macos.sh > /usr/local/bin/docky
$ sudo chmod +x /usr/local/bin/docky

