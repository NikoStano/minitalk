/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: nistanoj <nistanoj@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/18 04:54:21 by nistanoj          #+#    #+#             */
/*   Updated: 2025/09/29 21:33:19 by nistanoj         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "includes/minitalk.h"

static void	check_str(char *new_str, char c)
{
	if (!new_str)
		return ;
	new_str[0] = c;
	new_str[1] = '\0';
}

static char	*ft_strchar(char *str, char c)
{
	char	*new_str;
	int		len;
	int		i;

	if (!str)
	{
		new_str = malloc(2);
		check_str(new_str, c);
		return (new_str);
	}
	len = ft_strlen(str);
	new_str = malloc(len + 2);
	if (!new_str)
		return (NULL);
	i = 0;
	while (i < len)
	{
		new_str[i] = str[i];
		i++;
	}
	new_str[len] = c;
	new_str[len + 1] = '\0';
	free(str);
	return (new_str);
}

static void	send_char(char *message, siginfo_t *info)
{
	ft_putstr(message);
	free(message);
	message = NULL;
	kill(info->si_pid, SIGUSR1);
}

static void	handler(int sig, siginfo_t *info, void *ucontext)
{
	static int	bit;
	static char	c;
	static char	*message;

	(void)ucontext;
	if (sig == SIGUSR1)
		c |= (1 << (7 - bit));
	bit++;
	if (bit == 8)
	{
		message = ft_strchar(message, c);
		if (!message)
			exit(1);
		if (c == '\0')
			send_char(message, info);
		else
			kill(info->si_pid, SIGUSR2);
		c = 0;
		bit = 0;
	}
	else
		kill(info->si_pid, SIGUSR2);
}

int main(void)
{
	struct sigaction sa;
	char	*pid_str;

	sa.sa_sigaction = handler;
	sa.sa_flags = SA_SIGINFO;
	sigemptyset(&sa.sa_mask);
	sigaction(SIGUSR1, &sa, NULL);
	sigaction(SIGUSR2, &sa, NULL);
	ft_putstr("PID: ");
	pid_str = ft_itoa((int)getpid());
	if (pid_str)
	{
		ft_putstr(pid_str);
		ft_putchar('\n');
		free(pid_str);
	}
	while (1)
		pause();
	return (0);
}
