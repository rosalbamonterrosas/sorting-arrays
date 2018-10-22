# sorting-arrays
This program, developed in assemble language, creates arrays of numbers and sorts the arrays in ascending order from lowest to highest value.

At the beginning of the program, empty storage for two original arrays and their sorted versions is allocated. The SORT1 section sets the
R4/R5/R6 parameters, which are used by the COPY and SORT subroutines to copy and sort array ARY1. 

R4 holds the starting address of the array. R5 holds the length of the array. R6 holds the starting location of the sorted array. 

COPY subroutine copies the contents of array ARY1 into ARY1S. 
SORT subroutine sorts the elements on ARY1S in place.
SORT2 section is similar to SORT1 above using same registers. 

Using bubble sorting, the arrays are sorted in ascending order from lowest to highest value. 
