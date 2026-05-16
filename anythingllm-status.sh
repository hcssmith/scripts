#!/bin/bash

if ps aux | grep -q "[A]nythingLLMDesk"; then
  echo " 󰄬 "
else
  echo "  "
fi
