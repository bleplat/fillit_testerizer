/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   colorc.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bleplat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/11/20 18:47:14 by bleplat           #+#    #+#             */
/*   Updated: 2018/11/20 18:54:47 by bleplat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>

int main(int argc, char **argv)
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
		printf("\e[3%cm%c", '0' + (buff % 8), buff);
	}
	printf("\e[0m");
}
