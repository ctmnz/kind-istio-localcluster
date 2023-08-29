#!/bin/bash
flask run --host=0.0.0.0 &
wssh --port=8888

fg %1 

