#!/usr/bin/env -S nix shell github:ereslibre/nixities#rootlesskit github:ereslibre/nixities#slirp4netns github:ereslibre/nixities#containerd github:ereslibre/nixities#runc github:ereslibre/nixities#bash -c bash
TMPFILE=$(mktemp '/tmp/dockerd.XXXXXXXXXXXX') || exit 1
cat <<EOF > $TMPFILE
{
  "cdi-spec-dirs": [
    "/etc/cdi/",
    "/var/run/cdi/"
  ],
  "features": {
    "cdi": true
  },
  "userland-proxy": false,
  "rootless": true
}
EOF
DOCKERD=<PATH_TO_MOBY>/moby/moby/bundles/binary/dockerd <PATH_TO_MOBY>/moby/moby/contrib/dockerd-rootless.sh --config-file=$TMPFILE
