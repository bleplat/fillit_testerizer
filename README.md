# Install
- go out of your project folder.
- do `git clone https://github.com/bleplat/fillit_testerizer.git && cd fillit_testerizer`.
- edit the Makefile and write the path to your projet in the TESTED_DIR field (without the ending '/').

# run tests
- run `sh fillit_testerizer.sh`
- in case of errors, you can use the 'test_results' file to investigate, but errors do not mean you are wrong.

# add custom tests
You can create a folder called 'customtests' and put tests in it to also run your own tests.
The input file should be called `name` ('name' can be anything you want) and the expected result file should be called `name.expected`.
The same syntax is used for tests in 'testfiles' and 'ok_pieces'

# display with color
You can pipe the output ou fillit into './tests_colors' to display the output in colors:
`./copyed_project/fillit ./testfiles/hard1 | ./tests_colors`.
