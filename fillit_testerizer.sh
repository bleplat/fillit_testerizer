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
color_ok2="\e[92m"
color_ko2="\e[91m"

if [ $1 = "run" ]
then
	printf $color_def
	printf "Running tests without running make!\n"
else
	printf $color_def
	printf "Making files and running tests...\n"
	make re
	make norminette
fi

printf $color_def
printf "\e[1mfillit_\e[34mt\e[35me\e[36ms\e[37mt\e[35m\e[31me\e[32mr\e[33mi\e[34mz\e[35me\e[36mr\e[35m\n\n\e[0m"

printf "" > $diffttl

okttl=0
kottl=0

gotok() {
	okttl=`expr $okttl + 1`
}

gotko() {
	kottl=`expr $kottl + 1`
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
		printf " ✓ "
		printf $color_ok2
		gotok
	else
		printf $color_ko
		printf " \e[5m✖\e[25m "
		diff $1 $2 &> "tmp_diff"
		echo "Failed test with $3" >> $diffttl
		cat "tmp_diff" >> $diffttl
		printf $color_ko2
		gotko
	fi
}

onetest() { # $1 -> file_name
	#exetime=$(/usr/bin/time echo $($execmd $1 &> $your) 2>&1 | sed -E "/^$/d" | sed -E "s/^ *//g" | sed -E "s/ .*\$//g")
	timestart=$(./gettime)
	$execmd $1 &> $your
	timeend=$(./gettime)
	onediff "$1.expected" $your "TEST: $1"
	printf " ⏳ `echo \"scale = 1; $timeend - $timestart\" | bc -l` \t($1)\n"
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
onetest "testfiles/obvious2_inline"
onetest "testfiles/lorem_ipsum"
onetest "testfiles/empty"
onetest "testfiles/nl"
onetest "testfiles/dot_nonl"
onetest "testfiles/big_bad"
endtests

# Very bad cases
begintests "Testing d**k cases"
onetest "testfiles/unexisting"
onetest "testfiles/obvious2_nonl"
chmod 000 "testfiles/protected"
onetest "testfiles/protected"
chmod 775 "testfiles/protected"
endtests

# All possible pieces
ireturnline=0
begintests "Testing with ALL possible pieces:"
for file in ./ok_pieces/*
do
	if [[ $file =~ ^.*\.expected ]]
	then
		if [ $ireturnline -eq 8 ]
		then
			printf "\n"
			ireturnline=0
		fi
		$execmd $(echo $file | sed "s/\.expected//g") &> $your
		onediff $file $your $(echo $file | sed "s/\.expected//g")
		ireturnline=`expr $ireturnline + 1`
	fi
done
endtests

# Custom tests
begintests "Other custom tests:"
for file in ./customtests/*
do
	if [[ $file =~ ^.*\.expected ]]
	then
		printf "$file: "
		$execmd $(echo $file | sed "s/\.expected//g") &> $your
		onediff $file $your $file
		printf "\n"
	fi
done
endtests

# Bad arguments
begintests "Testing bad arguments"
cat "testfiles/error.expected" > $expect
#$execmd &> $your
#onediff $expect $your "Testing with 0 args"
#$execmd "###" "555" &> $your
#onediff $expect $your "Testing with 2 bad args"
#$execmd "testfiles/obvious1" "testfiles/obvious2" &> $your
#onediff $expect $your "Testing with 2 good args"
$execmd "testfiles/" &> $your
onediff $expect $your "Testing with folder"
$execmd "" &> $your
onediff $expect $your "Testing with empty arg"
$execmd &> tmp_your1
$execmd "testfiles/simple1" "555" &> tmp_your2
onediff tmp_your1 tmp_your2 "Testing usage display"
printf "\n"
endtests



printf $color_def
printf "ALL TESTS DONE!\n"
printf "$color_ok\tSUCCESS: $okttl / `expr $okttl + $kottl`\n"
printf "$color_ko\tFAILS: $kottl / `expr $okttl + $kottl`\n"
printf "\e[33mWARNING! This version is not finished and may contains bugs\nTake caution with false positives\n"
rm tmp_*
