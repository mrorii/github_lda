**********************************************************************
Collaborative Topic Modeling for Recommendations (CTR)
**********************************************************************

(C) Copyright 2011, Chong Wang and David Blei

written by Chong Wang, chongw@cs.princeton.edu.

This file is part of CTR.

CTR is free software; you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

CTR is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place, Suite 330, Boston, MA 02111-1307 USA


-----------------------------------------------------------------------------------------

This is a C++ implementation of Collaborative Topic Modeling for Recommendations (CTR).

Note that this code requires the Gnu Scientific Library, http://www.gnu.org/software/gsl/

Thanks Chetan Tonde for bug reporting. 

-----------------------------------------------------------------------------------------


TABLE OF CONTENTS


A. COMPILING

B. RUNNING

C. DATA FORMATS

D. OUTPUT and TESTING

-----------------------------------------------------------------------------------------


A. COMPILING

Type "make" in a shell. Make sure the GSL is installed. You may need to change
the Makefile a bit.


B. RUNNING

Type ./ctr to see help. 

C. DATA FORMATS

--user points to a file where each line is of the form

     [M] [item1] [item2] ... [item_M]

where [M] is the number of items in this user's library and [item_i] is the item
id.

--item points to a file where each line is of the form

     [M] [user1] [user2] ... [user_M]

where [M] is the number of users who has this item their library and [user_i] is
the user id. Note [M] can be zero, which indicates a new item.

--mult points to a file where each line is of the form (the LDA-C format):

     [M] [term_1]:[count] [term_2]:[count] ...  [term_M]:[count]

where [M] is the number of unique terms in the document, and the [count]
associated with each term is how many times that term appeared in the document. 

Next, run LDA-C code (downloaded from Blei's webpage) to obtain final.gamma and final.beta
to give warm start.

--theta_init points to final.gamma. (The program will normalize it.)

--beta_init points to final.beta.

-----------------------------------------------------------------------------------------

D. OUTPUT and TESTING

--directory contains the outputs.

final-U.dat indicates the final user vectors, where each line corresponds to a
user.

final-V.dat indicates the final item vectors, where each line corresponds to an
item.

[00xx-U].dat or [00xx-V].dat are the intermediate results.

For testing, users can write simple R or Python programs to predict ratings. 

