#!/bin/bash

cp LICENSE.txt ${PREFIX}

mkdir build
cd build

declare -a CMAKE_LIBXML_LIBRARY
if [[ ${target_platform} == osx-*64 ]]; then
  CMAKE_LIBXML_LIBRARY+=(-DLIBXML_LIBRARY="${PREFIX}"/lib/libxml2.dylib)
elif [[ ${target_platform} == linux-*64 ]]; then
  CMAKE_LIBXML_LIBRARY+=(-DLIBXML_LIBRARY="${PREFIX}"/lib/libxml2.so)
fi

cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_CXX_STANDARD_LIBRARIES=-lxml2 \
      "${CMAKE_LIBXML_LIBRARY[@]}" \
      -DLIBXML_INCLUDE_DIR=${PREFIX}/include/libxml2 \
      -DWITH_SWIG=OFF \
      -DWITH_STABLE_PACKAGES=ON \
      -DWITH_CPP_NAMESPACE=ON \
      ..

make -j"${CPU_COUNT}"
make install

rm ${PREFIX}/share/cmake/Modules/FindLIBXML.cmake
rm ${PREFIX}/share/cmake/Modules/FindBZ2.cmake
rm ${PREFIX}/share/cmake/Modules/FindZLIB.cmake