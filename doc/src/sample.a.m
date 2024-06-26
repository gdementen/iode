/*SAMPLE*/

<Sample d'impression>

    D馭inition du sample d'impression
    覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�

La d馭inition du sample d'impression concerne la compilation et
l'impression ou la visualisation des tables et des graphiques.

Les valeurs � imprimer ou � visualiser figurent dans la d馭inition des
tables et des graphiques sous forme d'une formule LEC. Cette forme LEC
ne donne aucune indication sur l'馗hantillonnage (p駻iode(s)
d'impression) ni sur la repr駸entation (en valeur relative, en taux de
croissance,...) de la valeur � imprimer. Ces derni鑽es informations sont
apport馥s par le sample d'impression.

Le sample d'impression contient des informations sur:

&EN l'馗hantillonnage des p駻iodes relatives aux variables ou aux valeurs
    calcul馥s � imprimer

&EN les op駻ations � effectuer sur les variables � imprimer

&EN les fichiers o� se trouvent les variables � imprimer ou intervenant
    dans le calcul des valeurs � imprimer.

&TI Syntaxe d'un sample d'impression
覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧

La syntaxe d'un sample r駱ond aux r鑒les d馗rites ci-dessous. Un sample est
compos� de p駻iodes, d'op駻ations sur des p駻iodes, d'op駻ations sur des
fichiers, de facteur(s) de r駱騁ition.

&IT Syntaxe d'une p駻iode
覧覧覧覧覧覧覧覧覧覧覧覧�

&EN une p駻iode s'indique comme en LEC : ~cyyPpp~C ou ~cyyyyPpp~C o� ~cyyyy~C
    indique l'ann馥, ~cP~C la p駻iodicit� et ~cpp~C la sous-p駻iode ~c(1990Y1)~C

&EN une p駻iode peut 黎re d馗al馥 de n p駻iodes vers la gauche ou la droite � l'aide des
    op駻ateurs ~c<<n~C et ~c>>n~C

&EN When used with a null argument, the shift oprerators have a special meaning :
&EN2 ~c<<0~C means "first period of the year"
&EN2 ~c>>0~C means "last period of the year"

&EN les p駻iodes sp馗iales ~cBOS,~C ~cEOS~C et ~cNOW~C peuvent 黎re
utilis馥s pour repr駸enter le d饕ut, la fin du sample courant ou la p駻iode
actuelle (horloge du PC).

&EN les p駻iodes sp馗iales ~cBOS1,~C ~cEOS1~C et ~cNOW1~C sont 駲uivalentes aux pr馗馘entes � ceci pr鑚 qu'elles
    sont d駱lac馥s � la premi鑽e sous p駻iode de l'ann馥 de ~cBOS,~C ~cEOS~C et ~cNOW~C
    respectivement (si ~cNOW~C = ~c2012M5~C, ~cNOW1~C = ~c2012M1~C).

&EN Chaque p駻iode est s駱ar馥 de la suivante par un point-virgule.

&EN Une p駻iode ou un groupe des p駻iodes peuvent 黎re r駱騁馥s : il
    suffit de placer apr鑚 la d馭inition de la colonne ou du groupe de
    colonnes le caract鑽e double point (:) suivi du nombre de
    r駱騁itions souhait�. La r駱騁ition se fait avec un incr駑ent de une
    p駻iode, sauf si elle est suivie d'une ast駻isque et d'une valeur.
    Cette valeur est alors l'incr駑ent de r駱騁ition. Elle peut 黎re n馮ative auquel
    cas les p駻iodes se pr駸enteront de mani鑽e d馗roissante.

&EN La r駱騁ition, l'incr駑ent et le shift peuvent 黎re les mots ~cPER~C (ou
    ~cP~C) ou ~cSUB~C (ou ~cS~C) qui indiquent respectivement le nombre de
    p駻iodes dans une ann馥 du sample courant et la sous p駻iode courante.

&EN La d馭inition des fichiers est optionnelle et est plac馥 entre
    crochets. Elle s'applique � toute la d馭inition de p駻iode qui pr馗鐡e.

&IT Op駻ations sur les fichiers
覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�

Les op駻ations possibles sur les fichiers sont :

&EN valeur absolue                        ~c[1]~C
&EN diff駻ence                            ~c[1-2]~C
&EN diff駻ence en pourcents               ~c[1/2]~C
&EN somme                                 ~c[1+2]~C
&EN moyenne                               ~c[1~~2]~C ou ~c[1^2]~C

&IT Op駻ations sur les p駻iodes
覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
Les op駻ations sur les p駻iodes sont :

&EN valeur (75)
&EN taux de croissance sur une ou plusieurs p駻iodes (75/74, 75/70)
&EN taux de croissance moyen (75//70)
&EN diff駻ence (75-74, 75-70)
&EN diff駻ence moyenne (75--70)
&EN moyenne (75~~74) ou (75^74)
&EN somme de p駻iode � p駻iode cons馗utives (70Q1+70Q4)
&EN valeur en indice ou en base (76=70)

La r駱騁ition peut s'effectuer avec un incr駑ent sup駻ieur � 1 ou inf駻ieur � 0 : il
suffit de placer une 騁oile suivie du pas apr鑚 le nombre de r駱騁itions
(70:3*5 = 70, 75, 80).

&EX
	    70; 75; 80:6
	    = 70:3*5; 81:5
	    = 70; 75; 80; 81; 82; 83; 84; 85

	    70/69:2
	    = 70/69; 71/70

	    (70; 70-69):2
	    = 70; 70-69; 71; 71-70;

	    70[1,2]:2*5
	    = 70[1]; 70[2]; 75[1]; 75[2]

	    (70;75)[1,2-1]
	    = 70[1];75[1];70[2-1];75[2-1]

	    (70;75;(80; 80/79):2)[1,2]
	    = 70[1]; 70[2]; 75[1]; 75[2]; 80[1];
		80[2]; 80/79[1]; 80/79[2] 81[1]; 81[2];
		    81/80[1]; 81/80[2]


	    2000Y1>>5
	    = 2005Y1

	    1999M1>>12
	    = 2000M1

	    EOS<<1
	    = 2019Y1                    (si EOS == 2020Y1)

	    BOS<<1
	    = 1959Y1                    (si BOS == 1960Y1)

	    EOS<<4:5*-1
	    =2016;2017;2018;2019;2020   (si EOS = 2020Y1)
&TX

In may 2012, assuming that ~c1990M6:2020M12~C is the current sample,
the following samples are equivalent :

&CO
    BOS:2;EOS   ==   1990M6;1990M7;2020M12
    EOS;EOS1    ==   2020M12:2020M1
    NOW;NOW1    ==   2012M5;2012M1
    NOW:P       ==   2012M5;2012M6;...;2013M4
    NOW:3*P     ==   2012M5;2013M5;2014M5
    NOW1:SUB    ==   2012M5

    2000Y1>>5      === 2005Y1
    1999M1>>12     === 2000M1
    EOS<<1         === 2020M11
    EOS<<P         === 2019M12
&TX

If the sample is 1960Y1:2020Y1,
&CO
    EOS:5*-1       === 2020;2019,2018,2017,2016
    BOS<<1         === 1959Y1

&TX

In may 2012, if the current sample is 1990Q1:2012Q4,
the following samples are equivalent :

&CO
    NOW;NOW1<<4    === 2012Q2;2011Q1 (for quaterly data)

    NOW<<0;NOW>>0    === 2012Q1;2012Q4
    NOW<<0:P        === 2012Q1;2012Q2;2012Q3;2012Q4
    NOW:3*P        === 2012Q2;2013Q2;2014Q2

    NOW;(NOW<<0>>1/NOW<<0)>>P   === 2012Q2;2013Q2/2013Q1


&TX

>















