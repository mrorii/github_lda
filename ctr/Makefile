CC = g++ -Wall
#CC = g++ -ansi -Wall -pedantic
#CFLAGS = -g -Wall -O3 -ffast-math -DHAVE_INLINE -DGSL_RANGE_CHECK_OFF
# CFLAGS = -g -Wall
LDFLAGS = -lgsl -lm -lgslcblas

GSL_INCLUDE = /u/chongw/libs/gsl/include
GSL_LIB = /u/chongw/libs/gsl/lib

LSOURCE = main.cpp utils.cpp corpus.cpp ctr.cpp data.cpp opt.cpp
LHEADER = utils.h corpus.h ctr.h data.h opt.h

ctr: $(LSOURCE) $(HEADER)
	  $(CC) -I$(GSL_INCLUDE) -L$(GSL_LIB) $(LSOURCE) -o $@ $(LDFLAGS)

ctr-d: $(LSOURCE) $(HEADER)
	  $(CC) -g -I$(GSL_INCLUDE) -L$(GSL_LIB) $(LSOURCE) -o $@ $(LDFLAGS)

clean:
	-rm -f *.o ctr
clean-d:
	-rm -f *.o ctr-d
