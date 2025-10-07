# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nistanoj <nistanoj@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/18 01:12:25 by nistanoj          #+#    #+#              #
#    Updated: 2025/10/07 22:30:58 by nistanoj         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SERVER		=	server
CLIENT		=	client

INCLUDE		=	includes

CC			=	gcc
CFLAGS		=	-Wall -Werror -Wextra -I$(INCLUDE) -ggdb
COMPILE		=	$(CC) $(CFLAGS)
RM			=	rm -rf

RED			=	\033[0;31m
GREEN		=	\033[0;32m
L_GREEN		=	\033[1;32m
YELLOW		=	\033[0;33m
BLUE		=	\033[0;34m
MAGENTA		=	\033[0;35m
CYAN		=	\033[0;36m
BOLD		=	\033[1m
RESET		=	\033[0m

UTIL		=	utils.c
SRC_S		=	server.c $(UTIL)
SRC_C		=	client.c $(UTIL)
DIR_OBJ		=	obj/
OBJ_S		=	$(SRC_S:%.c=$(DIR_OBJ)%.o)
OBJ_C		=	$(SRC_C:%.c=$(DIR_OBJ)%.o)
UTI			=	$(UTIL:%.c=$(DIR_OBJ)%.o)

all:			$(SERVER) $(CLIENT)

$(SERVER):		$(OBJ_S)
	@echo "$(CYAN)[ → ] Linking $(BOLD)$(SERVER)...$(RESET)"
	@$(COMPILE) $(OBJ_S) -o $@
	@echo "$(GREEN)[ ✓ ] $(BOLD)$(SERVER) compiled successfully!$(RESET)"

$(CLIENT):		$(OBJ_C)
	@echo "$(CYAN)[ → ] Linking $(BOLD)$(CLIENT)...$(RESET)"
	@$(COMPILE) $(OBJ_C) -o $@
	@echo "$(GREEN)[ ✓ ] $(BOLD)$(CLIENT) compiled successfully!$(RESET)"

$(DIR_OBJ)%.o:			%.c
	@mkdir -p $(dir $@)
	@echo "$(YELLOW)[ ℹ ] Compiling $(BOLD)$<...$(RESET)"
	@$(COMPILE) -c $< -o $@

norminette:
	@echo "$(CYAN)[ ℹ ] Running norminette...$(RESET)"
	@if command -v python3 >/dev/null 2>&1; then \
		OUTPUT=$$(python3 -m norminette 2>&1 | grep "Error"); \
		if [ -z "$$OUTPUT" ]; then \
			echo "$(GREEN)[ ✓ ] Norminette passed!$(RESET)"; \
		else \
			python3 -m norminette 2>&1 | grep -v "Norme: OK"; \
			echo "$(RED)[ ✗ ] Norminette found errors!$(RESET)"; \
		fi; \
	else \
		echo "$(RED)[ ✗ ] Norminette is not installed.$(RESET)"; \
	fi
	@echo "$(CYAN)[ ℹ ] Norminette check completed.$(RESET)"

clean:
	@echo "$(RED)[🧹 ] Cleaning object files...$(RESET)"
	@$(RM) $(DIR_OBJ)

fclean:			clean
	@echo "$(RED)[🧹 ] Cleaning executable...$(RESET)"
	@$(RM) $(SERVER) $(CLIENT)

re:				fclean all

bonus:			all

# test: $(SERVER) $(CLIENT) norminette
# 	@echo "$(YELLOW)╔════════════════════════════════════╗$(RESET)"
# 	@echo "$(YELLOW)║     Launching test on MINITALK     ║$(RESET)"
# 	@echo "$(YELLOW)╚════════════════════════════════════╝$(RESET)"
# 	@echo "$(CYAN)→ Cloning minitalk...$(RESET)"
# 	@git clone -q https://github.com/NikoStano/minitalk-tester.git
# 	@echo "$(GREEN)✓ minitalk-tester cloned successfully!$(RESET)"
# 	@$(MAKE) -s -C minitalk-tester
# 	@cd minitalk-tester

test: $(SERVER) $(CLIENT)
	@echo "$(YELLOW)╔════════════════════════════════════╗$(RESET)"
	@echo "$(YELLOW)║     Launching test on MINITALK     ║$(RESET)"
	@echo "$(YELLOW)╚════════════════════════════════════╝$(RESET)"
	@echo "$(CYAN)[ → ] Cloning minitalk...$(RESET)"
	@git clone -q https://github.com/NikoStano/minitalk-tester.git
	@echo "$(YELLOW)[ ℹ ]Launching server in background...$(RESET)"
	@./server & \
	SERVER_PID=$$!; \
	sleep 1; \
	echo "$(YELLOW)[ ℹ ] Running tests with PID $$SERVER_PID$(RESET)"; \
	$(MAKE) -s -C minitalk-tester test $$SERVER_PID; \
	kill $$SERVER_PID
	@echo "$(CYAN)[ → ] All tests ran! Cleaning up...$(RESET)"
	@$(MAKE) -s fclean
	@rm -rf minitalk-tester
	@echo "$(L_GREEN)[ ✓ ] All tests completed$(RESET)"

.PHONY:			all norminette clean fclean bonus test
