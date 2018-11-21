# /bin/sh

################################################################
### WARNING
### Dont forget to change the path to your project in the Makefile!
####################################################################

execmd="./copyed_project/fillit"

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
printf "\e[1mfillit_\e[34mt\e[35me\e[36ms\e[37mt\e[35m\e[31me\e[32mr\e[33mi\e[34mz\e[35me\e[36mr\e[35m\n\n"

printf "" > $diffttl

getms()
{
	return $(ruby -e 'puts (Time.now.to_f * 1000).to_i')
}

timeout() {
	time=$1
	command="/bin/sh -c \"$2\""
	expect -c "set echo \"-noechoi\"; set timeout $time; spawn -noecho $command; expect timeout { exit 1 } eof { exit 0 }"
	if [ $? = 1 ] ; then
		return 1
	else
		return 0
	fi
}

begintests() { # $1 Title
	printf $color_def
	printf "$1\n"
}

endtests() {
	printf $color_def
	printf "\n"
}

onediff() { # expected, your, title
	if [ "`diff $1 $2`" = "" ]
	then
		printf $color_ok
		printf "\e[25m✓"
	else
		printf $color_ko
		printf "\e[5m✖"
		printf $color_det
		diff $1 $2 &> "tmp_diff"
		echo "Failed test with $3" >> $diffttl
		cat "tmp_diff" >> $diffttl
	fi
}

onetest() { # $1 -> file_name
	#printf "testing $1...\n"
	exetime=$(/usr/bin/time echo $($execmd $1 &> $your) 2>&1 | sed -E "/^$/d" | sed -E "s/^ *//g" | sed -E "s/ .*\$//g")
	onediff "$1.expected" $your "TEST: $1"
	printf "\t(⏳ $exetime)\n"
}

singletest() { # $1 -> file_name
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

# Obvious tests
begintests "Testing obvious files"
onetest "testfiles/obvious1"
onetest "testfiles/obvious2"
onetest "testfiles/obvious3"
onetest "testfiles/obvious4"
onetest "testfiles/obvious5"
onetest "testfiles/obvious6"
endtests

# Obvious bad file
begintests "Testing obvious bad input"
onetest "testfiles/bad1"
onetest "testfiles/bad2"
onetest "testfiles/bad3"
onetest "testfiles/bad4"
onetest "testfiles/bad5"
onetest "testfiles/bad6"
onetest "testfiles/bad7"
onetest "testfiles/bad8"
onetest "testfiles/bad9"
onetest "testfiles/bad10"
onetest "testfiles/bad11"
onetest "testfiles/bad12"
onetest "testfiles/bad13"
onetest "testfiles/bad14"
onetest "testfiles/bad15"
onetest "testfiles/bad16"
onetest "testfiles/bad17"
onetest "testfiles/bad18"
onetest "testfiles/double_piece"
endtests

# Placement order
begintests "Testing placement order"
onetest "testfiles/place_order1"
onetest "testfiles/place_order2"
onetest "testfiles/place_order3"
onetest "testfiles/place_order4"
endtests

# Some puzzles
begintests "Testing with some puzzles"
onetest "testfiles/simple1"
onetest "testfiles/simple2"
onetest "testfiles/simple3"
onetest "testfiles/simple4"
onetest "testfiles/hard1"
endtests

# Subject sample tests
begintests "Testing subject samples"
onetest "testfiles/sample1"
onetest "testfiles/sample2"
onetest "testfiles/sample3"
endtests

# Special bad files
begintests "Testing 'special cases' of bad files"
onetest "testfiles/error"
onetest "testfiles/error_nonl"
onetest "testfiles/obvious2_nonl"
onetest "testfiles/obvious2_inline"
onetest "testfiles/lorem_ipsum"
onetest "testfiles/empty"
onetest "testfiles/nl"
onetest "testfiles/dot_nonl"
onetest "testfiles/big_bad"
endtests





printf $color_def
printf "ALL TESTS DONE!\n"
printf "\e[33mWARNING! This version is not finished and may contains bugs\nTake caution with false positives\n"
rm tmp_*
