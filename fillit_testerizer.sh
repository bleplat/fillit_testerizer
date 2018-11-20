# /bin/sh

################################################################
### WARNING
### Dont forget to change the path to your project in the Makefile!
####################################################################

execmd="./fillit"

expect=tmp_expected_results
your=tmp_your_result
diffttl=test_results

color_def="\e[36m"
color_det="\e[33m"
color_ok="\e[32m"
color_ko="\e[31m"

if [ $1 = "run" ]
then
	printf $color_def
	printf "Running tests without running make!"
else
	printf $color_def
	printf "Making files and running tests...\n"
	make re
	make norminette
fi

printf $color_def
printf "fillit\e[34mt\e[35me\e[36ms\e[37mt\e[35m\e[31me\e[32mr\e[33mi\e[34mz\e[35me\e[36mr\e[35m\n\n"

printf "" > $diffttl

onediff() { # expected, your, title
	if [ "`diff $1 $2`" = "" ]
	then
		printf $color_ok
		printf "[ok]"
	else
		printf $color_ko
		printf "[fail]"
		printf $color_det
		diff $1 $2 > "tmp_diff"
		echo "Failed test with $3" >> $diffttl
		cat "tmp_diff" >> $diffttl
	fi
}

onetest() { # $1 -> file_name
	printf $color_def
	printf "testing $1...\n"
	$execmd $1 &> $your
	onediff "$1.expected" $your "TEST: $1"
	printf "\n\n"
}

testleaks() {
	printf $color_def
	printf "searching leaks with $1...\n"
	pkill tests_leaks &> /dev/null
	./tests_leaks $1 &> /dev/null &
	sleep .6
	leaks tests_leaks | grep "total leaked bytes" | sed -e "s/^Process .*: //g" > "tmp_leaks"
	pkill tests_leaks &> /dev/null
	sleep .1
	if [ "`cat tmp_leaks`" = "0 leaks for 0 total leaked bytes." ]
	then
		printf $color_ok
		printf "[ok]\n\n"
	else
		printf $color_ko
		printf "[leaked] "
		cat tmp_leaks
		printf "\n"
	fi
}

#########################################
###              TESTS                ###
#########################################

onetest "testfiles/sample1"
onetest "testfiles/sample2"
onetest "testfiles/sample3"




printf $color_def
printf "ALL TESTS DONE!\n"
printf "\e[33mWARNING! This version is not finished and may contains bugs\nTake caution with false positives\n"
rm tmp_*
