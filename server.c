/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: nistanoj <nistanoj@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/18 04:54:21 by nistanoj          #+#    #+#             */
/*   Updated: 2025/09/30 18:54:50 by nistanoj         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "includes/minitalk.h"

static char	*ft_strchar(char *str, char c)
{
	int		i;
	int		len;
	char	*new_str;

	if (!str)
	{
		new_str = malloc(2);
		if (!new_str)
			return (NULL);
		new_str[0] = c;
		new_str[1] = '\0';
		return (new_str);
	}
	len = ft_strlen(str);
	new_str = malloc(len + 2);
	if (!new_str)
		return (NULL);
	i = -1;
	while (++i < len)
		new_str[i] = str[i];
	new_str[len] = c;
	new_str[len + 1] = '\0';
	return (free(str), new_str);
}

static void	send_str(char **message, char c, siginfo_t *info)
{
	if (c == '\0')
	{
		if (*message)
		{
			ft_putstr(*message);
			free(*message);
			*message = NULL;
		}
		write(1, "\n", 1);
		kill(info->si_pid, SIGUSR1);
	}
	else
	{
		*message = ft_strchar(*message, c);
		kill(info->si_pid, SIGUSR2);
	}
}

static void	handler(int sig, siginfo_t *info, void *context)
{
	static int		bit;
	static char		c;
	static char		*message = NULL;

	(void)context;
	if (sig == SIGUSR1)
		c |= (1 << (7 - bit));
	bit++;
	if (bit == 8)
	{
		send_str(&message, c, info);
		bit = 0;
		c = 0;
	}
	else
		kill(info->si_pid, SIGUSR2);
}

int	main(void)
{
	struct sigaction	sa;

	sa.sa_sigaction = handler;
	sa.sa_flags = SA_SIGINFO;
	sigemptyset(&sa.sa_mask);
	sigaction(SIGUSR1, &sa, NULL);
	sigaction(SIGUSR2, &sa, NULL);
	write(1, "PID: ", 5);
	ft_putnbr((int)getpid());
	write(1, "\n", 1);
	while (1)
		pause();
}
