/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: nistanoj <nistanoj@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/18 01:56:19 by nistanoj          #+#    #+#             */
/*   Updated: 2025/09/30 18:18:28 by nistanoj         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "includes/minitalk.h"

volatile sig_atomic_t	g_ack;

static void	ack_handler(int signal)
{
	(void)signal;
	g_ack = 1;
}

static void	send_char(char c, int pid)
{
	int	i;

	i = 7;
	while (i >= 0)
	{
		g_ack = 0;
		if ((c >> i) & 1)
			kill(pid, SIGUSR1);
		else
			kill(pid, SIGUSR2);
		if (!g_ack)
			pause();
		i--;
	}
}

static void	check_str(char *str, int pid)
{
	while (*str)
		send_char(*str++, pid);
	send_char('\0', pid);
}

static void	handler(int signal)
{
	(void)signal;
	ft_putstr("\033[1;32mLe server a recu le message !\n\033[0m");
	exit(0);
}

int	main(int ac, char **av)
{
	pid_t	pid;
	char	*str;

	if (ac != 3)
		return (ft_putstr("Usage: ./client <PID> <message>\n"), 1);
	pid = atoi(av[1]);
	if (pid <= 0 || !pid)
		return (ft_putstr("Invalid PID\n"), 1);
	str = av[2];
	signal(SIGUSR1, handler);
	signal(SIGUSR2, ack_handler);
	check_str(str, pid);
}
