# Judge0 1.13.1 plus Python 3.12, registered as language 100 (the id hosted Judge0 uses).
# Built by hand with scripts/build-judge0-image.sh, never by CI (docs/adr/0004).
FROM judge0/judge0:1.13.1
USER root

# The SHA-256 of the release tarball, checked once against its GPG signature
# (Thomas Wouters, 7169605F62C751356D054A26A821E680E5FA6305).
ENV PYTHON_312_VERSION=3.12.16
ENV PYTHON_312_SHA256=b5796915dc45ff745cfb4e990a7e7c93d6f546328a102ce31448d69ebc37575c
RUN set -xe && \
    curl -fSsL "https://www.python.org/ftp/python/$PYTHON_312_VERSION/Python-$PYTHON_312_VERSION.tar.xz" -o /tmp/python.tar.xz && \
    echo "$PYTHON_312_SHA256  /tmp/python.tar.xz" | sha256sum -c - && \
    mkdir /tmp/python && \
    tar -xf /tmp/python.tar.xz -C /tmp/python --strip-components=1 && \
    cd /tmp/python && \
    ./configure --prefix=/usr/local/python-$PYTHON_312_VERSION && \
    make -j2 && \
    make install && \
    rm -rf /tmp/*

# The server re-seeds languages from active.rb on every start, so the entry must live here.
# active.rb has no trailing newline, so start a new line before appending.
# PYTHONINTMAXSTRDIGITS=0 keeps 3.8's behaviour of printing ints of any length.
RUN printf "\n" >> /api/db/languages/active.rb && echo "@languages << { id: 100, name: \"Python ($PYTHON_312_VERSION)\", is_archived: false, source_file: \"script.py\", run_cmd: \"env PYTHONINTMAXSTRDIGITS=0 /usr/local/python-$PYTHON_312_VERSION/bin/python3 script.py\" }" \
      >> /api/db/languages/active.rb

USER judge0
