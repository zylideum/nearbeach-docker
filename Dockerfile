# syntax=docker/dockerfile:1
FROM python:3.8.3-alpine

# Environmental Variables for the Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN adduser -D -g "nearbeach" nearbeach

# Setup of Working Directory
WORKDIR /oceansuite
RUN chown nearbeach:nearbeach /oceansuite

# Update apk and pip
RUN echo "**** Update apk and Pip ****" && \
    apk update && \
    pip install --upgrade pip wheel

# Install Required Dependencies
RUN echo "**** install build packages ****" && \
    apk add --no-cache --virtual=build-dependencies --upgrade \
    cairo-dev \
    freetype-dev \
    gcc \
    gdk-pixbuf-dev \
    gpgme-dev \
    jpeg-dev \
    lcms2-dev \
    libc-dev \
    libffi-dev \
    mariadb-dev \
    musl-dev \
    openjpeg-dev \
    pango-dev \
    python3-dev \
    tcl-dev \
    tiff-dev \
    tk-dev \
    zlib-dev

# Copy the requirements.txt file
COPY --chown=nearbeach:nearbeach requirements.txt requirements.txt
# Install Required Python Dependencies
RUN echo "**** install python packages ****" && \
    pip install -r requirements.txt

USER nearbeach
# Copy everything into the destination
COPY --chown=nearbeach:nearbeach . .
RUN chmod u+x setup_db_and_run_server.sh

CMD './setup_db_and_run_server.sh'