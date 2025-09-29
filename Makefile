# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nistanoj <nistanoj@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/18 01:12:25 by nistanoj          #+#    #+#              #
#    Updated: 2025/09/29 16:16:58 by nistanoj         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SERVER		=	serveur
CLIENT		=	client

INCLUDE		=	includes

CC			=	gcc
CFLAGS		=	-Wall -Werror -Wextra -I$(INCLUDE)
COMPILE		=	$(CC) $(CFLAGS)
RM			=	rm -rf

GREEN		=	\033[1;32m
BLUE		=	\033[1;34m
YELLOW		=	\033[1;33m
NO_COLOR	=	\033[0m

UTIL		=	utils.c
SERV		=	server.c $(UTIL)
CLIE		=	client.c $(UTIL)
DIR_OBJ		=	obj/
OBJS		=	$(SERV:%.c=$(DIR_OBJ)%.o)
OBJC		=	$(CLIE:%.c=$(DIR_OBJ)%.o)
UTI			=	$(UTIL:%.c=$(DIR_OBJ)%.o)

all:			$(SERVER) $(CLIENT)
	@echo "$(GREEN)Use >>>  ./server <<< to see PID$(NO_COLOR)"
	@echo "$(GREEN)then in other terminal exec client as follow$(NO_COLOR)"
	@echo "$(GREEN)>>> ./client [PID] ["Message what server need to show"]$(NO_COLOR)"

$(SERVER):		$(OBJS)
	@$(COMPILE) $(OBJS) -o $@

$(CLIENT):		$(OBJC)
	@$(COMPILE) $(OBJC) -o $@

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
