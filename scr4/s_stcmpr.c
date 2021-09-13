#include "s_strs.h"

unsigned char   SCR_ALTSEQ[] = {
	    /* 00     */ ' ',
	    /* 01     */ ' ',
	    /* 02     */ ' ',
	    /* 03     */ ' ',
	    /* 04     */ ' ',
	    /* 05     */ ' ',
	    /* 06     */ ' ',
	    /* 07     */ ' ',
	    /* 08     */ ' ',
	    /* 09     */ ' ',
	    /* 0a     */ ' ',
	    /* 0b     */ ' ',
	    /* 0c     */ ' ',
	    /* 0d     */ ' ',
	    /* 0e     */ ' ',
	    /* 0f     */ ' ',
	    /* 10     */ ' ',
	    /* 11     */ ' ',
	    /* 12     */ ' ',
	    /* 13     */ ' ',
	    /* 14     */ ' ',
	    /* 15     */ ' ',
	    /* 16     */ ' ',
	    /* 17     */ ' ',
	    /* 18     */ ' ',
	    /* 19     */ ' ',
	    /* 1a     */ ' ',
	    /* 1b     */ ' ',
	    /* 1c     */ ' ',
	    /* 1d     */ ' ',
	    /* 1e     */ ' ',
	    /* 1f     */ ' ',
	    /* 20 ( ) */ ' ',
	    /* 21 (!) */ ' ',
	    /* 22 (") */ ' ',
	    /* 23 (#) */ ' ',
	    /* 24 ($) */ ' ',
	    /* 25 (%) */ ' ',
	    /* 26 (&) */ ' ',
	    /* 27 (') */ ' ',
	    /* 28 (() */ ' ',
	    /* 29 ()) */ ' ',
	    /* 2a (*) */ ' ',
	    /* 2b (+) */ ' ',
	    /* 2c (,) */ ' ',
	    /* 2d (-) */ ' ',
	    /* 2e (.) */ ' ',
	    /* 2f (/) */ ' ',
	    /* 30 (0) */ '0',
	    /* 31 (1) */ '1',
	    /* 32 (2) */ '2',
	    /* 33 (3) */ '3',
	    /* 34 (4) */ '4',
	    /* 35 (5) */ '5',
	    /* 36 (6) */ '6',
	    /* 37 (7) */ '7',
	    /* 38 (8) */ '8',
	    /* 39 (9) */ '9',
	    /* 3a (:) */ ' ',
	    /* 3b (;) */ ' ',
	    /* 3c (<) */ ' ',
	    /* 3d (=) */ ' ',
	    /* 3e (>) */ ' ',
	    /* 3f (?) */ ' ',
	    /* 40 (@) */ ' ',
	    /* 41 (A) */ 'A',
	    /* 42 (B) */ 'B',
	    /* 43 (C) */ 'C',
	    /* 44 (D) */ 'D',
	    /* 45 (E) */ 'E',
	    /* 46 (F) */ 'F',
	    /* 47 (G) */ 'G',
	    /* 48 (H) */ 'H',
	    /* 49 (I) */ 'I',
	    /* 4a (J) */ 'J',
	    /* 4b (K) */ 'K',
	    /* 4c (L) */ 'L',
	    /* 4d (M) */ 'M',
	    /* 4e (N) */ 'N',
	    /* 4f (O) */ 'O',
	    /* 50 (P) */ 'P',
	    /* 51 (Q) */ 'Q',
	    /* 52 (R) */ 'R',
	    /* 53 (S) */ 'S',
	    /* 54 (T) */ 'T',
	    /* 55 (U) */ 'U',
	    /* 56 (V) */ 'V',
	    /* 57 (W) */ 'W',
	    /* 58 (X) */ 'X',
	    /* 59 (Y) */ 'Y',
	    /* 5a (Z) */ 'Z',
	    /* 5b ([) */ ' ',
	    /* 5c (\) */ ' ',
	    /* 5d (]) */ ' ',
	    /* 5e (^) */ ' ',
	    /* 5f (_) */ ' ',
	    /* 60 (`) */ ' ',
	    /* 61 (a) */ 'A',
	    /* 62 (b) */ 'B',
	    /* 63 (c) */ 'C',
	    /* 64 (d) */ 'D',
	    /* 65 (e) */ 'E',
	    /* 66 (f) */ 'F',
	    /* 67 (g) */ 'G',
	    /* 68 (h) */ 'H',
	    /* 69 (i) */ 'I',
	    /* 6a (j) */ 'J',
	    /* 6b (k) */ 'K',
	    /* 6c (l) */ 'L',
	    /* 6d (m) */ 'M',
	    /* 6e (n) */ 'N',
	    /* 6f (o) */ 'O',
	    /* 70 (p) */ 'P',
	    /* 71 (q) */ 'Q',
	    /* 72 (r) */ 'R',
	    /* 73 (s) */ 'S',
	    /* 74 (t) */ 'T',
	    /* 75 (u) */ 'U',
	    /* 76 (v) */ 'V',
	    /* 77 (w) */ 'W',
	    /* 78 (x) */ 'X',
	    /* 79 (y) */ 'Y',
	    /* 7a (z) */ 'Z',
	    /* 7b ({) */ ' ',
	    /* 7c (|) */ ' ',
	    /* 7d (}) */ ' ',
	    /* 7e (~) */ ' ',
	    /* 7f () */ ' ',
	    /* 80 (�) */ 'C',
	    /* 81 (�) */ 'U',
	    /* 82 (�) */ 'E',
	    /* 83 (�) */ 'A',
	    /* 84 (�) */ 'A',
	    /* 85 (�) */ 'A',
	    /* 86 (�) */ 'A',
	    /* 87 (�) */ 'C',
	    /* 88 (�) */ 'E',
	    /* 89 (�) */ 'E',
	    /* 8a (�) */ 'E',
	    /* 8b (�) */ 'I',
	    /* 8c (�) */ 'I',
	    /* 8d (�) */ 'I',
	    /* 8e (�) */ 'A',
	    /* 8f (�) */ 'A',
	    /* 90 (�) */ 'E',
	    /* 91 (�) */ 'A',
	    /* 92 (�) */ 'A',
	    /* 93 (�) */ 'O',
	    /* 94 (�) */ 'O',
	    /* 95 (�) */ 'O',
	    /* 96 (�) */ 'U',
	    /* 97 (�) */ 'U',
	    /* 98 (�) */ 'Y',
	    /* 99 (�) */ 'O',
	    /* 9a (�) */ 'U',
	    /* 9b (�) */ ' ',
	    /* 9c (�) */ ' ',
	    /* 9d (�) */ ' ',
	    /* 9e (�) */ ' ',
	    /* 9f (�) */ ' ',
	    /* a0 (�) */ 'A',
	    /* a1 (�) */ 'I',
	    /* a2 (�) */ 'O',
	    /* a3 (�) */ 'U',
	    /* a4 (�) */ 'N',
	    /* a5 (�) */ 'N',
	    /* a6 (�) */ ' ',
	    /* a7 (�) */ ' ',
	    /* a8 (�) */ ' ',
	    /* a9 (�) */ ' ',
	    /* aa (�) */ ' ',
	    /* ab (�) */ ' ',
	    /* ac (�) */ ' ',
	    /* ad (�) */ ' ',
	    /* ae (�) */ ' ',
	    /* af (�) */ ' ',
	    /* b0 (�) */ ' ',
	    /* b1 (�) */ ' ',
	    /* b2 (�) */ ' ',
	    /* b3 (�) */ ' ',
	    /* b4 (�) */ ' ',
	    /* b5 (�) */ ' ',
	    /* b6 (�) */ ' ',
	    /* b7 (�) */ ' ',
	    /* b8 (�) */ ' ',
	    /* b9 (�) */ ' ',
	    /* ba (�) */ ' ',
	    /* bb (�) */ ' ',
	    /* bc (�) */ ' ',
	    /* bd (�) */ ' ',
	    /* be (�) */ ' ',
	    /* bf (�) */ ' ',
	    /* c0 (�) */ ' ',
	    /* c1 (�) */ ' ',
	    /* c2 (�) */ ' ',
	    /* c3 (�) */ ' ',
	    /* c4 (�) */ ' ',
	    /* c5 (�) */ ' ',
	    /* c6 (�) */ ' ',
	    /* c7 (�) */ ' ',
	    /* c8 (�) */ ' ',
	    /* c9 (�) */ ' ',
	    /* ca (�) */ ' ',
	    /* cb (�) */ ' ',
	    /* cc (�) */ ' ',
	    /* cd (�) */ ' ',
	    /* ce (�) */ ' ',
	    /* cf (�) */ ' ',
	    /* d0 (�) */ ' ',
	    /* d1 (�) */ ' ',
	    /* d2 (�) */ ' ',
	    /* d3 (�) */ ' ',
	    /* d4 (�) */ ' ',
	    /* d5 (�) */ ' ',
	    /* d6 (�) */ ' ',
	    /* d7 (�) */ ' ',
	    /* d8 (�) */ ' ',
	    /* d9 (�) */ ' ',
	    /* da (�) */ ' ',
	    /* db (�) */ ' ',
	    /* dc (�) */ ' ',
	    /* dd (�) */ ' ',
	    /* de (�) */ ' ',
	    /* df (�) */ ' ',
	    /* e0 (�) */ 'A',
	    /* e1 (�) */ 'B',
	    /* e2 (�) */ 'G',
	    /* e3 (�) */ 'P',
	    /* e4 (�) */ 'S',
	    /* e5 (�) */ 'S',
	    /* e6 (�) */ 'M',
	    /* e7 (�) */ 'G',
	    /* e8 (�) */ 'F',
	    /* e9 (�) */ 'T',
	    /* ea (�) */ 'O',
	    /* eb (�) */ 'D',
	    /* ec (�) */ ' ',
	    /* ed (�) */ 'F',
	    /* ee (�) */ 'E',
	    /* ef (�) */ ' ',
	    /* f0 (�) */ ' ',
	    /* f1 (�) */ ' ',
	    /* f2 (�) */ ' ',
	    /* f3 (�) */ ' ',
	    /* f4 (�) */ ' ',
	    /* f5 (�) */ ' ',
	    /* f6 (�) */ ' ',
	    /* f7 (�) */ ' ',
	    /* f8 (�) */ ' ',
	    /* f9 (�) */ ' ',
	    /* fa (�) */ ' ',
	    /* fb (�) */ ' ',
	    /* fc (�) */ ' ',
	    /* fd (�) */ ' ',
	    /* fe (�) */ ' ',
	    /* ff (�) */ 0xFF           /* JMP_M 4.19 03-06-95 */
	    };

/* ====================================================================
Fonction utilis�e pour d�finir les index SQZ dans les ISAM. Le string
str de lg caract�res est transform� en res en supprimant tous les
caract�res non alphanum�riques et en mettant tous les caract�res
minuscules en majuscule. Les caract�res de fin sont remplac�s par des
blancs.

Il n'y a pas de '\0' plac� � la fin du string.

&RT le pointeur vers le r�sultat res
&EX
    SCR_compress("de Biolley M.", buf, 13);

    buf vaut : "DEBIOLLEYM   "
&TX
&SA SCR_zstrip(), SCR_sqz()
=======================================================================*/

unsigned char *SCR_compress(res, str, lg)
unsigned char *res, *str;
int             lg;
{
    int     i, j;

    for(i = 0, j = 0 ; i < lg; i++) {
	if(str[i] == 0) break;              /* JMP 15-09-93 */
	res[j] = SCR_ALTSEQ[str[i]];
	if(res[j] != ' ') j++;
	}
    for( ; j < lg; j++) res[j] = ' ';
    return(res);
}

/*NH*/
unsigned char *SCR_compress2(res, str, lg)
unsigned char *res, *str;
int             lg;
{
    int     i, j;

    SCR_ALTSEQ[37] = '%';
    for(i = 0, j = 0 ; i < lg; i++) {
	if(str[i] == 0) break;
	res[j] = SCR_ALTSEQ[str[i]];
	if(res[j] != ' ') j++;
	}
    for( ; j < lg; j++) res[j] = ' ';
    SCR_ALTSEQ[25] = ' ';
    return(res);
}


