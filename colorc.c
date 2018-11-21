/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   colorc.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bleplat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/11/20 18:47:14 by bleplat           #+#    #+#             */
/*   Updated: 2018/11/21 13:55:09 by bleplat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>

void	ft_putcolor(char c)
{
	int rnd;

	rnd = c % (7 + 7);
	if (rnd <= 7)
		printf("\e[3%cm%c", '1' + (rnd % 7), c);
	else
		printf("\e[9%cm%c", '1' + ((rnd - 7) % 7), c);
}

int		main(int argc, char **argv)
{
	int		fd;
	char	buff;

	if (argc == 1)
		fd = 0;
	else
		fd = open(argv[1], O_RDONLY);
	if (fd < 0)
		return (1);
	
	while ((read(fd, &buff, 1)) > 0)
	{
		ft_putcolor(buff);
	}
	printf("\e[0m");
}
