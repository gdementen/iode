/* OBJS */

<Introduction au logiciel>
    Introduction au logiciel
    컴컴컴컴컴컴컴컴컴컴컴컴

Le logiciel IODE a 굏� mis au point avec l'appui scientifique d'une
굌uipe d'괹onom둻res ayant en charge la construction et l'exploitation
de grands mod둳es macro괹onomiques.
C'est en analysant le
travail des membres de cette 굌uipe et en tentant de r굋ondre au mieux �
leurs besoins que IODE, au d굋art confin� dans les aspects purement
괹onom굏riques, s'est 굃argi � des fonctionnalit굎 plus larges que celles
n괹essaires � la construction d'un mod둳e et aux simulations.


En effet, si la construction d'un mod둳e - r괺action des 굌uations,
estimation, tests et simulations - est la partie la plus lourde de
l'굃aboration d'un mod둳e, l'exploitation en aval des informations
produites par le mod둳e repr굎ente une part consid굍able de l'emploi du
temps des 괹onom둻res. En amont, la construction des s굍ies de base ou
l'importation de celles-ci � partir d'informations externes repr굎ente
괾alement un travail non n괾ligeable.

IODE s'attaque donc � toutes les 굏apes de la construction et de
l'exploitation des mod둳es :

&EN l'importation et l'exportation des s굍ies vers et � partir d'autres logiciels
    (TSP, Excel, KaA, LArray (Python), E-Views...),
&EN l'automatisation de l a construction des s굍ies � partir de donn괻s provenant de
    plusieurs ensembles de donn괻s de base,
&EN la documentation des bases de donn괻s statistiques,
&EN la r괺action des 굌uations,
&EN l'estimation des 굌uations par diff굍entes m굏hodes,
&EN les simulations de sc굈arios,
&EN la recherche d'objectifs (goal seeking),
&EN la production de tableaux et de graphiques,
&EN la g굈굍ation automatis괻 de rapports int괾rant tableaux, graphiques, texte
    libre, 굌uations, etc,
&EN l'importation des outputs dans des logiciels externes comme Word, Excel, ou Frame Maker,
&EN l'automatisation via un langage de scripting propre.

Pour atteindre ces diff굍ents objectifs, l'utilisateur de IODE doit
d괽inir et utiliser diff굍ents "objets". Ces objets sont manipul굎 par
IODE et stock굎 dans des espaces de travail ("workspaces").

La suite de ce chapitre aborde la d괽inition des objets de IODE, indique
l'organisation des programmes et fournit les notions de base de l'interface
utilisateur. Elle se compose de trois parties :

&EN <Les concepts et objets manipul굎> par IODE (notion d'objets
    et de workspaces),

&EN <Organisation des fichiers> qui introduit les diff굍ents
    굃굆ents et programmes composant le logiciel,

&EN <L'interface utilisateur de IODE> qui d괹rit l'괹ran de base et ses
    diff굍entes composantes.
>

<Les concepts et objets manipul굎>
    Les concepts et objets manipul굎
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IODE op둹e sur des <objets><Les objets> de diff굍ents types. Ceux-ci sont group굎 dans
des ensembles appel굎 <workspaces><Les Workspaces> (WS).
Ces deux notions sont fondamentales pour la bonne
compr괿ension du logiciel. Elles font l'objet des deux premi둹es sections suivantes.

Diff굍ents types d'objets - par exemple les 굌uations - utilisent des
formules dans leur d괽inition. Un langage standard, sp괹ialement adapt�
aux expressions 괹onom굏riques, est utilis� dans tous ces objets. Ce
langage, le <lec><Le LEC> (pour "Langage Econom굏rique Condens�"), est
rapidement pr굎ent� dans troisi둴e section.

La derni둹e section est consacr괻 aux <rapports>, qui, via un langage de
scripting, permettent d'automatiser les fonctions de IODE.

>
<Les objets>
    Les objets
    컴컴컴컴컴

Avant de d굏ailler le contenu de chaque type d'objet, commen뇇ns par
analyser la justification de chacun d'eux. En d'autres termes, essayons
de voir o� interviennent, dans le cadre d'un mod둳e, les concepts
auxquels ils sont associ굎.

Un mod둳e est un syst둴e d'EQUATIONS qui sont des formules faisant
intervenir des VARIABLES, s굍ies num굍iques temporelles d괽inies sur une
p굍iode de temps donn괻, avec une fr굌uence d굏ermin괻 (annuelles,
trimestrielles, etc). Les 굌uations peuvent contenir des
coefficients - 굒entuellement estim굎 - qui sont des variables sans
dimension, appel괻s dans IODE des SCALAIRES.

EQUATIONS, VARIABLES et SCALAIRES sont trois types d'objets g굍굎 par
IODE.

Les variables elles-m늤es ne sont pas toutes obtenues telles quelles,
mais r굎ultent le plus souvent de calculs bas굎 sur d'autres variables,
provenant 굒entuellement de plusieurs sources. Ces calculs peuvent 늯re
par exemple une agr괾ation des secteurs ou une dimension
g굊graphique ou encore des s굍ies mises en base commune. Les formules
utilis괻s pour effectuer le calcul de ces variables contruites sont appel괻s
IDENTITES de construction.

Le nom donn� � chaque VARIABLE ne permet en g굈굍al
pas d'en indiquer le contenu avec suffisamment de
pr괹ision. IODE permet de cr괻r des COMMENTAIRES dont le nom sera identique
� celui des VARIABLES qu'ils d괽inissent. Ces commentaires sont simlement
des textes libres.

COMMENTAIRES ET IDENTITES sont les quatri둴e et cinqui둴e objets g굍굎
par IODE.

Lorsqu'on dispose de variables, il est souvent utile des les pr굎enter -
� l'괹ran ou sur papier - sous forme de tableaux ou de graphiques. IODE
permet de construire � cette fin des TABLEAUX, non pas de valeurs, mais
de formules et de texte.

Ces "tableaux" sont en quelque sorte des
petits programmes qui permettent de construire des tables de nombres
ou des graphiques sur base de VARIABLES contenues dans les fichiers de
variables. Cette fa뇇n de proc괺er est tr둺 efficace : les m늤es
tableaux sont r굑tilis굎 pour imprimer diff굍entes versions des
VARIABLES (apr둺 la simulation d'un sc굈ario par exemple). Le m늤e
tableau peut aussi 늯re imprim� en taux de croissance, en comparaison de
fichiers, etc.

Le TABLEAU est le sixi둴e type d'objet de IODE.

Il n'y a pas de notion de mod둳e en tant qu'objet dans IODE : un mod둳e
est simplement une LISTE d'굌uations. Pour 굒iter le travail fastidieux
de r괻ncodage des listes, celles-ci sont g굍괻s comme des objets � part
enti둹e et - comme on le verra plus tard - sauv괻s dans des fichiers de
listes. L'utilisation des listes est par ailleurs omnipr굎ente : on les
trouve dans les formules pour en raccourcir l'괹riture, en param둻re des
fonctions de rapports pour simplifier l'encodage, etc.

La LISTE termine l'굈um굍ation des objets de IODE. Les objets g굍굎 par
IODE sont donc au nombre de sept.

Les objets des sept types sont identifi굎 par un nom de 20 caract둹es
maximum  (� partir de la version 6.01)
commen놹nt toujours par une lettre (ou le caract둹e '_'), en
minuscule pour les SCALAIRES et en majuscule pour les autres objets
(ceci afin de distinguer les scalaires et les variables dans les
formules du langage LEC sans ambig걁t�).

Chaque type d'objet a donc trouv� sa justification. La suite du chapitre
peut 늯re consacr괻 � une d괽inition plus d굏aill괻 de leur contenu.

&IT Les commentaires
컴컴컴컴컴컴컴컴
Les commentaires sont des textes libres. Un 괺iteur int괾r� � IODE
permet de les encoder. Ils servent � documenter des objets de IODE.

&IT Les 굌uations
컴컴컴컴컴컴�
Une 굌uation se pr굎ente comme une 괾alit� qui fera partie d'un mod둳e.
Chaque 굌uation est compos괻 des 굃굆ents suivants :

&EN la forme LEC (langage d'괹riture des formules dans IODE)
&EN un commentaire libre (titre de l'굌uation)
&EN la m굏hode par laquelle elle a 굏� estim괻 (s'il y a lieu)
&EN la p굍iode d'estimation 굒entuelle
&EN les noms des 굌uations estim괻s simultan굆ent
&EN les instruments utilis굎 pour l'estimation

Tous ces 굃굆ents de d괽inition sont pr굎ents dans chaque 굌uation, mais
굒entuellement laiss굎 vides s'ils n'ont pas de justification.

Le nom d'une 굌uation est celui de sa variable endog둵e.

&IT Les identit굎
컴컴컴컴컴컴�
Une identit� de construction est une expression en langage LEC qui
permet de construire une nouvelle s굍ie statistique sur base de s굍ies
d굁� d괽inies. En g굈굍al, les identit굎 sont "ex괹ut괻s" en groupe pour
constituer ou mettre � jour un ensemble de variables.

Il ne faut par confondre identit굎 et 굌uations. Les identit굎 au sens
du logiciel TROLL sont des 굌uations (ou parfois des listes) dans IODE.

&IT Les listes
컴컴컴컴컴
Les listes sont, comme les commentaires, des textes libres. Elles sont
utilis괻s pour simplifier l'괹riture en diff굍entes circonstances :

&EN liste d'굌uations d괽inissant un mod둳e
&EN liste de tableaux � imprimer
&EN argument quelconque d'une fonction (p굍iode d'impression par exemple)
&EN macro dans une 굌uation, une identit� ou un tableau
&EN etc

&IT Les scalaires
컴컴컴컴컴컴�
Les scalaires sont pour l'essentiel des coefficients estim굎 d'굌uations
괹onom굏riques. Pour cette raison, chaque scalaire contient dans sa
d괽inition :

&EN sa valeur
&EN le param둻re de "relaxation", fix� � 0 pour bloquer le coefficient
    lors d'une estimation
&EN son t-test, r굎ultat de la derni둹e estimation
&EN sa d굒iation standard, r굎ultat de la derni둹e estimation

Seule la valeur du scalaire a de l'int굍늯 lors du calcul d'une
expression LEC. Les trois autres valeurs n'ont de sens que pour
l'estimation.

Comme les autres objets, les scalaires sont identifi굎 par un nom de 10
caract둹es maximum  (20 � partir de la version 6.01). Ceux-ci doivent 늯re en minuscules pour que les
variables soient distinctes des scalaires dans les formules LEC.

&IT Les tableaux
컴컴컴컴컴컴
Une des op굍ations le plus souvent effectu괻s dans le cours d'un
exercice de simulation est l'affichage ou l'impression de tableaux et de
graphiques de r굎ultats. Les tableaux ont 굏� imagin굎 pour rendre cette
op굍ation la plus efficace possible.

Chaque tableau est un ensemble de lignes. Une ligne est compos괻 de deux
parties (en g굈굍al) :

&EN une partie de texte qui sera le titre de la ligne
&EN une partie formule qui permettra de calculer les valeurs � placer
    dans le tableau

&CO
    TITRE DU TABLEAU
    ----------------
    Produit national brut       PNB
    Ch뱈age                     UL
    Balance ext굍ieure          X-I
&TX

Les lignes sont en fait de plusieurs types : titre centr� sur la largeur
de la page, lignes de valeurs, lignes de s굋aration, r괽굍ences, etc.

Un tableau peut 늯re calcul� sur diff굍entes p굍iodes de temps, d괹rites
par un "sample" du type :

&CO
    1980Y1:10               -->> 10 observations � partir de 1980Y1
    1980Y1, 1985Y1, 1990:5  -->> 1980, 1985, puis 5 observations � partir
				de 1990Y1
    80/79:5                 -->> 5 taux de croissance � partir de 1980
    ...
&TX
Il peut de plus contenir des valeurs en provenance de diff굍ents
fichiers :

&CO
    (1990:5)[1,2,1-2]   -->> valeurs de 1990 � 1994 pour les fichiers
			    1, 2 et pour la diff굍ence entre les deux
			    fichiers.
&TX
Le r굎ultat du calcul peut 늯re :

&EN affich� � l'괹ran
&EN imprim�
&EN int괾r� dans un rapport

et ce, soit sous forme de tableau de nombres, soit sous forme de
graphique.

&NO Les tableaux peuvent tr둺 bien 늯re utilis굎 dans le cadre d'un
    projet n'int괾rant pas de mod둳e 괹onom굏rique : les seules
    informations utilis괻s par les tableaux sont les variables et
    굒entuellement les scalaires.

&IT Les variables
컴컴컴컴컴컴�
Les variables sont simplement des s굍ies de nombres. Comme les autres
objets, elles sont organis괻s en workspaces (WS), notion qui est 굏udi괻
ci-dessous.

Toutes les variables d'un WS sont d괽inies sur la m늤e p굍iode (sample).
Si des observations sont manquantes, elles prennent la valeur sp괹iale
NA (Not Available) repr굎ent괻 par --.

Comme les autres objets, les variables sont identifi괻s par un nom de 10
caract둹es maximum (20 � partir de la version 6.01). Ceux-ci doivent 늯re en majuscules pour que les
variables soient distinctes des scalaires dans les formules LEC.
>

<Les Workspaces>
&ALIAS workspaces

    Les workspaces
    컴컴컴컴컴컴컴


On a vu pr괹괺emment qu'il y avait 7 types d'objets g굍굎 dans IODE.
Lors d'une session de IODE, l'espace m굆oire est 괾alement divis� en 7
parties : chacune est r굎erv괻 � un des types d'objets et est appel괻
workspace (WS = espace de travail). On a donc en permanence 7 WS
"actifs" au cours d'une session de travail.

Au d굋art, tous les WS sont vides. Des fonctions, 굏udi괻s dans les
chapitres suivants, permettent de modifier le contenu des WS, soit en
agissant sur des WS entiers, soit sur des objets individuels.

&NO
    Les WS sont stock굎 en m굆oire pendant le dur괻 d'une session IODE. En quittant le
    programme, toutes les donn괻s sont perdues. Pour les
    sauvegarder, il faut utiliser les fonctions de sauvetage de WS.

Parmi les fonctions agissant sur les WS entiers, on trouve notamment :

&EN Load : charge en m굆oire le contenu d'un fichier
&EN Save : stocke l'actuel contenu de WS dans un fichier
&EN Copy : ajoute � un WS des objets copi굎 d'un fichier
&EN Clear : d굏ruit tous les objets d'un WS
&EN Sample : change la p굍iode de d괽inition du WS de variables

D'autres fonctions agissent sur la d괽inition des objets : cr괶tion,
modification, destruction, etc.

Les fonctions 괹onom굏riques (estimation, simulation) et la fonction de
construction de s굍ies sur base d'identit굎 agissent indirectement sur
les variables et les scalaires en modifiant leurs valeurs.

&IT R굎um�
컴컴컴
&EN En d괷ut de session, les WS sont charg굎 en m굆oire � partir de
    fichiers

&EN En cours de session, les objets sont modifi굎, cr굚s, d굏ruits dans
    les WS

&EN En fin de session (ou � n'importe quel moment), il faut sauver les
    WS dans des fichiers sur disque de fa뇇n � pouvoir les r괹up굍er
    dans des sessions ult굍ieures.
>


<Le LEC>
Le LEC, langage des formules de IODE
컴컴컴컴컴컴컴컴컴컴컴�
Qu'il s'agisse d'굌uations, d'identit굎 de construction ou encore de
graphiques, un langage d'괹riture de formules math굆atiques ad굌uat est
indispensable. Le langage LEC (Langage Econom굏rique Condens�) offre
l'avantage d'늯re � la fois concis dans son 괹riture et particuli둹ement
adapt� aux formules faisant intervenir des s굍ies chronologiques. Il est
utilis� chaque fois qu'une formule est n괹essaire dans le logiciel IODE.

Le LEC est 괾alement "naturel", en ce sens que sa syntaxe est proche de
l'괹riture de formules que l'on peut trouver dans la litt굍ature.

&CO
    Equation de consommation
    ------------------------
		   Yt
	Ct = a + b -- + c.C                              (texte)
		   Pt      t-1

	C := a + b * Y / P + c * C[-1]                    (LEC)


    Equation de production
    ----------------------
	ln Qt = a ln Kt + (1 - a) ln Lt + c.t + b        (texte)

	ln Q := a * ln K + (1 - a) * ln L + c * t + b     (LEC)
&TX

Le LEC est d괹rit en d굏ail dans un chapitre s굋ar�. Citons
simplement ici quelques caract굍istiques int굍essantes dont certaines
apparaissent dans les exemples ci-dessus :

&EN plus de 20 op굍ateurs math굆atiques sont int괾r굎 dans le langage :
    fonctions trigonom굏riques, hyperboliques, logarithmes,
    exponentielles, max, min, etc

&EN plus de 10 fonctions temporelles : maximum, minimum, somme et
    produit sur une p굍iode, lags, leads, diff굍ences et taux de
    croissance de degr� quelconque (y compris calcul�), moyennes
    mobiles, 괹arts type, etc

&EN les lags, leads et p굍iodes sont 괹rits tr둺 simplement, y compris
    sur des expressions et peuvent 늯re combin굎 :

&CO
	    (A + B)[-1]
	    UL[+1]
	    (X + dln Y)[1985Y1]
&TX

&EN des parties de formules peuvent 늯re temporairement annul괻s en les
    mettant en commentaire :

&CO
	    ln Q := a * ln K /* + (1 - a) ln (L + Y + Z) */
&TX

&EN des listes (macros) peuvent 늯re utilis괻s dans des formules :

&CO
	    A + B := c1 + c2 * $LL + c3 * $ZZ
&TX
>
<Rapports>
    Les rapports : scripter IODE
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Un rapport est un fichier ASCII (extension .rep) contenant deux types
d'굃굆ents :

&EN des instructions (les lignes qui commencent par $ ou ##)
&EN du texte libre (les autres lignes)

L'ex괹ution d'un rapport se traduit d'une part par l'encha똭ement
d'op굍ations (charger un fichier, estimer des 굌uations, imprimer un
tableau, etc) et d'autre part par l'impression d'un document "fini".

Les instructions commen놹nt par $ sont des instructions qui n'affichent
rien � l'괹ran. Celles commen놹nt par ## font intervenir l'괹ran, soit
pour afficher des informations, soit pour poser des questions.

On trouve plusieurs groupes d'instructions :

&EN celles permettant de contr뱇er le d굍oulement d'un rapport (Label,
    GoTo, Ask, Return, Quit, OnError, Foreach, ProcExec, etc)


&EN celles ex괹utant des fonctions de IODE (WsLoadEqs, WsSaveVar,
    FileDeleteA2m, DataEditVar, PrintTbl, ModelSimulate, ReportExec, etc)

Les instructions du second type permettent en fait
d'effectuer pratiquement toutes les op굍ations effectu괻s normalement �
partir des menus de IODE.

Avant d'늯re ex괹ut괻, chaque ligne de rapport est analys괻 et, si
n괹essaire, modifi괻 : on peut ainsi utiliser des
macros, remplacer des listes par leur valeur, effectuer des calculs...


&IT Exemples de rapports
컴컴컴컴컴컴컴컴컴컴

L'exemple qui suit charge des Workspace IODE de diff굍ents
types. Ensuite, il fixe la destination des impressions (ici dans un fichier de
format interm괺iaire, 굏udi� plus tard). Enfin, un beep sonore est produit
et un message indique que l'environnement est charg�.

Typiquement, l'ex괹ution de ce rapport d괷ute une session IODE en fixant
un environnement initial.

&CO
    $WsLoadVar fun\fun.var
    $WsLoadEqs fun\fun.eqs
    $WsLoadScl fun\fun.scl

    $PrintDest tmp.a2m A2M
    ##Beep
    ##Show Environnement fun charg�
&TX

Le rapport suivant d괽init le fichier output de l'ex괹ution
(bist92\bistelf1.rtf), affiche ensuite un message, construit les
tableaux et les imprime. Du
texte libre est int괾r� dans ce rapport ("TABLEAUX DES HYPOTHESES" par
exemple).

&CO
    $PrintDest bist92\bistelf1.rtf RTF
    ##Show processing french tables
    $PrintNbdec 1
	TABLEAUX DES HYPOTHESES
	-----------------------

    $PrintTbl 89:8 HYPEIR
    $PrintTbl 89/88:8 HYPEIIR

    $PrintNbdec 0
    .page
	TABLEAUX DES RESULTATS
	----------------------

    $PrintTbl 89:8 RESL00

    $PrintNbdec 1
    $PrintTbl 89/88:8 RESL00R
    $PrintTbl 89:8 RESL03
    ##Beep
&TX

&IT Le format A2M
컴컴컴컴컴컴�
Le format A2M est d괹rit en d굏ail dans un chapitre s굋ar�.

En r굎um�, un fichier A2M est un texte ASCII entrecoup� d'instructions
d'enrichissement typographiques et de structuration d'un document en
paragraphes, tableaux et graphiques. Ce langage est utilis� en interne par
IODE comme langage interm괺iaire. Des traducteurs internes � IODE permettent
ensuite d'imprimer un fichier A2M ou de le traduire vers des formats de
fichiers comme Word ou Frame.

Il est 괾alement loisible � l'utilisateur d'enrichir ses impressions
en pla놹nt dans ses rapports des commandes de formattage A2M. Celles-ci
seront interpr굏괻s par IODE lors de l'envoi vers une imprimante ou vers
un document MIF, HTML, RTF ou CSV.

L'utilisateur peut 괾alement d괹ider de sauvegarder ce format A2M pour
une impression ult굍ieure ou pour produire plusieurs formats diff굍ents.

Les programmes IODE et A2M interpr둻ent un fichier au format A2M et
permettent de g굈굍er :

&EN une impression sur une des imprimantes d괽inies sous Windows

&EN un fichier Rtf destin� � l'importation par exemple dans MS-Word

&EN un fichier Html destin� � la publication sur Internet

&EN un fichier Csv destin� � l'importation dans MS-Excel ou Lotus

&EN un fichier Mif destin� � l'importation dans Frame Maker

Gr긟e � cette fonctionnalit�, le choix de la destination des impressions
permet d'importer ais굆ent les 굏ats (tableaux, graphiques, etc) dans un
programme de traitement de texte ou dans un tableur.

Notons que les fichiers A2M sont exploitables en dehors de IODE, � l'aide
du programme ~cscr4w_at.~C
>









