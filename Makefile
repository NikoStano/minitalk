# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nistanoj <nistanoj@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/18 01:12:25 by nistanoj          #+#    #+#              #
#    Updated: 2025/09/30 01:41:59 by nistanoj         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SERVER		=	serveur
CLIENT		=	client

INCLUDE		=	includes

CC			=	gcc
CFLAGS		=	-Wall -Werror -Wextra -I$(INCLUDE) -ggdb
COMPILE		=	$(CC) $(CFLAGS)
RM			=	rm -rf

GREEN		=	\033[1;32m
BLUE		=	\033[1;34m
YELLOW		=	\033[1;33m
NO_COLOR	=	\033[0m

UTIL		=	utils.c
SRC_S		=	server.c $(UTIL)
SRC_C		=	client.c $(UTIL)
DIR_OBJ		=	obj/
OBJ_S		=	$(SRC_S:%.c=$(DIR_OBJ)%.o)
OBJ_C		=	$(SRC_C:%.c=$(DIR_OBJ)%.o)
UTI			=	$(UTIL:%.c=$(DIR_OBJ)%.o)

all:			$(SERVER) $(CLIENT)

$(SERVER):		$(OBJ_S)
	@$(COMPILE) $(OBJ_S) -o $@
	@echo "$(GREEN)Use >>> ./server <<< TO SEE PID$(NO_COLOR)"
	@echo ""

$(CLIENT):		$(OBJ_C)
	@$(COMPILE) $(OBJ_C) -o $@
	@echo "$(BLUE)In other terminal exec client as follow$(NO_COLOR)"
	@echo ""
	@echo "$(GREEN)>>> ./client [PID] ["Message what server need to show"]$(NO_COLOR)"

$(DIR_OBJ)%.o:			%.c
	@mkdir -p $(dir $@)
	@$(COMPILE) -c $< -o $@
# 	@echo "$(GREEN)Compiling $<$(NO_COLOR)."

norminette:
	@echo "\$(BLUE)Norminette check :$(NO_COLOR)"
	@python3 -m norminette
	# @norminette

clean:
	@$(RM) $(DIR_OBJ)
	@echo "$(GREEN)OBJ file removed.$(NO_COLOR)"

fclean:			clean
	@$(RM) $(SERVER) $(CLIENT)
	@echo "$(GREEN)Executable file removed.$(NO_COLOR)"

re:				fclean all

bonus:			all

.PHONY:			all norminette clean fclean bonus
