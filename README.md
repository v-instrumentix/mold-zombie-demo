# mold-zombie-demo
MRE of compilation leaving MOLD zombies
## How to replicate
Please use [Dockerfile](Dockerfile) that installs `gcc`, `cmake`, `make` and `mold`, defines trivial `CMake` project with `mold` as a linker and provides shell script wrapping `cmake` + `cmake --build` followed by check for `mold` processes left.

Assuming Dockerfile in current directory, next steps are as follows:

* Build and start container:
`docker build -tt . ; docker run -it --rm t su -`
* In container run wrapper script few times:
`bash /x/b`
After each run new zombie process `ld.mold` will appear (sample output also pasted below).

Tested with GCC 11, 12, 13 either with Ninja or Make.

```
[root@969b9d96458c ~]# bash /x/b
-- Configuring done (0.3s)
-- Generating done (0.0s)
-- Build files have been written to: /x/build
[ 50%] Building CXX object CMakeFiles/a.dir/main.cpp.o
[100%] Linking CXX executable a
[100%] Built target a
root          98  0.0  0.0      0     0 pts/0    Z+   16:06   0:00 [ld.mold] <defunct>
root         113  0.0  0.0  16452  1096 pts/0    S+   16:06   0:00 grep mold
[root@969b9d96458c ~]# bash /x/b
-- Configuring done (0.0s)
-- Generating done (0.0s)
-- Build files have been written to: /x/build
[ 50%] Building CXX object CMakeFiles/a.dir/main.cpp.o
[100%] Linking CXX executable a
[100%] Built target a
root          98  3.0  0.0      0     0 pts/0    Z    16:06   0:00 [ld.mold] <defunct>
root         135  0.0  0.0      0     0 pts/0    Z+   16:06   0:00 [ld.mold] <defunct>
root         150  0.0  0.0  16452  1272 pts/0    S+   16:06   0:00 grep mold
[root@969b9d96458c ~]# bash /x/b
-- Configuring done (0.0s)
-- Generating done (0.0s)
-- Build files have been written to: /x/build
[ 50%] Building CXX object CMakeFiles/a.dir/main.cpp.o
[100%] Linking CXX executable a
[100%] Built target a
root          98  1.0  0.0      0     0 pts/0    Z    16:06   0:00 [ld.mold] <defunct>
root         135  1.5  0.0      0     0 pts/0    Z    16:06   0:00 [ld.mold] <defunct>
root         172  0.0  0.0      0     0 pts/0    Z+   16:06   0:00 [ld.mold] <defunct>
root         187  0.0  0.0  16452  1112 pts/0    S+   16:06   0:00 grep mold
[root@969b9d96458c ~]# logout
```
