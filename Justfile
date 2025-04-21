NAME := "wins"

def:
    @just --list

# option used by ci build
ci: setup sprites release pack

# build the newgrf (debug, no crop)
build: preprocess
    ./nml/nmlc -p DEFAULT {{NAME}}.nml --grf {{NAME}}.grf --nml {{NAME}}_parsed.nml --nfo={{NAME}}.nfo
    @echo "All jobs done"
    @du -bh {{NAME}}.nml
    @du -bh {{NAME}}.grf
    @du -bh {{NAME}}.nfo

# build the newgrf (release, crop)
release: preprocess
    ./nml/nmlc -p DEFAULT -c {{NAME}}.nml --grf {{NAME}}.grf
    @echo "All jobs done"
    @du -bh {{NAME}}.nml
    @du -bh {{NAME}}.grf

# preprocess the pnml file
preprocess:
    ./quickgen.py
    ./spritesets.py
    ./build.py
    gcc -E -P -x c tags.txt \
        -D GIT_VERSION="$(git describe --tags --always --dirty || echo 0.0.0-0-0000000)" \
        > custom_tags.txt
    gcc -E -x c {{NAME}}.pnml \
        -D COMMIT="$(git rev-list --count HEAD || echo 1145)" \
        -D MIN_COMMIT="$(git rev-list --count "$(cat min_compatible_version)" || echo 1)" \
        > {{NAME}}.nml

# set up nml
setup:
    rm -rf nml
    git submodule update --init --recursive --remote

# copy the grf to the openttd newgrf folder (linux)
cp:
    cp {{NAME}}.grf ~/.local/share/openttd/newgrf/

# pack the grf into a tar file
pack:
    cp LICENSE.md license.txt
    cp README.md readme.txt
    cp changelog.md changelog.txt
    tar -cvf {{NAME}}-"$(git describe --tags --always --dirty || echo 0.0.0-0-0000000)".tar {{NAME}}.grf license.txt readme.txt changelog.txt
    rm license.txt readme.txt changelog.txt

# clean up
clean:
    rm -f *.{grf,nml,nfo,tar} custom_tags.txt generated/*.nml
    rm -rf ./.nmlcache

verify:
    md5sum {{NAME}}.grf | tee md5sum.txt -a

# make the sprites. do not use if you don't have aseprite
sprites:
    @aseprite --help > /dev/null || { echo "Aseprite isn't installed"; exit 1; }
    make all
