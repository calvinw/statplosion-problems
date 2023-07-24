#!/bin/bash

# python -m SimpleHTTPServer 8000 &>/dev/null &
# Rscript -e "servr::httw(pattern='*.html')"

#This runs a server that reloads changed html files 
python3 ../live.py &

#this will save the pid of the above background process
pid=$!

#Then when we exit we will kill it
trap ctrl_c EXIT 
function ctrl_c() {
    echo "Killing the server"
    kill "${pid}"
}

#Meanwhile this runs make on any changed Rmd file.
#after make finishes, it will reload in the server above
echo "calling ls *.Rmd | entr make"
ls *.Rmd | entr make
