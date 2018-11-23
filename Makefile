# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bleplat <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/07 09:05:04 by bleplat           #+#    #+#              #
#    Updated: 2018/11/23 12:07:49 by bleplat          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Change the above path to the path of your project, without an ending '/':
TESTED_DIR = ../bad


NAME = tests

INCLUDES = libft/includes
SRC_DIR = .
OBJ_DIR = .
CP_DIR = copyed_project

CFLAGS = -Wall -Wextra
LDFLAGS = -L libft -lft

all: import $(NAME)
	mkdir -p ok_pieces
	./genpieces 1> /dev/null
	chmod 666 ok_pieces/*
	@printf "\e[36mReady to run 'sh fillit_testerizer.sh'...\e[31m\n\n"




###################################
###    Tested Project Import    ###
###################################

norminette:
	@printf "\e[36mrunning norminette...\e[31m\n"
	@cd $(TESTED_DIR) && norminette *.h | sed -e "/^Norme: /d"
	@cd $(TESTED_DIR) && norminette *.c | sed -e "/^Norme: /d"

import:
	@printf "\e[35mcopying files..\n"
	cp -rf $(TESTED_DIR) $(CP_DIR)
	cd $(CP_DIR) && make fclean
	cd $(CP_DIR) && make
	@#ised -E "s/^# define BUFF_SIZE .*/\/\*# define BUFF_SIZE 0\*\//g" $(CP_DIR)/get_next_line.h > swp && mv swp $(CP_DIR)/get_next_line.h

$(GNL_DIR)/libft.a:
	cd $(GNL_DIR)/libft && make 1> /dev/null



###############################
###    TESTS EXECUTABLES    ###
###############################
TESTS_EXE = $(NAME)_colors gettime genpieces

main.o: main.c
	gcc $(CFLAGS) -o $@ -c main.c

genpieces: genpieces.c
	gcc -o $@ $<

$(NAME)_colors: colorc.c
	gcc $(CFLAGS) -o $@ $^

$(NAME)_leaks: main_leaks.c
	gcc $(CFLAGS) -I $(INCLUDES) -o $@ $^ $(LDFLAGS)

gettime: gettime.c
	gcc $(CFLAGS) -o3 -o $@ $<



###########################
###    Special Rules    ###
###########################

%.o: %.c
	@printf "\e33mnothing in rule to make $@!\n"

$(NAME): $(TESTS_EXE)
	@printf "\e[34mmake finished\n"

clean:
	@printf "\e[35mcleaning...\n"
	rm -rf tmp
	rm -f tmp_*
	rm -rf *.o

fclean: clean
	rm -rf $(CP_DIR) 2> /dev/null
	rm -rf $(NAME)_*
	rm -f test_results
	rm -f gettime
	rm -f genpieces
	rm -rf ok_pieces

re: fclean all
