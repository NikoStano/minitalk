/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: nistanoj <nistanoj@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/18 04:54:21 by nistanoj          #+#    #+#             */
/*   Updated: 2025/09/23 18:13:19 by nistanoj         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "includes/minitalk.h"

static char	*ft_strchar(char *str, char c)
{
	char	*new_str;
	int		len;
	int		i;

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
		{
			ft_putstr(message);
			free(message);
			message = NULL;
			kill(info->si_pid, SIGUSR1);
		}
		c = 0;
		bit = 0;
	}
	kill(info->si_pid, SIGUSR2);
}

int main(void)
{
	struct sigaction sa;

	sa.sa_sigaction = handler;
	sa.sa_flags = SA_SIGINFO;
	sigemptyset(&sa.sa_mask);
	sigaction(SIGUSR1, &sa, NULL);
	sigaction(SIGUSR2, &sa, NULL);
	ft_putstr("PID: ");
	ft_putstr(ft_itoa((int)getpid()));
	ft_putchar('\n');
	while (1)
		pause();
	return (0);
}
