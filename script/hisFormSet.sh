#!/bin/bash

function HistFormatSet() {

echo "HISTTIMEFORMAT="[%Y-%m-%d_%H:%M:%S]"" >> /etc/profile
export HISTTIMEFORMAT

source /etc/profile

}
