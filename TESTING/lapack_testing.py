#! /usr/bin/env python
# -*- coding: utf-8 -*-


###############################################################################
# lapack_testing.py  
###############################################################################


from subprocess import Popen, STDOUT, PIPE 
import os, sys, math
import getopt
# Arguments
try:
   opts, args = getopt.getopt(sys.argv[1:], "hsfep:t:n", 
                              ["help", "short", "file", "error","prec=","test=","number"])
   
except getopt.error, msg:
   print msg
   print "for help use --help"
   sys.exit(2)

short_summary=0
with_file=0
just_errors = 0
prec='x'
test='all'
only_numbers=0
for o, a in opts:
   if o in ("-h", "--help"):
      print sys.argv[0]+" [-h|--help] [-s |--short] [-f |--file] [-e |--error] [-p p |--prec p] [-t test |--test test] [-n | --number]"
      print "     - h is to print this message"
      print "     - f is to use directly the output of the LAPACK testing (.out files). By default, the script will run all the LAPACK tests"
      print " LEVEL OF OUTPUT"
      print "     - x is to print a detailed summary"
      print "     - e is to print only the error summary"
      print "     - s is to print a short summary"
      print "     - n is to print the numbers of failing tests (turn on summary mode)"
      print " SECLECTION OF TESTS:"
      print "     - p [s/c/d/z/x] is to indicate the PRECISION to run:"
      print "            s=single"
      print "            d=double"
      print "            c=complex"
      print "            z=double complex"
      print "            x=all [DEFAULT]"
      print "     - t [lin/eig/mixed/rfp/all] is to indicate which TEST FAMILY to run:"
      print "            lin=Linear Equation"
      print "            eig=Eigen Problems"
      print "            mixed=mixed-precision"
      print "            rfp=rfp format"
      print "            all=all tests [DEFAULT]"
      print " EXAMPLES:"
      print "     ./lapack_testing.py -n -f"
      print "            Will return the numbers of failed tests by analyzing the LAPACK output"
      print "     ./lapack_testing.py -n -f -p s"
      print "            Will return the numbers of failed tests in REAL precision by analyzing the LAPACK output"
      print "     ./lapack_testing.py -n -f -p s -t eig "
      print "            Will return the numbers of failed tests in REAL precision by analyzing only the LAPACK output of EIGEN testings"
      print "Written by Julie Langou (June 2011) "
      sys.exit(0)
   else:
      if o in ("-s", "--short"):
         short_summary = 1
      if o in ("-f", "--file"):
         with_file = 1
      if o in ("-e", "--error"):
         just_errors = 1
      if o in ( '-p', '--prec' ):
         prec = a
      if o in ( '-t', '--test' ):
         test = a
      if o in ( '-n', '--number' ):
         only_numbers = 1
         short_summary = 1

# process options
execution=1
summary="SUMMARY             \tnumerical error   \tother error  \n";
summary+="================    \t=================\t================  \n";
nb_of_test=0

# Add current directory to the path for subshells of this shell
# Allows the popen to find local files in both windows and unixes
os.environ["PATH"] = os.environ["PATH"]+":."

# Define a function to open the executable (different filenames on unix and Windows)
def run_summary_test( f, cmdline, short_summary):
   nb_test_run=0
   nb_test_fail=0
   nb_test_illegal=0
   nb_test_info=0
   if (with_file==1):
      if not os.path.exists(cmdline):
        error_message=cmdline+" file not found"
        r=1
      else:
        pipe = open(cmdline,'r')
        r=0
   else:
      if os.name != 'nt':
         cmdline="./" + cmdline

      outfile=cmdline.split()[4]
      pipe = open(outfile,'w')
      p = Popen(cmdline, shell=True, stdout=pipe)
      p.wait()
      pipe.close()
      r=p.returncode
      pipe = open(outfile,'r')
      error_message=cmdline+" did not work"

   if r != 0 and (with_file==0):
       print "---- TESTING " + cmdline.split()[0] + "... FAILED(" + error_message +") !"
       for line in pipe.readlines():
          f.write(str(line))
   elif r != 0 and (with_file==1):
       print "---- ERROR: You used the option -f, please check that you have the LAPACK output!"
       print "---- "+error_message
   else:
         for line in pipe.readlines():
        	f.write(str(line))
        	words_in_line=line.split()
        	if (line.find("run")!=-1):
#        	   print line
        	   whereisrun=words_in_line.index("run)")
        	   nb_test_run+=int(words_in_line[whereisrun-2])
        	if (line.find("out of")!=-1):
        	   if (short_summary==0): print line,
        	   whereisout= words_in_line.index("out")
        	   nb_test_fail+=int(words_in_line[whereisout-1])
        	if (line.find("illegal")!=-1):
        	   if (short_summary==0):print line,
        	   nb_test_illegal+=1
        	if (line.find(" INFO")!=-1):
        	   if (short_summary==0):print line,
        	   nb_test_info+=1
        	if (with_file==1):
        	   pipe.close()
           
   f.flush();

   return [nb_test_run,nb_test_fail,nb_test_illegal,nb_test_info]


# If filename cannot be opened, send output to sys.stderr
filename = "testing_results.txt"
try:
     f = open(filename, 'w')
except IOError:
     f = sys.stdout

if (short_summary==0):
   print " "
   print "---------------- Testing LAPACK Routines ----------------"
   print " "
   print "-- Detailed results are stored in", filename

dtypes = (
("s", "d", "c", "z"),
("REAL             ", "DOUBLE PRECISION", "COMPLEX          ", "COMPLEX16         "),
)

if prec=='s':
   range_prec=[0]
elif prec=='d':
   range_prec=[1]
elif prec=='c':
   range_prec=[2]
elif prec=='z':
   range_prec=[3]
else:  
   range_prec=range(4)

if test=='lin':
   range_test=[15]
elif test=='mixed':
   range_test=[16]
   range_prec=[1,3]
elif test=='rfp':
   range_test=[17]
elif test=='eig':
   range_test=range(15)
else:  
   range_test=range(18)

list_results = [
[0, 0, 0, 0, 0],
[0, 0, 0, 0, 0],
[0, 0, 0, 0, 0],
[0, 0, 0, 0, 0],
]

for dtype in range_prec:
  letter = dtypes[0][dtype]
  name = dtypes[1][dtype]

  if (short_summary==0):
     print " "
     print "------------------------- %s ------------------------" % name
     print " "
     sys.stdout.flush()


  dtests = (
  ("nep", "sep", "svd",
  letter+"ec",letter+"ed",letter+"gg",
  letter+"gd",letter+"sb",letter+"sg",
  letter+"bb","glm","gqr",
  "gsv","csd","lse",
  letter+"test", letter+dtypes[0][dtype-1]+"test",letter+"test_rfp"),
  ("Nonsymmetric Eigenvalue Problem", "Symmetric Eigenvalue Problem", "Singular Value Decomposition",
  "Eigen Condition","Nonsymmetric Eigenvalue","Nonsymmetric Generalized Eigenvalue Problem",
  "Nonsymmetric Generalized Eigenvalue Problem driver", "Symmetric Eigenvalue Problem", "Symmetric Eigenvalue Generalized Problem",
  "Banded Singular Value Decomposition routines", "Generalized Linear Regression Model routines", "Generalized QR and RQ factorization routines",
  "Generalized Singular Value Decomposition routines", "CS Decomposition routines", "Constrained Linear Least Squares routines",
  "Linear Equation routines", "Mixed Precision linear equation routines","RFP linear equation routines"),
  (letter+"nep", letter+"sep", letter+"svd",
  letter+"ec",letter+"ed",letter+"gg",
  letter+"gd",letter+"sb",letter+"sg",
  letter+"bb",letter+"glm",letter+"gqr",
  letter+"gsv",letter+"csd",letter+"lse",
  letter+"test", letter+dtypes[0][dtype-1]+"test",letter+"test_rfp"),
  )


  for dtest in range_test:
     nb_of_test=0
     # NEED TO SKIP SOME PRECISION (namely s and c) FOR PROTO MIXED PRECISION TESTING
     if dtest==16 and (letter=="s" or letter=="c"):
        continue
     if (with_file==1):
        cmdbase=dtests[2][dtest]+".out"
     else:
        if dtest==15:
           # LIN TESTS
           cmdbase="xlintst"+letter+" < "+dtests[0][dtest]+".in > "+dtests[2][dtest]+".out"
        elif dtest==16:
           # PROTO LIN TESTS
           cmdbase="xlintst"+letter+dtypes[0][dtype-1]+" < "+dtests[0][dtest]+".in > "+dtests[2][dtest]+".out"
        elif dtest==17:
           # PROTO LIN TESTS
           cmdbase="xlintstrf"+letter+" < "+dtests[0][dtest]+".in > "+dtests[2][dtest]+".out"
        else:
           # EIG TESTS
           cmdbase="xeigtst"+letter+" < "+dtests[0][dtest]+".in > "+dtests[2][dtest]+".out"
     if (just_errors==0 and short_summary==0):
        print "-->  Testing "+name+" "+dtests[1][dtest]+" [ "+cmdbase+" ]"
     # Run the process: either to read the file or run the LAPACK testing   
     nb_test = run_summary_test(f, cmdbase, short_summary)
     list_results[0][dtype]+=nb_test[0]
     list_results[1][dtype]+=nb_test[1]
     list_results[2][dtype]+=nb_test[2]
     list_results[3][dtype]+=nb_test[3]
     got_error=nb_test[1]+nb_test[2]+nb_test[3]
     
     if (short_summary==0):
        if (nb_test[0]>0 and just_errors==0):
           print "-->  Tests passed: "+str(nb_test[0])
        if (nb_test[1]>0):
           print "-->  Tests failing to pass the threshold: "+str(nb_test[1])
        if (nb_test[2]>0):
           print "-->  Illegal Error: "+str(nb_test[2])
        if (nb_test[3]>0):
           print "-->  Info Error: "+str(nb_test[3])
        if (got_error>0 and just_errors==1):
           print "ERROR IS LOCATED IN "+name+" "+dtests[1][dtest]+" [ "+cmdbase+" ]"
           print ""
        if (just_errors==0):
           print ""
#     elif (got_error>0):
#        print dtests[2][dtest]+".out \t"+str(nb_test[1])+"\t"+str(nb_test[2])+"\t"+str(nb_test[3])
        
     sys.stdout.flush()
  percent_num_error=float(list_results[1][dtype])/float(list_results[0][dtype])*100
  percent_error=float(list_results[2][dtype]+list_results[3][dtype])/float(list_results[0][dtype])*100
  summary+=name+"\t"+str(list_results[1][dtype])+"\t("+"%.3f" % percent_num_error+"%)\t"+str(list_results[2][dtype]+list_results[3][dtype])+"\t("+"%.3f" % percent_error+"%)\t""\n"
  list_results[0][4]+=list_results[0][dtype]
  list_results[1][4]+=list_results[1][dtype]
  list_results[2][4]+=list_results[2][dtype]
  list_results[3][4]+=list_results[3][dtype]
  
if only_numbers==1:
   print str(list_results[1][4])+"\n"+str(list_results[2][4]+list_results[3][4])
else:
   print summary
   percent_num_error=float(list_results[1][4])/float(list_results[0][4])*100
   percent_error=float(list_results[2][4]+list_results[3][4])/float(list_results[0][4])*100
   print "--> ALL PRECISIONS   \t"+str(list_results[1][4])+"\t("+"%.3f" % percent_num_error+"%)\t"+str(list_results[2][4]+list_results[3][4])+"\t("+"%.3f" % percent_error+"%)\t""\n"



# This may close the sys.stdout stream, so make it the last statement
f.close()
