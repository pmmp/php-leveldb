#!/bin/sh

if [ ! -d leveldb-$LEVELDB_VERSION ] || [ ! -f leveldb-$LEVELDB_VERSION/libleveldb.so ]; then
	rm -rf leveldb-$LEVELDB_VERSION 2>/dev/null
	curl -fsSL https://github.com/pmmp/leveldb/archive/$LEVELDB_VERSION.tar.gz -o leveldb-$LEVELDB_VERSION.tar.gz
	tar zxf leveldb-$LEVELDB_VERSION.tar.gz
	cd leveldb-$LEVELDB_VERSION
	cmake . \
		-DBUILD_SHARED_LIBS=ON \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DLEVELDB_BUILD_TESTS=OFF \
		-DLEVELDB_BUILD_BENCHMARKS=OFF \
		-DCMAKE_INSTALL_PREFIX=./
	make -j8
	cd ..
else
	echo "Using cached libleveldb build"
fi

cd leveldb-$LEVELDB_VERSION
make install
cd ..

phpize && ./configure --with-leveldb=$PWD/leveldb-$LEVELDB_VERSION && make -j4
