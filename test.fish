#!/usr/bin/env fish

set -l options (fish_opt --short h --long help)
set -a options (fish_opt --short n --long name --required-val)

argparse --max-args 0 $options -- $argv
or exit

if set -q _flag_help
    echo "test.fish [-h|--help] [-n|--name]"
    exit 0
end

set -l name gnu-arm-embedded-ssh
if set -q _flag_name
    set name $_flag_name
end

podman run --rm -p 2222:22 --name test-container -dt localhost/$name:latest
or exit

sleep 5
or exit

podman run --rm --network host -it docker.io/toolbelt/netcat:latest \
    -z localhost 2222
or exit

podman stop test-container
or exit

podman run --rm --name test-container -it localhost/$name:latest arm-none-eabi-g++ --version
or exit
