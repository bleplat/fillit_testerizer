/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   genpieces.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bleplat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/11/23 10:18:04 by bleplat           #+#    #+#             */
/*   Updated: 2018/11/23 11:49:12 by bleplat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

int				get_piece(int index)
{
	int		pieces[19];

	pieces[0] = 0x0033; // square

	pieces[1] = 0x1111; // stick |
	pieces[2] = 0x000F; // stick -

	pieces[3] = 0x0072; // T top
	pieces[4] = 0x0131; // T right
	pieces[5] = 0x0027; // T bottom
	pieces[6] = 0x0232; // T left

	pieces[7] = 0x0311; // L down
	pieces[8] = 0x0322; // L down inverted
	pieces[9] = 0x0223; // L up
	pieces[10] = 0x0113; // L up inverted
	pieces[11] = 0x0017; // L left
	pieces[12] = 0x0071; // L left inverted
	pieces[13] = 0x0074; // L right
	pieces[14] = 0x0047; // L right inverted

	pieces[15] = 0x0231; // Z vertical descend
	pieces[16] = 0x0132; // Z vertical ascend
	pieces[17] = 0x0063; // Z horizontal descend
	pieces[18] = 0x0036; // Z horizontal ascend
	if (index < 19)
		return (pieces[index]);
	else
		return (0);
}

void			put_piece(int piece, char *piece_name)
{
	int		ichr;
	int		fd;

	printf("generating %s...\n", piece_name);
	fd = open(piece_name, O_WRONLY | O_CREAT);
	ichr = 0;
	while (ichr < 16)
	{
		if ((piece & (1 << ichr)) != 0)
			write(fd, "#", 1);
		else
			write(fd, ".", 1);
		if ((ichr + 1) % 4 == 0)
			write(fd, "\n", 1);
		ichr++;
	}
	close(fd);
}

char			get_hex(int i)
{
	if ((i & 0xF) <= 9)
		return ('0' + (i & 0xF));
	else
		return ('A' + (i & 0xF) - 10);
}

char			*create_piece_name(const char *path, int piece, const char *end)
{
	char	*dst;
	int		needs;
	int		hexoffset;

	needs = strlen(path) + 4 + strlen(end) + 1;
	dst = (char*)malloc(sizeof(char) * needs);
	if (!dst)
		return (NULL);
	bzero(dst, needs);
	strlcat(dst, path, needs);
	hexoffset = strlen(dst);
	dst[hexoffset + 0] = get_hex(piece >> 12);
	dst[hexoffset + 1] = get_hex(piece >> 8);
	dst[hexoffset + 2] = get_hex(piece >> 4);
	dst[hexoffset + 3] = get_hex(piece >> 0);
	strlcat(dst, end, needs);
	return (dst);
}

void			all_piece_configs(int opiece)
{
	int		currpiece;
	char	*name;
	int		y;
	int		x;
	
	y = 0;
	while (y == 0 || ((opiece << ((y - 1) * 4)) & 0xF000) == 0)
	{
		x = 0;
		while (x == 0 || ((opiece << (x - 1)) & 0x8888) == 0)
		{
			currpiece = (opiece << x) << (y * 4);
			name = create_piece_name("ok_pieces/piece_", currpiece, "");
			put_piece(currpiece, name);
			free(name);
			x++;
		}
		y++;
	}
}

void			all_pieces(void)
{
	int		i_piece;
	int		piece;

	i_piece = 0;
	while (i_piece < 19)
	{
		piece = get_piece(i_piece);
		all_piece_configs(piece);
		i_piece++;
	}
}

int				main(int argc, char **argv)
{
	all_pieces();
	return (0);
}
