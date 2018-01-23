# Copyright (C) 2012-2017 IBM Corp.
#
# This program is Licensed under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License. See accompanying LICENSE file.
# 
CC = g++
#
#CFLAGS = -g -O2 -std=c++11 -DDEBUG_PRINTOUT -Wfatal-errors -Wshadow -Wall -I/usr/local/include 
CFLAGS = -g -O2 -std=c++11 -pthread -DFHE_THREADS -DFHE_BOOT_THREADS -DFHE_DCRT_THREADS -I/usr/local/ntl/include -I/usr/local/gmp/include -fmax-errors=2

# useful flags:
#   -std=c++11
#   -DNO_HALF_SIZE_PRIME  tells helib to not use the half size prime
#                         in the prime chain
#
#   -DFHE_THREADS  tells helib to enable generic multithreading capabilities;
#                  must be used with a thread-enabled NTL and the -pthread
#                  flag should be passed to gcc
#
#   -DFHE_BOOT_THREADS  tells helib to use a multithreading strategy for
#                       bootstrapping; requires -DFHE_THREADS (see above)

#  If you get compilation errors, you may need to add -std=c++11 or -std=c++0x

$(info HElib requires NTL version 10.0.0 or higher, see http://shoup.net/ntl)
$(info If you get compilation errors, try to add/remove -std=c++11 in Makefile)
$(info )

LD = g++
AR = ar
ARFLAGS=rv
GMP=-lgmp
NTL=-lntl

# NOTE: NTL and GMP are distributed under LGPL (v2.1), so you can link
#       against them as dynamic libraries.
LDLIBS = -L/usr/local/lib -L/usr/local/gmp/lib -L/usr/local/ntl/lib $(NTL) $(GMP) -lm

HEADER = EncryptedArray.h FHE.h Ctxt.h CModulus.h FHEContext.h PAlgebra.h DoubleCRT.h NumbTh.h bluestein.h IndexSet.h timing.h IndexMap.h replicate.h hypercube.h matching.h powerful.h permutations.h polyEval.h multicore.h EvalMap.h matmul.h PtrVector.h PtrMatrix.h intraSlot.h recryption.h debugging.h binaryArith.h binaryCompare.h tableLookup.h

SRC = KeySwitching.cpp EncryptedArray.cpp FHE.cpp Ctxt.cpp CModulus.cpp FHEContext.cpp PAlgebra.cpp DoubleCRT.cpp NumbTh.cpp bluestein.cpp IndexSet.cpp timing.cpp replicate.cpp hypercube.cpp matching.cpp powerful.cpp BenesNetwork.cpp permutations.cpp PermNetwork.cpp OptimizePermutations.cpp eqtesting.cpp polyEval.cpp extractDigits.cpp EvalMap.cpp recryption.cpp debugging.cpp matmul.cpp matmul1D.cpp blockMatmul.cpp blockMatmul1D.cpp intraSlot.cpp binaryArith.cpp binaryCompare.cpp tableLookup.cpp

OBJ = NumbTh.o timing.o bluestein.o PAlgebra.o  CModulus.o FHEContext.o IndexSet.o DoubleCRT.o FHE.o KeySwitching.o Ctxt.o EncryptedArray.o replicate.o hypercube.o matching.o powerful.o BenesNetwork.o permutations.o PermNetwork.o OptimizePermutations.o eqtesting.o polyEval.o extractDigits.o EvalMap.o recryption.o debugging.o matmul.o matmul1D.o blockMatmul.o blockMatmul1D.o intraSlot.o binaryArith.o binaryCompare.o tableLookup.o

TESTPROGS = Test_General_x Test_PAlgebra_x Test_IO_x Test_Replicate_x Test_LinPoly_x Test_matmul_x Test_matmul1D_x Test_Powerful_x Test_Permutations_x Test_Timing_x Test_PolyEval_x Test_extractDigits_x Test_EvalMap_x Test_bootstrapping_x Test_PtrVector_x Test_intraSlot_x Test_binaryArith_x Test_binaryCompare_x Test_tableLookup_x


all: fhe.a

check: Test_General_x Test_matmul_x Test_matmul1D_x Test_LinPoly_x Test_Permutations_x Test_PolyEval_x Test_Replicate_x Test_EvalMap_x Test_extractDigits_x Test_bootstrapping_x Test_binaryArith_x Test_binaryCompare_x Test_tableLookup_x
	./Test_General_x R=1 k=10 p=2 r=2 noPrint=1
	./Test_General_x R=1 k=10 p=2 d=2 noPrint=1
	./Test_General_x R=2 k=10 p=7 r=2 noPrint=1
	./Test_matmul_x m=1365
	./Test_matmul1D_x m=96 p=7
	./Test_LinPoly_x noPrint=1
	./Test_Permutations_x noPrint=1
	./Test_PolyEval_x p=7 r=2 d=34 noPrint=1
	./Test_Replicate_x m=1247 noPrint=1
	./Test_EvalMap_x mvec="[7 3 221]" gens="[3979 3095 3760]" ords="[6 2 -8]" noPrint=1
	./Test_extractDigits_x m=2047 p=5 noPrint=1
	./Test_bootstrapping_x noPrint=1 N=512
	./Test_bootstrapping_x p=7 noPrint=1
	./Test_binaryArith_x
	./Test_binaryCompare_x
	./Test_tableLookup_x

test: $(TESTPROGS)

obj: $(OBJ)

DoubleCRT.o: DoubleCRT.cpp $(HEADER)
	$(CC) $(CFLAGS) -c DoubleCRT.cpp

%.o: %.cpp $(HEADER)
	$(CC) $(CFLAGS) -c $<

fhe.a: $(OBJ)
	$(AR) $(ARFLAGS) fhe.a $(OBJ)

./%_x: %.cpp fhe.a
	$(CC) $(CFLAGS) -o $@ $< fhe.a $(LDLIBS)

clean:
	rm -f *.o *_x *_x.exe *.a core.*
	rm -rf *.dSYM

info:
	: HElib require NTL version 10.0.0 or higher
	: Compilation flags are 'CFLAGS=$(CFLAGS)'
	: If errors occur, try adding/removing '-std=c++11' in Makefile
	:
