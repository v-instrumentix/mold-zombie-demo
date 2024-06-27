ARG SOURCE_IMAGE="almalinux:8"
FROM ${SOURCE_IMAGE}
#
# Install minimal set of utils
#
RUN dnf install -y gcc-toolset-13-gcc-c++ cmake make
RUN dnf install -y epel-release
RUN dnf install -y mold
#RUN dnf install -y --enablerepo powertools ninja-build
WORKDIR /x
#
# Minimal CMake file using MOLD
#
RUN <<EOF cat > CMakeLists.txt
project(molddefunc)
cmake_minimum_required(VERSION 3.25)
add_link_options(-fuse-ld=mold)
add_executable(a main.cpp)
EOF
#
# Script wrapping build steps
RUN <<EOF cat > b
#!/usr/bin/env bash
set -Eeou pipefail
source /opt/rh/gcc-toolset-13/enable
echo 'int main() {}' > /x/main.cpp
cmake -B/x/build -S/x
cmake --build /x/build
ps axuww | grep mold
EOF
CMD ["su", "-"]