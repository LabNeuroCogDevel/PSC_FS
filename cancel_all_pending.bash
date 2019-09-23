#!/usr/bin/env bash
squeue -A $(id -gn)|grep ' PD '|awk '{print $1}'| xargs scancel
