
START

#include "macros.h"

..esc ~


<Version 6.64> (30/06/2022)>
    Version 6.64 (30/06/2022)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Version IODE pour python
컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Dans le module iode de python (iode.pyd), la fonction python
&CO
    iode.report(filename)
&TX

est corrig괻. Elle se comporte comme son 굌uivalent dans les rapport :

&CO
    $ReportExec filename
&TX


&TI DataListSort
컴컴컴컴컴컴컴컴
Cette fonction 굏ait erron괻 depuis la version 6.63: le tri ne se faisait pas correctement.
Ce bug est corrig�.

Par ailleurs, une liste d괽inie avec des ; comme s굋arateur peut 늯re r굊rdonnanc괻 par
cette fonction, ce qui' n'굏ait pas le cas auparavant.


&TI Reports
컴컴컴컴컴�

&IT $foreach index
컴컴컴컴컴컴
Si un $define portant le m늤e nom que l'index d'une boucle $foreach existant
avant d'entrer dans une boucle, ce define n'굏ait pas restaur� � la fin de
la boucle. Il 굏ait erron굆ent remplac� � la fin de la boucle par la liste
de valeurs pass괻 comme argument.

Dor굈avant, l'index d'une boucle $foreach est restaur� apr둺 la boucle si il
굏ait d괽ini avant l'appel.

&EX

$define A XYZ
A is %A%

$foreach A 1 2 3
    A is %A%
$next A

A is %A%
&TX
Affiche :

&CO
A is XYZ
    A is 1
    A is 2
    A is 3
A is XYZ
&TX

&IT Oem to Ansi conversion
컴컴컴컴컴�
Implementation of $SysAnsiToOem and $SysOemToAnsi.


&IT Parsing of @function()
컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Les noms reconnus des @functions() peuvent dor굈avant contenir des chiffres
ou le caract둹e '_'.

De plus, lorsque le nom d'une @function n'est pas reconnu, le texte est
conserv� inchang� dans le r굎ultat du rapport.


&IT @function() avec des param둻res entre quotes
컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Le second argument d'expressions avec 2 param둻res entre quotes comme ~c@fn("abc","def")~C
굏ait ignor굎. Cette erreur est corrig괻.


&IT Parsing of {@function()}
컴컴컴컴컴컴컴컴컴컴컴컴컴컴
As of now, when an expression between accolades contains @-functions, these
 @-functions are calculed and replaced by their value before the evaluation of {expression}.

&EX
    $define B 1
    $show Value of {1 + %@upper(b)%}   ->> {1 + %B%}  ->> {1 + 1}  ->> 2
&TX



&IT New $multiline command
컴컴컴컴컴컴컴컴컴컴컴컴컴
Par d괽aut, une ligne de rapport peut dor굈avant se prolonger sur la ligne suivante si
elle se termine par un espace suivi d'un backslash ~c(\)~C.
Si c'est la cas,
le caract둹e de retour � la ligne est ins굍� entre les lignes ~c(\n)~C.

Cela permet par exemple de construire dans un rapport des 굌uations qui se d괹omposent
sur plusieurs lignes, rendant leur lecture plus simple.

Pour ne pas permettre cette extension (compatilibili� avec les versions
ant굍ieures) il suffit de placer la commande ~c$multiline 0~C avant les
lignes concern괻s. Sans argument, le multi-lignes est accept�.

&CO
   $multiline [{Nn0}]
&TX

Par exemple, on peut dor굈avant 괹rire :

&CO
    $multiline 1
    $DataUpdateEqs A A := c1 + \
    c2 * t
&TX

La d괽inition de l'굌uation A sera alors sur deux lignes.

A l'inverse, sans le multiline, une erreur est g굈굍괻. Ainsi

&CO
    $multiline 0
    $DataUpdateEqs A A := c1 + \
    c2 * t
&TX

essaie de cr괻r une 굌uation termin괻 par ~c"+ \"~C, ce qui donne le r굎ultat suivant :

&CO
    essais.rep[23] - $multiline 0
    essais.rep[24] - $DataUpdateEqs A A := c1 + \
    (string)[7]:syntax error
    Error : dataupdateeqs A A := c1 + \
&TX

&IT New $noparsing command
컴컴컴컴컴컴컴컴컴컴컴컴컴
Par defaut, les textes entre backquotes (`) ne sont pas pars굎 dans les rapports.
La commande $noparsing permet de modifier ce comportement.

&CO
    $noparsing 0  indique que le parsing doit toujours avoir lieu
    $noparsing 1 indique que le parsing ne doit avoir lieu entre les backquotes (`).
&TX

&EX
     $define C  1
     $noparsing 1
     Example : `{1 + %@upper(c)%}` ->> {1 + %@upper(c)%}
&TX

conserve le texte entre backquotes et parse le reste de la ligne:

&CO
     Example : {1 + %@upper(c)%} ->> 2
&TX


&IT New $undef command
컴컴컴컴컴컴컴컴컴컴컴컴컴
Les macros peuvent etre supprim괻 par la commande $undef ou $undefine.

&CO
    $undef macro_name
    $undefine macro_name
&TX

&EX
    $define toto AAA
    toto = '%toto%'         =>> toto = 'AAA'
    $define toto
    toto = '%toto%'         =>> toto = ''
    $undef toto
    toto = '%toto%'         =>> toto = '%toto%'
&TX

&IT New $shift_args command
컴컴컴컴컴컴컴컴컴컴컴컴컴�
Alias of ~c$shift~C.

&IT iodecmd: $ask command
컴컴컴컴컴컴컴컴컴컴컴컴컴�
&CO
    $ask label question
&TX

La commande $ask fonctionne dor굈avant dans l'environnement iodecmd. La question est affich괻
� l'괹ran et une r굋onse est attendue: si un des caract둹es "OoJjYy1" est entr�, la r굋onse
est positive et le rapport se poursuit au label indiqu�.


&IT Noms des fichiers ascii apr둺 lecture dans IODE
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Lors de la lecture de fichiers ascii (~c"test.av"~C par exemple), le nom du fichier
source 굏ait remplac� par ~c"ws"~C dans le WS concern� de sorte que lors du sauvetage,
il fallait normalement remplacer le nom "ws".

Par exemple, si on lit le fichier ~c"test.av",~C le nom du WS courant  est ~c"ws.var"~C.

Dor굈avant, lorsqu'un fichier ascii est lu dans IODE, par exemple ~c"test.av",~C ou
    "test.xxx" 2 cas sont distingu굎 :

&EN si le fichier existe, le nom du WS retient onserve le nom du fichier lu mais l'extension
    est remplac괻 par l'extension ascii standard (ici ~c"test.av"~C, m늤e pour ~c"test.xxx"~C );

&EN si le fichier n'existe pas et qu'il n'a pas d'extension (par exemple ~c"test"~C )
et qu'un fichier avec le m늤e nom mais avec l'extension standard
(ici ~c".var"~C) existe, c'est ce fichier ~c"test.var"~C qui est lu et le nom
du ws devient ~c"test.var"~C;



>

<Version 6.63> (30/09/2020)>
    Version 6.63 (30/09/2020)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Authentification des logiciels
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Les programmes ~ciode.exe~C, ~ciodecmd.exe~C et ~ciodecom.exe~C ont 굏�
adapt굎 afin d'굒iter d'늯re bloqu굎 par McAfee Active Threat Protection
(d괹oupe des ex괹utables en deux modules : programme et data).

Par ailleurs les programmes sont dor굈avant sign굎 avec le certificat du BFP
et donc authentifi굎 comme tels.


&TI Manuel
컴컴컴컴컴
La version Winhelp du manuel n'est plus distribu괻 car non support괻 par les
derni둹es versions de Windows. Seules les versions locale (HtmlHelp) et Web
(iode.plan.be) sont encore disponibles.



>

<Version 6.62> (29/05/2020)
    Version 6.62 (29/05/2020)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Check Version
컴컴컴컴컴컴컴컴�
La fonction de v굍ification de version (cfr iode.ini =>> ~c[General] CheckVersion~C) est
d굎activ괻 en raison d'un probl둴e de compatibilit� avec la nouvelle version
du site iode.plan.be.
>


<Version 6.61> (15/05/2019)
    Version 6.61 (16/05/2019)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Hodrick-Prescott filter
컴컴컴컴컴컴컴컴컴컴컴컴컴�
La fonction de calcul de trend bas괻 sur le "filtre Hodrick-Prescott"
transforme les s굍ies � traiter en logarithme avant d'effectuer le calcul
d'optimisation proprement dit. Une fois calcul괻s, les s굍ies contenant le
trend sont transform괻s � nouveau en passant � l'exponentielle.

Ceci a deux cons굌uences :

&EN seules les parties strictement positives des s굍ies peuvent 늯re trait괻s
&EN une s굍ie purement lin괶ire, qui ne pr굎ente donc aucune d굒iation par
rapport au trend, devrait 늯re identique apr둺 filtrage. Ce n'est plus le cas
si on lui applique une transformation du type log, m늤e si on repasse
ensuite � l'exponentielle.

Une nouvelle fonction plus standard a donc 굏� ajout괻 � IODE. Cette fonction
est plus en ligne avec les r굎ultats obtenus avec les logiciels standard comme stata.


&IT Nouvelle fonction de rapport
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

&CO
    $WsTrendStd filename lambda series1 series1...
&TX

&IT Nouvel op굍ateur LEC
컴컴컴컴컴컴컴컴컴컴컴컴
&CO
    hpstd([[from,]to],expr)  : calcul sans passage au logarithme de ~cexpr~C
&TX

Les param둻res sont :
&EN from : p굍iode de d굋art du calcul, premi둹e ann괻 par d괽aut
&EN to : p굍iode de fin de calcul, derni둹e ann괻 par d괽aut
&EN expr : expression LEC quelconque. Doit 늯re strictement positif pour ~chp()~C

&IT Nouvel 괹ran
컴컴컴컴컴컴컴컴
L'괹ran Workspace / Trend Hodrick-Prescott filter a 굏� adapt� en cons굌uence en proposant
le choix entre le passage au logarithme ou non.

&TI Taux de croissance moyens
컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Correction d'un bug qui s'est gliss� dans la version 6.58 dans le calcul des
taux de croissance moyens. Ce bug rendait en g굈굍al les taux de croissance
moyens beaucoup plus 굃ev굎 que ce qu'ils devaient 늯re.

>

<Version 6.60> (11/04/2019)
    Version 6.60 (11/04/2019)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Rapports : nouvelles fonctions
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Des fonctions de rapport ont 굏� ajout괻s :
&EN @mkdir : cr괻r un r굋ertoire
&EN @rmdir : supprimer un r굋ertoire
&EN @getdir : afficher le repertoire courant
&EN @chdir : changer de r굋ertoire courant
&EN @void : supprimer l'output d'une fonction

Par ailleurs les commandes qui changent le directory courant affichent le
nouveau directory dans la barre de titre de la fen늯re.

&IT Exemple
컴컴컴컴컴�
&CO
  ## Utilisation des commandes de gestion de dirs
  ## --------------------------------------------
  ##
  ## Syntax :
  ##
  $debug 1
  $msg Current dir : @getdir()
  $msg Make dir    : @mkdir(subdir)
  $msg Chdir       : @chdir(subdir)
  $msg Chdir       : @chdir(..)
&TX

R굎ultat
컴컴컴컴

&CO
  Current dir : c:\usr\iode
  Make dir    :
  Chdir       : c:\usr\iode\subdir
  Chdir       : c:\usr\iode
&TX


&TI Correctif : save WS / CSV format
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Les fichiers de variables peuvent  � nouveau 늯re sauv굎 en format csv via le menu
"Workspace / Save Workspace" ou via la commande $WsSaveVar dans un rapport.

&CO
## Load a IODE var file and save vars in CSV format
$WsLoadVar ..\dos\test.var
$WsSaveVar test.csv
&TX

&TI Filtre Hodrick-Prescott
컴컴컴컴컴컴컴컴컴컴컴컴컴�
La description de la m굏hode a 굏� ajout괻 au manuel de IODE dans
la partie "Le programme IODE / Workspace / Trend Correction".


>

<Version 6.59> (13/03/2019)
    Version 6.59 (13/03/2019)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Rapports : nouvelles fonctions $ModelSimulateSave*
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴


Le nombre d'it굍ations et le seuil de convergence atteint lors de la derni둹e simulation
peuvent 늯re sauv굎 dans des ~uvariables~U IODE. Deux nouvelles fonctions de rapport
ont 굏� cr굚es � cette fin :


&EN $ModelSimulateSaveNiters ~ivar_name~I
&EN $ModelSimulateSaveNorms  ~ivar_name~I

Pour rappel, les fonctions de rapport suivantes permettent d'obtenir les m늤es informations :


&EN ~c@SimNiter(period)~C
&EN ~c@SimNorm(period)~C

&IT $ModelSimulateSaveNiters
컴컴컴컴컴컴컴컴컴컴컴�

Cette commande permet de sauver dans une variable le nombre d'it굍ations
qui ont 굏� n괹essaires pour chaque p굍iode lors de la derni둹e simulation.

Le nom de la variable r굎ultat est pass� comme param둻re.

S'il n'y a pas encore eu de simulation dans le cours de la session, la variable est
cr굚e avec des valeurs NA.

Si une simulation a d굁� eu lieu, les valeurs des p굍iodes non simul괻s sont fix괻s � 0 et
celles des p굍iodes simul괻s contiennent le nombre d'it굍ations n괹essaires �
la convergence pour cette p굍iode. S'il n'y a pas de convergence, la valeur est celle du
param둻re MAXIT de la simulation.


Syntaxe :
&CO
    $ModelSimulateSaveNiters varname
&TX

Exemple :
&CO
    $ModelSimulateSaveNiters SIM_NITERS
&TX

&IT $ModelSimulateSaveNorms
컴컴컴컴컴컴컴컴컴컴컴�

Cette commande permet de sauver dans une variable le seuil de convergence (la norme) atteint
pour chaque p굍iode lors de la derni둹e simulation.

Le nom de la variable r굎ultat est pass� comme param둻re.

S'il n'y a pas encore eu de simulation dans le cours de la session, la variable est
cr굚e avec des valeurs NA.

Si une simulation a d굁� eu lieu, les valeurs des p굍iodes non simul괻s sont fix괻s � 0 et
celles des p굍iodes simul괻s contiennent le seuil de convergence
pour cette p굍iode.

Syntaxe :
&CO
    $ModelSimulateSaveNorms varname
&TX
Exemple :
&CO
    $ModelSimulateSaveNiters SIM_NORMS
&TX


&TI Filtre Hodrick-Prescott
컴컴컴컴컴컴컴컴컴컴컴컴컴
La valeur du param둻re lambda peut dor굈avant 늯re un nombre r괻l. Auparavant,
cette valeur 굏ait un nombre entier.

>

<Version 6.58> (20/01/2019)
    Version 6.58 (20/01/2019)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Rapports : $DataCreateGraph
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Correction : l'ordre des param둻res de d괽inition des grids est corrig� pour
correspondre au manuel.


&TI Comment ex괹uter un rapport IODE
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Il est possible d'ex괹uter un rapport IODE (soit ~cmyreport.rep~C) de
plusieurs fa뇇ns. En plus de la m굏hode habituelle � travers l'interface de IODE,
on peut lancer un rapport IODE de 3 fa뇇ns :

&EN en lan놹nt le programme ~ciode~C suivi du nom du fichier rapport dans un "Command Prompt"
&EN en lan놹nt le programme ~ciodecmd~C suivi du nom du fichier rapport dans un "Command Prompt"
&EN dans l'explorateur Windows en double-cliquant sur le fichier .rep

Pour illustrer cela, voici un exemple de rapport.

&IT LoadWs.rep
컴컴컴컴컴컴컴
Le rapport suivant charge 5 WS en m굆oire.

&CO
$define file c:\iode\example\fun

$WsLoadVar %file%
$WsLoadEqs %file%
$WsLoadScl %file%
$WsLoadTbl %file%
$WsLoadCmt %file%
&TX

&IT Ex괹uter un rapport dans un "Command Prompt" avec le programme ~ciode~C
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

A partir de la version 6.58, il suffit de lancer la commande iode en lui
passant le nom du rapport comme param둻re. Par exemple :

&CO
  c:\iode>> iode LoadWs.rep
&TX

Iode est alors lanc� et LoadWs.rep est ex괹ut� ~udans l'interface de IODE~U.
Si le rapport se termine par ~c$quitode~C, IODE est quitt� � la fin du
rapport.

A noter que le directory o� a 굏� install� iode doit se trouver dans le PATH pour
que cela fonctionne. Sans cela, Windows ne pourrait savoir o� trouver le
programme...

Pour changer le PATH,
&EN 1. aller dans ~cControl Panel\All Control Panel Items\System~C
&EN 2. s굃ectionnez "Advanced system Settings"
&EN 3. s굃ectionnez l'onglet "Advanced"
&EN 4. s굃ectionnez "Environment Variables"
&EN 5. allez aux "System variables"
&EN 6. double-cliquez sur la variable "Path"
&EN 7. ajoutez le directory d'installation de IODE (si cela n'a pas encore 굏� fait)
&EN 8. Cliquez OK (3x) pour confirmer

Le prochain lancement du "Command Prompt", la nouvelle valeur de la variable
~cPath~C sera connue.

&IT Ex괹uter un rapport dans un "Command Prompt" avec le programme ~ciodecmd~C
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Le programme iodecmd permet d'ex괹uter un rapport IODE sans
interface utilisateur. Une fois le rapport termin�, iodecmd rend la main.

Par d괽aut, le r굎ultat de chaque commande est affich� � l'괹ran :
&CO
  c:\iode>> iodecmd LoadWs.rep

Loading example\fun
394 objects loaded
Loading example\fun
274 objects loaded
Loading example\fun
161 objects loaded
Loading example\fun
46 objects loaded
Loading example\fun
317 objects loaded
&TX

&IT Lancement d'un rapport dans l'explorateur Windows
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Il est possible de lancer un rapport dans l'explorateur Windows en
double-cliquant sur le fichier. Condition pr괶lable:il faut associer les fichiers
~c*.rep~C avec le programme IODE. Suite aux restrictions apport괻s par Microsoft,
cette association (comme les autres) ne se fait plus automatiquement.

A noter que cela ne peut fonctionner qu'� partir de la version 6.58.

>

<Version 6.57> (02/03/2018)
    Version 6.57 (02/03/2018)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI E-Views
컴컴컴컴컴�
Nouvelles directives dans les fichiers d'굌uations EVIEWS. Les directives
doivent se trouver seules sur une ligne. Elles peuvent 늯re en majuscules, minuscules ou
un m굃ange des deux.

Elles d굏erminent la fa뇇n dont les termes des 굌uations ou identit굎 EVIEWS
du type ~cname(1)~C doivent 늯re traduites en IODE.

&CO
  KEEP COEFS:
  DROP COEFS:
&TX

&EN Apr둺 KEEP COEFS:, la traduction de ~cname(1)~C ou ~cNAME(1)~C donne ~cname_1~C.
&EN Apr둺 DROP COEFS:, la traduction de ~cname(1)~C ou ~cNAME(1)~C donne ~cname~C.

Au d괷ut de la lecture fichier, ~cDROP COEFS:~C est la valeur initiale.

&IT Exemple de fichier EVIEWS
컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

&CO
Identities:
===========
KEEP COEFS:

B_QHOA  = b_1(2)  * b_c0122222
B_QHOB  = b_qh_b_14(1)  * B_CO14

DROP COEFS:

B_QHOCADD  = (b_qh_c_1(1)  * B_CO1)  + (b_qh_c_2(1)  * B_CO2)  + (b_qh_c_7(1)  * B_CO7)
B_QHOCR_NC  = b_qh_cr_14(1)  * B_CO14
&TX

&IT R굎ultat en IODE
컴컴컴컴컴컴컴컴컴컴
&CO
B_QHOA := b_1_2*B_C0122222
B_QHOB := b_qh_b_14_1*B_CO14
B_QHOCADD := (b_qh_c_1*B_CO1)+(b_qh_c_2*B_CO2)+(b_qh_c_7*B_CO7)
B_QHOCR_NC := b_qh_cr_14*B_CO14
&TX

>
<Version 6.56> (27/01/2017)
    Version 6.56 (27/01/2017)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Sauvetage des workspaces (fix)
컴컴컴컴컴컴컴컴컴컴컴컴컴
Dans l'괹ran de sauvetage des workspaces, les ws pour lesquels aucune extension n'est
indiqu괻 sont � nouveau sauv굎 en format IODE (~c.var~C, ~c.cmt~C , ...). Dans la version
pr괹괺ente, aucun sauvetage n'굏ait effectu�.

Si une extension de format ascii est indiqu괻, le ws est sauv� en format ascii.

Les commandes de rapport ~c$WsSave*~C op둹ent de la m늤e mani둹e.


&TI G굈굍ation de fichiers csv
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

&IT A partir des rapports ($WsSaveCsvVar, $csvsep et $csvdec)
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Les param둻res de ces commandes (s굋arateur de liste et caract둹e d괹imal)
sont initialis굎 par les valeurs des "International Settings" d괽inies dans
Windows. De cette fa뇇n, les fichiers csv g굈굍굎 sont directement lisibles
en Excel sans avoir � se pr굊ccuper des s굋arateurs et autres caract둹es
d괹imaux.

&IT A partir de l'괹ran Save Workspace
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Dans l'괹ran "Workspace/Save Workspace",
si l'extension du fichier est ~c.csv~C, le fichier est sauv� en format CSV.
Les param둻res (s굋arateur et caract둹e d괹imal) sont fix굎 par les
commandes ~c$csvsep~C et ~c$csvdec~C ou, � d괽aut, par les valeurs des
locales Windows. Les fichiers peuvent donc directement 늯re ouverts en Excel.

&TI Copy/Paste de variables entre Excel et IODE
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
&NO Cette nouvelle fonction est encore en phase de test.

La copie de valeurs � partir d'Excel vers l'괺iteur de variables de IODE est
am굃ior� � plusieurs 괾ards :

&EN les virgules d괹imales sont trait괻s correctement
&EN les signes de devise (currency) sont ignor굎 dans les copies vers IODE
&EN les cellules vides sont interpr굏괻s comme -- (na)

Attention cependant � ce que le s굋arateur entre les valeurs doit 늯re la
tabulation. Les blancs sont ignor굎.

Si la copie provient
d'un autre logiciel, il faut s'assurer que c'est bien le TAB qui s굋are les
valeurs.

&NO Cette fonction utilise les "locale" de Windows pour d굏erminer les
s굋arateur de milliers et de d괹imales. Comme le s굋arateur de milliers
est parfois le point (1.234,5 par exemple), il faut 늯re attentif que 1.23 est en fait
123 car le signe des milliers est ignor�.

>

<Version 6.55> (05/01/2017)
    Version 6.55 (05/01/2017)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Ouverture d'anciens fichiers
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Correction d'un bug lors de l'ouverture des fichiers de version ant굍ieure
(magic number 504d).


&TI Interpr굏ation des macros
컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Lorsqu'une macro (string entre %) n'est pas trouv괻, le texte de la macro
est conserv� tel quel, % inclus.

Pour rappel, voici un rapport qui indique comment se comportent les macros :


&EX
## IODE : Macro examples
## ---------------------
$msg -----------------------------------------------
$msg Undefined Macros - Normal, uppercase, lowercase
$msg -----------------------------------------------
$msg Normal text   : %bla bla bla%
$msg Uppercase     : %##bla bla bla%
$msg Lowercase     : %!bla bla bla%
$msg ------------------------------------------------------------
$msg Macro modifications : normal, squeezed, uppercase, lowercase
$msg ------------------------------------------------------------
$define macro1 Variable name
$msg %%macro1%%  %macro1%
$msg %%-macro1%% %-macro1%
$msg %%!macro1%% %!macro1%
$msg %%##macro1%% %##macro1%
&TX

Le r굎ultat de ce rapport est :
&CO
-----------------------------------------------
Undefined Macros - Normal, uppercase, lowercase
-----------------------------------------------
Normal text   : %bla bla bla%
Uppercase     : %BLA BLA BLA%
Lowercase     : %bla bla bla%
------------------------------------------------------------
Macro modifications : normal, squeezed, uppercase, lowercase
------------------------------------------------------------
%macro1%  Variable name
%-macro1% Variablename
%!macro1% variable name
%#macro1% VARIABLE NAME
&TX

&TI Orthographe
컴컴컴컴�
Correction d'une erreur d'orthographe en fran놹is dans les textes automatiques des
tableaux/graphiques.

&TI iode -fontsize
컴컴컴컴컴컴컴컴컴
Le param둻re ~c-fontsize nn~C est prioritaire sur la d괽inition
~c[FONT] FONTSIZE=nn~C dans le fichier ~ciode.ini~C.
>

<Version 6.54> (22/08/2016)
    Version 6.54 (22/08/2016)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Duplex and page orientation printing options
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Pour 굒iter les probl둴es li굎 aux mises � jour des drivers des imprimantes Windows,
les options d'impression en recto/verso et en portait/landscape ont 굏� annul괻s:
ces options ne sont plus affich괻s dans l'괹ran "Print Setup/Options/Printer" et ne
sont plus actives dans les commandes des rapports.

Pour 굒iter les probl둴es de compatibilit굎 avec des rapports existants, les fonctions

&EN  $PrintOrientation
&EN  $PrintDuplex

restent valides, mais n'ont plus d'effet sur la configuration des imprimantes.

>

<Version 6.53> (18/07/2016)
    Version 6.53 (18/07/2016)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI E-Views to IODE
컴컴컴컴컴컴컴컴컴
&EN L'importation des coefficients est � nouveau op굍ationnelle. Cette option
avait 굏� supprim괻 dans la version pr괹괺ente.

&EN Les lignes commen놹nt par ~c@INNOV~C sont ignor괻s.

Pour rappel, la m굏hode d'importation fonctionne comme suit :

&IT Lignes "Forecasting Equation:" et "Substituted coefficients:"
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Lorsqu'une ligne ~cForecasting Equation~C est rencontr괻, l'굌uation qui la
suit (apr둺 avoir saut� une ligne) est lue et conserv괻 en m굆oire jusqu' � la ligne
 ~cSubstituted Coefficients:~C suivante. Cette derni둹e est alors analys괻 et les
valeurs des coefficients en sont extraites et plac괻s dans dans scalaires
IODE. Ces scalaires portent le nom de l'endog둵e de l'굌uation avec le
suffixe ~c_1~C, ~c_2~C, ...

L'굌uation initiale est transform괻 pour remplacer les coefficients ~cC(1)~C... par
les noms des scalaires ~cendo_1~C, ... et elle est finalement sauv괻 dans IODE.

&IT Lignes "~cEstimation Command:~C" et "~cEstimation Equation:~C"
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Ces lignes sont ignor괻s.


&IT Lignes apr둺 "~cIDENTITIES:~C"
컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Les lignes contenant des identit굎 sont interpr굏괻s comme 굌uations � partir du moment o� :

&EN soit une ligne contenant le texte ~cIdentities:~C est trouv괻
&EN soit une premi둹e identit� pr괽ix괻 par ~c@IDENTITY~C est trouv괻

A partir de ce moment toutes les lignes contenant du texte sont interpr굏괻s par
le programme comme des 굌uations IODE.

En cas d'erreur de syntaxe, la lecture s'arr늯e et un message d'erreur est produit.
>

<Version 6.52> (21/06/2016)
    Version 6.52 (21/06/2016)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI E-Views to IODE
컴컴컴컴컴컴컴컴컴
La syntaxe des fichiers de transfert E-Views to Iode est l괾둹ement modifi괻 pour
permettre une plus grande souplesse : les lignes contenant des identit굎 ne
sont plus interpr굏괻s qu'� partir du moment o� :

&EN soit une ligne contenant le texte ~cIdentities:~C est trouv괻
&EN soit une premi둹e identit� pr괽ix괻 par ~c@IDENTITY~C est trouv괻

A partir de ce moment toutes les lignes contenant du texte sont interpr굏괻s par
le programme comme des 굌uations IODE.

En cas d'erreur de syntaxe, la lecture s'arr늯e et un message d'erreur est produit.


&TI Corrections
컴컴컴컴컴컴컴�
&EN la lecture et l'괹riture de fichiers de profils sont corrig괻s


&TI IodeCom
컴컴컴컴컴�
La version pr괹괺ente ne fonctionnait plus correctement sur certaines machines en raison
de l'absence d'une dll dans la distribution. Ce probl둴e est corrig�.

&TI IodeCmd
컴컴컴컴컴�
Les messages d'erreurs pr괹is sont � pr굎ent affich굎 dans ~ciodecmd~C. Auparavant
seul le message ~c"Error ... Msg##nn"~C 굏ait affich�.

>

<Version 6.51> (04/04/2016)
    Version 6.51 (04/04/2016)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Fonctions de rapport : format LArray
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
De nouvelles fonctions de rapport permettant le sauvetage de s굍ies dans le
format csv adapt� au package Python LArray ont 굏� cr굚es :

&EN $WsSaveCsvVar filename [from to] [vars]
&EN $CsvSep
&EN $CsvDec
&EN $CsvDigits (changer)

&IT Exemple
컴컴컴컴컴�
Le rapport suivant fixe d'abord les param둻res :
&EN le s굋arateur de cellules (d괽aut ,)
&EN le nombre de chiffres significatifs (d괽aut 10)
&EN le caract둹e d괹imal (d괽aut .)
&EN le texte pour les valeurs NaN (d괽aut vide)

Il lance cr괻 ensuite 4 fichiers selon des modes diff굍ents :
&EN toutes les variables sur ou tout le sample
&EN toutes les variables sur la p굍iode 2003Y1 2010Y1
&EN les variables commen놹nt par ~cAC~C sur la p굍iode 2009Y1 2010Y1
&EN les variables commen놹nt par ~cAC~C ou ~cB~C sur tout le sample du WS

&CO
$wsloadvar ..\fun\fun
$csvsep ;
$csvdigits 10
$csvdec .
$csvnan nan

$WsCsvSaveVar fun
$WsCsvSaveVar fun1 2003y1 2010y1

$csvdigits 5
$WsCsvSaveVar fun2 2009y1 2010y1 ACAF ACAG
$WsCsvSaveVar fun3 AC* B*


&TX

Les fichiers r굎ultant de ce rapports sont :

&TI fun.csv
컴컴컴컴컴�
&CO
 var\time;1960;1961;1962;1963;1964;1965;1966;1967;1968;1969;1970;...
 ACAF;nan;nan;nan;nan;nan;nan;nan;nan;nan;nan;1.2130001;5.2020001;9.184;...
 ACAG;nan;nan;nan;nan;nan;nan;nan;nan;nan;nan;-11.028999;-15.847;-19.288002;...
 ...
&TX

&TI fun1.csv
컴컴컴컴컴�
&CO
 var\time;2003;2004;2005;2006;2007;2008;2009;2010
 ACAF;nan;nan;nan;nan;nan;nan;nan;nan
 ACAG;nan;nan;nan;nan;nan;nan;nan;nan
 AOUC;nan;0.2478319161;0.2545676576;0.2637957322;0.2762428533;0.2858059161;...
 ...
&TX

&TI fun2.csv
컴컴컴컴컴�
&CO
 var\time;2009;2010
 ACAF;nan;nan
 ACAG;nan;nan
 ...
&TX

&TI fun3.csv
컴컴컴컴컴�
&CO
var\time;1960;1961;1962;1963;1964;1965;1966;1967;1968;1969;1970;1971;...
ACAF;nan;nan;nan;nan;nan;nan;nan;nan;nan;nan;1.213;5.202;9.184;8.079;...
ACAG;nan;nan;nan;nan;nan;nan;nan;nan;nan;nan;-11.029;-15.847;-19.288;...
BENEF;11.665;13.607;12.208;14.795;18.797;20.86;17.28;20.49;26.935;32.601;...
BQY;31.777;30.853;30.353;27.37;26.937;35.435;37.148;39.506;42.183;43.18;...
BRUGP;nan;nan;nan;nan;nan;nan;nan;nan;nan;nan;0;0;0;0;0;0;0.268;6.137;...
BVY;7.2;7.1;7.1;6.6;6.8;9.4;10.3;11.3;12.4;13.3;17.2;17;19.5;19.2;22.3;...
 ...
&TX

&TI Correction DDE
컴컴컴컴컴컴컴컴컴
Extension des buffers pour la copie vers Excel en DDE.

>

<Version 6.50> (25/01/2016)
    Version 6.50 (25/01/2016)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Adaptations techniques
컴컴컴컴컴컴컴컴컴컴


&EN Planning Corner : REAL ->> IODE_REAL
&EN Compilateur BCC32 7.10 Embarcadero
>

<Version 6.49> (19/01/2016)
    Version 6.49 (19/01/2016)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI WsImportEViews
컴컴컴컴컴컴컴컴컴컴

Cette fonction de rapport a 굏� 굏endue :

&EN Support des fonctions LOG, DLOG, EXP
&EN Fonction ~c@TREND~C traduite en ~ct~C
&EN La fin des lignes � partir d'une quote (caract둹e  ') est ignor괻
&EN Support des lignes sans pr괽ixe @IDENTITY
&EN Support des coefficients VARNAME(n) ->> varname_1
&EN Les expressions C(n) ne sont plus trait괻s s굋ar굆ent, mais comme n'importe quelle
autre expression VARNAME(n).
&EN le s굋arateur entre membre de gauche et de droite de l'굌uation est le premier
signe = rencontr� s'il n'est pas entre parenth둺es. Par exemple :

&CO
  A + (TIME=2015) = X + Y
&TX
devient bien :

&CO
  A + (TIME=2015) := X + Y
&TX
>


<Version 6.48> (12/10/2015)
    Version 6.48 (12/10/2015)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Check Last Version
컴컴컴컴컴컴컴컴컴컴

Correctif : la v굍ification de la derni둹e version peut 늯re supprim괻 via
le fichier iode.ini (voir 6.47), param둻re ~c[General] CheckVersion=0~C.

Cependant, l'acc둺 au site ~ciode.plan.be~C 굏ait quand-m늤e effectu�, m늤e
si ce param둻re 굏ait fix� � 0, ce qui bloquait quelques secondes le
d굆arrage de IODE en cas de blocage du site.

>

<Version 6.47> (06/10/2015)
    Version 6.47 (06/10/2015)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Check Last Version
컴컴컴컴컴컴컴컴컴컴컴
La derni둹e version du logiciel se trouve sur le site ~ciode.plan.be~C. A
chaque d굆arrage de IODE, la version courante est compar괻 avec la derni둹e
version disponible sur le serveur. Si une nouvelle version est disponible,
l'utilisateur est pr굒enu via un message et via le titre de la fen늯re.

Ce check, et le message qui l'accompagne 굒entuellement, peuvent 늯re supprim굎 via le
param둻re ~cGeneral/CheckVersion~C du fichier ~ciode.ini~C.



&TI IODE.INI
컴컴컴컴컴컴
De nouveaux param둻res sont d괽inis :

&CO
[General]
Banner=0
CheckVersion=0
&TX
&EN ~cBanner~C permet de supprimer l'affichage du banner au d굆arrage de IODE
&EN ~cCheckVersion~C permet de supprimer la recherche de nouvelle version sur le
site ~ciode.plan.be~C et dons de ne plus afficher de message si la version
courante n'est plus la derni둹e.


&TI Correctifs
컴컴컴컴컴컴컴컴컴컴
Corrections de bugs :
&EN impression de fichiers A2M
&EN 괺ition de tableaux de comparaison de fichiers
&EN affichage des noms de fichiers dans des graphiques

>

<Version 6.46> (16/09/2015)
    Version 6.46 (16/09/2015)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Fichier iode.ini
컴컴컴컴컴컴컴컴컴컴

Un nouveau fichier de param둻res est ajout� � IODE : ~ciode.ini~C.
Ce fichier est lu au d굆arrage de IODE.


&IT Localisation
컴컴컴컴컴컴컴컴
Le fichier ~ciode.ini~C se trouve par d괽aut dans le
r굋ertoire d'installation de IODE (par d괽ault ~cc:\iode~C). On peut
sp괹ifier un autre fichier en utilisant le nouveau param둻re ~c-iodeini~C au
lancement de IODE.

Par exemple :
&CO
   c:\usr\mymodel>> iode -iodeini mycolors.ini
&TX


&IT Syntaxe du fichier iode.ini
컴컴컴컴컴컴컴컴컴컴컴
La syntaxe du fichier est proche de celle des fichiers ~c.ini~C  :
&EN chaque section d괷ute par un nom entre []. Par exemple :
~c[Fonts]~C.
&EN dans chaque section, les param둻res sont indiqu굎 sous la forme
~cparam=values~C ou ~cparam~C si une valeur ne doit pas 늯re fournie.
&EN Un ligne qui commence par un point-virgule est ignor괻

&IT Contenu de iode.ini
컴컴컴컴컴컴컴컴컴컴컴�

Ce fichier contient actuellement les informations suivantes, mais sera
굏endu dans le futur :

Section ~c[Screen]~C
컴컴컴컴컴컴컴컴
&EN Nl : nombre de lignes de la fen늯re Iode (en caract둹es)
&EN Nc : nombre de colonnes de la fen늯re Iode (en caract둹es)

&CO
[SCREEN]
NL=35
NC=90
&TX


Section ~c[Font]~C
컴컴컴컴컴컴컴컴컴
&EN2 ~cFontName~C : nom
&EN2 ~cFontSize~C : taille (en points)
&EN2 ~cFontSizeMin~C : taille minimum
&EN2 ~cFontSizeMax~C : taille maximum
&EN2 ~cFontSizeIncr~C : incr굆ent en point de la taille des caract둹es

&CO
[FONT]
;FontName=Terminal
FontName=Courier new
FontSize=13
FontSizeMax=30
FontSizeMin=6
FontSizeIncr=1
&TX


Sections ~i[palette_name]~I
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Ces sections contiennent la description RGB des couleurs utilis괻s dans l'괹ran.
Seule la palette [Palette_Default] est utilis괻 par Iode. Si elle est
pr굎ente, elle remplace les valeurs par d괽aut de Iode.

La logique est la suivante :
&EN les trois premi둹es valeurs repr굎entent le code RGB (Red, Green, Blue)
de la couleur de fond (background)

&EN les trois derni둹es valeurs repr굎entent le code RGB (Red, Green, Blue)
du caract둹e (foreground).

Ainsi 0 0 0 repr굎ente le noir et 255 255 255 repr굎ente le blanc. Toute combinaison
permet de cr괻r une palette compl둻e de couleurs.

Pour simplifier l'괹riture, on peut utiliser les mots suivants dans le texte :
&EN BLACK    ==    0,   0,   0
&EN WHITE    ==  255, 255, 255
&EN RED      ==  255,   0,   0
&EN GREEN    ==    0, 192,   0
&EN BLUE     ==    0,   0, 191
&EN YELLOW   ==  255, 255,   0
&EN CYAN     ==    0, 255, 255
&EN MAGENTA  ==  255,   0, 255
&EN PINK     ==  127,   0, 127
&EN GREY     ==  127, 127, 127
&EN ROSE     ==  255, 127,   0
&EN VBLUE    ==   15,  15, 255


&CO
[Palette_Default]
Default     =     0,   0,   0,      0, 255, 255
Reverse     =   191, 191, 191,      0,   0,   0
Underline   =   255, 255,   0,    255,   0,   0
Bold        =     0,   0,   0,    255, 255,   0
Blinking    =   255, 255, 255,      0,   0,   0
Dim         =    31,  31,  31,      0,   0,   0
Black       =     0,   0, 192,    255, 255, 255
Blue        =     0,   0, 255,    255, 255, 255
Green       =     0, 255,   0,    255, 255, 255
Cyan        =     0, 255, 255,      0,   0,   0
Red         =   255,   0,   0,    255, 255, 255
Magenta     =   127,   0, 127,      0,   0,   0
White       =   255, 255, 255,      0,   0,   0
Yellow      =   255,   0,   0,    255, 255,   0
Shadow      =    63,   63,  63,     0,   0,   0
Chelp1      =   255, 127,   0,      0,   0,   0
Chelp2      =   191, 191, 191,    127, 127, 127

&TX

&TI Correction de bugs
컴컴컴컴컴컴컴컴컴컴�
&EN Fonctions corrig괻s :
&EN2 ~c$DataCompare~C : les comparaisons d'굌uations et d'identit굎
    donnaient comme diff굍entes des 굌uations/identit굎 identiques.

&EN2 ~c##FileRename, ##FileCopy, ##WsHtolLast, ##WsLtoHFlow, ##WsLtoHStock,
##WsSeasonAdj, ##WsTrend~C : iode pouvait stopper en raison de la longueur
des noms de fichiers.

>

<Version 6.45> (07/09/2015)
    Version 6.45 (07/09/2015)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Aide en ligne
컴컴컴컴컴컴컴컴�
Deux formats de fichiers sont dor굈avant support굎 : les format ~c  .hlp~C et ~c.chm.~C
Il s'agit du m늤e manuel, mais chaque format offre des fonctions sp괹ifiques
de recherche et d'affichage.

On peut passer d'un format � un autre dans le menu ~cHelp~C.

L'acc둺 au site ~ciode.plan.be~C est 괾alement ajout� directement dans la menu Help.

&IT Fichier ~ciode.hlp~C
컴컴컴컴컴컴컴컴컴컴컴컴

Il s'agit de l'ancien syst둴e WinHelp de Windows. Cette formule pr굎ente
l'avantage de pointer directement sur la page du manuel correspondant au
contexte courant. Dans l'괺ition des rapports par exemple, en cliquant sur F10 avec
le curseur sur un nom de fonction, on acc둪e directement � la page d굎ir괻.

Contrainte : � partir de Vista, il faut avoir pr괶lablement
install� le logiciel WinHelp pour pouvoir exploiter ce format. Ce logiciel
est gratuit et est disponible sur le site de Microsoft.

&IT Fichier ~ciode.chm~C
컴컴컴컴컴컴컴컴컴컴컴컴

Ce fichier est d'un format plus r괹ent et pr굎entent
d'autres fonctions de recherche et d'indexation. Il est propos� par
d괽aut. Ce manuel n'est cependant pas pilot� par iode : une fois ouvert, l'utilisateur
doit rechercher la page qui l'int굍esse � travers l'interface du programme lui-m늤e.

Dans les deux cas, le fichier d'aide doit se trouver dans m늤e directory que
le programme ~ciode.exe~C.

&TI Correction de bugs
컴컴컴컴컴컴컴컴컴컴�
&EN Fonctions corrig괻s :
&EN2 ~c$DataCompareXxx~C
&EN2 ~c$DataDuplicate~C
&EN2 ~c$DataListXxx~C

>

<Version 6.44> (10/04/2015)
    Version 6.44 (10/04/2015)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Sauvetage et relecture des WS en Ascii
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Le sauvetage en ascii des fichiers de commentaires, d'굌uations, de listes
et de tableaux prend en compte les caract둹es ~c"~C et ~c\~C qui peuvent 늯re
pr굎ents dans certains textes (titres, commentaires, ...).

Ces caract둹es sont pr괹괺굎 au moment du sauvetage par un backslash (~c\~C). Cela permet
de relire ensuite sans probl둴e le fichier ascii g굈굍� (~c.ac, .ae, .al, .at~C).

&TI Noms de WS d굋assant 63 caract둹es
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Les noms de WS sup굍ieurs � 63 caract둹es et/ou contenant des espaces sont �
pr굎ent g굍굎 par IODE. Cela permet de placer ses fichiers dans n'importe quel directory comme :
&CO
~cC:\Users\My Name\SharePoint\share sgad\cic\IODE\TresLongNomdeDirectoryPourTesterIode~C
&TX

Les fichiers avec des noms longs et/ou des espaces dans leur nom
sont utilisables dans les situations suivantes :

&EN Ouverture � partir de l'explorateur Windows
&EN Lancement � partir d'un shell dos ("Command Prompt")
&EN Rapports : dans les fonctions ~c$WsLoad*~C, ~c$WsSave*~C, etc.

&TI Caract둹es accentu굎 en HTML
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Tous les caract둹es minuscules accentu굎 sont traduits dans la forme html du type "&...;".

&TI Enregistrement des touches
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Il est possible d'enregistrer dans un fichier les s굌uences de touches
utilis괻s pendant une session iode. Il faut pour ce faire lancer ~ciode~C
avec le param둻re ~c-rec~C comme ci-dessous :

&CO
    iode -rec filename
&TX

Le fichier (ici ~cfilename~C) contiendra des s굌uences de touches codifi괻s
selon la syntaxe d괹rite dans la version 6.27 de iode. Ce fichier peut 늯re
괺it� � l'aide d'un 괺iteur ascii.

Ces touches peuvent ensuite 늯re "rejou괻s" automatiquement. Cela permet par exemple :
&EN de lancer des op굍ations r굋굏itives sans avoir � passer par les rapports
&EN de lancer des proc괺ures de test unitaires

Toutes les op굍ations ne sont cependant pas exploitables : les op굍ations
effectu괻s � l'aide de la souris ne sont pas support괻s. Il faut 괾alement
늯re attentif au fait que la position dans un menu ou le contenu d'un 괹ran
de saisie peuvent changer entre deux lancements successifs de iode.

&TI Correction de bugs
컴컴컴컴컴컴컴컴컴컴�
Lors de l'괺ition des tableaux, une erreur pouvait se produire
lors de la destruction de lignes.


>

<Version 6.43> (24/02/2014)
    Version 6.43 (24/02/2014)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI IODECMD : arguments
컴컴컴컴컴�
Le lancement d'un rapport � l'aide de iodecmd peut contenir les arguments du rapport :
&CO
  c:\>> iodecmd -y -v myrep arg1 arg2
&TX

Les param둻res du programme ~ciodecmd~C doivent se trouver avant le nom du rapport sans
quoi ils sont consid굍굎 comme des arguments du rapport et pass굎 comme tels au rapport.

&TI Conversion UTF8
컴컴컴컴컴컴컴컴컴�
De nouvelles fonctions de rapport permettent de transformer des fichiers codes ANSI ou OEM
en UTF-8 directement depuis des rapports.

&CO
    $SysAnsiToUTF8 inputfile outputfile
    $SysOemToUTF8  inputfile outputfile
&TX


&TI Conversion ANSI-OEM
컴컴컴컴컴컴컴컴컴�
Les fonctions de rapport suivantes convertissent des fichiers cod굎 ANSI en OEM
et r괹iproquement.

&CO
    $SysAnsiToOem inputfile outputfile
    $SysOemToAnsi inputfile outputfile
&TX

>

<Version 6.42> (07/10/2013)
    Version 6.42 (07/10/2013)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI G굈굍ation de tableaux HTML
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Lors de la g굈굍ation de tableau en HTML, des classes par d괽aut sont utilis괻s pour les tags suivants :
&EN <<TABLE>> : A2mTable
&EN <<TR>> : A2mTR
&EN <<TH>> : A2mTH
&EN <<TD>> : A2mTD

Ces tags peuvent 늯re remplac굎 par d'autres via 4 commandes dans les rapports :
&CO
  $PrintHtmlTableClass [myTableClass]
  $PrintHtmlTRClass    [myTRClass]
  $PrintHtmlTHClass    [myTHClass]
  $PrintHtmlTDClass    [myTDClass]
&TX

Les noms de classes vides suppriment la r괽굍ence � la classe dans le tag html.


>

<Version 6.41> (15/07/2013)
    Version 6.41 (15/07/2013)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Gestion M굆oire
컴컴컴컴컴컴컴컴컴�
Am굃ioration  de la gestion des "swaps" pour permettre la gestion de plus
de ~bblocs~B m굆oire (>>32767).

On a dans la version courante :
&EN 262144 bytes par bloc m굆oire  (ou plus pour des objects plus grands)
&EN 65535 blocs m굆oire maximum
>

<Version 6.40> (20/02/2013)
    Version 6.40 (20/02/2013)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Rapports
컴컴컴컴

&IT $indent
컴컴컴컴컴�
Il est dor굈avant possible d'indenter les commandes dans les rapports.
La commande ~c$indent~C sans argument indique qu'� partir de ce moment, les
commandes peuvent ne plus 늯re coll괻s � la marge. Avec l'argument N ou n ou
0, le comportement ancien reprend.


Pour 굒iter les probl둴es de compatibilit� entre les versions de IODE, la valeur
par d괽aut est de ne pas accepter les indentations.

&CO
   $indent [{Nn0}]
&TX

Par exemple, on peut 괹rire :

&CO
$indent

$procdef print list
$------------------
    $foreach i %list%
	$show print : %i%
    $next i
$procend

$procdef print2 list
$-------------------
    $foreach i %list%
	$show print2 : %i%
	$procexec print 1 2 3
    $next i
$procend

$procexec print2 A B C
&TX
Le r굎ultat produit est le suivant  :

&CO
print2 : A
print : 1
print : 2
print : 3
print2 : B
print : 1
print : 2
print : 3
&TX

&IT $procdef, $procend, $procexec
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Les instructions de ce groupe permettent de construire des proc괺ures, c'est � dire des
listes de commandes qui peuvent 늯re r굑tilis괻s et param굏r괻s.

&CO
 $procdef procname [fparm1 ...]
 ..
 $procend
&TX

o�
&EN ~bprocname~B est le nom de la proc괺ure (case sensitive).
&EN ~bfparm1~B est le premier param둻re ~iformel~I de la proc괺ure

&IT Appel d'une proc괺ure
컴컴컴컴컴컴컴컴컴컴컴컴�
L'appel se fait simplement par la commande :

&CO
$procexec nom_proc aparm1 ...
&TX

o�
&EN ~bprocname~B est le nom de la proc괺ure (case sensitive).
&EN ~baparm1~B est le premier param둻re ~iactuel~I de la proc괺ure

&IT Param둻res
컴컴컴컴컴컴컴
Les param둻res formels sont trait굎 dans la proc괺ure comme des defines
(locaux � la proc괺ure) : ils doivent 늯re appel굎 par ~c%fparm%~C.

Leurs valeurs sont fix괻s comme suit :

&EN S'il y a moins de param둻res actuels que de param둻res formels ou si
leur nombre est 괾al, les valeurs des param둻res actuels sont assign괻s dans
l'ordre aux premiers param둻res formels. Les param둻res formels
exc괺entaires sont consid굍굎 comme vides.

&EN S'il y a plus de param둻res actuels que de param둻res formels, les
param둻res formels, ~bsauf le dernier~B, re뇇ivent les valeurs de premiers
param둻res actuels, dans l'ordre de leur passage.
~bLe dernier param둻res formel re뇇it la valeur de tous
les param둻res actuels restants~B.

Exemple avec plus de param둻res actuels de formels :
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
&CO
$indent
$procdef print list
    $foreach i %list%
	$show print : %i%
    $next i
$procend
$procexec print A B C
&TX

R굎ultat :
&CO
print : A
print : B
print : C
&TX
On constate que le param둻re formel ~clist~C re뇇it toutes les valeurs
pass괻s � la proc괺ure. La boucle it둹e donc 3 fois.

Exemple avec moins de param둻res actuels de formels :
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
&CO
$indent
$procdef print titre list
    $show %titre%
    $foreach i %list%
	$show print : %i%
    $next i
$procend
$procexec print "Mon Titre"
&TX

R굎ultat :
&CO
Mon Titre
&TX
Cette fois, le premier param둻re ~ctitre~C contient ~c"Mon Titre"~C qui est
imprim� avant la boucle. Par contre, la boucle ne s'ex괹ute pas car le
param둻re ~clist~C est vide.

&IT Port괻 de la d괽inition d'une proc괺ure
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
1. Les proc괺ures doivent 늯re d괽inies avant de pouvoir 늯re appel괻s.

2. Une fois d괽inie, une proc괺ure reste appelable au sein de la m늤e session de IODE, m늤e
si le rapport qui l'a d괽inie est termin�. On peut ex괹uter un rapport qui n'a
d'autre effet que de charger des proc괺ures en m굆oire. Ces proc괺ures resteront disponibles
pendant toutes la session IODE.

3. Une proc괺ure peut 늯re remplac괻 par une autre du m늤e nom � tout moment.

&IT Port괻 des param둻res formels
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Les param둻res formels sont trait굎 comme des defines dont la port괻 est
limit괻 � la proc괺ure courante.

Par cons굌uent, si un define existe ~uavant l'appelU de la proc괺ure avec le m늤e nom qu'un
des param둻res, ce define ne peut 늯re utilis� au sein de la proc괺ure.
Apr둺 la proc괺ure, il reprend sa valeur ant굍ieure.

Exemple :
&CO
$define titre Quotients de mortalit�
$show Avant la proc : %titre%

$procdef print titre list
    $show Pendant la proc :%titre%
    $foreach i %list%
	$show print : %i%
    $next i
$procend

$procexec print "Mon Titre"
$show Apr둺 la proc :%titre%
&TX

R굎ultat :
&CO
Avant la proc : Quotients de mortalit�
Pendant la proc :Mon Titre
Apr둺 la proc :Quotients de mortalit�
&TX

&TI E-Views
컴컴컴컴컴�
Dans la commande ~c$WsImportEviews~C,
la traduction de la fonction de taux de croissance (@PCH) en grt est remplac괻 par 0.01 * grt.
&CO
    @PCH(X)  ->> 0.01 * grt(X)
&TX

>

<Version 6.39> (13/02/2013)
    Version 6.39 (13/02/2013)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Rapports
컴컴컴컴
Correction de bugs mineurs dans la construction de tableaux dans les rapports � l'aide
de commentaires (fonction ~c$DataUpdateTbl~C).
>

<Version 6.38> (11/02/2013)
    Version 6.38 (11/02/2013)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI IODECMD
컴컴컴컴컴컴컴컴
Syntaxe :

&CO
    iodecmd [-nbrun n] [-alloclog filename] [-v] [-y] [-h] reportfile
&TX
where :
&EN -nbrun n : n = nb of repetitions of the report execution (default 1)
&EN -allocdoc filename : memory debugging info stored in filename (developpers only)
&EN -v : verbose version (all messages displayed)
&EN -y : answer yes to all questions asked during the report execution
&EN -h : display program syntax
&EN reportfile : report to execute


&IT Error messages
컴컴컴컴컴컴컴컴컴
The error messages are now included in iodecmd (replacing msg like "error
##nnn" by something more readable).


&TI Reports
컴컴컴컴컴�

&IT $Quit or $QuitOde
컴컴컴컴컴컴컴컴컴컴�
L'utilisation de la fonction $quit dans un rapport iode provoquait une erreur dans iodecmd.
Cette erreur est corrig괻.

&IT $EqsEstimate
컴컴컴컴컴컴컴�
Les coefficients inexistants avant l'estimation sont cr굚s automatiquement.
Cela 굒ite de devoir les cr괻r dans une commande s굋ar괻.

&IT $vseps, @vtake(), @vdrop(), @vcount()
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
New commands and functions that allow an easier manipulation of lists
in the report execution process.

&CO
    $vseps {seperator list}  : specify the new list separator(s) -- default : ",; "
    @vtake({n},{list})       : take the n first elements of the list (or last if n is negative)
    @vdrop({n},{list})       : drop the n first elements of the list (or last if n is negative)
    @vcount({list})          : return the number of elements in the list
&TX

Exemple :
&CO
    $vseps ;
    $define LIST A;B;C;D
    $label next
    $define ELEMENT @vtake(1, %LIST%)
    $msg ... Some operation on element %ELEMENT% ...
    $define LIST @vdrop(1,%LIST%)
    $goto next @vcount(%LIST%)
&TX

&IT Boucles :  $foreach et $next
컴컴컴컴컴컴컴컴컴�
Cette commande de rapport permet de simplifier l'괹riture de
boucles ou de boucles imbriqu괻s.

La commande $foreach permet de sp괹ifier
un index et la liste de valeurs que cet index doit successivement prendre.

La commande $next permet de revenir au point de d굋art de la boucle
($foreach) et de passer � la valeur suivante de l'index.

&SY2
    $foreach {index} {values}
    ...
    $next {index}
&TX
o�
&EN ~c{index}~C est un nom de macro de maximum 10 caract둹es (par exemple ~ci, idx, PAYS~C , ...)
&EN ~c{values}~C est une liste de valeurs s굋ar괻s par des virgules, blancs ou
point-virgules. Les s굋arateurs peuvent 늯re modifi굎 par la commande ~c$vseps~C

Exemple 1 : boucles imbriqu괻s
&CO
    $foreach I BE BXL VL WAL
	$foreach J H F
	$show [%I%;%J%]
	$next J
    $next I
&TX

Exemple 2 : utilisation de listes
&CO
    $DataUpdateLst MYLIST X,Y,Z
    $Define n 0
    $foreach I @lvalue(MYLIST)
	$Define n {%n% + 1}
	$show Element %n% : [%I%]
    $next I
&TX


&IT $goto
컴컴컴컴�
La fonction goto prend un ou deux arguments :
&EN argument 1 : le label o� le programme doit pointer
&EN argument 2 (optionnel) :indique s'il faut ou non aller au label indiqu�.
Si cet argument est un nombre diff굍ent de 0, le rapport se poursuit au
label indiqu�. Sinon le rapport se poursuit � la ligne suivante.

Auparavant, le rapport se poursuivait au label uniquement si l'argument 2 굏ait 1. Toutes les
autres valeurs 굏aient 굌uivalentes � 0.

&TI Execution of identities
컴컴컴컴컴컴컴컴컴컴컴컴�
Augmentation des performances pour les grands ensembles d'identit굎 et les
identit굎 tr둺 longues : cpu diminu� d'un facteur 20.

&TI Format Ascii
컴컴컴컴컴컴컴컴
Les valeurs suivantes sont reconnues comme na dans les fichiers ASCII :
&CO
    .
    /
    na
&TX

Attention, deux points coll굎 sont consid굍굎 comme deux valeurs na distinctes. Ainsi,

&CO
    1 ./. 2 .. 3
&TX
굌uivant � :
&CO
    1 na na na 2 na na 3
&TX

&TI  Estimation
컴컴컴컴컴컴컴�
L'estimation d'굌uations dont les coefficients ont des valeurs nulles pouvait dans
certains cas 늯re erronn괻. Les coefficients nuls sont fix굎 � 0.1 avant de lancer le
processus d'estimation, ce qui pourrait dans certains cas poser probl둴e.
>

<Version 6.37> (28/09/2012)
    Version 6.37 (28/09/2012)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Memory leaks
컴컴컴컴컴컴컴컴
Diff굍entes corrections ont 굏� apport괻s pour permettre de gagner ou de
r괹up굍er de l'espace m굆oire.

&EN IodeEnd() : suppression des WS
&EN SimulateSCC() : r괹up굍ation de stracpy() des noms de 굌uations
&EN Repeat() : free(line)
&EN GMacro() : free(tmp)
&EN KI_scalar_list() : d굋lacement dans la boucle d'un free
&EN Remplacement de malloc, realloc et free par SCR_*().

>

<Version 6.36> (31/05/2012)
    Version 6.36 (31/05/2012)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Genereralized Samples
컴컴컴컴컴컴컴컴컴컴컴컴�
Different elements have been added to the generalized sample syntax :


&EN new macros to
specify the first (BOS = Begin Of Sample) and last (EOS = End Of Sample)
period of the current WS, the current period (NOW), or the first period (with
respect to the current periodicity), the number of sub periods and the current sub period :
&EN2 ~bBOS~B : Begin of Sample
&EN2 ~bBOS1~B : first period in the BOS's year
&EN2 ~bEOS~B : End of Sample
&EN2 ~bEOS1~B : first period in the EOS's year
&EN2 ~bNOW~B : current period (according to the computer clock)
&EN2 ~bNOW1~B : first period in the NOW's year
&EN2 ~bP~B or ~bPER~B : number of periods in one year of the current sample
&EN2 ~bS~B or ~bSUB~B : current subperiod (eg : for a monthly sample, S is equal to 5 in may)

&EN shift operators : ~c<<n~C and ~c>>n~C : concatenated to a period definition,
they shift the period by the specified number of periods.

&EN reverse increments : ~c2000:5*-n~C creates a sample in reverse order : ~c2004;2003;2002;2001;2000~C.

&IT BOS, EOS, NOW, BOS1, EOS1, NOW1, SUB, PER
컴컴컴컴컴컴컴�
Assuming that ~c1990M6:2010M12~C is the current sample,
the following samples are equivalent to each other :

&CO
    BOS:2;EOS   ==   1990M6;1990M7;2010M12
    EOS;EOS1    ==   2010M12:2010M1
    NOW;NOW1    ==   2012M5;2012M1
    NOW:P       ==   2012M5;2012M6;...;2013M4
    NOW:3*P     ==   2012M5;2013M5;2014M5
    NOW1:SUB    ==   2012M5
&TX

~cNOW~C is thus replaced by the current period (defined by the computer clock).
The sub-period depends on the current periodicity. In the case of Weekly series,
the current week is based on the ISO-8601 standard.

&IT Shift operators <<n and >>n
컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
When the value of the sample is not known in advance, for example when the
variable file is a report parameter or when a report can be used with different
input file, it is
important to be able to indicate not only the last observation, but also the
next-to-last observations or more generally the ~ulast n observations~U. The
same is true for the first observations which can also be unknown at the
moment a report is written.

To specify EOS minus 10 periods, simply write :
&CO
    EOS<<10
&TX

More generally, a specified period can be modified by a left or right shift :
&CO
    2000Y1>>5      === 2005Y1
    1999M1>>12     === 2000M1
    EOS<<1         === 2019Y1 (if EOS == 2020Y1)
    BOS<<1         === 1959Y1 (if BOS == 1960Y1)
    NOW;NOW1<<4    === 2012Q2;2011Q1 (for quaterly data)
&TX

When used with a null argument, the shift oprerators have a special meaning :
&EN <<0 means "first period of the year"
&EN >>0 means "last period of the year"

&CO
    NOW<<0;NOW>>0    === 2012Q1;2012Q4
&TX

The same operators accept the new macros PER (P) and SUB (S) :
&CO
    NOW<<0:P        === 2012Q1;2012Q2;2012Q3;2012Q4
    NOW:3*P        === 2012Q2;2013Q2;2014Q2
&TX

The shift operators can also be applied on expressions :
&CO
    NOW;(NOW<<0>>1/NOW<<0)>>P   === 2012Q2;2013Q2/2013Q1

&TX
&IT Increments
컴컴컴컴컴컴컴
A range of periods is defined by :

&EN the first period
&EN the number of repetitions
&EN a optional increment to add more than one period at a time

In the previous versions, increments should be positive. It is now possible
to use negative increments, allowing expressions such as :

&CO
    EOS:5*-1  == 2020;2019,2018,2017,2016
&TX

&TI E-Views to IODE
컴컴컴컴컴컴컴컴컴�
Object : extraction of equations, scalars and identities from E-Views export data.

&IT Format of E-Views data
컴컴컴컴컴컴컴컴컴컴컴컴컴컴

&CO
Forecasting Equation:
=========================
D(B_PQVC) = C(1)*D(PQVC) + C(2)*(D2001+D2002) + C(3)*D(B_PQVC(-3))

Substituted Coefficients:
=========================
D(B_PQVC) = 0.894661573413*D(PQVC) - 0.0284533462569*(D2001+D2002) + 0.241546373731*D(B_PQVC(-3))

@IDENTITY gro_w_produz_def  = w_produz_def  / w_produz_def(-1)  - 1
&TX


The E-views file is interpreted as decribed below :

&EN the 2 equations following the titles "Forecasting Equation" and "Substituted
Coefficients" are extracted.

&EN the first equation is translated into IODE format :
&EN2  ~cD(...)~C is replaced by ~cd(...)~C
&EN2  ~cC(<<n>>)~C is replaced by the ~cendoname_<<n>>~C
&EN2  ~cExpr(<<lag>>)~C is replaced bu ~cExpr[<<lag>>]~C
&EN2  the first encountered variable is choosen as the endogenous variable
&EN2 the first = sign is considered as the separator between left and right
    members of the equation and therefore replaced by :=

&EN the coefficients values are extracted from the second equation ("Substituted Coefficients").
&EN the lines beginning by ~c@IDENTITY~C are extracted and translated in
    IODE equations with no coefficient.

&EN every equation is added in the current Equations WS.
&EN every detected coefficient is saved in the Scalars WS.

&IT Fonction de rapport
컴컴컴컴컴컴컴컴컴컴컴�
Pour exploiter ce format, il faut appeler la fonction de rapport suivante :
&CO
    $WsImportEviews filename
&TX

o� filename est le nom du fichier � importer. Les WS courants sont augment굎 des 굌uations
et scalaires d굏ect굎.


&TI Comparaison de WS de variables
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Correction d'un bug qui rendait la comparaison des s굍ies incorrecte (les
premi둹es et derni둹es valeurs n'굏aient pas compar괻s).

>

<Version 6.35> (28/03/2012)
    Version 6.35 (28/03/2012)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Simulation
컴컴컴컴컴컴컴
La performance des simulations, sp괹ifiquement lors du d굆arrage (link, sort), a 굏�
largement am굃ior괻. Pour atteindre cet objectif, le processus de simulation
a 굏� divis� en 2 굏apes. La premi둹e ne s'occupe que du r굊rdonnancement du
mod둳e, la seconde de la simulation.

De plus, des am굃iorations notables ont 굏� apport괻s � plusieurs
endroits en terme de vitesse d'ex괹ution dans la phase de d굆arrage. La
simulation d굆arre quasi instantan굆ent m늤e avec un mod둳e d굋assant les
100 000 굌uations.

&IT D괹oupe de la simulation en deux passages
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Deux nouvelles fonctions de rapport et les deux 괹rans de saisie
correspondant ont 굏� cr굚s.

~uComposantes Fortement Connexes~U
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
La premi둹e fonction permet de d괹omposer le mod둳e en composantes fortement
connexes (CFC ou SCC pour Strongly Connex Components) et de le r굊rdonnancer.
Trois listes sont donc cr굚es : 굌uations pr굍괹ursives,
interd굋endantes et postr괹ursives.

Lors du r굊rdonnancement du mod둳e, le
nombre d'it굍ations de triangulation (tri) pour le block interd굋endant doit
늯re sp괹ifi�. Cette valeur n'a 굒idemment d'effet que sur la liste des
굌uations interd굋endantes.

Ces 3 listes ne doivent 늯re contruites qu'une seule fois pour une version donn괻 du mod둳e.

Cette premi둹e fonction a la syntaxe suivante :

&CO
    $ModelCalcSCC nbtri lstpre lstinter lstpost
&TX
o� :

&EN nbtri est le nombre d'it굍ations de triangulation � effectuer
&EN lst* sont les NOMS des listes destin괻s � contenir les r굎ultats du tri des 굌uations

~uSimulation~U
컴컴컴컴컴컴컴
La seconde fonction lance la simulation du mod둳e sur base des trois listes
pr괶lablement construites par la fonction $ModelCalcSCC (ou � la main).

Sa syntaxe est :

&CO
    $ModelSimulateSCC from to pre inter post
&TX
o� :
&EN from et to d굏erminent le sample de simulation
&EN pre, inter et post sont les listes qui d괽inissent l'ordre d'ex괹ution du mod둳e.


&IT Choix du nombre de tris
컴컴컴컴컴컴컴컴컴컴컴컴컴�

Apr둺 la d괹ompostion en CFC, le bloc interd굋endant est tri� pour augmenter la vitesse
de la simulation. Le nombre de passage de l'algorithme de tri peut 늯re
sp괹ifi� � plusieurs endroits :

&EN Dans l'괹ran de simulation "standard" : param둻re "Passes" fix�
&EN Dans l'괹ran de calcul de la d괹omposition du mod둳e :  param둻re "Triangulation Iterations"
&EN Comme param둻re dans la commande rapport $ModelCalcSCC
&EN Comme dernier param둻re dans la commande rapport $ModelSimulateParms

&NO Dans les versions ant굍ieures, le nombre de passages de la triangulation sp괹ifi� dans
l'괹ran de simulation n'avait pas d'effet

&IT Debug
컴컴컴컴�
L'option debug activait la g굈굍ation d'un fichier simul.dbg qui contenait une quantit� 굈orme
d'informations. Dans cette version, seules les listes ~c_PRE, _INTER~C et
~c_POST~C (avec la d괹oupe du mod둳e) sont g굈굍괻s.

&IT Commande de rapport $ModelSimulateParms
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Cette commande prend un param둻re suppl굆entaire avec le nombre d'it굍ations
de triangulation demand괻s.

&TI Fonctions de rapport
컴컴컴컴컴컴컴컴컴컴컴컴

Les fonctions suivantes permettent d'obtenir la valeur de certains
param둻res de simulation :

&CO
    @SimEps()   : retourne la valeur du crit둹e de convergence utilis� pour
		  la derni둹e simulation
    @SimRelax() : retourne la valeur du param둻re de relaxation utilis� pour
		  la derni둹e simulation
    @SimMaxit() : retourne la valeur du maximum d'it굍ations utilis�
		  pour la derni둹e simulation
&TX

Les r굎ultats par p굍iode de simulation peuvent 늯re r괹up굍굎 via les fonctions suivantes :
&CO
    @SimNiter(period) : nombre d'it굍ations n괹essaires � la
		     r굎olution du mod둳e � l'ann괻 period
    @SimNorm(period)  : seuil de convergence atteint � la r굎olution
		     du mod둳e � l'ann괻 period
&TX

Un chrono virtuel a 굏� ajout� pour permettre de calculer les dur괻s de traitement :

&CO
    @ChronoReset() : remet le chrono � 0
    @ChronoGet()   : retourne le temps 괹oul� (en msecs) depuis le dernier
		  reset du chrono
&TX


&IT Exemple
컴컴컴컴컴�
L'exemple ci-dessous compare les performances selon le nombre de tri de
l'algorithme de simulation.

&CO

  $ Parameters
  $ ----------
  $define modeldir C:\iode\nemesis
  $define model base_neujobs_rd
  $define nbtri 5
  $define simfrom 2011Y1
  $define simto 2012Y1
  $define simper %simfrom% %simto%
  $ModelSimulateParms 0.00001 0.6 500 Both 0 No 1

  $ Output file
  $ -----------
  $PrintDest compare.html HTML

  $ Load fresh files
  $ ----------------
  $WsLoadVar %modeldir%\%model%
  $WsLoadScl %modeldir%\%model%
  $WsLoadEqs %modeldir%\%model%

  $ ==== $ModelCalcSCC ===
  .par1 tit_1
  Comparaison entre les performances selon le nombre de tri

  $ ==== Loop on Tri tests ===
  $define i 0
  $label nexttri

  $ Calcul SCC
  $ ----------
  $show $ModelCalcSCC %i%
  @ChronoReset()
  $ModelCalcSCC %i% pre inter post
  $define cpu1  @ChronoGet()

  $ Simulate
  $ --------
  $ Reload vars for a clean start and modify exo
  $show Reload Vars ...
  $WsLoadVar %modeldir%\%model%
  $DataUpdateVar RPOIL 2011Y1 1.20

  $show $ModelSimulateSCC  %simper% pre inter post
  @ChronoReset()
  $ModelSimulateSCC %simper% pre inter post
  $define cpu2 @ChronoGet()

  $ Reporting
  $ ---------
  .par1 enum_1
  Tris : %i%
  .par1 enum_2
  Calc SCC : %cpu1% msec
  .par1 enum_2
  Simulation (eps = @simeps(); maxit=@simmaxit()) : %cpu2% msec

  $define j {%simfrom%}
  $define totit 0

  $label nextsimper
  .par1 enum_3
  {%j%@T} : conv = @simnorm({%j%@T}), niter = @simniter({%j%@T})
  $define simit @simniter({%j%@T})
  $define totit {%totit% + %simit%}
  $define j {%j% + 1}
  $goto nextsimper {%j% <<= %simto%}
  .par1 enum_3
  Total iterations : %totit%
  $define i {%i% + 1}
  $goto nexttri {%i% <<= %nbtri%}
&TX

&TI Comparaison de WS de variables
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
La comparaison des WS de varialbles s'effectait sur base d'une stricte 괾alit� binaire.
Par cons굌uent les r굎ultats de simulation avaient peu de chance d'늯re consid굍굎 comme
괾aux, une diff굍ence � 1e-15 suffisant � faire 괹houer le test d'괾alit�.

Une nouvelle fonction de rapport, ~c$DataCompareEps~C, permet de fixer le
seuil en-de뇚 duquel le test d'괾alit� est consid굍� comme ayant 굏�
satisfait.

Le test de comparaison est :
&CO
    si x1 <<>> 0 :  |(x1 - x2) / x1| << eps
    sinon :       |x2| << eps
&TX

&SY
    $DataCompareEps eps
&TX

L'괹ran de comparaison de WS (Data/List/File Compare) permet 괾alement de
sp괹ifier cette valeur (param둻re Threshold).

&TI Seuil de comparaison par d괽aut
컴컴컴컴컴컴컴컴컴컴�
Le seuil de comparaison est fix� � 1e-7 par d괽aut.
>



<Version 6.34> (29/02/2012)
    Version 6.34 (29/02/2012)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Commandes d'impression en rtf et mif
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Les commandes de num굍otation des pages et de d괽inition des headers et footers de pages
ont 굏� impl굆ent괻s pour les sorties rtf (Word) et mif (Framemaker).

Par exemple :
&CO
    $printdest resfun.rtf RTF
    $printpagefooter Ecopol - @date("dd/mm/yy") - page%d
    $printpageheader Hypoth둺es et r굎ultats de la projection de base
&TX

Par ailleurs, une partie du catalogue de paragraphes est supprim괻 : il s'agit par
exemple de par_2, enum_6, ... qui ne sont jamais utilis굎.


&TI Hodrick Preskott
컴컴컴컴컴컴컴컴컴컴

Am굃ioration de la fonction dans le cas o� l'expression contient des NaN :
les premi둹es et derni둹es valeurs NaN sont skipp괻s.


&TI Nouvelles fonctions de rapport
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
De nouvelles fonctions de rapports permettent d'automatiser plus facilement
certains processus, notamment en extrayant des informations des objets
굌uations.

Le SAMPLE d'estimation d'une 굌uation peut 늯re retrouv� dans un rapport � l'aide
de la fonction ~c@eqsample~C. La partie "FROM" et la partie "TO" sont obtenues
respectivement par les fonctions @eqsamplefrom et @eqsampleto.

A l'aide de ces fonctions, il devient facile d'automatiser le processus de
r괻stimation.

&CO
    @eqsample(eqname)     : retourne le sample d'estimation de l'굌uation ~ceqname~C
    @eqsamplefrom(eqname) : retourne la partie FROM du sample d'estimation
    @eqsampleto(eqname)   : retourne la partie TO du sample d'estimation
    @eqlhs(eqname)        : retourne le membre de gauche d'une 굌uations
    @eqrhs(eqname)        : retourne le membre de droite d'une 굌uations
&TX

Dans l'exemple suivant, on extrait la premi둹e ann괻 d'estimation de l'굌uation ENDO1
pour r괻stimer l'굌uation sur un sample prolong� � droite.

&CO
    $EqsEstimate @eqsamplefrom(ENDO1) 2012Y1 ENDO1
&TX



&TI Transferts entre Excel et IODE dans les rapports
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Avant cette version de IODE, pour qu'un transfert de donn괻s entre Excel et
IODE via la fonction ~c$ExceLGetVar~C puisse fonctionner, le format des
nombres � transf굍er ne pouvait contenir de s굋arateur de milliers ni de
signe de devise comme $ ou �.

A partir de :  cette version, les formats contenant des s굋arateurs de milliers ou des
devises sont correctement interpr굏굎.

Par d괽aut, IODE lit la d괽inition des valeurs des s굋arateurs de milliers
et le caract둹e des devises dans les param둻res "r괾ionaux" (Regional
Settings). Si ces informations ne conviennent pas, elles peuvent 늯re
modifi괻s par les commandes de rapport suivantes :

&CO
    $ExcelThousand
    $ExcelCurrency
&TX

&IT $ExcelThousand
컴컴컴컴컴컴컴컴컴컴�
Syntaxe :
&CO
    $ExcelThousand [char]
&TX

La valeur de char remplace celle du s굋arateur de milliers d괽inie dans les
param둻res de Windows. Lorsque ce caract둹e est rencontr� lors du transfert
d'Excel vers IODE, il est ignor�.

Certaines valeurs sp괹iales de ~cchar~C ont une interpr굏ation particuli둹e :

&EN d, D, p ou P : le s굋arateur est le point
&EN c ou C : le s굋arateur est la virgule
&EN ~cspace~C ou ~cs~C ou ~cSpace~C : le s굋arateur est l'espace
&EN n, N ou pas d'argument : il n'y a pas de s굋arateur
&EN tout autre valeur est prise telle quelle comme s굋arateur

&IT $ExcelCurrency
컴컴컴컴컴컴컴컴컴컴�
Syntaxe :
&CO
    $ExcelCurrency [char]
&TX

La valeur de char remplace celle du caract둹e indiquant la devise dans les
param둻res de Windows. Lorsque ce caract둹e est rencontr� lors du transfert
d'Excel vers IODE, il est ignor�.

Certaines valeurs sp괹iales de ~cchar~C ont une interpr굏ation particuli둹e :

&EN d, D : dollar
&EN e ou E : euro
&EN p ou P : sterling pound
&EN pas d'argument : il n'y a pas de signe de devise
&EN tout autre valeur est prise telle quelle comme signe de devise

&IT Exemple
컴컴컴컴컴�
Fichier Excel :
&CO
  |    B       C       D       E
--|--------------------------------
3 | $10,000 $20,000 $30,000 $40,000
4 | $12,345 $23,456 $34,567 $45,678
&TX

Rapport :

&CO
$WSSample 1989Y1 2000Y1
$ExcelThousand C
$ExcelCurrency D
$ExcelGetVar A 1990Y1 Sheet1!R3C2:R3C10
&TX

>

<Version 6.33> (23/06/2011)
    Version 6.33 (23/06/2011)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Transfert IODE vers Excel dans les rapports : ~c$ExcelLang,~C ~c$ExcelDecimal~C
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Deux nouvelles fonctions permettent de sp괹ifier dans les rapports la
version linguistique d'Excel et la s굋arateur d괹imal qui doit 늯re utilis� dans les
transfert de IODE vers Excel.

&IT $ExcelLang
컴컴컴컴컴컴컴
Par d괽aut, IODE consid둹e que la version linguistique de Excel est
l'anglais. Cela implique que les ~cRanges~C dans Excel doivent s'괹rire
~cRnCn~C (par exemple R2C4 pour ligne (Row) 2, colonne (Column) 4).

Dans les autres langues, cette 괹riture ne convient plus et IODE doit
envoyer les donn괻s par exemple vers ~cL2C4~C au lieu de ~cR2C4~C dans la
version fran놹ise.

Pour assurer qu'un rapport IODE reste valable quelle que soit la langue
d'Excel, la commande ~c$ExcelLang~C a 굏� ajout괻 � IODE. Elle a pour
syntaxe :

&CO
    $ExcelLang {F|N}
&TX
Tout autre param둻re (E par exemple) remettra IODE en version anglaise.

Exemple
컴컴컴�
Dans l'exemple ci-dessous, IODE enverra le contenu de la variable AAA �
partir de la cellule L1C1 du Sheet1 du fichier Excel ouvert.

&CO
    $ExcelLang F
    $ExcelSetVar AAA Sheet1!R1C1
&TX

&NO Il faut noter que dans la commande ~c$ExcelSetXxx~C, ~ble range reste d괽ini
comme ~cR1C1~C~B. C'est uniquement en interne qu'IODE transformera cette
information en ~cL1C1~C.

&IT $ExcelDecimal
컴컴컴컴컴컴컴
Par d괽aut, IODE envoie les donn괻s num굍iques vers Excel en utilisant
 ~ble s굋arateur d괹imal d괽ini dans les "Regional Settings" de Windows
 (voir Control Panel)~B.

Cette option ne fonctionne que si le s굋arateur d괹imal n'a pas 굏� modifi�
dans Excel : on peut en effet d괹ider d'utiliser le ~bpoint d괹imal~B dans Excel alors
que dans Windows, c'est la ~bvirgule~B qui a 굏� choisie.

Pour permettre de forcer l'envoi vers une version Excel dans laquelle le s굋arateur d괹imal
ne serait pas celui de Windows, une nouvelle fonction de rapport a 굏� introduite. Sa syntaxe est :

&CO
    $ExcelDecimal {C}
&TX
L'absence de param둻re C ou tout autre param둻re que C (comma) s굃ectionne le point d괹imal.

Exemple
컴컴컴�
Dans l'exemple ci-dessous, IODE enverra le contenu de la variable AAA avec des virgules comme s굋arateur d괹imal
� partir de la cellule L1C1 du Sheet1 du fichier Excel ouvert.

&CO
    $ExcelDecimal C
    $ExcelLang F
    $ExcelSetVar AAA Sheet1!R1C1
&TX

>

<Version 6.32> (17/05/2011)
    Version 6.32 (17/05/2011)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Rapports : $WsExtrapolate, $DataScan, $EqsEstimate
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
$WsExtrapolate, $DataScan, $EqsEstimate : lorqu'une variable fournie comme
argument n'existait pas, le rapport continuait son ex괹ution m늤e si
~c$OnError~C 굏ait fix� � ~cAbort~C ou ~cExit.~C

Ainsi, dans l'exemple qui suit, le message Hello s'affiche m늤e si la
variable ~cUnknownVar~C n'existe pas.

&CO
    $OnError Abort
    $WsExtrapolate 1 1990Y1 2000Y1 UnknowVar
    $echo Hello
&TX


&TI Editeur de rapports
컴컴컴컴컴컴컴컴컴컴컴�
Les couleurs de l'괺iteur de rapport ont 굏� modifi괻s pour am굃iorer la lisibilit�.

&TI Graphiques
컴컴컴컴컴컴컴
&EN Added MULTIBAR PERCENT to HTML
&EN Changed MULTIBAR (HTML, RTF) to category chart (ex 1990,1991,2010, 2020)
&EN Corrected bug when " (double quote) is in the graph title (HTML only)
&EN Corrected bug in legends (RTF ldo example)

&TI Users Manual
컴컴컴컴컴컴컴컴
A new chapter "Methods and algorithms" has been added to the users manual.

>

<Version 6.31> (05/04/2011)
    Version 6.31 (05/04/2011)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI IODECOM
컴컴컴컴컴컴
Ajout du programme IodeComServer dans la distribution de IODE.
>

<Version 6.30> (28/03/2011)
    Version 6.30 (28/03/2011)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Corrections
컴컴컴컴컴컴컴
L'affichage de messages trop longs plantait IODE : cette erreur est
corrig괻, la limite d굋endant maintenant de la taille de l'괹ran.

&IT Graphiques en MIF
컴컴컴컴컴컴컴컴컴컴�
Am굃ioration des textes dans les graphiques : adaptation de la taille des caract둹es � la d괽inition a2m

&IT Affichage
컴컴컴컴컴컴�
La taille minimum des caract둹es est port괻 � 6 points au lieu de 4 auparavant, ce qui 굏ait illisible sur
la plupart des 괹rans.
>


<Version 6.29> (17/03/2011)
    Version 6.29 (17/03/2011)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Programme d'installation d'un upgrade
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Le nouveau programme d'installation de IODE permet d'associer des fichiers � IODE.
Pour ce faire, il faut augmenter les droits de l'utilisateur qui installe le programme en
les pla놹nt au niveau d'Administrateur.

Apr둺 l'installation initiale, et donc apr둺 l'association entre
les fichiers iode (.var, .eqs, ...) et le programme lui-m늤e. cette augmentation n'est plus n괹essaire
pour remplacer le programme ou les fichiers constituant le logiciel et sa documentation.
Un installateur "upgrade" a donc 굏� construit pour permettre � l'utilisateur d'effectuer lui-m늤e la mise
� niveau de sa version.


&TI Rapports
컴컴컴컴컴컴
&EN La commande ~c$quit~C est ajout괻 et est synonime de $quitode
&EN La commande ~c$shift~C peut avoir comme param둻re le nombre de ~c"shift"~C � effectuer

&CO
    $shift 2
&TX


>
<Version 6.28> (14/03/2011)
    Version 6.28 (14/03/2011)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Nouvelle version du programme d'installation
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Cette version int둮re les nouveaut굎 suivantes :

&EN restriction d'acc둺 aux comptes administrateurs
&EN r굏ablissement de la liaison automatique entre les fichiers de IODE et le programme IODE, y compris sous
    Vista et Windows 7.
&EN s굃괹tion des composants � installer :
&EN2 Shortcuts dans le menu d굆arrer (onglets IODE)
&EN2 Th둴es et styles pour les graphiques (nouveau)
&EN2 Mod둳e fun d'exemple (nouveau)
&EN2 Version COM de IODE (enregistrement automatique), permettant un acc둺
    optimis� aux fonctions de IODE par exemple en VBA (Excel, ...) ou en APL (nouveau)
&EN2 Configuration de Textpad et de Notepad++ pour l'괺ition des rapports de
    IODE (colorisation syntaxique et auto-completion) (nouveau)
&EN2 Fichiers Excel et APL d'interfa놹ge avec IODE


&TI Resize de la fen늯re de IODE
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
La taille de la fen늯re est m굆oris괻 dans le fichier de profil de IODE. Au prochain d굆arrage, cette
taille est donc reprise par d괽aut.


&TI Largeur de la colonne des noms d'objets
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
La largeur de la premi둹e colonne des tableaux d'objets est m굆oris괻 pour
les sessions suiVantes dans le fichier de profil de IODE.

>
<Version 6.27> (03/03/2011)
    Version 6.27 (03/03/2011)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Resize de la fen늯re de IODE
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

La taille de la fen늯re de IODE peut 늯re adapt괻 par l'utilisateur :

&EN en tirant sur le bord de la fen늯re
&EN en double-cliquant dans le titre de la fen늯re
&EN en indiquant le nombre de lignes et de colonnes dans la ligne de commande

En combinaison avec une diminution de la taille des caract둹es, cela permet de visualiser
un nombre beaucoup plus grand d'informations sur l'괹ran.

&TI Taille de caract둹es
컴컴컴컴컴컴컴컴컴컴컴컴
La combinaison de touches ~cCtrl+Wheel~c + ~cUp~C ou ~cDown~C augmente ou diminue la taille de la police de
caract둹es courante (limit� entre 3 points et 50 points). La taille de la fen늯re
s'adapte en cons굌uence.

La taille initiale peut 늯re d굏ermin괻 au d굆arrage de IODE via le param둻res ~c-fontsize~C  ~cnb_points~C.

&TI Fermeture de la fen늯re
컴컴컴컴컴컴컴컴컴컴컴컴컴�
La croix dans le coin sup굍ieur droit de la fen늯re permet de quitter IODE (comme le ferait ~cAlt+X~C).


&TI D굋lacement dans les tableaux d'괺ition
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
La roulette de la souris ("Mouse wheel") permet de d굋lacer le tableau d'objets et cours d'괺ition vers
le haut ou vers le bas.

&TI New parameters
컴컴컴컴컴컴컴컴컴
New parameters in the iode command line have been created :

&EN ~c-nl~C ~cnumber~C : number specifies the number of lines of the Iode window
&EN ~c-nc number~C : : number becomes the number of columns of the Iode window
&EN ~c-fontsize points~C : specify the number of points of the characters (3-50).
&EN ~c-fontname "fontname"~C : define the font to use in the iode windows
&EN ~c-pbf file~C : indicates that Iode will "play" at startup the keystrokes present in the file
&EN ~c-pbs "string"~C : same as pbf buf with a string defined on the command line


&TI Syntaxe des s굌uences ~cplayback~C
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Une s굌uence ~cPlayback~C consiste en une suite de touches, de commentaires et de messages.

Les r둮les suivantes s'appliquent :

&EN Tous les caract둹es d'espacement (nl, return, ff, tab) sont
    ignor굎 sauf le blanc.

&EN Tous les caract둹es ascii sont envoy굎 dans le buffer de lecture, blanc compris
&EN Les s굌uences suivantes indiquent que le premier caract둹e qui suit (ou la touche @..) sera
modifi� par ~cAlt,~C ~cCtrl~C ou ~cshift~C.
&EN2 ~c&a~C : le prochain caract둹e sera ~calt+char~C
&EN2 ~c&c~C : le prochain caract둹e sera ~cctrl+char~C
&EN2 ~c&s~C : le prochain caract둹e sera ~cshift+char~C

&EN Le d굃ai d'attente entre deux touches peut 늯re modifi� � l'aide des s굌uences suivantes :

&EN2 ~c&d0~C : le d굃ai d'attente entre deux touches est annul�
&EN2 ~c&d-~C : le d굃ai d'attente entre deux chars est diminu� de 50 ms
&EN2 ~c&d+~C : le d굃ai d'attente entre deux chars est augment� de 50 ms

&EN La suite de l'ex괹ution peut 늯re interrompue et un message peut 늯re affich� :
&EN2 ~c&m[Msg]~C : affiche le message Msg et attend qu'on presse une touche
    avant de reprendre. Le message se termine � la fin de la ligne courante.
&EN ~c&n~C : 굌uivalent d'un retour � la ligne dans le message
&EN ~c&autre_char~C : renvoie autre_char

&EN Les s굌uences suivantes renvoient des touches sp괹iales :
&EN2 @F1 � @F9 : renvoie SCR_F1 � F9 (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @FA � @FJ : renvoie SCR_F10 � F19 (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @l : renvoie SCR_CSR_LEFT (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @r : renvoie SCR_CSR_RIGHT (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @u : renvoie SCR_CSR_UP (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @d : renvoie SCR_CSR_DOWN (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @p : renvoie SCR_CSR_PG_UP  (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @n : renvoie SCR_CSR_PG_DN  (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @h : renvoie SCR_CSR_HOME  (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @e : renvoie SCR_CSR_PG_END (ou Shift, Ctrl, Alt en fonction de ce qui pr괹둪e)
&EN2 @I : renvoie SCR_INSERT
&EN2 @D : renvoie SCR_DELETE
&EN2 @R : renvoie SCR_ENTER (ou Shift, Ctrl en fonction de ce qui pr괹둪e)
&EN2 @E : renvoie SCR_ESCAPE
&EN2 @B : renvoie SCR_BACKSPACE (ou Shift, Ctrl en fonction de ce qui pr괹둪e)
&EN2 @T : renvoie SCR_TAB (ou Shift, Ctrl en fonction de ce qui pr괹둪e)
&EN2 @autre_char : renvoie autre_char

&EN Le caract둹e ## marque le d괷ut d'un commentaire qui va jusqu'� la fin de
la ligne

&IT Exemples
컴컴컴컴컴�
La commande qui suit d굆arre iode et effectue les op굍ations suivantes :
&CO
    iode -pbs "@R&adt@R@R"
&TX

&EN ~c@R~C : enter dans l'괹ran d'accueil
&EN ~c&ad~C : Alt+D : va dans le menu Data
&EN ~ct~C : va sur l'option Tables
&EN ~c@R~C : entre dans le sous-menu
&EN ~c@R~C : ouvre l'option "Edit WS"

Le fichier qui suit reprend l'essentiel des possibilit굎.
&CO
    ## Diminue le d굃ai des touches
    &d0
    ## Affiche un message et attend la touche ENTER
    &mLoad workspaces : Menu Workspace, function Load Work Space
    ## Entre dans la page Load WS
    @R@r@R@R
    ## Introduit le nom des fichiers � charger (@T = TAB pour passer au suivant)
    ..\ode\fun@T
    ..\ode\fun@T
    ..\ode\fun@T
    ..\ode\fun@T
    ..\ode\fun@T
    ..\ode\fun@T
    ..\ode\fun
    ## Message
    &mPress ENTER to continue
    ## F10 pour loader
    @FA
    ## Delai de 50ms
    @ -------------
    &d0&d+
    ## Alt+D : se d굋lace dans le menu Data
    &ad
    ## T, Enter, Enter : va sur Tables, et entre dans le scroll d'괺ition
    t@R@R
    ## Maximise (Ctrl + X)
    &cX
    ## Down 4 x Up 5x
    @d@d@d@d
    @u@u@u@u@u
    ## Edit (Enter, F10, Enter)
    @R@FA@R
    ## Down 4 x
    @d@d@d@d
    ## Edit
    @R@FA@R
    ## Idem avec un d굃ai de 150ms
    ## ---------------------------
    &mM늤e s굌uence avec un d굃ai de 150 ms
    &d0&d+&d+&d+
    ## Alt+D : se d굋lace dans le menu Data
    &ad
    ## T, Enter, Enter : va sur Tables, et entre dans le scroll d'괺ition
    t@R@R
    ## Maximise (Ctrl + X)
    &cX
    ## Down 4 x Up 5x
    @d@d@d@d
    @u@u@u@u@u
    ## Edit (Enter, F10, Enter)
    @R@FA@R
    ## Down 4 x
    @d@d@d@d
    ## Edit
    @R@FA@R
    ## Quit IODE (alt-X, Enter)
    &mPress ENTER to quit
    &aX@R
&TX



>
<Version 6.26> (04/08/2010)
    Version 6.26 (04/08/2010)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Division par 0 en LEC
컴컴컴컴컴컴컴컴컴컴컴컴�
La nouvelle fonction LEC ~cdiv0(x,y)~C retourne 0 lorsque y vaut 0.
&CO
    div0(x, y) = 0 si y = 0
&CO
    div0(x, y) = x / y sinon
&TX

&TI Corrections LEC
컴컴컴컴컴컴컴컴컴�
Deux corrections ont 굏� apport괻s dans le traducteur LEC :

&EN la limite de longueur des expressions LEC apr둺 remplacement des macros
    ($NAME) est port괻 de 4000 � 40000 caract둹es.

&EN lorsque le nombre d'arguments d'une fonction � nombre d'arguments variable d굋asse 255
    l'erreur est correctement signal괻. Auparavant, elle 굏ait dans certains
    cas ignor괻 et g굈굍ait des r굎ultats impr굎ibles (exemple fonction ~clsum~C).

&TI Correction Rapports
컴컴컴컴컴컴컴컴컴컴컴�
Dans le cas de certaines erreurs LEC (expressions trop longues), l'ex괹ution
des rapports s'arr늯ait. Un message d'erreur est dor굈avant affich� dans ce cas.



>

<Version 6.25> (17/06/2010)
    Version 6.25 (17/06/2010)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Graphiques en Flash dans les pages HTML
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Les graphiques g굈굍굎 dans le format HTML sont remplac굎 par une version
Flash (Fusion Chart). Cela signifie que lorsqu'on choisit de g굈굍er en
sortie un fichier HTML, ceux-ci contiennent la d괽inition de graphiques
exploitables en flash.

Ces graphiques n괹essitent une librairie dont la source est d괽inie dans le
fichier ~cswf.ini~C. Par d괽aut, ce fichier contient les donn괻s suivantes :

&CO
[SWF]
    JSPATH=http:/www.plan.be/FusionCharts/JSClass/FusionCharts.js
    GRAPHPATH=http:/www.plan.be/FusionCharts/Charts
    ANIMATE=0
    ROUNDED=1
    GRADIENT=1
&TX
o�

&EN ~cJSPATH~C indiquent o� trouver le programme de d괽inition des graphiques

&EN ~cGRAPHPATH~C indiquent o� trouver les librairies flash

&EN ~cANIMATE~C vaut 1 pour que l'affichage soit progressif

&EN ~cROUNDED~C vaut 1 pour avoir des coins des cadres et des barres "arrondis"

&EN ~cGRADIENT~C indique si les couleurs doivent 늯re pleines (0) ou progressives (1)


>

<Version 6.24> (15/04/2010)
    Version 6.24 (15/04/2010)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Ouverture de fichiers sur r굎eau
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Iode se plantait parfois lors de l'ouverture de fichiers sur r굎eau � partir
de l'Explorateur Windows ou lorsque le r굋ertoire par d괽aut 굏ait un
r굋ertoire r굎eau. Cette erreur est corrig괻.

&TI Limitation des noms de fichiers
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
&EN La limite des noms de fichiers � 63 caract둹es reste
d'application pour des raisons de compatibilit� entre les versions
successives des fichiers workspace.

&EN Les noms de fichiers ne doivent si possible pas contenir de s굋arateur
comme l'espace ou la virgule, y compris dans le nom des r굋ertoires. En
effet, l'ouverture � partir de l'Explorateur Windows ne fonctionne pas dans
ce cas.

>

<Version 6.23> (01/04/2009)
    Version 6.23 (01/04/2009)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Gestion m굆oire
컴컴컴컴컴컴컴
R굒ision des allocations dans les rapports :
&EN nouvelle librairie d'allocation de m굆oire
&EN optimisation de l'espace m굆oire allou� (굒ite en partie le morc둳ement
progressif de la m굆oire dans le cas des longs rapports)

&EN nouvelle version des librairies C++
컴컴컴컴컴컴컴컴�
Ces modifications augmentent la performance de certaines fonctions et
permettent de passer � 2GB de RAM utilis괻.



&TI Rapports
컴컴컴컴컴컴
R굚criture de la fonction $Repeat pour :

&EN gain (parfois important) de vitesse
&EN r굎oudre le probl둴e des rapports "crois굎" (le fichier temporaire
    ~cws.rep~C n'est plus utilis�)

&TI Graphiques Stacked
컴컴컴컴컴컴컴컴컴컴컴
Programmation des graphiques barres "stacked" en Frame (MIF) et � l'괹ran.

&TI Police de caract둹es pour les graphiques
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Nouveau param둻re optionnel ~cfontsize~C  permettant de pr괹iser la taille des caract둹es
dans les graphiques.

&CO
    $PrintGraphSize width height [fontsize]

    o� :
	width et height repr굎entent la taille du graphique en mm
	fontsize donne la taille de la police du graphique en points
&TX


>

<Version 6.22> (18/11/2008)
    Version 6.22 (18/11/2008)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Graphiques
컴컴컴컴컴컴컴
Quelques am굃iorations ont 굏� apport괻s dans l'affichage des graphiques :
&EN suppression de "Minor Ticks" sur l'axe des X
&EN modification du placement des "Minor Ticks" sur l'axe des Y et Z

&TI Corrections :
컴컴컴컴컴컴컴컴�
Apr둺 le chargement des "th둴es" graphiques (.thm), le directory d'origine
est restaur�.

>

<Version 6.21> (27/10/2008)
    Version 6.21 (27/10/2008)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI M굏hode d'estimation "Maximum likelihood" (BHHH)
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Une nouvelle m굏hode d'estimation est propos괻 dans l'괹ran de d괽inition
des 굌uations : MaxLik (Berndt, Hall, Hall and Hausman). La m굏hode est
d괹rite dans les "Annals of Economic and Social Measument, 3/4, 1974".

Il s'agit en fait d'une g굈굍alisation des m굏hodes existantes qui modifie
la direction de d굋lacement de la solution � chaque it굍ation et non pas une
seule fois (comme dans les cas des m굏hodes 3SLS ou Zellner) ou aucune fois
(comme dans les autres cas, soit LSQ ou INSTR).


&TI Format ASCII
컴컴컴컴컴컴
Dans le format de d괽inition des 굌uations (fichiers .ae), la m굏hode doit
s'괹rire MAXLIK (� la place par exemple de LSQ).


&TI Fonction de rapport $EqsSetMethod
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Le num굍o d'ordre de la m굏hode MAXLIK est 4.

&CO
    $EqsSetMethod   {0|1|2|3|4} eqname1 eqname2 ...
	o� 0 indique la m굏hode LSQ (moindres carr굎)
	1 indique la m굏hode Zellner
	2 indique la m굏hode INF (2 stages avec instruments)
	3 indique la m굏hode GLS (3 stages avec instruments)
	4 indique la m굏hode MAXLIK
	eqname1 .. sont des noms d'굌uations existantes
&TX


&EN Formats ASCII
컴컴컴컴컴컴컴컴�
Dans les formats des variables et des scalaires, la valeur NaN peut 늯re indiqu괻
soit par na, soit par /, pour permettre la lecture des donn괻s provenant de SAS.

&TI Sample g굈굍alis�
컴컴컴컴컴컴컴컴컴컴�
Dans le cas des fichiers, il est possible d'imprimer une colonne en "base"
d'un autre fichier, c'est-�-dire en divisant le fichier courant par un autre et en

Par exemple le sample suivant sur les fichier 1 et 2 :
&CO

    2000[1;2;1=2]
&TX

pourrait donner comme r굎ultat :

..tb 4
..sep @
..ttitle Exemple Base
@1R@1R2000[1]@1R2000[2]@1R2000[1=2]
..tl
@1LX1@1D0.700@1D0.400@1D174.982
@1LX2@1D0.814@1D1.200@1D67.847
..tl
@4L(=) Base year
@4L[1]
@4L[2] c:/USR/ODE/pw.var
@4L27/10/08
..te


&TI Impression des formes LEC avec coefficients
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Dans le cas de l'impression d'굌uations avec remplacement des coefficients
par leurs valeurs (fonction "Print Objects definition"),
le nombre de d괹imales demand괻s dans l'괹ran ou dans le rapport sp괹ifie le
nombre de d괹imales de chaque coefficients.

La valeur -1 peut toujours 늯re utilis괻 pour que le syst둴e imprime le
maximum de d괹imales disponibles.

Ce m늤e nombre de d괹imales est utilis� pour l'impression des t-tests dans l'굌uation.

Cette modification a un impact sur l'impression des Equations et des Identit굎.


&TI Impression des scalaires
컴컴컴컴컴컴컴컴컴컴컴컴컴컴
L'impression des scalaires a 굏� revue :

&EN le nombre de d괹imales indiqu괻s � l'괹ran est utilis� pour les valeurs
des coefficients, des standard errors et des tests t

&EN les valeurs na sont imprim괻s comme -.-


>

<Version 6.20> (07/04/2008)
    Version 6.20 (07/04/2008)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~


&TI Graphs
컴컴컴컴컴
Bug bij het printen naar RTF opgelost.


&TI Nieuwe LEC functies
컴컴컴컴컴컴컴컴컴컴컴�

&CO
    gamma(x) = gamma functie
&TX

>

<Version 6.19> (07/02/2008)
    Version 6.19 (07/02/2008)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI DataCalcLst
컴컴컴컴컴컴컴�

Een lijst kan worden opgebouwd door het product te maken van twee bestaande
lijsten.

&CO
    $DataCalcLst RES ONE x TWO
&TX

De lijst RES wordt gemaakt bestaande uit alle combinaties (product) van
lijst ONE en TWO.

&IT Voorbeeld
컴컴컴컴컴컴�
&CO
    $DataUpdateLst L1 R1;R2
    $DataUpdateLst L2 C1;C2;C3
    $DataCalcLst L1_L2 L1 x L2

L1_L2 = R1C1;R1C2;R1C3;R2C1;R2C2;R2C3
&TX

&TI Nieuwe LEC functies
컴컴컴컴컴컴컴컴컴컴컴�


&EN urandom(s) = random uniform verdeeld in het interval [0,s[

&EN grandom(m, s) = random variabele met een normal distributie met gemiddelde m
en standaard afwijking s
>

<Version 6.18> (01/12/2008)
    Version 6.18 (01/12/2008)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Grafieken in Word
컴컴컴컴컴컴�

De grafieken zijn aangepast aan wat er bestond in FrameMaker. Als u
afdrukt in RTF (Word), krijgt u dezelfde grafieken als op het scherm.

&TI MultiBarCharts
컴컴컴컴컴컴컴컴컴
Nieuwe BarCharts (Stacked Barchart, Stacked in Percent) zijn nu beschikbaar.

&SY
    $PrintMulti STACKMODE
&TX
met
&CO
    STACKMODE = None(=default), Stacked, Percent
&TX

&TI Graph themes
Bepaal de look van uw grafieken via een themabestand
&SY
    $PrintGraphTheme theme
&TX

Theme bepaalt het gebruikte lettertype voor de titel, legende en assen.
Het bestand bevat ook de kleuren, dikte en type van lijnen, staafjes bij
het maken van grafieken.

Theme is het pad naar het bestand, als het pad niet volledig is kijkt iode
in de directory waar iode wordt opgestart en daarna in de directory waarin
iode ge땙stalleerd is.


&IT Voorbeeld
컴컴컴컴컴컴�
&CO
    $PrintGraphTheme c:\usr\ode\bw.thm
&TX
Voorbeeld van theme-bestand
&CO
    TitleFont name=Palatino, style=bold, size=8
    AxisFont name=Arial, style=regular, size=8
    LegendFont name=Arial, style=regular, size=8
    Line color=orange, width=2, style=solid, pointer=nothing
    Line color=blue, width=2, style=solid, pointer=nothing
    Line color=green, width=2, style=solid, pointer=nothing
    Line color=red, width=2, style=solid, pointer=rectangle
    Line color=violet, width=2, style=solid, pointer=circle
    Bar color=blue, style=bdiagonal
    Bar color=orange, style=solid
    Bar color=paleblue, style=solid
    Bar color=red, style=fdiagonal
&TX
waar :
&EN {Title|Axis|Legend}Font met name, style (bold, italic, regular) en grootte in points

&EN Line color={orange, blue, red, violet, black, gray, paleblue, green}, width in punten, style={solid, dot, dash, dahdot}, pointer={none, rectangle, circle, triangle}

&EN Bar color={orange, blue, red, violet, black, gray, paleblue, green}, style={solid, bdiaognal, fdiagonal}

&TI ColorBand
컴컴컴컴컴컴�

Plaats een gekleurde achtergrond (bv. om forcast periode aan te duiden)

&SY
    $PrintGraphBand 2007Y1 2011Y1

    $PrintGraphBand zonder argumenten heft het commando op
&TX

>

<Version 6.17> (20/07/2007)
    Version 6.17 (20/07/2007)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Nouvelles fonctions d'exportations des graphiques
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Les fonctions graphiques ont 굏� am굃ior괻s dans de nombreux aspects. Ces fonctions
permettent notamment maintenant d'exporter directement des graphiques dans
une dimension ad굌uate vers Word.

&TI Fonction LEC app()
컴컴컴컴컴컴컴컴컴컴�
La fonction
~capp()~C du LEC a 굏� am굃ior괻 pour les cas de s굍ies contenant des
valeurs nulles.

Le r굎ultat de la fonction
~capp(A,~C B) est obtenu comme suit au
temps t :

&EN Si
~cA[t]~C est d괽ini,
~cA[t]~C est retourn�

&EN Si
~cA[t]~C n'est pas d괽ini, on calcule les valeurs
~ct0~C et
~ct1~C autour de
~ct~C
telles que
~cA[t0]~C et
~cA[t1]~C soient d괽inis et non nuls. Si ni
~ct0~C ni
~ct1~C ne
peuvent 늯re trouv굎, retourne
~cNaN.~C Il s'agit dans ce cas d'un s굍ie
~cA~C
valant ~cNaN~C sur toute la p굍iode.

&EN si seul
~ct0~C est d괽ini, retourne
~cB[t] * (A[t0] / B[t0])~C

&EN Si seul
~ct1~C est d괽ini, retourne
~cB[t] * (A[t1] / B[t1])~C

&EN Si
~ct0~C et
~ct1~C sont d괽inis, calcule d'abord
~cDelta = (A[t1]/A[t0]) / (B[t1]/B[t0])~C
puis retourne
~cA[t0] * (B[t]/B[t0]) * Delta ** ((t-t0)/(t1-t0))~C

>


<Version 6.16> (14/06/2007)
    Version 6.16 (14/06/2007)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Fonction LEC if()
컴컴컴컴컴컴컴컴컴컴�
Dans le cas d'une condition dont la valeur est NaN, le r굎ultat de la
fonction if(cond, iftrue, iffalse) est iffalse.

Auparavant, cette fonction retournant iftrue.

Exemple :
&CO
    A 1 2 1 -- 2
    if(A=2, 1, 0)  -->> 0, 1, 0, 0, 1
&TX
>
<Version 6.15> (14/03/2007)
    Version 6.15 (14/03/2007)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Gestion m굆oire (en test)
컴컴컴컴컴컴컴컴컴컴�
La gestion des objets en m굆oire est modifi괻 pour permettre la cr괶tion
d'un plus grand nombre d'objets. On constate en effet que, suivant la taille m굆oire
disponible, le nombre maximum d'objets d'un m늤e type ne pouvait d굋asser
les 300 � 400 000.

Cette version permet de cr괻r plusieurs millions d'objets d'un m늤e type :
des tests ont 굏� men굎 jusqu'� 2.850.000 objets.

Cette modification a un co뻯 : les blocs m굆oire allou굎 aux objets 굏ant
plus grands, les manipulations (modifications, destructions, cr괶tions)
peuvent parfois 늯re un peu ralenties.

&TI Cr괶tion d'objets
컴컴컴컴컴컴컴컴컴컴�
Lors de la cr괶tion de nombreux objets � partir d'un rapport, l'ajout des nouveaux
objets dans la tables des objets peut devenir relativement lent en raison du
r굊rdonnancement constant de la table des noms n괹essit� par cette
op굍ation d'insertion. Ce probl둴e dispara똳 cependant lorsque les noms sont
cr굚s dans l'ordre alphab굏ique : le gain de temps pour quelques centaines de milliers
d'objets peut atteindre un rapport de 10.

Dans l'exemple suivant, le nom des objets cr괻s le sont par ordre
alphab굏ique (la fonction @fmt permet de formater les entiers : on cr괻 donc
dans l'ordre A000000000, A000000001, etc et pas A1, A2, etc.

&CO
$define max 1000000
$define i 0
$WsSample 2000Y1 2050Y1

$label again
$datacreatevar A@fmt(%i%,000000000)
$show var %i%
$define i {%i% + 1}
$goto again {%i% << %max%}

$quit
&TX
>

<Version 6.14> (23/01/2007)
    Version 6.14 (23/01/2007)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~
&TI Messages d'erreur
컴컴컴컴컴컴컴컴컴컴�
Quelques messages d'erreur n'굏aient pas correctement repr굎ent굎 � l'괹ran (MSG##nnn apparaissait � la place du texte).
Cette erreur est corrig괻.

&TI M굆oire disponible
컴컴컴컴컴컴컴컴컴컴컴
La quantit� de m굆oire disponible affich괻 dans le bas de l'괹ran de IODE repr굎ente
dor굈avant la m굆oire RAM libre et plus, comme c'굏ait le cas dans les versions
pr괹괺entes, toute la m굆oire, y compris la m굆oire virtuelle.

Cette nouvelle valeur est plus indicative sur la quantit� utilement
disponible : la m굆oire pagin괻 sur disque est particuli둹ement lente et
l'utiliser n'est pas r괻llement praticable.

>
<Version 6.13> (22/11/2006)
    Version 6.13 (22/11/2006)
    컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~
&TI Longueur des noms de fichiers
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

La longueur des noms de fichiers Iode est limit괻 � 63 caract둹es.
De fa뇇n g굈굍ale, les noms trop longs sont une source de probl둴es dans
IODE. Modifier cette limite
imposerait de transformer tous les WS (qui contiennent en interne le nom sur 63
caract둹es max).

Les modifications suivantes ont 굏� apport괻s dans cette version pour 굒iter les
plantages du programme :
&EN les noms de rapports de plus de 63 caract둹es sont accept굎 dans l'괹ran de
    lancement des rapports et dans les rapports IODE eux-m늤es
    ~c($ReportExec)~C

&EN Si une tentative de sauvetage de fichiers Iode est effectu괻 avec un nom de
    fichier de plus de 63 caract둹es, un message d'erreur est produit et le processus s'arr늯e.

>
<Version 6.12> (22/06/2006)
    Version 6.12 (22/06/2006)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Grafieken
컴컴컴컴컴컴�

Bij het maken van grafieken werd de periode veelal tot 2010 als de
observaties stopten in bijv 2006. Nu worden enkel de aangegeven periodes
weergegeven. Wil je toch nog de oude manier van werken: druk af in a2m-formaat
en wijzig de lijn
&CO
 .ggrid TMM
&TX
in
&CO
 .ggrid MMM
&TX

&TI Nieuwe rapportfuncties
컴컴컴컴컴컴컴컴컴컴컴컴컴

&IT 1. DataRasVar
컴컴컴컴컴컴컴컴�

Vertrekkende van de waarden van variabelen beantwoordend aan pattern,
worden de waarden verdeeld via een RAS methode.

&CO
$DataRasVar pattern X_dimensie Y_dimensie ref_jaar h_jaar [maxit [eps]]
&TX

&EN ~bpattern:~B de variabelen worden gebruikt die voldoen aan de volgende
 criteria x wordt vervangen door alle waarden uit $X, y door die uit $Y

&EN ~bX_dimensie:~B lijst van de waarden die "x" uit het pattern kan aannemen
    OPGELET: laatste uit de lijst is de SOM over de x dimensie

&EN ~bY_dimensie:~B lijst van de waarden die "y" uit het pattern kan aannemen
    OPGELET: laatste uit de lijst is de SOM over de y dimensie

&EN ~bref_jaar:~B referentie jaar: het jaar waarvoor alle gegevens bekend zijn

&EN ~bh_jaar:~B referentie jaar: het jaar waarvoor alleen de sommen bekend zijn

&EN ~bmaxit:~B maximaal iteraties (default=100)

&EN ~beps:~B de drempel (default=0.001)

~uVoorbeeld~U
&CO
    $WsLoadVar ras.av
    $DataUpdateLst X R1;R2;R3;R4;R5;R6;RT
    $DataUpdateLst Y C1;C2;C3;C4;C5;CT
    $DataRasVar xy $X $Y 1980Y1 1981Y1 10 0.00001
&TX
de RAS matrix ziet er dan als volgt uit:
&CO
    R1C1 R1C2 R1C3 R1C4 R1C5 R1C6 | R1CT
    R2C1 R2C2 R2C3 R2C4 R2C5 R2C6 | R2CT
    R3C1 R3C2 R3C3 R3C4 R3C5 R3C6 | R3CT
    R4C1 R4C2 R4C3 R4C4 R4C5 R4C6 | R4CT
    R5C1 R5C2 R5C3 R5C4 R5C5 R5C6 | R5CT
    -------------------------------
    RTC1 RTC2 RTC3 RTC4 RTC5 RTC6 | RTCT
&TX

met de waarden bij het jaar
~cref_jaar~C.
De nieuwe rij en kolom sommen hebben de waarde uit het
~ch_jaar.~C
Als er waarden bekend in
~ch_jaar~C
voor enkele cellen dan worden die gebruikt.

RAS berekent dan de cellen zo dat de nieuwe randvoorwaarden gelden en
overschrijft de onkende waarden (Not Available)

&IT 2. DataPatternXXX
컴컴컴컴컴컴컴컴컴컴�

Deze functie cre뎓rt lijsten met daarin de namen van objecten
die voldoen aan een opgegeven patroon.

~uSyntax~U
&CO
$DataPatternXXX lijst pattern X_dimensie [Y_dimensie]
&TX
&EN ~blijst:~B de naam van de lijst met het resultaat

&EN ~bpattern:~B
: patroon waaraan de naam van de objecten moeten voldoen, als
 men "x" vervangt door de elementen uit de X_dimensie en indien
 opgegeven "y" door de elementen uit de Y_dimensie

&EN ~cX_dimensie~C
: lijst met "x"-mogelijkheden

&EN ~c[Y_dimensie~C
: lijst met "y"-mogelijkheden] : optioneel

&NO
Opgelet: alleen bestaande elementen worden in de lijst opgenome.

~uVoorbeeld~U
&CO
    $WsLoadVar ras.av
    $DataUpdateLst X R1;R2;R3
    $DataUpdateLst Y C1;C2
    $DataPatternVar RC xy $X $Y

$RC=R1C1,R1C2,R2C1,R2C2,R3C1,R3C2
inzoverre R1C1,R1C2,R2C1,R2C2,R3C1,R3C2 variabelen zijn in WS
&TX

&IT 3. $WsClearAll
컴컴컴컴컴컴컴컴컴
Maakt alle WS-en leeg.

&IT 4. @evalue
컴컴컴컴컴컴컴

Geeft de formule van de EQS opgegeven als argument.

>
<Version 6.11> (10/11/2004)
    Version 6.11 (10/11/2004)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Nouvelles fonctions de rapport
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
&EN ~b@sqz(string)~B : supprime les blancs de string
&EN ~b@strip(string)~B : supprime les blancs de fin de string

>

<Version 6.10> (18/10/2004)
    Version 6.10 (18/10/2004)

..esc ~
&TI Nouvelles fonctions LEC
컴컴컴컴컴컴컴컴컴컴컴�

Trois nouvelles fonctions sont introduites dans le langage LEC :

&EN  ~cfloor(expr)~C : partie enti둹e de l'expression
&EN  ~cceil(expr)~C : partie enti둹e de l'expression plus 1
&EN  ~cround(expr [, n])~C : arrondi de expr � la n둴e d괹imale. Si n n'est pas d괽ini, il est fix� � 0.

&TI Nouvelles fonctions de rapport
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

&EN ~c@time([format])~C : renvoie l'heure. Le format contient ~chh~C pour l'heure,
    ~cmm~C pour les minutes et ~css~C pour les secondes. Par d괽aut, le format est : ~c"hh:mm:ss"~C.

&EN ~c@date([format])~C : renvoie la date. Le format contient ~cdd~C pour le
    jour, ~cmm~C pour le mois et ~cyyyy~C pour l'ann괻. Par d괽aut, le
    format est ~c"dd-mm-yyyy"~C

&EN ~c@take(n,string)~C : extrait les ~cn~C premiers caract둹es de ~cstring~C. Si ~cn~C est n괾atif, extrait les n derniers.
&EN ~c@drop(n,string)~C : supprime les ~cn~C premiers caract둹es de ~cstring~C. Si ~cn~C est n괾atif, supprime les n derniers.
&EN ~c@count(string)~C : retourne le nombre d'굃굆ents de string (s굋ar굎 par des virgules)
&EN ~c@index(n,list)~C : retourne l'굃굆ent ~cn~C de ~clist~C

&EX
    @take(3,iode)    : iod
    @take(-3,iode)   : ode
    @drop(1,iode)    : ode
    @take(-3,iode)   : i
    @count(a,b,c,d)  : 4
    @index(2,a,b,c)  : b
&TX

>

<Version 6.09> (06/09/2004)
    Version 6.09 (06/09/2004)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

..esc ~

&TI Correction de la fonction de rapport $DataUpdateVar
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Cette fonction interpr굏ait comme ~cna~C les valeurs ~c+0.0~C ou ~c-0.0~C ou
~c.0~C. Cette erreur est corrig괻.
>
<Version 6.08> (16/08/2004)
    Version 6.08 (16/08/2004)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

..esc ~

&TI Int괾ration de valeurs d'Excel dans les rapports
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
Si un worksheet Excel contient des donn괻s n괹essaires � l'ex괹ution d'un rapport,
il est facile d'int괾rer dynamiquement des valeurs ou des ranges de valeurs dans le texte
d'un rapport.

Il suffit de placer la r괽굍ence aux cellules n괹essaires entre accollades
dans une ligne de rapport :

&CO
    $DataUpdateVar {=Sheet1!R2C1} %YEAR% {=Sheet1!R2C2:R3C10}
&TX

La premi둹e r괽굍ence ~c{=Sheet1!R2C1}~C est lue dans Excel (le fichier doit
굒idemment 늯re pr괶lablement ouvert) et est replac괻 dans la ligne de
commande. Dans l'exemple, il s'agira du nom de la s굍ie � modifier.


La seconde r괽굍ence ~c{=Sheet1!R2C2:R3C10}~C est 괾alement remplac괻 par la
valeur dans Excel. S'il y a plusieurs cellules, celles-ci sont s굋ar괻s par
des blancs.

Dans l'exemple, on aura par exemple :

&CO
    $DataUpdateVar PNB 1990 3.23 2.34 2.56 3.12 3.45
&TX

Apr둺 remplacement, la commande est ex괹ut괻 comme n'importe quelle autre
commande de rapport.


&TI Commande de rapport $ExcelWrite
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Cette fonction permet d'괹rire du texte ou des valeurs quelconques dans une feuille Excel.

Remplace les cellules sp괹ifi괻s par la ou les valeurs donn괻s. Plusieurs
colonnes sont s굋ar괻s par ~c\t~C et plusieurs lignes par ~c\n~C.

&SY2
    $ExcelWrite MySheet!R4C4 texte[\ttexte][\ntexte][...]
&TX

&EX2
    $ExcelOpen c:\usr\iode\test.xls
    $ExcelGetCmt MySheet!R1C1 Titre\n A:\t{A[1970Y1]}\t{A[1980Y1]}\t{A[1990Y1]}
    $ExcelSaveAs c:\usr\iode\test.xls
&TX

>


<Version 6.07> (08/03/2004)
    Version 6.07 (08/03/2004)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

..esc ~

&TI D괽inition des samples
컴컴컴컴컴컴컴컴컴컴컴
    Correction : lorsque une p굍iode est incompl둻ement donn괻 (~c2000Y~C au
    lieu de ~c2000Y1~C), le ~c1~C est fix� par d괽aut (au lieu de ~c0~C auparavant).
    De m늤e, ~c2000Q~C vaut ~c2000Q1~C.

&TI Lecture des tables en ASCII
컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Les valeurs min et max peuvent contenir une valeur n괾ative dans les
    fichiers ASCII de d괽inition des tableaux.

    Par exemple :
&CO
      T1 {
	DIM 2
	ENGLISH
	BOX 0 AXIS 0 XGRID 0 YGRID 0
	ALIGN LEFT
	YMAX ~b-1.000000~B
	ZMAX ~b-2.000000~B
	DIV LEC "1" LEFT ""
	- TITLE "Title" BOLD CENTER
	- LINE
	- "" "##s" CENTER  LAXIS  GRLINE
	- LINE
	- "A" LEFT LEC "A" DECIMAL  LAXIS  GRLINE
	- "B" LEFT LEC "B" DECIMAL  LAXIS  GRLINE
	/* END OF TABLE */
      }
&TX

&TI Impression des tableaux avec fichier manquant
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Lors du calcul de tableaux ou de graphiques pour l'affichage ou
    l'impression, si un des fichiers source ([1], [2], ...) n'est pas
    d괽ini, IODE ne s'arr늯e plus � chaque calcul, mais affiche un message
    dans le bas de l'괹ran et donne des ~c--~C comme r굎ultat pour les colonnes
    correspondantes.

&TI Impressions multiples
컴컴컴컴컴컴컴컴컴컴�
    Une erreur dans la version pr괹괺ente ne permettait plus d'imprimer
    plusieurs fois au cours de la m늤e session de IODE. Cette erreur est corrig괻.

&TI Taux de croissances moyens
컴컴컴컴컴컴컴컴컴컴컴컴컴
    Les samples g굈굍alis굎 contenant ~c//~C (taux de croissance moyens) sont �
    nouveau accept굎.


&TI Graphiques
컴컴컴컴컴
    Corrections dans les graphiques : Minor et Major grids adapt굎
    (uniquement pour l'impression).
>

<Version 6.06> (02/02/2004)
    Version 6.06 (02/02/2004)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

..esc ~

&TI Simulation
컴컴컴컴컴
    Lorsque la m굏hode de r굊rdonnancement (Sort algorithm) est fix괻 �
    "None" et qu'une liste d'굌uations non vide est fournie, l'ordre de la
    liste est conserv� pour la simulation.

    Cela implique en g굈굍al un nombre sup굍ieur d'it굍ations mais 굒ite le
    temps du r굊rdonnancement.

&TI Graphiques
컴컴컴컴컴
    Le fichier iode.ini qui contient les donn괻s d'affichage des graphiques
    est plac� dans le r굋ertoire temporaire de Windows. Ce fichier est donc
    accessible en 괹riture ce qui 굒ite, lorque les droits de l'utilisateur
    sont limit굎, que la fen늯re graphique refuse de se fermer.

&TI Report line
컴컴컴컴컴
    Le fichier ws.rep qui contient la ligne de rapport � ex괹uter (fonction
    "Report/Execute a report line") est plac� dans le r굋ertoire temporaire
    de Windows. Ce fichier est donc accessible en 괹riture ce qui permet,
    m늤e si les droits de l'utilisateur sont limit굎, de cr괻r le fichier.

    Cette fonction est notamment n괹essaire dans le cadre de l'utilisation
    de IODE comme objet COM.
>
<Version 6.05> (10/10/2003)
    Version 6.05 (10/10/2003)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

..esc ~

&TI Commande rapport de gestion de directory et de fichiers
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

    Nouvelles commandes ajout괻s aux rapports :

&EN $chdir dirname : change de directory courant
&EN $mkdir dirname : cr괻 un directory
&EN $rmdir dirname : d굏ruit un directory
&EN $SysAppendFile in out : ajoute le fichier in au fichier out
&EN $A2mToPrinter file.a2m : imprime le fichier file.a2m

&TI Formattage d'entiers
컴컴컴컴컴컴컴컴컴컴컴컴
    Nouvelle fonction ~c@fmt(val,fmt)~C qui retourne un string formatt�.

    Formatte un entier val suivant un format fmt donn�. Le r굎ultat est un
    string transform� de longueur 괾ale � celle de fmt.

    Les caract둹es reconnus dans le format sont : 'X', 'x', '9', '0'. Ils
    signifient qu'aux seules positions de ces caract둹es seront plac굎 dans
    leur ordre d'apparition les caract둹es r굎ultant du formattage de val.
    Seul cas particulier : le caract둹e '0' qui sera remplac� par une '0' si
    le caract둹e correspondant dans le formattage de val est ' '.

&SY
    @fmt(val,fmt)
    o�
    val = valeur enti둹e
    fmt = format
&TX

&EX
    @fmt(123,0009)   --->> 0123
    @fmt(123,A0000A)   --->> A00123A
&TX
    Attention, les blancs avant et apr둺 le format sont repris dans le r굎ultat.

&TI Underflow et Overflow
컴컴컴컴컴컴컴컴컴컴컴컴�
Les calculs non tol굍굎 (exponentielles en particulier) sont prises en
compte plus correctement notamment dans les fonctions d'estimation.

Auparavant, un message du type "Underflow error" 굏ait affich� et Iode se
plantait...
>
<Version 6.04> (18/01/2002)
    Version 6.04 (18/01/2002)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

..esc ~

&TI Longueur des lignes de rapports
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    La longueur max est port괻 � 10000 caract둹es.

&TI Output HTML
컴컴컴컴컴�
    Cadrage des cellules de titres � droite (au lieu de centr�).

&TI Output HELPHTML
컴컴컴컴컴컴컴�
    Idem HTML et correction des titres de la table des mati둹es.

&TI Output MIF
컴컴컴컴컴
    Gestion des sauts de pages dans les rapports (.page).

&TI LEC
컴컴컴�
    Correction de la fonction exp(a, b). Cette fontion prenait toujours
    l'exponentielle n굋굍ienne. Elle permet maintenant de prendre la puissance
    de n'importe quelle formule.

    Notons que
&CO
    exp(a, b)  == a**b
&TX
    D'autre part, les erreurs de calculs r굎ultant de mauvaises valeurs
    des arguments sont mieux prises en charge par IODE :

&CO
    exp(-1, 0.5)
&TX
    retourne NA (--).
>

<Version 6.03> (13/12/2001)
    Version 6.03 (13/12/2001)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Simulation
컴컴컴컴컴
    Correction de la m굏hode Newton dans le cas du goal-seeking et d'une
    굌uation non r굎olue par rapport � l'endog둵e.

&TI Graphiques
컴컴컴컴컴
    Am굃ioration des routines graphiques.
>

<Version 6.02>
    Version 6.02 (16/11/2000)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

..esc ~

&TI LEC
컴�
    Deux nouvelles fonctions dans le langage LEC :
&CO
	hp([[from,]to],expr) : filtre Hodrick-Prescott
	appdif(expr1, expr2) : compl둻e la s굍ie expr1 sur base de la s굍ie
			       apparent괻 expr2 en tenant compte des
			       diff굍ences au lieu des taux de croissance
			       (comme dans app())
&TX
    La fonction app() est modifi괻 :
&CO
	app(expr1, expr2) : dans le cas o� plusieurs observations sont
	    manquantes, le taux de croissance est r굋arti de mani둹e
	    굌uilibr괻 entre les points connus.
&TX
&TI Gestion M굆oire
컴컴컴�
    Augmentation de l'espace m굆oire dans le cas de grands WS
    (variable interne K_CHUNCK=1024).
>

<Version 6.01>
    Version 6.01 (16/10/2000)
    컴컴컴컴컴컴컴컴컴컴컴컴�

..esc ~

&TI Rapports
컴컴컴컴
    Nouvelles @-functions:
&CO
	@cvalue(name, ...) : texte de commentaires
	@vvalue(name, ...) : valeurs de s굍ies
	@sample(B|E|nil)   : sample courant (d괷ut, fin, les deux)
&TX
&TI Readme
컴컴컴
    Affichage du readme sous forme HTML.

&TI Distribution
컴컴컴컴컴컴
    Distribution de IODE � partir du site ~l"http://www.plan.be/fr/soft/iode.htm"www.plan.be~L

&TI Graphiques
컴컴컴컴컴
	Nouvelle librairie graphique (TeeChart) plus 굏endue pour
	l'affichage et l'impression des graphiques.
>
<Version 5.32>
    Version 5.32 (16/08/2000)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Low to High
컴컴컴컴컴
    Lorsqu'une s굍ie contient des donn괻s manquantes au milieu de la p굍iode
    de d괽inition, la transformation se fait pour chaque partie d괽inie.
    Auparavant, seule la premi둹e partie 굏ait trait괻.

&TI Estimation : m굏hode stepwise
&CO
    $EqsStepWise from to eqname leccond {r2|fstat}
&TX

&TI Rapports
컴컴컴컴
    Nouvelles fonctions de rapports pour l'괹hange avec Excel:

&CO
    $ExcelSetScl name cell : fixe une valeur dans Excel � partir d'un scalaire IODE
    $ExcelGetScl name cell : r괹up둹e une valeur de scalaire � partir d'Excel
    $ExcelGetCmt name cell : r괹up둹e une valeur de commentaire � partir d'Excel
&TX

&TI Nouveaux formats et limites de IODE

Cette version supprime la plupart des limites inh굍entes au logiciel IODE.
Elle introduit en plus un algorithme de compression pour diminuer la taille
requise par les WS sur disque.

&IT Compatibilit� avec les versions ant굍ieures
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Les anciens fichiers sont interpr굏굎 automatiquement lors du chargement.
    Les nouveaux ne sont plus lisibles dans les anciennes versions de IODE.

&IT Nombre d'objets
컴컴컴컴컴컴컴�
    Le nombre maximum d'objets g굍ables simultan굆ent en WS passe de 65535 �
    2,147,483,647 (si le hardware le permet).

&IT Nom des objets
컴컴컴컴컴컴컴
    Le nom des objets peut contenir 20 caract둹es maximum au lieu de 10.

&IT Taille des objets
컴컴컴컴컴컴컴컴�
    La taille des objets est limit괻 � 2,147,483,647 bytes au lieu de 32,500.

&IT Nombre de colonnes des tableaux
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Le nombre de colonnes d'un tableau est limit� � 99 (au lieu de 20 auparavant).


&IT Compression des fichiers
컴컴컴컴컴컴컴컴컴컴컴컴
    Les diff굍ents WS peuvent 늯re comprim굎 au moment de leur sauvetage.
    Selon le type d'objet et leur d괽inition, la compression peut aller de
    30 � 75%.

    Chaque objet 굏ant comprim� individuellement, le co뻯 au niveau du temps
    de sauvetage peut 늯re important pour les fichiers contenant de nombreux
    objets ou sur des machines lentes (1000 variables de 25 obs. � la sec.
    sur un Pentium III 450 MHz).

    Iode reconna똳 et transforme automatiquement les fichiers comprim굎.

    Le chargement n'est pratiquement pas p굈alis� par la proc괺ure de
    d괹ompression. Un seul cas fait exception : les fichiers de variables
    dont les s굍ies doivent 늯re charg괻s par une fonction de type
    $WsCopyVar: dans ce cas, la lecture est ralentie par le fait que les
    longueurs des s굍ies comprim괻s deviennent variables et que le fichier
    doit par cons굌uent 늯re lu s굌uentiellement.

    Le panneau de sauvetage pr굎ente un checkbox qui permet d'indiquer si on
    souhaite ou non comprimer les fichiers.

&TI Rapports
    컴컴컴컴
    La fonction $WsSaveCmpXxx permet de sauver les WS en les comprimant.

    Nouvelle fonction ~c@srelax(scl1,scl2,...)~C qui retourne la valeur
    du relax d'un scalaire.

&TI DDE
컴�
    Correction dans les transferts entre IODE et APL. Les valeurs
    inf굍ieures � 1e-10 plantaient parfois IODE.

&TI LEC
컴�
    Correction pour les 굌uations du type log(X) :=
>
<Version 5.31>
    Version 5.31 (11/05/2000)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI IMPORT GEM
컴컴컴컴컴
    La fonction ~cFile/Import~C lit le nouveau format des fichiers GEM (projet
    Nemesis/E3ME).

    La fonction de rapport ~c$FileImportVar~C est 괾alement impl굆ent괻 pour ce
    nouveau format:
&CO
	$FileImportVar GEM rulefile infile outfile from to  [trace]
&TX

&TI Formattage de p굍iodes dans les rapports
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
    L'expression {1980Y1 - 1@@T} dans les rapports ne donne le r굎ultat
    correct - � savoir 1979Y1 - que si le sample courant contient 1979Y1. Si
    le sample 굏ait par exemple 1980Y1 2000Y1, le r굎ultat 굏ait 1981Y1.
    Cette erreur est corrig괻.
>
<Version 5.30>
    Version 5.30 (13/04/2000)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Simulation
컴컴컴컴컴
    Le processus de simulation ne s'arr늯e plus si une valeur NAN est atteinte
    dans le prologue et l'굋ilogue du mod둳e (les parties non interd굋endantes).
>
<Version 5.29>
    Version 5.29 (17/03/2000)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Rapports
컴컴컴컴

    Une ligne de rapport est interpr굏괻 avant d'늯re (굒entuellement)
    ex괹ut괻. Cette interpr굏ation se fait de la fa뇇n suivante:

    L'ordre d'interpr굏ation est le suivant :

    Les caract둹es sp괹iaux sont : ~b%, { et @.~B

    Chaque ligne est interpr굏괻 de gauche � droite. D둺 qu'un des
    caract둹es sp괹iaux est rencontr�, un traitement particulier est
    appliqu�.

Si on rencontre % :
&EN si le suivant est %, un seul % est conserv� comme du texte
&CO
    Exemple : augmentation de 10%% du PNB ->> un seul % reste dans le texte
&TX
&EN sinon, la macro est remplac괻 par sa valeur ou vide si la macro n'existe pas :
&CO
	    Exemple : la variable %VAR% ->> la variable XYZ
&TX

Si on rencontre { :
&EN si le suivant est {, un seul { est conserv� comme du texte, le texte est
    lu jusqu'� }, les macros sont remplac괻s

&EN2 si le texte r굎ultat commence par $ ou ##, il s'agit d'une commande
	  de rapport qui est ex괹ut괻 et le r굎ultat (0 ou 1) se retrouve
	  dans le texte.
&EN2 sinon, le texte r굎ultat est calcul� comme une formule LEC � la
	  p굍iode courante d괽inie par $SetTime. Si la formule se termine
	  pas @T ou @999.999, le r굎ultat est format� en cons굌uence.

Si on rencontre @ :

&EN2 si le suivant est @, un seul @ est conserv� comme du texte,
	le texte est lu jusqu'� la parenth둺e fermante,
	la fonction correspondante est ex괹ut괻. A noter qu'en
	l'absence de parenth둺es, le texte reste inchang� (Ex.: gb@plan.be
	reste tel quel).

&CO
	$define VAL 123.123
	$msg {%VAL%@999.9} gb@plan.be
&TX
	Donne :
&CO
	123.1 gb@plan.be
&TX

&TI Formattage dans les rapports
컴컴컴컴컴컴컴컴컴컴컴컴컴컴
    Le format dans les formules LEC des rapports peut s'exprimer comme .9, auquel
    cas, le nombre de d괹imales est fix� et le nombre de positions avant la virgule
    est d굏ermin� par la valeur du nombre lui-m늤e.

    Exemple :
&CO
	{123.456@.99}    ->> 123.46
	{123.456@9999}   ->> 123
	{123.456@99}     ->> **
	{123.456@999.99} ->> 123.46
&TX
>
<Version 5.28>
    Version 5.28 (03/03/2000)

..esc ~

&TI Format Ascii des tableaux
컴컴컴컴컴컴컴컴컴컴컴컴�
    Le format ascii des tableaux comprend maintenant les informations
    concernant les attributs graphiques.

&IT    Exemple
&CO
	TABLE {
	DIM 2
	ENGLISH
	BOX 0 AXIS 0 XGRID 0 YGRID 0
	ALIGN LEFT
	YMIN na
	YMAX 1000.000000
	ZMIN 2.000000
	DIV LEC "1" LEFT ""
	- TITLE "Titel" BOLD CENTER
	- LINE
	- "" "##s" CENTER  LAXIS GRLINE
	- LINE
	- "lijn A" LEFT LEC "A" DECIMAL  LAXIS GRLINE
	- "lijn B" LEFT LEC "B" DECIMAL  LAXIS GRLINE
	- "Totaal" LEFT LEC "A+B" DECIMAL  RAXIS GRBAR
	/* END OF TABLE */
	}
&TX
    La description se trouve dans le manuel de l'utilisateur.
>

<Version 5.27>
    Version  5.27 (25/2/2000)
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
&TI High to Low
컴컴컴컴컴�
    Correction dans le cas des donn괻s non disponibles.
>
<Version 5.26>
    Version 5.26 (7/2/2000)
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Rapports
컴컴컴컴
    Two new functions to automate the import of variables and comments in
    various external formats.

&CO
    $FileImportCmt format rule infile outfile language [trace]

	format = {Ascii, Rotated_Ascii, DIF, NIS, GEM, PRN, TXT_Belgostat}
	rule = rulefile to use to translate names
	infile = file to import
	outfile = IODE-file with imported series
	language =  {E,F,D}
	trace = debug file (optional)
&TX
&CO
    $FileImportVar format rule infile outfile from to  [trace]

	format = {A, R, D, N, G, P, T}
	rule = rulefile to use to translate names
	infile = file to import
	outfile = IODE-file with imported series
	from = begin of sample
	to   = end of sample
	trace = debug file (optional)
&TX
&IT Examples
    컴컴컴컴
&CO
    $FileImportCmt TXT bstrule.txt bf-06ser.txt bh\p6d.cmt D p6d.log
    $FileImportVar TXT bstrule.txt bf-06obs.txt bh\p6y.var 1980Y1 2000Y1 p6y.log
&TX
>

<Version 5.25> (1/2/2000)
    Version 5.25 (1/2/2000)

..esc ~

&TI Load WS
컴컴컴�
    En cas de probl둴e lors de la lecture d'un fichier (fichier incomplet
    par exemple), IODE s'efforce de lire le maximum d'objets.
    Cependant,si un fichier pose probl둴e, un message d'erreur est g굈굍� et
    il y a lieu de sauver son travail au plus vite. De plus, il est
    conseill� de sauver les donn괻s du fichier � probl둴e dans un format
    Ascii et de le recharger par la suite.

&TI Low to High
컴컴컴컴컴�
    La fonction Low To High s'est enrichie d'une nouvelle m굏hode
    d'interpolation en plus des 2 existantes. Cette m굏hode (Step) conserve
    une valeur constante (celle de l'observation de la s굍ie de base,
    굒entuellement divis괻 par le nombre de sous-p굍iodes) pour toutes les
    observations calcul괻s).

    D'autre part, la syntaxe des fonctions de rapport correspondantes est :
&CO
	$WsLToHFlow  {L|C|S} file var1 var2 ...
	$WsLToHStock {L|C|S} file var1 var2 ...
    avec L pour interpolation lin괶ire
	 C pour interpolation par Cubic Splines
	 S pour interpolation par Steps
&TX

&TI Aide
컴컴
    Le fichier d'aide en format HtmlHelp (plus convivial, plus lisible) est
    int괾r� dans IODE. Cependant, si le syst둴e HtmlHelp n'est pas install�
    sur la machine cible, l'ancien fichier d'aide est utilis�.
>

<Version 5.24> (20/1/2000)
    Version 5.24 (20/1/2000)

..esc ~
&TI Corrections

&EN    Interface ~bDataStream~B : corrections pour les ann괻s � partir de 2000

&EN     Interface ~bODBC~B : adaptation aux champs de grande taille (longueur max : 4K)
>
<Version 5.23>
Version 5.23 (13/12/1999)


&TI LEC
컴�
    La fonction ~capp()~C de calcul de s굍ie apparent괻s est modifi괻 dans
    le cas d'une r굏ropolation ou d'une extrapolation sur base d'une
    s굍ie apparent괻. Le taux de croissance est utilis� pour les valeurs
    en dehors de la p굍iode de d괽inition de la s굍ie � compl굏er.
>
<Version 5.22>
    Version 5.22 (19/09/99)

&TI Importations
컴컴컴컴컴컴
    Le format d'괹hange Belgostat version 2000 est disponible dans le
    panneau d'importation. Les commentaires et s굍ies peuvent 늯re
    import굎.

    Ce format remplace dor굈avant le format DIF-Belgostat. Les fichiers
    de donn괻s ne sont plus disponibles via l'ancienne connexion
    Belgostat, mais sous forme de fichiers complets sur le site Internet
    de la BNB (voir GB pour infos).

&TI Rapports
컴컴컴컴
    Nouvelles fonctions :
&CO
	@sstderr(scalar, ...)
	@equal(str1, str2)
&TX
    Exemple
&CO
	$show Valeur de a1 : @sstderr(a1)
	A est le premier param둻re ? @equal(A,%1%)
&TX
    R굎ultat
&CO
	Valeur de a1 : 2.23
	A est le premier param둻re ? 0
&TX

    Modification support YoY pour Diff et Grt :
&CO
	$DataUpdateVar varname [{L | D | G | DY | GY}] period values
&TX
    Excel : Correction dans ~c$ExcelSetVar~C : la derni둹e observation 굏ait
    manquante.

&TI Lectures tableaux
컴컴컴컴컴컴컴컴�
    Lors de la lecture d'un tableau en ASCII (fichier .at), si une
    forme LEC est erron괻 ou vide, la cellule correspondante contient
    la forme LEC sous forme d'un string. Il est alors possible de
    la corriger dans l'괺iteur de tableau (si cela est souhait�).
>

<Version 5.21>
    Version 5.21 (10/08/99)

..esc ~

&TI Interface ODBC

    De nouvelles fonctions de rapport permettent d'ex괹uter des requ늯es
    SQL. Ces fonctions permettent par exemple de construire automatiquement
    des s굍ies au format IODE � partir de bases de donn괻s Access, Oracle
    ou m늤e de fichiers de texte.

    Les commandes de rapport se pr굎entent sous forme de fonctions:
&CO
	@SqlOpen(ODBC_source[,user,passwd])
	@SqlQuery("SQL Query")
	@SqlNext()
	@SqlField(field_nb)
	@SqlRecord([field_nb[,field_nb[,...]]])
	@SqlClose()
&TX
    Pour pouvoir acc괺er � une base de donn괻s dans IODE, il faut
    pr괶lablement d괽inir une 'source ODBC' (Open DataBase Connectivity),
    ce qui peut 늯re fait tr둺 facilement � l'aide du programme ODBC32
    inclus dans le Control Panel de Windows.

    La syntaxe compl둻e et des exemples peuvent 늯re trouv굎 dans le manuel.

&TI Rapports

    Les titres et pieds de pages introduits par les commandes
    ~c$PrintPageHeader~C et ~c$PrintPageFooter~C sont conserv굎 si le r굎ultat
    de l'impression est sauvegard� dans un fichier a2m.
>

<Version 5.20>
    Version 5.20 (21/06/99)
    컴컴컴컴컴컴컴컴컴컴컴�
..esc ~
&TI Installation
컴컴컴컴컴컴컴컴
    Les fichiers n괹essaires � l'utilisation de la version HTML Help de l'aide
    de IODE sont int괾r굎 dans le programme d'installation de IODE.
    Ces fichiers ne doivent 늯re install굎 que pour les versions Windows
    95 et NT 4.0. Ils font partie de Windows 98.

&TI Programme A2M
컴컴컴컴컴컴컴컴�
    Le programme A2M qui permet, � l'ext굍ieur de IODE, d'imprimer ou de
    transformer des fichiers A2M, est corrig�.

&TI Rapports
컴컴컴컴
&EN L'impression des tableaux faisant appel � plusieurs fichiers de
      variables n괹essite un appel � la fonction ~c$PrintTblFile~C avant
      chaque appel � ~c$PrintTbl.~C Idem pour les graphiques. Ce n'est pas
      nouveau, mais cela peut surprendre!

&EN Nouvelle fonction ~c$RepeatString~C permettant de choisir le string �
      remplacer dans la commande r굋굏괻 par ~c$Repeat.~C
&CO
      $RepeatString ++
      $Repeat "$DataDuplicateVar ++ ++_1" A B C
      copie la s굍ie A sous A_1, B sous B_1, etc.
&TX

&TI Impression de rapports
컴컴컴컴컴컴컴컴컴컴컴
    Les num굍os de lignes sont imprim굎 par la fonction d'impression des
    rapports. Par ailleurs, cette fonction imprime � nouveau l'enti둹et�
    des rapports.

&TI Simulation
컴컴컴컴컴
    L'algorithme de Newton-Raphson a 굏� l괾둹ement am굃ior�.
>

<Version 5.19>
    Version 5.19 (31/05/99)
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
..esc ~
&TI Rapports
컴컴컴컴
    Les lignes des rapports peuvent dor굈avant atteindre une longueur
    maximale de 4095 caract둹es. Cependant, si la ligne contient une
    forme LEC, il est possible que l'espace n괹essaire � la forme
    compil괻 de cette derni둹e d굋asse la limite du LEC.
>
<Version 5.18>
    Version 5.18 (30/04/99)
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Rapports
컴컴컴컴

&IT Transformation de strings

    Nouvelles ~c@fonctions~C n괹essaires pour certains rapports.

&EN @month(mois, langue)
&EN @ansi(mois, langue)

Exemples :
&CO
    @ansi(@month(2,F)) : F굒rier
    @ansi(@month(2,N)) : Februari
    @ansi(@month(2,E)) : February
&TX

&IT G굈굍ation d'un HtmlHelp
&CO
    $PrintHtmlHelp [YES|No] : permet de g굈굍er des fichiers HTML Help.
&TX

&IT Fonction de bouclage
&CO
    $Repeat "command" args :
&TX
Cette fonction permet d'ex괹uter une commande sur une liste d'arguments
sans devoir cr괻r un rapport � cette fin. La position de l'argument dans
la liste est repr굎ent괻 par le caract둹e de soulignement.

Exemples :

&CO
	1. Tri de plusieurs listes

	    $Repeat "$DataListSort _ _" A B C
		굌uivaut �

	    $DataListSort A A
	    $DataListSort B B
	    $DataListSort C C

	2. Duplicate Vars

	    Avec les nouvelles fonctions @fn(), on peut copier toutes les
	    variables d'un WS en une seule op굍ation :

	    $Repeat "$DataDuplicateVar _ _1" @vexpand(*)
&TX
>
<Version 5.17>
    Version 5.17 (12/03/99)

..esc ~

&TI Seasonal adjustment
컴컴컴컴컴컴컴컴컴�
    Nouveau param둻re dans le panneau de d굆arrage qui permet de lib굍er
    le crit둹e v굍ifiant si une influence saisonni둹e est pr굎ente dans
    une s굍ie.

    Le m늤e param둻re peut 늯re pass� comme argument suppl굆entaire � la fonction
    de rapport $WsSeasAdj :
&CO
	$WsSeasAdj Filename Varname Varname ... Eps
&TX

&TI LEC
컴�
    Nouveaux op굍ateurs :

&EN ~clastobs(from,~C ~cto,~C ~cexpr)~C : calcule la derni둹e observation sur
	    une p굍iode donn괻

&EN ~cinterpol(expr)~C : fournit une valeur � expr en t en interpolant ou
	    extrapolant les valeurs connues (actuellement de fa뇇n lin괶ire).

&EN ~capp(expr1,~C ~cexpr2)~C : fournit une valeur � expr1 en t en utilisant
	    la s굍ie expr2 comme s굍ie apparent괻

&EN ~crandom(expr)~C : fournit un nombre al괶toire compris entre -expr/2 et +expr/2.

    Modifications:

	Les op굍ateurs ~clmean~C et ~clstderr~C ne retournent plus de valeur ~cNA~C
	lorsqu'une des observations est ~cNA:~C ils n'utilisent simplement plus
	les valeurs indisponibles dans les calculs.

&TI Rapports
컴컴컴컴
    Nouvelles fonctions dans le groupe @function() :
&CO
	@ttitle(tablename,tablename, ...) : titre des tableaux

	@cexpand(pattern, ...)
	@eexpand(pattern, ...)
	@iexpand(pattern, ...)
	@lexpand(pattern, ...)
	@sexpand(pattern, ...)
	@texpand(pattern, ...)
	@vexpand(pattern, ...)

	@vliste(objname, ...) : liste des variables dans les eqs objname
	@sliste(objname, ...) : liste des scalaires dans les eqs objname
&TX

&TI Impression de tableaux
컴컴컴컴컴컴컴컴컴컴컴
    Lorsqu'une variable n'est pas d괽inie, les tableaux s'affichent ou
    s'impriment avec -- comme valeur pour les cellules concern괻s.
>
<Version 5.16>
    Version 5.16 (24/02/99)

&TI LEC
컴�
    Nouvel op굍ateur :

&EN ~clstderr(expr,~C ~cexpr,~C ~c...)~C : calcule la d굒iation standard
	    des expressions pass괻s comme param둻re

&TI Rapports
컴컴컴컴
    Nouveau groupe de fonctions dont la syntaxe g굈굍ale est :
&CO
	@function_name(arg1, arg2, ...)
&TX
    Ce groupe de fonctions va progressivement 늯re 굏endu selon les demandes
    des utilisateurs. Actuellement, les fonctions d괽inies sont :
&CO
	@upper(texte) : mise d'un texte en majuscules
	@lower(texte) : mise d'un texte en minuscules
	@date([format]) : date
	@time([format[]) : heure
	@replace(string, from, to) : substitution d'un texte par une autre

	@fdelete(filename) : d굏ruit le fichier filename
	@fappend(filename,string|NL, ...) : 괹rit dans un fichier les textes
				pass굎 comme argument
&TX
    Sont en projet (les id괻s sont bienvenues) :
&CO
	@ttitle(tablename,tablename, ...) : titre des tableaux
	@tgetnl(tablename) : nombre de lignes d'un tableau
	@tgetnc(tablename) : nombre de colonnes d'un tableau
	@tgetlinetype(tablename,line) : type de ligne
	@tgetcelltype(tablename,line) : type de cellule
	@tgetcell(tablename,line,col) : contenu de la cellule [line, col]

	@cvalue(name, ...) : texte du commentaire
	@evalue(name, ...) : forme LEC de l'굌uation
	@ivalue(name, ...) : forme LEC de l'identit�
	@lvalue(name, ...) : d괽inition de la liste
	@svalue(name, ...) : valeur du scalaire
	@tvalue(name, ...) :
	@vvalue(name, ...) : vecteur formatt� des donn괻s

	@elistv(objname, ...) : liste des variables dans les eqs objname
	@ilistv(objname, ...) : liste des variables dans les idts objname
	@tlistv(objname, ...) : liste des variables dans les tbls objname
	@elists(objname, ...) : liste des scalaires dans les eqs objname
	@ilists(objname, ...) : liste des scalaires dans les idts objname
	@tlists(objname, ...) : liste des scalaires dans les tbls objname

	@cexpand(pattern, ...)
	@eexpand(pattern, ...)
	@iexpand(pattern, ...)
	@lexpand(pattern, ...)
	@sexpand(pattern, ...)
	@texpand(pattern, ...)
	@vexpand(pattern, ...)
&TX

    Ces fonctions s'ex괹utent dans le cadre d'une ligne de rapport et le
    r굎ultat de la fonction est imprim� dans l'output du rapport.

    Par exemple :
&CO
	Le tableau T1 a pour titre @ttitle(T1). Ce titre en majuscules
	est par cons굌uent @upper(@ttitle(T1)). Ce texte est imprim�
	le @date() � @time().
&TX
    Pour placer le titre du tableau T1 dans le fichier toto.txt :
&CO
	@fappend(toto.txt, @ttitle(T1))
&TX
>
<Version 5.15>
    Version 5.15 (25/01/99)

&TI Rapports
컴컴컴컴
    Nouvelles fonctions :
&CO
	$PrintHtmlStrip {Yes | No}
	$A2mToRtf filein fileout
	$A2mToMif filein fileout
	$A2mToCsv filein fileout
	$A2mToHtml filein fileout
&TX
>
<Version 5.14>
    Version 5.14 (05/01/99)

..esc ~

&TI Copy
컴컴
    La fonction de copy d'objet (WorkSpace/Copy Into Workspace) et
    la fonction de rapport 굌uivalente sont corrig괻s.

&TI Euro
컴컴
    La valeur de conversion euro/FB est fix괻 � ~c40.3399~C dans le LEC.

    Exemple : si on a une s굍ie ~cA~C en FB, a forme ~c(A/euro)~C fournit
    la valeur en euro de cette s굍ie. Rappelons qu'un diviseur de colonne
    peut 늯re introduit dans les tableaux, ce qui permet de transformer
    tr둺 facilement les tableaux.

&TI Y2K
컴�
    Les valeurs des samples g굈굍alis굎 (pour les impressions) et des
    p굍iodes dans le LEC sont adapt괻s pour permettre l'괹riture des
    ann괻s au-del� de l'an 2000 en deux chiffres.

    Ainsi les ann괻s inf굍ieures � 50 sont consid굍괻s comme 20xx et celles
    sup굍ieures � 50 comme 19xx. Par exemple :
&CO
	A[0Y1]     == A[2000Y1]
	20Y1:3     == 2020Y1:3
	B[50Y1]    == B[1950Y1]
	A[105Y1]    == B[2005Y1]
&TX
>
<Version 5.13>
    Version 5.13 (24/12/98)

..esc ~

&TI LEC
컴�
    Nouvel op굍ateur ~ceuro~C dont la valeur sera correctement fix괻 le 1/1/99.

&TI Impression de variables
컴컴컴컴컴컴컴컴컴컴컴�
    Le caract둹e espace ne peut plus 늯re utilis� comme s굋arateur de liste
    dans l'괹ran PRINT/VIEW Variables, afin de permettre d'y placer
    des formules LEC comme d A.

&TI Rapports
컴컴컴컴
    ~c$DataDelete~C accepte les wildcards comme argument. Enfin une fa뇇n
    rapide de perdre tout votre travail sans devoir couper le PC.
>

<Version 5.12>
    Version 5.12 (17/12/98)

..esc ~

&TI 'Unit Root' tests
컴컴컴컴컴컴컴컴�
    Les tests de Dickey-Fuller sont disponibles au niveau des rapports
    et du panneau d'estimation d'굌uations.

    Les tests sont sauvegard굎 dans des scalaires dont le nom est
    compos� du pr괽ixe df_ et du nom de la premi둹e s굍ie apparaissant
    dans la formule � tester. Par exemple, le test pour la formule
    ~cd(A0GR+A0GF)~C est ~cdf_a0gr.~C

&IT    Dans les rapports
    컴컴컴컴컴컴컴컴�
&CO
	$StatUnitRoot drift trend order expression
&TX
    o�
&CO
	drift : 0 ou 1 selon que la formule � estimer doive incorporer
		un terme constant (1) ou non (0)
	trend : 0 ou 1 selon que la formule � estimer doive incorporer
		un terme de trend (1) ou non (0)
	order : l'ordre du polynome � estimer pour obtenir les tests
	expression : forme LEC � tester
&TX
    Par exemple :
&CO
	$StatUnitRoot 1 1 3 A
&TX
    L'굌uation estim괻 est :
&CO
	d(A) := df_ * A[-1]+
		    df_d +    /* DRIFT */
		    df_t * t +  /* TREND */
		    df1 * d(A[-1]) + df2*d(A[-2]) + df3*d(A[-3]) /* ORDER */
&TX
    Seuls le test de Dickey-Fuller est sauvegard� dans un scalaire sous
    le nom ~cdf_a~C dans le cas de l'exemple.

&IT Dans le panneau d'estimation

    La touche F3 ou le bouton "Unit Root" permettent de sp괹ifier et de
    tester une ou plusieurs formules. Les r굎ultats sont affich굎 dans
    la fen늯re.

    Le seul scalaire sauvegard� est celui correspondant � la derni둹e
    expression test괻.

&TI Agr괾ation de s굍ies
컴컴컴컴컴컴컴컴컴컴�
    De nouvelles fonctions de rapports permettent d'effectuer
    des agr괾ations, des produits ou des sommes de s굍ies.
    Les s굍ies � traiter peuvent se trouver en WS ou dans un
    fichier externe.

    Quatre nouvelles fonctions de rapport ont 굏� d괽inies � cet effet:
&CO
    $WsAggrChar [char] : d괽init le caract둹e � introduire dans le
			 code des s굍ies cr굚es
    $WsAggrSum  pattern [filename] : somme des s굍ies d괽inies par pattern
    $WsAggrMean pattern [filename] : moyenne des s굍ies
    $WsAggrProd pattern [filename] : produit des s굍ies
&TX
    Si filename est d괽ini, les s굍ies du fichier seront utilis괻s �
    la place de celles du WS.

    ~cpattern~C est d괽ini comme une s굌uence de parties de noms plac괻s
    entre crochets ou parenth둺es. Chaque partie peut contenir des
    caract둹es alphanum굍iques ou un point d'interrogation.

    Les parties de noms entre parenth둺es ne sont pas agr괾괻s. Celles
    entre crochets le sont.

&IT    Exemple
    컴컴컴�
	Soit un WS avec des s굍ies par pays (BE, FR, GE), et par secteur
	(S101..S999):
&CO
	    BES101, BES102 ... BES199
	    BES201, BES202 ... BES299
	    ...
	    BES901, BES902 ... BES999

	    FRS101, FRS102 ... FRS199
	    FRS201, FRS202 ... FRS299
	    ...
	    FRS901, FRS902 ... FRS999

	    ...

	    GBS101, GBS102 ... GBS199
	    GBS201, GBS202 ... GBS299
	    ...
	    GBS901, GBS902 ... GBS999
&TX

    On peut cr괻r la somme de tous les secteurs pour chaque pays par
    les commandes :
&CO
	$WsAggrChar _
	$WsAggrSum (??)[????]
&TX
    Les s굍ies cr굚es seront :
&CO
	    BE____, FR____, ..., GB____
&TX
    Les points d'interrogations entre () permettent de pr괹iser les
    codes de s굍ies � traiter. Les autres indiquent les parties �
    agr괾er. Dans ce cas les points d'interrogation sont
    remplac굎 par des _ (ou un autre caract둹e selon l'argument
    de ~c$WsAggrChar~C) dans les s굍ies r굎ultats. Ce caract둹e
    peut 늯re blanc. Dans l'exemple, les s굍ies cr굚es sont alors BE, FR
    et GB.

    On peut 괾alement cr괻r la somme de tous les pays par secteur ou
    la somme de tous les pays pour certains secteurs :
&CO
	$WsAggrSum [??](????) : cr괻 __S101, __S102, ...
	$WsAggrSum [??](??)[??] : cr괻 __S1__, __S1__, ...
&TX
    On peut limiter la cr괶tion � un seul ou � quelques codes :
&CO
	$WsAggrSum (BE)[S??9] : cr괻 BES__9
	$WsAggrSum (BES)[?](?9) : cr괻 BES_09, BES_19, BES_29, ... BES_99
&TX
&IT    Caract둹e de regroupement
    컴컴컴컴컴컴컴컴컴컴컴컴�
    La commande ~c$WsAggrChar~C permet de sp괹ifier le caract둹e �
    placer dans les s굍ies g굈굍괻s. Ce caract둹e peut 늯re blanc.
    Pour 굒iter que des s굍ies d굁� agr괾괻s soient reprises dans une
    agr괾ation ult굍ieure, ces s굍ies ne sont pas retenues dans le
    calcul si le caract둹e d'agr괾at courant se trouve � une position
    correspondant dans pattern � un point d'interrogation entre
    crochets. Ainsi, la s굍ie ~cBE____~C ne sera pas reprise dans le
    calcul ~c(BE)[????]~C. Par contre elle sera reprise dans le calcul
    ~c[??](????)~C, car dans ce dernier cas elle n'intervient pas dans
    la somme.

    Supposons que les s굍ies ~cBE____~C, ~cFR____~C et ~cGB____~C soient
    d괽inies ainsi que ~cBES101~C, ...

    ~c$WsAggrSum~C ~c(??)[????]~C g굈둹e ~cBE____~C, ~cFR____~C, etc.
    Elle n'utilise donc pas les s굍ies contenant ~c_~C apr둺 la deuxi둴e
    position, comme ~cBE____~C. En effet, si on les reprenaient, on
    additionnerait deux fois les m늤es s굍ies.

    ~c$WsAggrSum~C ~c[??](????)~C g굈둹e ~c______~C en prenant la somme
    de ~cBE____,~C ~cFR____,~C ~cGB____,~C ce qui est correct car les
    autres s굍ies (comme ~cBES101~C) donnent lieu � d'autres s굍ies
    (~c__S101~C).
>
<Version 5.11>
    Version 5.11 (03/11/98)

&TI Support des longs noms de fichiers
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
    IODE supporte les noms de plus de 15 caract둹es dans la limite
    des champs des 괹rans de saisie. La s굃ection de fichiers
    dans des r굋ertoires comme ~c\My~C ~cDocuments~C est 괾alement possible
    pour des fichiers � longs noms.

&TI Correction Simulation
컴컴컴컴컴컴컴컴컴컴�
    Une petite correction a 굏� apport괻 au programme de simulation
    dans le cas de valeurs d'endog둵es tr둺 petites (en g굈굍al
    dans le cas de r괹up굍ation de donn괻s de la version simple
    pr괹ision).
>

<Version 5.10> (14/10/98)
    Version 5.10 (14/10/98)
    컴컴컴컴컴컴컴컴컴컴컴�
..esc ~

&TI Rapports
컴컴컴컴

    ~cWsCopyVar~C : correction dans le cas o� la copie ne concerne
    qu'une seule ann괻.

&CO
     $WsCopyVar 1970Y1 1970Y1 A* B*
&TX

&TI Estimation
컴컴컴컴컴
    Les graphiques ne pouvaient 늯re affich굎 ou imprim굎 dans le cas
    o� le s굋arateur entre le membre de gauche et le membre de droite
    de l'굌uation (:=) se trouvait � la ligne. Ce bug est corrig�.

&TI Langage LEC
컴컴컴컴컴�
    Nouvel op굍ateur LEC qui retourne le signe d'une expression:
&CO
    sign(expr) vaut
		    1 si expr >>= 0
		    -1 si expr << 0
&TX

&TI Marquer/Copier/Coller
컴컴컴컴컴컴컴컴컴컴�
    Les op굍ations de "copier/coller" peuvent 늯re effectu괻s entre
    IODE et d'autres programmes Windows (Excel, ...) ou entre diff굍ents
    괹rans de IODE. Le "Clipboard" de Windows est utilis� pour stocker
    les donn괻s copi괻s.

    Les touches de fonction classiques de Windows ont 굏� impl굆ent괻s
    pour faciliter cet usage : Shift+curseur permet de s굃ectionner
    ou d'굏endre la s굃ection et la souris permet de marquer
    des parties de texte. Pour placer du texte dans le Clipboard
    et copier ce qui s'y trouve � la position du curseur, on
    utilisera respectivement les touches Ctrl+C et Ctrl+V.

    Cette nouvelle facilit� est tr둺 pratique dans de nombreux
    cas :

&EN  recopier un nom de fichier � charger dans le panneau Load WS
&EN  copier des parties d'굌uations dans d'autres 굌uations
&EN  copier des valeurs de s굍ies vers Excel, ou de Excel vers IODE
&EN  copier des s굍ies dans un fichier Ascii ou les r괹up굍er
	  d'un fichier Ascii
&EN  recopier les valeurs d'une ann괻 pour plusieurs s굍ies dans
	  une autre ann괻
&EN  copier entre deux instances de IODE qui tournent en m늤e temps
&EN  etc

&IT     1. En 괺ition d'un 괹ran
    컴컴컴컴컴컴컴컴컴컴컴컴
      Cette partie s'applique par exemple � l'괹ran Load WorkSpace.

      MARQUER
      컴컴컴�
&EN  entrer dans un champ : marque tout le champ
&EN  Ctrl+L : marque tout le champ courant
&EN  Shift+Left : prolonge la marque d'un caract둹e vers la gauche
&EN  Shift+Right : prolonge la marque d'un caract둹e vers la droite
&EN  Shift+Home : prolonge la marque jusqu'au d괷ut du champ
&EN  Shift+End : prolonge la marque jusqu'� la fin du champ
&EN  cliquer avec la souris et garder le bouton de gauche enfonc� :
	  d괽init ou prolonge la partie marqu괻

      DEMARQUER
      컴컴컴컴�
&EN  tout d굋lacement du curseur supprime les marques (LEFT, RIGHT,
	    HOME, END)
&EN  tout caract둹e entr� supprime (et d굏ruit) les marques
&EN  DEL supprime les marques

      DETRUIRE
      컴컴컴컴
&EN  n'importe quel caract둹e remplace la partie marqu괻
&EN  DEL : d굏ruit la partie marqu괻

      COPIER
      컴컴컴
&EN  Ctrl+C : copie ce qui est marqu� dans le clipboard

      COLLER
      컴컴컴
&EN  Ctrl+V : copie � partir de la position courante
		   les donn괻s du clipboard (qui peuvent provenir
		   d'un autre programme) et remplace la marque
		   courante

&IT    2. En 괺ition des variables
    컴컴컴컴컴컴컴컴컴컴컴컴컴�

      MARQUER
      컴컴컴�
&EN  Ctrl+L : marque la cellule courante ou 굏end la marque
&EN  Shift+Left, Shift+Right, Shift+Home, Shift+End, Shift+PgDn,
	  Shift+PgUp : marque ou 굏end la marque

      DEMARQUER
      컴컴컴컴�
&EN  Ctrl+U : supprime les marques

      COPIER
      컴컴컴
&EN  Ctrl+C : copie ce qui est marqu� dans le clipboard

      COLLER
      컴컴컴
&EN  Ctrl+V : copie � partir de la position courante
		   les donn괻s du clipboard

      Ces fonctions permettent par exemple de copier des colonnes ou
      des lignes de donn괻s entre Excel et IODE, ou encore de
      copier une ann괻 vers une autre pour un ensemble de variables.

&IT    3. En 괺ition des champs EDITOR (rapports, 굌uations, listes, etc)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
      Cette partie s'applique par exemple � l'괺iteur de rapports,
      � la saisie d'une 굌uation, � la d괽ition d'un sample d'impression.

      MARQUER
      컴컴컴�
&EN  Ctrl+L : marque la ligne courante ou prolonge jusqu'�
		   la ligne courante (inchang�)
&EN  Ctrl+T : marque le caract둹e courant ou prolonge la marque
		   (inchang�)
&EN  Alt+B  : marque la colonne courante ou prolonge la marque
		   (inchang�)
&EN  Shift+Left : prolonge la marque d'un caract둹e vers la gauche
&EN  Shift+Right : prolonge la marque d'un caract둹e vers la droite
&EN  Shift+PgUp : prolonge la marque d'une page vers le haut
&EN  Shift+PgDn : prolonge la marque d'une page vers le bas
&EN  Shift+Home : prolonge la marque jusqu'au d괷ut du champ
&EN  Shift+End : prolonge la marque jusqu'� la fin du champ
&EN  cliquer avec la souris et garder le bouton de gauche enfonc� :
	  d괽init ou prolonge la partie marqu괻 (rectangle)

      DEMARQUER
      컴컴컴컴�
&EN  Ctrl+U : supprime les marques (ne d굏ruit pas)

      DETRUIRE
      컴컴컴컴
&EN  Ctrl+D : d굏ruit ce qui est marqu� et supprime les marques

      COPIER
      컴컴컴
&EN  Ctrl+C : copie ce qui est marqu� dans le clipboard de Windows

      COLLER
      컴컴컴
&EN  Ctrl+V : copie � partir de la position courante
		   les donn괻s du clipboard (qui peuvent provenir
		   d'un autre programme) et remplace la marque
		   courante
>
<Version 5.09> (05/10/98)
    Version 5.09 (05/10/98)
    컴컴컴컴컴컴컴컴컴컴컴�
&TI Rapports
컴컴컴컴
    La commande ~c$system~C fonctionne � nouveau dans la version
    Win95 de IODE. Cela permet notamment d'ex괹uter des fichiers
    de commandes ~c(.bat),~C y compris des programmes 16 bits.

    La commande est bloquante, c'est-�-dire que le programme attend
    la fin de l'ex괹ution de la commande ~c$system~C avant de continuer
    le rapport.

&TI Utilitaire wait.exe
컴컴컴컴컴컴컴컴컴�

    Pour permettre de synchroniser des programmes Windows successifs,
    l'utilitaire wait.exe est ajout� aux fichiers distribu굎.

&IT    Exemple d'utilisation
    컴컴컴컴컴컴컴컴컴컴�
&CO
	Rapport test.rep
	----------------
	    $system arima.bat QC hermes.var
	    $printobjvar QC

	Fichier arima.bat
	-----------------
	    wait var2db -v %1 -f %2
	    cd d:\usr\tse
	    l_ax23 d:\usr\igor\src commands.txt %1
	    ax23 d:\usr\igor\src commands.txt
	    cd d:\usr\igor\src
	    wait db2var -v %1 -f %2
&TX
    Sans utiliser ~cwait~C dans le fichier ~carima.bat,~C le programme
    ~cl_ax23~C s'ex괹ute sans attendre la fin de ~cvar2db.~C
>
<Version 5.08> (25/09/98)
    Version 5.08 (25/09/98)
    컴컴컴컴컴컴컴컴컴컴컴�
&TI LEC
컴�
    Nouveaux op굍ateurs en LEC :

&CO
	isan(expr) : retourne 0 si expr est NAN et 1 sinon
	lmean(expr, expr, ...) : retourne la moyenne d'un
				ensemble d'expressions
	lprod(expr, expr, ...) : retourne le produit des expressions
	lcount(expr, ...)      : retourne le nombre d'expressions
&TX
>
<Version 5.07> (26/08/98)
    Version 5.07 (26/08/98)
    컴컴컴컴컴컴컴컴컴컴컴�
&TI Format CSV invers�
컴컴컴컴컴컴컴컴컴
    Il est possible d'exporter des s굍ies en format CSV invers�,
    c'est-�-dire avec les s굍ies en lignes et non en colonnes.
    Dans ce format, les commentaires ne sont pas export굎 pour
    des raisons de largeur de colonnes insuffisantes.

&TI Rapports
컴컴컴컴
    Macro ~c%-nom%~C supprime dans la macro tous les caract둹es non
    aplhanum굍iques ou de soulignement.
&CO
	$define ARG0 Abc[-3]
	$msg %ARG0%
	$msg %-ARG0%
	$msg %!ARG0%
	$msg %#ARG0%
&TX
    Donne comme message :
&CO
	Abc[-3]
	Abc3
	abc[-3]
	ABC[-3]
&TX
>
<Version 5.06>
    Version 5.06 (11/08/98)
    컴컴컴컴컴컴컴컴컴컴컴�

&TI Utilisation de wildcards
컴컴컴컴컴컴컴컴컴컴컴컴
    Afin de simplifier l'괹riture, il est possible d'utiliser des
    "wildcards". Ces wildcards sont l'굏oile (*) ou le point
    d'interrogation (?).

&EN * : indique une suite quelconque de caract둹es, m늤e vide
&EN ? : indique un caract둹e unique

    On utilisera des noms contenant des 굏oiles ou des points
    d'interrogation dans certains 괹rans, dans les formes LEC et dans
    certaines fonctions de rapport. Ces noms sont remplac굎 par
    des listes contenant les noms correspondants pr굎ents en WS.

    Supposons que les variables A1F, A0F, B1F, B0G, AF, BG et A soient
    en WS. On a alors :

&CO
	A*      == A1F;A0F;A
	*1*     == A1F;B1F
	*F      == A1F;A0F;B1F;AF
	?F      == AF
	A?      == AF
	?       == A
	A?*     == A1F;A0F;AF (mais pas A)
&TX

    Dans cette version de IODE, ce type d'expression peut 늯re utilis�
    dans

&EN l'괹ran ou la fonction $WsCopyXxx
&EN l'괹ran ou la fonction de cr괶tion de tableau $DataUpdateTbl
&EN l'괹ran ou la fonction d'impression de variables $PrintVar
&EN les formes LEC (entre quotes)

    Dans le cas de la forme LEC, l'expression � 굏endre doit 늯re
    fournie entre quotes (') pour la distinguer de l'op굍ateur *.

    Dans le cas des 괹rans ou des rapports, les parties � ne pas
    굏endre doivent 늯re exprim괻s entre double quotes (").

    Ainsi,
&CO
	A*;"B*A"        sera traduit en A1;A2;...;B*A

	A*;"lsum('A*')" sera traduit en A1;..;lsum('A*')
&TX
    Dans les rapports, les fonction suivantes sont concern괻s par
    cette modification :
&CO
	$WsCopyXxx filename args
	$DataUpdateTbl
	$DataEditXxx
	$PrintVar
&TX

&TI Extensions LEC
컴컴컴컴컴컴컴
    Lorsque l'op굍ateur le permet (lsum, max et min), on peut
    utiliser les wildcards dans le langage LEC. Cependant, pour
    distinguer l'굏oile et l'op굍ateur fois, la liste � 굏endre
    doit 늯re entour괻 de quotes simples('). Ainsi,

      ~clsum('A*')~C
    est 굌uivalent �
      ~clsum(A1,A2,AX)~C si A1, A2 et AX sont
     les seules s굍ies commen놹nt pas A dans le WS courant.

    On peut 괾alement utiliser une combinaison de noms de s굍ies :

	~cmax('*G;*F')~C


    Le nombre maximum d'op굍andes des op굍ateurs ~clsum(),~C ~cmax()~C
    et ~cmin()~C est port� � 255, de fa뇇n � pouvoir exploiter au mieux
    les wildcards.

&IT    Remarque importante
    컴컴컴컴컴컴컴컴컴�
    Les noms contenant des wildcards dans les formes LEC sont r굎olus en
    fonction du contenu du WS COURANT. La forme LEC compil괻 est
    m굆oris괻 avec ces noms. Si on change le contenu du WS, il est
    possible que certaines s굍ies n'existent plus ou que de nouvelles
    apparaissent. La forme compil괻 n'굏ant pas chang괻 automatiquement,
    il faut si on souhaite adapter la forme LEC au nouveau contenu,
    recompiler la forme en l'괺itant.

&TI Load WS
컴컴컴�
    Correction d'une erreur (rare mais possible) dans le chargement
    de fichiers de scalaires.


&TI Rapports
컴컴컴컴
    Correction dans les messages d'erreurs (plus de pr괹ision dans
    le texte).

    Les caract둹es % et { peuvent 늯re introduits comme texte
    normal en 굏ant doubl굎. Le texte %%1%% ne sera donc pas interpr굏�
    comme une macro, mais comme le texte %1%.

    Commentaires : une ligne de commentaire vide ne g굈둹e plus de
    message d'erreur. Elle peut commencer par $ ou par #.

    Nouvelles fonctions:

&CO
	 $Debug {Yes|No} : affiche le num굍o de la ligne et le fichier
			   en cours d'ex괹ution dans les rapports.

	 $SysMoveFile filein fileout : renomme un fichier

	 $SysCopyFile filein fileout : copie un fichier

	 $SysDeleteFile file1 file2 ... : d굏ruit des fichiers
&TX

&TI Edition des variables
컴컴컴컴컴컴컴컴컴컴�
    Deux nouvelles options ont 굏� ajout괻s � la touche ~cF5~C lors de
    l'괺ition des tableaux de variables. Ces options permettent
    d'afficher les valeurs en diff굍ences et en taux de croissance
    sur une ann괻 (Year On Year). On a donc maintenant dans l'ordre:

&EN level
&EN difference
&EN growth rate
&EN YoY difference
&EN YoY growth rate

    Pour faciliter la navigation, on peut utiliser ~cshift+F5~C pour
    revenir au mode pr괹괺ent.

    Les graphiques s'affichent en fonction du mode utilis�. Ainsi, si
    l'affichage s'effectue en taux de croissance, la touche ~cF8~C fait
    appara똳re le graphique dans le m늤e mode.

&TI HTML
컴컴
    Le format HTML de sortie des impressions est enrichi et permet
    de placer automatiquement des graphiques dans les documents. Les
    fichiers graphiques portent le nom IMGn.GIF et se trouvent dans le
    r굋ertoire de travail. Les graphiques sont automatiquement
    r괽굍enc굎 dans le fichier HTML r굎ultat.

    Pour permettre de param굏rer la g굈굍ation des fichiers GIF,
    un nouveau panneau est int괾r� dans les "Printer Options". Les options
    qui y sont d괽inies peuvent 괾alement 늯re d괽inies par des
    fonctions de rapport.

    Les fonctions de rapports sont :
&CO
	$PrintGIFBackColor color    : d괽init la couleur de fond des
				      graphiques
	$PrintGIFTransColor color   : d괽init la couleur consid굍괻 comme
				      "transparente"
	$PrintGIFTransparent Yes|No : indique si le fichier GIF doit 늯re au
				      format transparent
	$PrintGIFInterlaced Yes|No  : indique si le fichier GIF doit 늯re au
				      format interlac�
	$PrintGIFFilled Yes|No      : indique s'il faut remplir les barres dans
				      les bar charts
	$PrintGIFFont num굍o        : indique si le num굍o du font � utiliser
				      pour les labels (voir 괹ran pour
				      les valeurs possibles).
&TX
>
<Version 5.05>
    Version 5.05 (31/07/1998)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Rapports
컴컴컴컴
    La macro ~c%*%~C repr굎ente tous les arguments du rapport.
    Il est � noter que la commande ~c$shift~C supprime le premier argument
    de ~c%*%~C.


    Par exemple:

&CO
    Fichier main.rep
    ----------------
    ...
    $ReportExec sub1.rep %*%
    ...
    $Shift
    ...
    $ReportExec sub2.rep %*%
    ...

    Ex괹ution du rapport
    --------------------
    $ReportExec Main.rep A B C D E

&TX
    Le rapport ~csub1.rep~C re뇇it comme arguments tous
    les arguments pass굎 � ~cmain.rep,~C soit ~cA B C D E~C.
    Le rapport ~csub2.rep~C re뇇it les arguments ~cB C D E~C.


&TI Nouveaux op굍ateurs LEC
컴컴컴컴컴컴컴컴컴컴컴�
    Les op굍ateurs suivants ont 굏� ajout굎 au langage LEC :

&CO
	- lsum(expr1, expr2, ...) : calcule la somme d'une liste
	  de s굍ies

	- index([[from,] to,] valeur, expr) : retourne la premi둹e p굍iode
	  o� valeur appara똳 dans la s굍ie expr entre les p굍iodes
	  from et to. Si la valeur n'appara똳 pas dans expr, -- est
	  retourn�.

	- acf([[from,] to,] valeur, expr) : retourne la fonction
	  d'auto-correlation de degr� valeur de l'expression expr
	  sur le sample from � to.

&TX

    Exemples
&CO
	Soient A et B d괽inies sur 1970Y1-1990Y1
	A = 0 1 2 3 ...
	B = 2 4 6 8 ...

	lsum(A,B) vaut 2 5 8 11 ...

	index(6, B) vaut -- -- 2 2 2 2 ... (ce qui 굌uivaut en LEC
					    � -- -- 1972Y1 1972Y1 ...)
	index(1971Y1, 1990Y1, 6, B) vaut 2 2 2 2 ...
&TX

&TI Impressions
컴컴컴컴컴�
    Les impressions ne fonctionnaient plus correctement dans la version
    pr괹괺ente pour certains drivers (qms, hp). Cette erreur est
    corrig괻.

    Les tableaux g굈굍굎 en Frame (mif) contiennent le titre
    dans le corps du tableau et plus dans un paragraphe s굋ar�.

&TI Aanpassing van Census II methode
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
    Om geen informatie te verliezen bij het berekenen van de laatste
    observaties, werd het algoritme aangepast. Bij onvolledige periodes
    worden, krijgen gegevens op het einde van de periode voorang.


&TI Schatten van vgln
컴컴컴컴컴컴컴컴�
    Bij het on-line schatten van vgln worden nu ook de testen als scalars
    weggeschreven.


&TI IODE-XLS interface
컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Lijsten kunnen worden gebruikt bij het opvragen van gegevens

>
<Version 5.04>
    Version 5.04 (01/04/1998)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI ACCESS RESEAU ET NOMS DE FICHIERS
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Des fichiers d'un autre ordinateur du r굎eau peuvent 늯re acc괺굎
    directement dans IODE sans avoir � monter un drive r굎eau.

    Par exemple, on peut dans le panneau de LOAD WS entrer un nom
    comme :

&CO
	\\GB\iode\stat\naccount.var
&TX

    qui fait r괽굍ence au drive "iode" d괽ini sur la machine "GB".

    La lecture des r굋ertoire est 괾alement possible sur un drive
    r굎eau.

    Pour permettre l'introduction de noms plus longs, les champs des
    pages contenant un ou des noms de fichiers ont 굏� 굏endus � 64
    caract둹es.

&TI RTF
컴�
    Les impressions en RTF sont 괾alement valables pour les graphiques.
    Les graphiques cr굚s sont inclus dans le fichier RTF en format
    hexad괹imal et sont interpr굏굎 par Word ou le compilateur
    d'aide Windows.

    La dimension de ces graphiques est d굏ermin괻 par les param둻res
    d괽inis dans Print Preferences/A2m ou par la commande de rapport
    $PrintGraphSize.

&TI MIF
컴�
    La g굈굍ation des tableaux en MIF est am굃ior괻 : la largeur de
    la premi둹e colonne est adapt괻 au contenu et celle des colonnes
    suivantes est proportionnellement r굋artie en fonction du nombre
    de colonnes.

    Graphiques : les attributs des caract둹es dans les Labels et Titres
    des graphiques sont corrig굎.

&TI PRINTER
컴컴컴�
    Nouvelles options d'impressions :

&EN Landscape ou Portrait
&EN Simplex, Duplex, Vertical Duplex
&EN S굃ection de l'imprimante par d괽aut.

&TI RAPPORTS
컴컴컴컴
    Trois nouvelles fonctions :

&EN $SetPrinter PrinterName
&EN $PrintOrientation {Portrait | Landscape}
&EN $PrintDuplex {Simplex | Duplex | VerticalDuplex}

&TI PRECISION DES DONNEES
컴컴컴컴컴컴컴컴컴컴�

    Affichage en 8 ou 15 chiffres significatifs � l'괺ition.
    La touche F6 permet de changer la pr괹ision de l'괺ition des
    variables (8 ou 15 chiffres significatifs).
    Sauvetage en 8 ou 15 chiffres significatifs en .av et .as
    Version double pr괹ision pour les Variables et les Scalaires.

&TI Fonctions LEC
컴�
    Nouveaux op굍ateurs
&CO
     var([from [,to],] x)             == sum((xi-xm)**2) / n
     covar([from [,to],] x, y)        == sum((xi-xm)*(yi-ym)) / n
     covar0([from [,to],] expr, expr) == sum(xi * yi) / n
     corr([from [,to],] x, y)         == covar(x, y) / sqrt(var(x) * var(y))
     stddev([from [,to],] x, y)       == sqrt(var(x))
&TX
    Modifications
&CO
    stderr : corrig� (estimateur non biais�) == sqrt(sum((xi-xm)**2/(n-1)
&TX
    L'ancien op굍ateur stderr est remplac� par stddev.

&TI MESSAGES
컴컴컴컴
    Dans les rapports, les messages envoy굎 par $show sont affich굎 dans
    la derni둹e ligne de l'괹ran m늤e dans le cours d'une proc괺ure
    longue.

&TI WS/COPY
컴컴컴�
    Correction dans le cas de listes non d괽inies pass괻s comme argument
    de la fonction.

&TI ESTIMATION DE BLOCS
컴컴컴컴컴컴컴컴컴�
    Correction dans l'estimation de blocs dans les rapports. Auparavant,
    il fallait passer tous les noms des 굌uations du bloc comme argument
    de la fonction EsqEstimate. Une seule 굌uation suffit maintenant si
    elle contient le bloc.
>
<Version 5.03>
    Version 5.03 (08/02/1998)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Tableaux
컴컴컴컴
    S굃ection des lignes � copier ou d굏ruire par Ctrl+L � nouveau
    op굍ationnelle.

    Options graphiques :

&EN l'alignement des observations par rapport � l'abcisse (ann괻)
	  peut 늯re sp괹ifi� par courbe (touche F4).

&EN les options box et shadow sont op굍ationnelles dans
	  l'affichage et l'impression des graphiques. Shadow
	  indique si on veut ou non un hachurage autour du graphique.

&EN les Grids (Major, minor ou None) sont impl굆ent괻s

&TI Graphiques
컴컴컴컴컴
    Quelques corrections d'affichage ont 굏� op굍괻s dans les graphiques.
    En particulier :

&EN il est possible d'imprimer des graphiques sans titre
&EN les bars charts fonctionnent

    Il est possible de modifier la taille des graphiques � imprimer
    ou � int괾rer (Frame) par les Options d'impression (Print Setup/A2M).

    Les options Background Color et Brush + Box sont op굍ationnelles
    pour les graphiques automatiques (variables et estimations).

    La position des bars ou des lignes par rapport � l'abcisse peut 늯re
    choisie : gauche, centre ou droite (voir TABLEAUX).

&TI ESTIMATION
컴컴컴컴컴
    Les graphiques des estimations contiennent le nom de la variable
    endog둵e.


&TI A2M
컴�
    La g굈굍ation des fichiers A2M s'est enrichie d'une commande
    de d괽inition des cadres, couleur et fond des graphiques.
    Cette commande est g굈굍괻 automatiquement en fonction
    des options retenues dans IODE.
&CO
     .gbox box color brush
&TX
    Nouveaux paragraphes pour les tableaux :
&CO
	CellRight, CellLeft, ...
	HeaderRight, ...
	FooterRight, ...
&TX

&TI Properties
컴컴컴컴컴
    Une nouvelle option du menu syst둴e (Properties) permet de
    visualiser le contenu global des WS, le directory de d굋art et
    la m굆oire disponible.

    Cette option est disponible � la fois lorsque la fen늯re est active
    et lorsqu'elle est minimis괻 (bouton de droite).

&TI Titre de la fen늯re IODE
컴컴컴컴컴컴컴컴컴�
    Le titre de la fen늯re contient le nom du directory de lancement
    de IODE et un num굍o d'ordre correspondant � la chronologie de
    d굆arrage des processus IODE.

&TI Taille des caract둹es
컴컴컴컴컴컴컴컴컴컴�
    La taille des caract둹es est maintenu pour les sessions suivantes de
    IODE (apr둺 modification par le menu Syst둴e de la fen늯re IODE).

&TI G굈굍ation de fichiers d'aide Windows
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    La g굈굍ation des fichiers d'aide de Windows est rendue possible
    dans cette version avec une d괹oupe en sujets (topics).

    Lors des impressions, chaque tableau et chaque 굌uation avec
    r굎ultats d'estimation constituent un nouveau topic du fichier
    d'aide.

    De plus les fonctions de rapport suivantes permettent de sp괹ifier
    les niveaux et le titres des sujets de l'aide.

&TI Fonctions de Rapports
컴컴컴컴컴컴컴컴컴컴컴컴�
    Des nouvelles fonctions ont 굏� introduites dans les rapports pour
    permettre de sp괹ifier les options d'impression dans le corps
    d'un rapport.

&CO
   $PrintA2mAppend [NO|Yes]
   $PrintFont      Time|Helvetica|Courier|Bookman|Palatino [size [incr]]
   $PrintTableFont Time|Helvetica|Courier|Bookman|Palatino [size]
   $PrintTableBox  n
   $PrintTableColor [NO|Yes]
   $PrintTableWidth width [col1 [coln]]
   $PrintTableBreak [NO|Yes]
   $PrintTablePage  [NO|Yes]

   $PrintBackground Black|Blue|Magenta|Cyan|Red|Green|Yellow|White
   $PrintGraphBox   n
   $PrintGraphBrush pct|Yes
   $PrintGraphSize  width_mm [height_mm]
   $PrintGraphPage  [NO|Yes]

   $PrintRtfHelp    [YES|No]
   $PrintRtfTopic   titre du topic
   $PrintRtfLevel   [+|-|n]
   $PrintRtfTitle   titre du help
   $PrintRtfCopyright copyright text
   $PrintParanum    [NO|Yes]
   $PrintPageHeader titre des pages suivantes
   $PrintPageFooter  footnote des pages suivantes
&TX

&TI Echanges EXCEL-IODE
컴컴컴컴컴컴컴컴컴�
    Lorsque la configuration de la machine d괽init la virgule comme
    s굋arateur des chiffres d괹imaux, les tranferts IODE-Excel
    remplacent les virgules par des points dans les nombres (et
    inversement).

&TI Ligne de commande
컴컴컴컴컴컴컴컴�
    La syntaxe du programme IODE.EXE permet de charger plusieurs
    fichiers en une seule op굍ation :

&CO
    iode monws.var monws.cmt monws.at
    iode monws.*
&TX
    Le tableau d'괺ition correspondant au dernier fichier de la liste
    (ici monws.tbl) sera ouvert au d굆arrage de IODE.
    Les fichiers non iode ne sont pas charg굎.

    De plus, les fichiers ASCII (.ac, .av, ...) peuvent 괾alement
    늯re charg굎 de cette fa뇇n.

&TI Automatic launch in Netscape
컴컴컴컴컴컴컴
    Le programme d'installation de IODE enregistre les types de fichiers
    .var, .cmt, etc de telle sorte que, si un lien vers un fichier IODE
    appara똳 dans une page HTML (via Netscape par exemple), il soit
    possible d'ouvrir directement le fichier en question dans IODE.

    IODE est lanc� et le fichier r괽굍enc� est charg� dans le WS
    correspondant.

    Attention, le fichier ainsi charg� est pr괶lablement sauv� par
    Netscape dans un fichier temporaire situ� dans le directory
    ~c\Windows\Temp~C.
>

<Version 5.02>
    Version 5.02 (20/12/1997)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Impressions Objets
컴컴컴컴컴컴컴컴컴
    Correction dans l'impression des variables.

&TI Rapports
컴컴컴컴
    Cr괶tion des listes : le point-virgule sert de s굋arateur (au lieu
    de la virgule ant굍ieurement).

&IT     $DSImportDB
    컴컴컴컴컴�
    Importation de donn괻s de DataStream.

   Syntaxe :
&CO
	$DSImportDB nom_data_stream1, ...
&TX
    Cette fonction va lire sur le sample courant la ou les variables
    d괽inies par nom_data_stream1, ... et cr괻 dans le WS courant une
    s굍ie dont le nom est construit en rempla놹nt les caract둹es non
    alphanum굍iques par des understroke.

   Exemple :
&CO
	$DSImportDB BEGDP..A12
&TX
    cr괻 ~cBEGDP__A12~C dans le WS courant.

    Si le nom_data_stream contient le caract둹e pourcent (%), la
    fonction ne s'ex괹ute pas car % est un caract둹e r굎erv� dans les
    rapports. Pour pallier ce probl둴e, il faut cr괻r une liste
    contenant le nom des s굍ies et appeler DSImportDB avec la liste
    comme argument.

&CO
	$DSImportDB $MYLST
&TX
    Note : cette fonction n'est op굍ationnelle actuellement que sur les machines
	   qui ont un acc둺 � DataStream.

&TI Uninstall
컴컴컴컴�
    Nouvelle fonction de d굎installation de IODE. Cette fonction est
    accessible soit via Control Panel/Install Software, soit dans le
    menu START/Groupe IODE.
>
<Version 5.01>
    Version 5.01 (17/12/1997)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Rapports
컴컴컴컴
    La fonction $EqsEstimate imprime les graphiques des observations
    et des valeurs estim괻s.
&CO
    $IdtExecuteTrace werkt terug
&TX
&TI Execute IDT's
컴컴컴컴컴컴�
    Bij het uitvoeren van identiteiten wordt er per default geen output
    meer gegenereerd. Alleen als de "Trace" of "Debug" optie wordt gebruikt
    krijgt u een overzicht van de uitgevoerde identiteiten. Dit kan u
    fullscreen, of door het $IdtExecuteTrace commando in rapporten.

&TI Print Files
컴컴컴컴컴�
    U kan uw a2m-files en rapport-definities vanuit IODE afprinten.
>
<Version 5.0>
    Version 5.0 (15/10/1997)
    컴컴컴컴컴컴컴컴컴컴컴컴
&TI Direct Printen vanuit IODE
컴컴컴컴컴컴컴컴컴컴컴컴컴

    In de vorige versies van IODE, moest een A2M-file worden aangemaakt om
    later af te drukken op een printer of door te sturen naar een ander
    pakket (MIF, RTF, ...). Er bestond ook een AGL-formaat met daarin de
    definitie van de grafieken.

    Vanaf de 4.80-versie kan er direct worden afgedrukt op de "default"
    printer, of indien gewenst uw output laten omzetten naar het formaat
    van uw keuze (MIF,RTF, good-old A2M, ...)

    Het volstaat in de Menu-File "Print Setup" aan te duiden hoe u de output
    van uw printjobs wil krijgen.

&EN    1. Kiest u voor "Windows Printer" dan wordt alles afgedrukt op uw
       "default" Windows-printer.

&EN     2. Wil u de output van uw printjobs in Frame, Word of het WWW gebruiken
       kies dan voor de "File"-optie. Elke keer dat u afdrukt, vraagt IODE
       de naam en het formaat waarin u uw output wil terugvinden.

    U zal merken dat de "windows" waarin u de printopdracht geeft lichtjes
    zijn veranderd. Het veld waarin de naam van de A2M-file stond is om
    evidente redenen verdwenen. Wil u toch nog A2M-files maken, geen nood.
    E굈 van de formaten waaronder u kan printen is good-old A2M.

&TI Grafieken in A2M
컴컴컴컴컴컴컴컴

    Vanaf de versie 4.80 van IODE kan u naast tabellen, IODE-objecten en
    tekst ook grafieken afdrukken of omzetten naar MIF. Het A2M-formaat
    werd uitgebreid met een nieuw object, nl. de grafiek.

    Het is nu ook mogelijk om met linker- en rechterassen te werken. U
    bepaalt voor elke lijn in een grafiek naast het type (bar, line, ...)
    ook de te gebruiken as. U oude grafieken zijn nog steeds bruikbaar,
    per "default" wordt alleen de linkeras gebruikt.


    Voor het afdrukken van grafieken via namen van variabelen, gebruikt u
    het $DataPrintGraph commando.
&CO
    $DataPrintGraph   {Level | Diff | Grt}
		      {Line | Scatter | Bar | Mixt}
		      {NoXGrids | MinorXGrids | J(MajorXGrids)}
		      {NoYGrids | MinorYGrids | J(MajorYGrids)}
		      {Level | G(Log) | Semi-Log | Percent}
		      {ymin | --} {ymax | --}
		      perfrom perto varname1 varname2 ...
&TX
    Voor het afdrukken van grafieken via tabellen, gebruikt u
    het $PrintGr commando.
&CO
    $PrintGr gsample table_names
&TX

    Reeds bestaande A2M-bestanden blijven compatibel.

&TI Printen vanuit een Rapport
컴컴컴컴컴컴컴컴컴컴컴컴컴

    Bij het uitvoeren van een rapport moet u aangeven onder welke vorm
    en in welke file u uw output wil recuperen. Per default wordt niets
    afgedrukt.

    Om vanuit een rapport gebruik te kunnen maken van de nieuwe print-
    mogelijkheden, werden de "PrintDest" en "PrintDestNew" commando's
    aangepast. U vroegere rapporten moet u niet aanpassen, zij zullen
    A2M-bestanden blijven aanmaken.

&IT    Vroeger
    컴컴컴�
&CO
	$PrintDest filename (vb. $PrintDest tabel.a2m)
&TX
&IT    Nu
    컴
&CO
	$PrintDest
&TX
		print alles wat volgt af op uw default-Windows printer
&CO
	$PrintDest filename [format]
&TX
		print alles wat volgt af in "filename" onder het gewenste
		formaat.

		format = A2M, MIF, HTML, RTF, als geen formaat wordt
		gespecifieerd, is A2M het gekozen formaat

&TI Wisselwerking EXCEL en IODE-rapporten
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Nieuwe rapportfuncties in IODE laten u toe om IODE-objecten weg
    te schrijven naar Excel, gegevens uit Excel te gebuiken om IODE
    data aan te passen, etc...

&CO
    $ExcelOpen "filename"
&TX
	Opent in Excel de file. Als Excel niet draait en het pad naar
	Excel.exe staat in uw systeemvariabele PATH an wordt Excel
	opgestart.
	(vb: $ExcelOpen "c:\usr\iode\test.xls")
&CO
    $ExcelSave
&TX
	Slaat de openstaande workbook op


&CO
    $ExcelPrint
&TX
	Print het openstaande workbook

&CO
    $ExcelSet{Obj} objnaam [sample] excelrange
&TX
	Schrijft het IODE-obj "objname" in een Excel-spreadsheet
	in de aangeduide range

	(vb: $ExcelSetVar AAA Sheet1!R1C1
	     $ExcelSetCmt AAA Sheet1!R1C1
	     $ExcelSetTbl AAA 90:11 Sheet1!R1C1)

&CO
    $ExcelGetVar varname [begin period] rangname
&TX
	Haalt uit de Excel-range de waarden voor de update van "varname".
	Wordt de "begin period" niet aangegeven, dan wordt de begin periode
	van de sample aangenomen.


&TI XODE in IODE
컴컴컴컴컴컴
    U kan alle functies uit XODE in IODE gebruiken. Als u bij de "Save" of
    de "Load" van een file een ASCII-extensie gebruikt (bijv. ac voor
    commentaarbestanden) dam wordt een IODE-ascii bestand weggeschreven of
    gelezen. U kan ook vanuit een rapport ASCII-bestanden im- of exporteren

&CO
    Syntax : $WsImportObj filename
	     $WsExportObj filename
&TX
	bijv. $WsImportVar test.ac

    Onder het menu-punt "File" vindt de Import en Export (by rule) functies
    van XODE terug.

&TI RAPPORTS
컴컴컴컴
    Nouvelles fonctions dans les rapports :

&EN ~c$Minimize~C : minimise la fen늯re de IODE (par exemple pour
		    afficher des graphiques de Excel g굈굍굎 par
		    la simulation en cours)
&EN ~c$Maximize~C : restaure la fen늯re de IODE
&EN ~c$Sleep~C nn : arr늯e le processus pendant nn milli둴es de seconde.
		    Cela permet � un client ou un serveur DDE de
		    conserver le contr뱇e en cas de requ늯es trop
		    rapides.
&TI CORRECTION
컴컴컴컴컴
    Erreur lors de la destruction d'un objet (tableau par exemple)
    corrig괻.

&TI RAPPORTS
컴컴컴컴
    La fonction ~c$EqsEstimate~C imprime les graphiques des observations
    et des valeurs estim괻s.
>

<Version 4.73>
    Version 4.73 (08/08/1997)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Calcul de taux de croissance moyens
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Lorsqu'une valeur n괾ative r굎ulte de la division de la p굍iode
    de fin par la p굍iode de d괷ut dans un calcul de taux de croissance
    moyen, le calcul de la racine de cette valeur 1/n est impossible.
    Dans ce cas, la valeur retourn괻 est --, alors qu'auparavant, le
    programme avait un comportement erratique.
>
<Version 4.71>
    Version 4.71 (20/05/1997)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI IMPRESSIONS
컴컴컴컴컴�
    Le nombre de caract둹es pr굒us pour les valeurs des tableaux et des
    coefficients est augment�.

&TI *ODEW32
컴컴컴�
    Am굃ioration de la gestion de l'utilisation CPU de la machine.
    Cette correction am굃iore sur certaines configurations les
    performances d'acc둺 aux r굎eaux.
>
<Version 4.72>
    Version 4.72 (17/06/1997)
    컴컴컴컴컴컴컴컴컴컴컴컴�

La version 4.72 contient trois groupes de fichiers suppl굆entaires :

&EN Version IODE double pr괹ision
&EN WS APL d'interface avec IODE
&EN Programme A2M pour Windows 95

&TI VERSION DOUBLE PRECISION
컴컴컴컴컴컴컴컴컴컴컴컴
    Les donn괻s num굍iques (s굍ies, coefficients, ...) sont g굍괻s en
    IODE en simple pr괹ision, c'est-�-dire avec une pr괹ision de 8
    chiffres significatifs.

    Dans certains cas, cette limite est "un peu courte". A cette fin,
    une version double pr괹ision (16 chiffres significatifs) a 굏�
    d굒elopp괻. Les programmes de cette version (uniquement win32) sont
    IODEW32d, XODEW32d, GODEW32d et TODEW32d.

    Pour pouvoir exploiter ces programmes, il faut d'abord exporter en
    ASCII tous les fichiers n괹essaires, � l'exception des commentaires
    et des listes. Utilisez pour cela XODEW32. Les fichiers de
    variables, de tableaux, d'identit굎 et d'굌uations contenant des
    informations num굍iques, ils doivent 늯re traduits avant exploitation.

    Il faut ensuite importer ces fichiers en double pr괹ision � l'aide
    de XODEW32d. On constatera 굒idemment que les fichiers peuvent
    doubler de taille.

    Ensuite, IODEW32d peut 늯re utilis� exactement comme IODEW32.


&TI WS APL d'interface avec IODE
컴컴컴컴컴컴컴컴컴컴컴컴컴컴
    Les fonctions de ce WS sont affich괻s lors de son chargement.

    Elles permettent :

&EN de piloter IODE � partir de l'APL
&EN de charger des donn괻s de IODE vers APL
&EN de copier les donn괻s de l'APL vers IODE

    Pour que cela fonctionne, il faut d굆arrer le programme IODEW32 ou
    IODEW32d. Plus d'explications seront fournies dans un document
    s굋ar�.


&TI PROGRAMME A2M pour WIN95
컴컴컴컴컴컴컴컴컴컴컴컴
    Un programme permettant d'imprimer ou de traduire des fichiers a2m
    en diff굍ents langages est distribu� sur les disquettes de IODE.

    Ce programme, ind굋endant de IODE, peut 늯re lanc� n'importe quand
    et exploit� en cours de travail dans IODE. Il ne fonctionne que sous
    Windows 95.

    A2m contient 괾alement une s굍ie d'utilitaires de manipulation de
    fichiers HTML.

&TI DDE SERVER
컴컴컴컴컴
    Un serveur DDE est impl굆ent� dans IODEW32 et IODEW95. Cela
    signifie qu'il est possible d'exploiter les fonctions et les
    donn괻s de IODE dans le cadre d'autres programmes, comme
    Excel ou APL.

    La version actuelle est encore une version limit괻: toutes les
    possibilit굎 exploitables ne sont donc pas impl굆ent괻s. En fonction
    des demandes futures, d'autres fonctions pourront 늯re d괽inies.

&IT    Utilisation en Excel
    컴컴컴컴컴컴컴컴컴컴
    Par exemple, on peut placer dans une cellule d'un tableau Excel
    la r괽굍ence � une variable de IODE sous le format suivant :
&CO
	=IODE|XVAR!'SER1!Sheet1!R2C2'
&TX
    La valeur de la s굍ie sera plac괻 � la position demand괻.

&IT    Utilisation en APL
    컴컴컴컴컴컴컴컴컴컴
    En APL, un WS IODE a 굏� programm� pour permettre de lancer des
    commandes de rapport � partir d'une fonction APL, charger en APL des
    donn괻s de IODE et replacer ces donn괻s apr둺 modification dans
    l'environnement IODE. Une fonction permet de piloter compl둻ement
    IODE � partir de l'APL.

&IT    Fonctions du serveur DDE
    컴컴컴컴컴컴컴컴컴컴컴컴
    Les donn괻s techniques qui suivent permettent d'exploiter le
    serveur DDE dans le cadre d'autres programmes.
&CO
    Service : IODE
    Topics  : WS (Request et Poke), REP (Poke), PLAY (Poke), XVAR, XCMT
	      CMT, EQS, IDT, LST, SCL, TBL, VAR (Request et Poke)

     1. Request
     ----------
	Items de WS
	-----------
	     SAMPLE = sample du WS IODE courant

	     CLIST  = liste des commentaires du WS IODE courant
	     ELIST  = liste des 굌uations du WS IODE courant
	     ILIST  = liste des identit굎 du WS IODE courant
	     LLIST  = liste des listes du WS IODE courant
	     SLIST  = liste des scalaires du WS IODE courant
	     TLIST  = liste des tableaux du WS IODE courant
	     VLIST  = liste des variables du WS IODE courant

	     CNAME  = nom du fichier des commentaires de IODE
	     ENAME  = nom du fichier des 굌uations de IODE
	     INAME  = nom du fichier des identit굎 de IODE
	     LNAME  = nom du fichier des listes de IODE
	     SNAME  = nom du fichier des scalaires de IODE
	     TNAME  = nom du fichier des tableaux  de IODE
	     VNAME  = nom du fichier des variables de IODE

	     CDESCR = description du fichier des commentaires de IODE
	     EDESCR = description du fichier des 굌uations de IODE
	     IDESCR = description du fichier des identit굎 de IODE
	     LDESCR = description du fichier des listes de IODE
	     SDESCR = description du fichier des scalaires de IODE
	     TDESCR = description du fichier des tableaux  de IODE
	     VDESCR = description du fichier des variables de IODE

	     CNB    = nombre de commentaires dans IODE
	     ENB    = nombre de 굌uations dans IODE
	     INB    = nombre de identit굎 dans IODE
	     LNB    = nombre de listes dans IODE
	     SNB    = nombre de scalaires dans IODE
	     TNB    = nombre de tableaux  dans IODE
	     VNB    = nombre de variables dans IODE

	Items de CMT, EQS, IDT, LST, SCL, TBL, VAR
	------------------------------------------
	     L'item est le nom de l'objet. La valeur retourn괻
	     est la d괽inition de l'objet.

	Items de XVAR
	-------------
	    L'item est compos� de trois 굃굆ents s굋ar굎 par des ! :
		- nom de la ou des variables s굋ar굎 par des virgules ou
		    des blancs. t repr굎ente une ligne de p굍iodes
		- nom du sheet o� placer le r굎ultat
		- range de la premi둹e cellule dans ce sheet

	    Cette requ늯e g굈둹e un Poke vers excel avec la d괽inition
	    des variables et leur code.

	    Si aucun nom de s굍ie n'est donn�, une s굍ie avec les
	    valeurs des p굍iodes pr괹둪e. Sinon, on peut placer
	    les p굍iodes en indiquant la s굍ie t (minuscule).

	    S'il n'y a pas de sheet, Sheet1 est choisi comme destination
	    S'il n'y a pas de range, R1C1 est choisi comme destination

	    Exemples
	    --------
		IODE|XVAR!' ' : toutes les s굍ies dans le sheet1, en R1C1
				avec les p굍iodes
		IODE|XVAR!'t,QC0,QAFF!Sheet2!R1C1' : s굍ies QCO et QAFF
				dans le Sheet2 en position R1C1, avec
				les p굍iodes en premi둹e ligne
		IODE|XVAR!'QC0!Sheet2!R1C1' : s굍ie QCO sans les p굍iodes

	Items de XCMT
	-------------
	    L'item est compos� de trois 굃굆ents s굋ar굎 par des ! :
		- nom de la ou des commentaires s굋ar굎 par des virgules ou
		    des blancs
		- nom du sheet o� placer le r굎ultat
		- range de la premi둹e cellule dans ce sheet

	    Cette requ늯e g굈둹e un Poke vers excel avec la valeur des
	    commentaires et leurs codes.

	    S'il n'y a pas de sheet, Sheet1 est choisi comme destination
	    S'il n'y a pas de range, R1C1 est choisi comme destination

	    Exemples
	    --------
		IODE|XCMT!' ' : tous les commentaires dans le sheet1,
				en R1C1
		IODE|XVAR!'QC0,QAFF!Sheet2!R1C1' : comments QCO et QAFF
				dans le Sheet2 en position R1C1
		IODE|XVAR!'QC0!Sheet2!R5C2' : comment QCO en Sheet2, ligne
				5 colonne 2

     2. Poke
     -------
	Items de WS (Data en fonction du contexte)
	-----------
	     SAMPLE = change le sample du WS IODE courant (format IODE)

	     CNAME  = change le nom du fichier des commentaires de IODE
	     ENAME  = change le nom du fichier des 굌uations de IODE
	     INAME  = change le nom du fichier des identit굎 de IODE
	     LNAME  = change le nom du fichier des listes de IODE
	     SNAME  = change le nom du fichier des scalaires de IODE
	     TNAME  = change le nom du fichier des tableaux  de IODE
	     VNAME  = change le nom du fichier des variables de IODE

	     CDESCR = change la description des commentaires de IODE
	     EDESCR = change la description des 굌uations de IODE
	     IDESCR = change la description des identit굎 de IODE
	     LDESCR = change la description des listes de IODE
	     SDESCR = change la description des scalaires de IODE
	     TDESCR = change la description des tableaux  de IODE
	     VDESCR = change la description des variables de IODE

	     CCLEAR = Clear des commentaires dans IODE
	     ECLEAR = Clear des 굌uations dans IODE
	     ICLEAR = Clear des identit굎 dans IODE
	     LCLEAR = Clear des listes dans IODE
	     SCLEAR = Clear des scalaires dans IODE
	     TCLEAR = Clear des tableaux dans IODE
	     VCLEAR = Clear des variables dans IODE

	     CLOAD = Load un fichier de commentaires dans IODE
	     ELOAD = Load un fichier d'굌uations dans IODE
	     ILOAD = Load un fichier d'identit굎 dans IODE
	     LLOAD = Load un fichier de listes dans IODE
	     SLOAD = Load un fichier de scalaires dans IODE
	     TLOAD = Load un fichier de tableaux dans IODE
	     VLOAD = Load un fichier de variables dans IODE

	     CSAVE = Sauve le fichier de commentaires de IODE
	     ESAVE = Sauve le fichier d'굌uations de IODE
	     ISAVE = Sauve le fichier d'identit굎 de IODE
	     LSAVE = Sauve le fichier de listes de IODE
	     SSAVE = Sauve le fichier de scalaires de IODE
	     TSAVE = Sauve le fichier de tableaux de IODE
	     VSAVE = Sauve le fichier de variables de IODE

	Items de PLAY
	-------------
	     TEXT : data = texte � placer dans le buffer clavier
		    de IODE
	     KEYS : data = texte des touches � placer dans le buffer
		    clavier : aA..aZ, aF1..aF10, cA..cZ, cF1..cF10,
			      sF1..sF10, ESC, ENTER, BACKSPACE,
			      HOME, END, LEFT, RIGHT, UP, DOWN,
			      PGUP, PGDN, DEL, TAB

	Items de CMT, EQS, IDT, LST, SCL, TBL, VAR
	------------------------------------------
	    Nom de l'objet � modifier.
	    Data contient la valeur avec des TAB comme s굋arateur
	    dans le cas des variables.

	Items de REP
	------------
	    La valeur de l'item est sans signification.
	    La valeur de data est une commande de rapport � ex괹uter
	    (ex. '$WsLoadVar test')
&TX
>

<Version 4.70>
    Version 4.70 (10/03/1997)

&TI G굈굍ation de fichiers HTML


&IT   Param둻res de QODE

    De nouveaux param둹es se sont ajout굎 au programme QODE pour
    affiner la g굈굍ation des fichiers HTML :

&EN -toc tit_level : indique s'il faut g굈굍er une table des
	 mati둹es au d괷ut du document et jusqu'� quel niveau de titre

&EN -parb tit_level et

&EN -pari tit_level : indique s'il faut donner un niveau de
	    titre aux paragraphes parb et pari (on donc 굒entuellement
	    les introduire dans la table des mati둹es

&IT    HTML g굈굍�
    컴컴컴컴컴�
    En d괷ut et en fin du fichier HTML se trouvent deux commentaires
    qui permettent d'effectuer un remplacement automatique dans le
    fichier, afin par exemple de placer une barre navigationnelle
    standardis괻 en haut et en bas du document.

    Ces commentaires sont :
&CO
	<<!STARTHEADER>>
	<<!ENDHEADER>>

	<<!STARTFOOTER&>>
	<<!ENDFOOTER>>
&TX
    Le programme scr4_sbs permet de substituer ces textes par le contenu
    d'un fichier. La commande � effectuer est :
&CO
	scr4_sbs "<<STARTHEADER>>" "<<!ENDHEADER>>" replacefile
		file.htm
&TX
    Elle a pour effet de remplacer dans le fichier file.htm tout ce qui
    se trouve entre ~c<<!STARTHEADER>>~C et ~c<<!ENDHEADER>>~C,
    ces textes compris, par le contenu du fichier replacefile.

&TI Graphiques
컴컴컴
    Correction de l'affichage et de l'impression des graphiques
    � partir des tableaux. Le buffer contenant le titre du tableau est
    allou� dynamiquement: auparavant, un titre de plus de 80 caract둹es
    plantait le programme.

&TI Fichier printcap for WinNFS de Network Instruments
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Le fichier printcap.ni contient les instructions n괹essaires
    � l'impression via IODE32 ou QODE sous Windows 95. EN effet,
    le logiciel Winsock Companion de Network Instruments est utilis�
    en lieu et place de PC-NFS sous WIndows 95, ce qui exige une autre
    configuration.

    Attention, � la diff굍ence des la version PC-NFS, les imprimantes
    doivent 늯re pr괶lablement d괽inies dans l'environnement Windows
    pour pouvoir 늯re utilis괻s.

&TI Corrections de bugs
컴�
    Les variables ~c_YOBSi~C, ~c_YCALCi~C et ~c_YRESi~C g굈굍괻s
    automatiquement lors des estimations 굏aient parfois absentes. Cette
    erreur est corrig괻.

&TI QODE : g굈굍ation de fichier MIF

    La traduction de fichiers a2m en format MIF 굏ait impossible
    si la largeur d'une colonne (la premi둹e) 굏ait sup굍ieure �
    60 caract둹es. Cette limite est port괻 � 400 caract둹es.

    La limite � 60 caract둹es est cependant conserv괻 pour les outputs
    en fichier formatt굎 Ascii.
>
<Version 4.69>
    Version 4.69 (12/09/1996)
    컴컴컴컴컴컴컴컴컴컴컴컴�

..esc ~

&TI WsCopyVar, HighToLow, LowToHigh, Census X11
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Ces fonctions sont corrig괻s : en utilisation hors des
    rapports, elles plantaient IODE (toutes versions).

&TI G굈굍ation des tableaux
컴컴컴컴컴컴컴컴컴컴컴�
    Correction dans le calcul lorsque le diviseur est non LEC.

&TI Simulation
컴컴컴컴컴
    La version DOS 32 bits a 굏� quelque peu acc굃굍괻.

&TI Estimation
컴컴컴컴컴
    Les tests r굎ultant de la derni둹e estimation sont sauv굎 dans
    des scalaires de fa뇇n � permettre diff굍ents calcul par la
    suite. Il en va de m늤e pour les r굎idus, membres de gauche et
    de droite des 굌uations.

    Les tests portent les noms suivants (~ce0_*~C pour la premi둹e 굌uation
    du bloc, ~ce1_*~C pour la deuxi둴e, ...) :

&EN        ~ce0_n       ~C  : nombre de p굍iode du sample
&EN        ~ce0_k       ~C  : nombre de coefficients estim굎
&EN        ~ce0_stdev   ~C  : std dev des r굎idus
&EN        ~ce0_meany   ~C  : moyenne de Y
&EN        ~ce0_ssres   ~C  : somme du carr굎 des r굎idus
&EN        ~ce0_stderr  ~C  : std error
&EN        ~ce0_stderrp ~C  : std error %
&EN        ~ce0_fstat   ~C  : F-Stat
&EN        ~ce0_r2      ~C  : R carr�
&EN        ~ce0_r2adj   ~C  : R carr� ajust�
&EN        ~ce0_dw      ~C  : Durbin-Watson
&EN        ~ce0_loglik  ~C  : Log Likelihood

    Les s굍ies calcul괻s sont 괾alement sauv괻s dans une variable
    sous les noms :

&EN  ~c_YCALC0~C pour le membre de droite de la premi둹e 굌uation du
	  bloc, ~c_YCALC1~C pour la deuxi둴e 굌uation, etc.

&EN  ~c_YOBS0~C pour le membre de gauche de la premi둹e 굌uation du
	  bloc, ~c_YOBS1~C pour la deuxi둴e 굌uation, etc.

&EN  ~c_YRES0~C pour les r굎idus de la premi둹e 굌uation du bloc, ...

    En dehors du sample d'estimation, les valeurs de la s굍ie sont --.
>

<Version 4.68>
    Version 4.68 (16/07/1996)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI HTML
컴컴
&EN Correction dans le cas des caract둹es sp괹iaux ayant une
      signification particuli둹e en HTML (<</A>>, ...). Ces caract둹es
      굏aient transform굎 auparavant.

&EN Le format des tableaux est all괾� : les lignes verticales
      et horizontales sont supprim괻s. De plus, les cellules de
      type LINE g굈둹ent une ligne intercalaire dans le tableau
      en HTML.

&EN L'alignement des nombres se fait � droite et plus sur
      le point d괹imal. En effet, Netscape ne g둹e pas correctement
      l'alignement d괹imal.

&TI Estimation
컴컴컴컴컴
    L'impression des r굎ultats des estimations ne g굈둹e plus de
    tableaux pour 굒iter les sauts de pages inutiles en Postscript.

&TI Print/View Variables
컴컴컴컴컴컴컴컴컴컴
    Il est dor굈avant possible d'afficher des valeurs r굎ultant de
    formules contenant l'op굍ateur * ou contenant des virgules (min,
    vmax, ...).
    Cependant, les s굋arateurs entre les formules sont dor굈avant
    limit굎 aux blancs, points-virgules et retour ligne.

&TI Noms de fichiers
컴컴컴컴컴컴컴컴
    A la demande de plusieurs utilisateurs, la longueur des noms de
    fichiers est port괻 dans la plupart des 괹rans � un minimum de 40
    caract둹es.
    Le prix � payer est que les "profiles" des versions ant굍ieures
    ne sont plus compatibles avec la version 4.68.

&TI Fichiers a2m
컴컴컴컴컴컴
    Dans les 괹rans o� l'on permet d'"imprimer" dans un fichier a2m,
    il est possible de sp괹ifier si l'on souhaite que le fichiers
    soient vid굎 avant l'impression. Cela permet d'굒iter que
    des fichiers d'output accumulent des impressions successives.

    Notons que cette option est li괻 � la fonction de rapport
    $PrintDestNew (voir 4.67).

&TI Execute identities
컴컴컴컴컴컴컴컴컴
    Le fichier "trace" optionnel est r굀nitialis� � chaque ex괹ution.

&TI Simulation Debug
컴컴컴컴컴컴컴컴
    L'option debug de la simulation g굈둹e automatiquement des listes
    comprenant des 굌uations pr�- et post-r괹ursives.
    Dans cette version, un fichier de trace est 괾alement g굈굍�. Ce
    fichier se nomme "simul.dbg" et se trouve dans le directory
    d'o� IODE a 굏� lanc�.
    Le fichier de trace comprend actuellement la liste des 굌uations
    pour lesquelles une sous-it굍ation (Newton-Raphson) a 굏�
    n괹essaire et le nombre de sous-it굍ations.

&TI Remarques
컴컴컴컴�
    Dans les rapports, les expressions du type
&CO
	    $Goto label {X[1975Y1] << 2}
&TX
    ne fonctionnent que si la p굍iode est fix괻 par la fonction
&CO
	    $SetTime
&TX
    Si ce n'est pas le cas, l'expression (m늤e si l'ann괻 est fix괻
    comme dans l'exemple) ne s'ex괹utent pas.
>
<Version 4.67> (12/07/1996)
    Version 4.67 (12/07/1996)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Versions Windows
컴컴컴컴컴컴컴컴
&EN Meilleure gestion de la souris.
&EN Stop possible plus souvent.

&TI HTML
컴컴
    Il est possible de sp괹ifier un fichier HTML comme sortie de
      QODE ou TODE. Cette fonction g굈굍e du HTML 3.0 (y compris les
      tableaux).

&TI Crit둹e de convergence Newton
컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Dans cette version, on a repris deux types de crit둹es dans le
    cas d'une 굌uation non r굎olue par rapport � l'endog둵e ou dans
    le cas du goal seeking. Dans la version 4.66, on avait renforc�
    les contraintes de convergence. Dans la version 4.67, en attendant
    un refonte de l'algorithme, on reprend le crit둹e 4.66 (crit둹e
    fort, comme dans KaA), mais en cas de non convergence par cette
    m굏hode, on reprend le crit둹e ant굍ieur (v.4.65).

&TI Rapports
컴컴컴컴
&IT    Nouvelle fonction $msg
    컴컴컴컴컴컴컴컴컴컴컴

	Elle affiche le texte de l'argument et attend une touche avant
	de continuer. Cela permet de stopper momentan굆ent le rapport
	pour afficher un message � l'intention de l'utilisateur,
	contrairement � la fonction $show qui affiche dans le bas de
	l'괹ran mais ne stoppe pas.

&CO
	    $msg texte libre
&TX
&IT    Macros
    컴컴컴
	Les macros sont d괽inies entre des pourcents : %FILE%. Si le
	premier pourcent est imm괺iatement suivi du caract둹e

&EN            ## : le contenu de la macro est transpos� en majuscules
&EN            ! : le contenu de la macro est transpos� en minuscules

	Par exemple,
&CO
	    ##define TOTO TBL1
	    Premier  tableau : %!TOTO%
	    Deuxi둴e tableau : %##TOTO%
&TX
	Donnera � l'ex괹ution :
&CO
	    Premier  tableau : tbl1
	    Deuxi둴e tableau : TBL1
&TX
&IT    Noms des fichiers a2m
    컴컴컴컴컴컴컴컴컴컴�
	Pour 굒iter les probl둴es de noms de fichiers entre DOS et
	Unix, les noms des fichiers a2m d괽inis par la commande
	$PrintDest sont toujours transpos굎 en minuscules.

	Le nom des fichiers output peut atteindre 64 caract둹es au
	lieu de 40 auparavant.

&IT    Fonction FileDelete*
    컴컴컴컴컴컴컴컴컴컴
	Le fichier destination de l'output est ferm� avant toute
	destruction de fichier pour 굒iter les erreurs dans les
	rapports du type suivant :
&CO
	    $PrintDest res.a2m

	    $Label Again
	    $FileDeleteA2m res        (le fichier est ouvert!)
	    ...
	    $Goto Again
&TX
&IT    Nouvelle fonction $PrintDestNew
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	Cette fonction d굏ruit le fichier output avant de commencer
	� l'utiliser. Cela 굒ite de cr괻r de gigantesques fichiers
	accumulant tous les r굎ultats successifs.
>

<Version 4.66> (17/01/1996)
    Version 4.66 (17/01/1996)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Crit둹e de convergence Newton
컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    Lorsqu'une 굌uation n'est pas r굎olue analytiquement par IODE
    (endog둵e r굋굏괻 dans l'굌uation), un sous-algorithme de Newton est
    utilis� pour obtenir la convergence de cette 굌uation.

    En raison du manque relatif de pr괹ision dans les calculs, cette
    sous it굍ation peut dans certains cas ne pas converger correctement.

    Dans cette version, la contrainte de convergence est plus
    restrictive qu'auparavant, s'alignant de la sorte sur celui de KaA.
    Par cons굌uent, il est possible que certaines 굌uations ne
    convergent plus dans cette nouvelle version.

    Dans une version en pr굋aration, tout ce probl둴e sera revu et de
    nouveaux algorithmes seront propos굎.

&TI Noms des fichiers (Load)
컴컴컴컴컴컴컴컴컴컴컴컴
    Un erreur se produisait lors du chargement d'un fichier dont le nom
    굏ait du type "../nom". Le message "file not found or incompatible
    type" 굏ait alors produit. Cette erreur est corrig괻.

&TI Profiles
컴컴컴컴
    Les profils qui permettent de retrouver d'une session � l'autre les
    m늤es 괹rans sont standardis굎 (DOS 16 bits ou 32 bits).
>


<Versions 4.64-65> (17/10/1995)
    Versions 4.64-65 (17/10/1995)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Qode (Postscript)
컴컴컴컴컴컴컴컴�

Le driver Postscript incorpor� dans QODE et QODE32 a 굏� adapt� aux
imprimantes HP4m+ et HP4mv.

Bureau du Plan : les fichiers printcap.nfs et printcap sont adapt굎
		 aux nouvelles imprimantes r굎eau.

>

<Version 4.63> (02/10/1995)
    Version 4.63 (02/10/1995)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Tableaux en Mif
컴컴컴컴컴컴컴�

    Une simplification de l'importation en Frame des tableaux (QODE) a
    굏� apport괻 dans cette version : auparavant, il fallait disposer du
    fichier a2m.m4 dans le directory du fichier mif pour pouvoir ouvrir
    avec succ둺 en Frame un fichier MIF contenant un tableau
    (et encore...).
    Typiquement, si ce n'굏ait pas le cas, on obtenait un document Frame
    vide.

    Dor굈avant, l'importation des tableaux r굋ond aux r둮les suivantes :

&EN        il ne faut plus de fichier a2m.m4
&EN        il n'y a plus de lignes en haut et en bas du document,
	  h굍itage des versions 1.0 et 1.3 de Frame
&EN        les tableaux g굈굍굎 sont de type "Format A", formt d괽ini dans
	  le catalogue de tableaux de tout fichier Frame

    Pratiquement, pour importer des tableaux en Frame, on proc둪e
    comme suit :

&EN        cr괻r les tableaux dans un fichier a2m en IODE ou IODE32
	    (Print Tables)
&EN         "Quick print a2m file" vers un fichier mif
&EN         lancer Frame
&EN         deux possibilit굎 ensuite :

&EN2             ouvrir le fichier mif (File/Open)
&EN2             importer le fichier mif dans un document existant
		(File/Import/File)

    Dans le dernier cas (File/Import), on peut exploiter un format
    pr괺괽ini : il suffit de d괽inir dans un template de Frame
    un type de tableau "Format A" selon ses desiderata.
>


<Version 4.62> (29/09/1995)
    Version 4.62 (29/09/1995)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Versions ?ODE32
컴컴컴컴컴컴컴�
    Une erreur s'est gliss괻 dans le portage de la version 4.61 en 32 bits.
    L'interpr굏ation des valeurs non enti둹es (dans les fichiers
    ASCII, les 굌uations et les identit굎) 굏ait erron괻.
>

<Version 4.61> (02/09/1995)
    Version 4.61 (02/09/1995)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Regroupement de fichiers
컴컴컴컴컴컴컴컴컴컴컴컴
    Le nombre de fichiers distribu굎 dans IODE est consid굍ablement
    diminu� : les ex괹utables de IODE int둮rent toutes les informations
    n괹essaires � leur fonctionnement, exception faite des fichiers
    d'aide et du fichier printcap de d괽inition des imprimantes locales.
>

<Version 4.60> (15/05/1995)
    Version 4.60 (15/05/1995)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI LEC : variable i
컴컴컴컴컴컴컴컴
    Nouvelle variable dans le langage LEC permettant de conna똳re lors
    d'un calcul la diff굍ence entre l'ann괻 de calcul d'une
    sous-expression par rapport � l'ann괻 de calcul de toute la formule.
    Cette variable s'appelle i et son comportement s'apparente � celui
    de t. Elle est donc invariante par rapport � l'ann괻 de calcul d'une
    formule LEC.

    On calcule toujours une forme LEC pour une valeur du temps t donn괻,
    mais dans une sous-expression, t peut 늯re diff굍ent. C'est par
    exemple le cas pour les op굍ateurs d(), dln(), sum(), ...
    On peut, grace � i, conna똳re la diff굍ence entre le t de calcul de la
    formule et le t de calcul de la sous-expression courante.

    On peut donc calculer des expressions comme
&CO
	sum(t-2, t-4, A / (1 - i)**2),
&TX
    qui 굌uivaut � :
&CO
	A[-2]/(1-(-2))**2 + A[-3]/(1-(-3))**2 + A[-4]/(1-(-4))**2
&TX
    Sans i, une telle expression ne peut 늯re 괹rite en LEC.

    Cet op굍ateur a 굏� impl굆ent� pour permettre la traduction de
    l'op굍ateur SUM de TROLL.

    Ainsi, si on calcule une expression pour un t donn�, i prend les
    valeurs suivantes selon les cas. Attention, les expressions
    indiqu괻s ci-dessous sont les formules compl둻es, et pas
    une sous-expression!

&CO
	- A + i == A + 0
	- d(A+i) == A + 0 - (A[-1] + -1)
	- l(i+1, A) == "A[-(i+1)]" == "A[-(0+1)]" == A[-1]
	- sum(t-1, t-2, i**2) == (-1)**2 + (-2)**2
	- sum(t-1, t-2, l(i-2, A) / i**2) ==
	    l((-1)-2, A) / (-1)**2 +
	    l((-2)-2, A) / (-2)**2        ==
		l(-3, A) / 1 +
		A[+3] + A[+4] / 4
&TX
&TI High to Low
컴컴컴컴컴�
    Correction dans le cas des fichiers input dont la derni둹e observation
    fait partie du calcul des s굍ies output : un fichier 93M1:94M12
    donnait la valeur NA pour l'ann괻 94.

>

<Version 4.59> (06/03/1995)
    Version 4.59 (06/03/1995)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Tableaux
컴컴컴컴
    Correction de la fonction de cr괶tion automatique (rapports).

&TI Listes
컴컴컴
    Toutes les listes g굈굍괻s ont pour s굋arateur le point-virgule au
    lieu de la virgule.

    Lors de l'importation de listes via XODE, les listes avec
    s굋arateur point-virgule sont correctement transf굍괻s et non
    plus scind괻s en plusieurs lignes s굋ar괻s n'importe o�.

>

<Version 4.58> (13/02/1995)
    Version 4.58 (13/02/1995)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Simulation
컴컴컴컴컴
    Les valeurs initiales des endog둵es sont calcul괻s 괾alement
    pour les blocs pr�- et post-r괹ursifs. Auparavant, seuls les
    endog둵es du bloc interd굋endant 굏aient initialis괻s.

&TI Tableaux
컴컴컴컴
    La cr괶tion automatique des tableaux s'est enrichie de deux nouvelles
    fonctionnalit굎 : au niveau des rapports et au niveau de la cr괶tion
    manuelle d'un tableau.

&IT    1. Dans les rapports
    컴컴컴컴컴컴컴컴컴컴
	La fonction $DataUpdateTbl a la syntaxe suivante :
&CO
	    $DataUpdateTbl table_name title;lec1;lec2;...
&TX
	Si title est un nom de commentaire, le commentaire est utilis�
	comme titre.
	De m늤e, si on trouve des noms de variables comme forme lec, et
	qu'il existe un commentaire pour ces variables, le titre de
	la ligne correspondante est remplac� par la valeur du
	commentaire.

&IT        Exemple
	컴컴컴�
	Supposons qu'il existe en WS un commentaire pour A et non pour
	B, et un commentaire TIT :
&CO
	    Commentaire A   : "Produit national brut"
	    Commentaire TIT : "Titre de mon tabelo"
&TX
	La ligne
&CO
		$DataUpdateTbl T1 TIT;A;B;A+B
&TX
	cr괻 le tableau T1 avec la forme suivante :
&CO
	    旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	    �          Titre de mon tabelo              �
	    �                                           �
	    �  Produit national brut               A    �
	    �  B                                   B    �
	    �  A+B                                 A+B  �
	    읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
&TX
&IT    2. Cr괶tion manuelle
    컴컴컴컴컴컴컴컴컴컴
	Les m늤es r둮les s'appliquent dans la cr괶tion d'un tableau. De
	plus, il est possible d'utiliser des listes dans le champ de
	d괽inition des formes LEC.


>


<Version 4.57> (25/01/1995)
    Version 4.57 (25/01/1995)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Estimation
컴컴컴컴컴
    1. L'괹ran de d괽inition des 굌uations reprend dor굈avant les
       valeurs des tests avec 3 d괹imales, y compris dans le cas
       des blocs d'굌uations. Ces m늤es tests sont sauv굎 dans
       toutes les 굌uations du bloc.

    2. L'impression des coefficients se fait en format d괹imal dans
       tous les cas, alors qu'auparavant le format d굋endait de
       la valeur (1e-03 au lieu de 0.001).

>


<Version 4.56> (02/12/1994)
    Version 4.56 (02/12/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Xode
컴컴
&EN (R�-)Adaptation de XODE pour la lecture des donn괻s des fichiers NIS.
&EN  Correction de la lecture des tableaux ascii.

&TI Iode/Tableaux
컴컴컴컴컴컴�
    Le nombre maximum de colonnes d'un tableau est port� � 20. Rappelons
    cependant que la taille totale d'un objet ne peut d굋asser 16000
    bytes (texte, formules LEC, donn괻s internes). Plus le nombre de
    colonnes est 굃굒�, plus le nombre de lignes devra 늯re limit� !

>

<Version 4.55> (28/10/1994)
    Version 4.55 (28/10/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Xode
컴컴
    Adaptation au nouveau format des fichiers NIS.

&TI Fode
컴컴
    Am굃ioration de la version batch du programme. La nouvelle syntaxe
    est :
&CO
	fode[32] -i file ... -o outputfile
&TX
    Dans le cas o� fode est lanc� sans param둻re, il fonctionne
    comme avant en mode interactif.
    Sinon, les fichiers suivant -i sont trait굎 et le r굎ultat
    est plac� dans le fichier ASCII d괽ini par le param둻re -o.

    Am굃ioration de la pr굎entation en colonnes lorsque le texte
    d'une colonne s'굏end sur plusieurs lignes.

>

<Version 4.54> (23/08/1994)
    Version 4.54 (23/08/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Editeur MMT
컴컴컴컴컴�
    Le sauvetage d'un fichier 괺it� � l'aide de l'괺iteur int괾r� MMT
    pla놹it des tabulations en d괷ut de lignes lorsqu'au moins 8
    blancs 굏aient pr굎ents. Lors de l'impression d'un tel fichier
    (par exemple dans le cadre de FODE), ces blancs de d괷ut de lignes
    semblaient - sur certaines imprimantes - 늯re ignor굎. En fait,
    les imprimantes ne repr굎entent pas toutes les tabulations de la
    m늤e mani둹e, ce qui explique les 굒entuels probl둴es.

    Pour pallier ces inconv굈ients, l'괺iteur int괾r� MMT sauve
    dor굈avant tous les blancs comme tels, sans remplacer les suites
    de 8 blancs par des tabulations.


    Attention : cette modification n'est valable que dans IODE, TODE,
		FODE, etc, mais pas dans le programme ind굋endant MMT.

&TI Xode
컴컴
    Rules file : une ligne blanche intercalaire arr늯ait le processus de
    lecture. Dor굈avant les lignes blanches sont ignor괻s.

&TI Xode : Export by rule
컴컴컴컴컴컴컴컴컴컴�

    Cette nouvelle option permet de g굈굍er des fichiers
    de donn괻s en formats externes : Comma separated values (CSV), TSP,
    WKS (Lotus/Excel), DIF.

    Le nom du fichier de variables est requis.

    Le fichier des "rules" permet de limiter les variables � exporter et
    굒entuellement d'en changer les noms.

    Si un fichier de commentaires est indiqu�, chaque variable est
    accompagn괻 der son commentaire.

    Si le sample n'est pas pr괹is�, toutes les observations sont
    fournies dans le fichier r굎ultat.

    Dans le cas du format CSV, deux 굃굆ents sont libres : le s굋arateur
    de colonnes (par d괽aut ;) et la repr굎entation de la valeur
    inconnue (par d괽aut ##N/A).

    Dans le cas des fichiers WKS, un "Label" est associ� � chaque range
    de valeurs, ce label 굏ant identique au code de la s굍ie.

&TI Xode
컴컴
    La fonction d'importation de XODE accepte les valeurs des tests
    statistiques de l'estimation sous forme d'un mot-cl� et de la
    valeur du test. Par exemple :
&CO
	STDEV 0.228351
	MEANY 2.68489
	SSRES 0.00182236
	STDERR 0.0142297
	FSTAT 2566.21
	R2 0.996505
	R2ADJ 0.996117
	DW 0.512136
	LOGLIK 32.272
&TX
    Ces informations sont g굈굍괻s automatiquement par la fonction
    d'exportation de XODE.
>

<Version 4.53> (06/06/1994)
    Version 4.53 (06/06/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Rapports
컴컴컴컴
    La fonction $ReportExec accepte une liste comme argument :
&CO
	    $ReportExec test $LISTE
&TX
    re뇇it comme argument les 굃굆ents de la liste $LISTE et permet
    donc d'ex괹uter un rapport type sur un nombre initialement
    inconnu d'arguments. Par exemple, pour remplacer tous les 0 par
    des NA pour la liste $LISTE de variables, il suffit de faire :


    FICHIER ZTONA.REP
    컴컴컴컴컴컴컴컴�
&CO
	$label again
	$goto fin {%0%=0}
	##show arg0 : %1%
	$DataCalcVar %1% if(%1%=0, 1/0, %1%)
	$shift
	$goto again
	$label fin
&TX
    APPEL
    컴컴�
&CO
	$ReportExec ztona $LISTE
&TX
	ou, dans l'괹ran d'ex괹ution :
&CO
	Report Name : ztona.rep
	Argument    : $LISTE
&TX

&TI Lec
컴�
    La fonction moyenne mobile
&CO
	ma(n, expr)
&TX
    n'existait que sous le nom
&CO
	mavg(, expr)
&TX
    suite � une erreur dans le manuel.

    Les deux sont dor굈avant disponibles.

&TI Simulation
컴컴컴컴컴
    Correction : lorsqu'une liste d'굌uations est introduite et que
    cette liste n'existe pas, un message d'erreur est produit. Auparavant,
    toutes les 굌uations 굏aient simul괻s.

&TI Saisie de valeurs
컴컴컴컴컴컴컴컴�
    Dans l'괺ition manuelle des donn괻s (WS de variables ou via
    tableaux), quelques modifications ont 굏� apport괻s pour am굃iorer
    l'interface :

&EN les 8 chiffres significatifs sont affich굎
&EN si l'affichage de la valeur d굋asse la taille de la cellule,
	  celle-ci est temporairement agrandie.
&EN lors de la saisie via tableau, les 8 chiffres significatifs
	  sont conserv굎

&TI Rappel
    컴컴컴
	    Il est inutile d'esp굍er que plus de 8 chiffres significatifs
	    soient conserv굎 dans les valeurs des s굍ies : les valeurs
	    "float" affichent n'importe quoi au-del� du huiti둴e chiffre.
	    Ainsi, la valeur 0.012345678 exploite toute la pr괹ision
	    disponible est introduire 0.012345678912 ne modifiera plus la
	    valeur machine du nombre.
>

<Version 4.52> (24/05/1994)
    Version 4.52 (24/05/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Corrections
컴컴컴컴컴�
&EN Impressions des tableaux : correction de la s굋aration entre les
      colonnes.
&EN Rapports : comportement bizarre en version 16 bits
&EN Estimation : si le nombre de degr굎 de libert� est 0, les tests
	    sont corrig굎

&TI Trend Correction
컴컴컴컴컴컴컴컴
    Impl굆entation de la m굏hode Hodrick-Prescott pour la construction
    de s굍ie de trend. Le principe est le m늤e que pour la
    dessaisonnalisation : les s굍ies lues dans un fichier sont import괻s
    et transform괻s simultan굆ent.

    Une note technique de Bart Hertveldt d괹rit la m굏hode et son
    utilisation.

    Les fonctions de rapport ont la syntaxe suivante :
&CO
	$WsTrend VarFilename Lambda series1 series2 ...
	##WsTrend (interactive)
&TX
>

<Version 4.51> (15/04/1994)
    Version 4.51 (15/04/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Impressions de tableaux
컴컴컴컴컴컴컴컴컴컴
    La s굋aration entre les colonnes des tableaux en Postscript est
    ajust괻 pour permettre de placer plus de colonnes sur une m늤e page.

&TI Edition de tableaux
컴컴컴컴컴컴컴컴컴컴
    La derni둹e ligne de l'괹ran contient une indication sur les
    attributs de la cellule s굃ectionn괻 : cadrage et polices de
    caract둹es.
>

<Version 4.50> (18/03/1994)
    Version 4.50 (18/03/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Lec
컴�
    Les formules faisant intervenir des lags n괾atifs (leads), du
    type l(-2, A), dln(-2, X+Y), retournaient un r굎ultat incorrect en
    raison des arrondis des nombres n괾atifs.

    Cette erreur est corrig괻 et, par exemple, si A vaut 1, 2, 3, 4, ...,
    l(2, A) vaut 3, 4, ..., tandis que l(-2, A) vaut --, --, 1, 2, ...
>

<Version 4.49> (23/02/1994)
    Version 4.49 (23/02/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Xode
컴컴
    Correction d'un Bug : l'exportation en ASCII de tableaux dont
    certaines cellules 굏aient vides 굏aient incorrecte : ces cellules
    굏aient "saut괻s". Lors de la r굀mportation de tableaux, il en
    r굎ultait un d괹alage dans les colonnes.

    Typiquement, la premi둹e ligne contenant la p굍iode "##s" dans
    la deuxi둴e colonne se voyait modifi괻 par deux xode successifs :
    avant on avait une premi둹e colonne vide, apr둺, la premi둹e colonne
    contenait la p굍iode :
&CO
	AVANT :        ""            "##s"
	APRES :        "##s"          ""
&TX

>

<Version 4.48> (16/02/1994)
    Version 4.48 (16/02/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�
&TI Impression de tableaux
컴컴컴컴�
 Option fixed width characters pour les tableaux o� l'alignement
      est n괹essaire

&TI Lec
컴�
Les calculs incorporant des p굍iodes dans des fonctions telles
      que sum() ou mean() 굏aient incorrects lorsque ces p굍iodes
      굏aient n괾atives (mean(-2, X)). Cette erreur est corrig괻.

&TI Simulation et extrapolation
컴컴컴컴컴컴컴컴컴컴컴컴컴�
 Deux options compl굆entaires permettent de prolonger une s굍ie
      ou de choisir le point de d굋art d'une simulation en prenant la
      valeur de l'ann괻 pr괹괺ente ou une extrapolation des deux ann괻s
      pr괹괺entes uniquement si la valeur courante est NA.
>

<Version 4.47> (10/02/1994)
    Version 4.47 (10/02/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI View Tables and Graphics
컴컴컴컴컴컴컴컴컴컴컴컴
    Lorsque plusieurs tableaux doivent 늯re affich굎 (sous forme de
    graphique ou de tableau de nombres), un tableau d굍oulant reprenant le
    nom de chaque tableau ainsi que son titre est propos�.

    Il suffit de presser ENTER sur le tableau souhait� pour afficher le
    r굎ultat (tableau ou graphique).


&TI Edit Objects
컴컴컴컴컴컴
    Lors de l'괺ition des objets, un sous-menu propose d'괺iter
    tout le WS ou seulement une liste. De plus, F10 permet d'entrer
    directement en 괺ition de tout le WS.

    Dans le cas des listes, diff굍entes fonctions ont 굏� regroup괻s
    � ce niveau du menu et certaines se sont ajout괻s :

&EN         Recherche de texte dans les objets
&EN         Tri des listes
&EN         Analyse (Scan) de WS
&EN         Stocker la liste des objets d'un fichier ou du WS
&EN         Effectuer des op굍ations (intersection, union, diff굍ence)
	  sur des listes
&EN         Calculer le nombre d'굃굆ents d'une liste

    Dans le cas des variables, une nouvelle fonction permet la mise
    � jour des s굍ies par le biais de tableaux. Si plusieurs tableaux sont
    demand굎, un menu avec les tableaux est affich�, et non plus tous les
    tableaux successivement.

    Les fonctions de rapports correspondantes sont :

&CO
	    - $DataListVar name pattern [file]
	    - $DataCalcLst res lst1 op lst2
		    o� op = {+,*,-}

	    - $ViewByTbl list
&TX

&TI Sample
컴컴컴
    Les p굍iodes d괽inies dans les 괹rans DataEditGraph, IdtExecute et
    ModelSimulate sont adapt괻s lors d'un changement du sample du WS ou
    lors d'un chargement de fichier de variables.

    Cette modification a lieu dans les cas suivants :

&EN         periodicit� WS != nouvelle periodicit�
&EN         si WS.from >> nouveau from
&EN         si WS.to   << nouveau to

&TI Graph sur base de s굍ies
컴컴컴컴컴컴컴컴컴컴컴컴
&EN F8 dans le tableau d굍oulant des variables affiche le graphique de
      la s굍ie sur laquelle le curseur se trouve avec les propri굏굎 du
      plus r괹ent appel � la fonction DataEditGraph

&EN Shift-F8 dans le m늤e tableau remplace l'ancien F8 et permet donc
      de grouper plusieurs s굍ies sur le m늤e graphique. De plus, cette
      fonction permet de modifier les propri굏굎 (Sample, type, ...) des
      futurs graphiques affich굎 � l'aide de F8.

&TI Ex괹ution directe d'identit굎
컴컴컴컴컴컴컴컴컴컴컴컴컴컴
&EN F7 dans le tableau d굍oulant des identit굎 ex괹ute l'identit�
      courante sur toute la p굍iode du WS

&EN Shift-F7 lance la fonction IdtExecute

&TI Xode bug (HP)
컴컴컴컴컴컴�
&EN xode -i *.eqs fonctionne
&EN impression en PostScript fonctionne � nouveau

&TI DataCompare
컴컴컴컴컴�
    Le contenu du WS courant peut 늯re compar� � celui d'un fichier.
    Le r굎ultat de cette comparaison est compos� de 4 listes :

&EN         objets trouv굎 dans le WS seulement
&EN         objets trouv굎 dans le fichier seulement
&EN         objets trouv굎 dans les deux, avec la m늤e d괽inition
&EN         objets trouv굎 dans les deux, avec une d괽inition diff굍ente

    Dans un rapport :
&CO
    $DataCompareXxx file ONE TWO THREE FOR

	  ONE         in WS only
	  TWO         in file only
	  THREE       in both, equal
	  FOR         in both, different
&TX

&TI Estimate
컴컴컴컴
    Une fonction de construction automatique d'ajustements dynamiques
    est ajout괻 dans le panneau de d괽inition d'굌uation.
    Deux m굏hodes sont disponibles :

    Partial Adjustment (1 coefficient c1):
&CO
	lhs := rhs ->> d(lhs) := c1 * (rhs -(lhs)[-1])
&TX
    Error Correction Model (deux coefficients c1 et c2):
&CO
	lhs := rhs ->> d(lhs) := c1 * d(rhs) + c2 * (rhs-lhs)[-1]
&TX
&TI Load et Save de WS
컴컴컴컴컴컴컴컴컴
    Lors de la lecture et de l'괹riture des WS sur disque, des
    v굍ifications compl굆entaires sont effectu괻s pour s'assurer de la
    bonne fin de l'op굍ation (notamment de le cas de timeout sur
    r굎eau).

&TI Object Names
컴컴컴컴컴컴
    Les noms des objets sont v굍ifi굎 lors de leur cr괶tion et ne
    peuvent contenir que des lettres, chiffres ou le caract둹e _.
    En outre, le premier caract둹e ne peut 늯re un chiffre.

&TI Qode
컴컴
    Nouvelle option -fw pour l'impression des tableaux a2m. Cette option
    remplace les caract둹es proportionnels standards par des non
    proportionnels. Le but est de conserver l'alignement dans
    les tableaux contenant des blancs.

&TI Impression de tableaux
컴컴컴컴�
    Bug solutionn� : l'impression avec un sample erronn� donne un
      message d'erreur.

&TI Seasonal Adjustment
컴컴컴컴컴컴컴컴컴�
    Une message d'erreur est affich� si une variable n'existe pas dans
    le fichier indiqu�.

&TI Bug connu
컴컴컴컴�
    Dans la seule version 16 bits, le remplacement r괹ursif des listes
    par leur valeur peut cr괻r une erreur si plus de 3 niveaux
    d'imbrication sont n괹essaires.
&CO
	A = $B
	B = $C
	C = $D
&TX
    L'utilisation de $A peut entra똭er une erreur.
>

<Version 4.45-4.46> (05/01/1994)
    Version 4.45-4.46 (05/01/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

&TI Gode
컴컴
    L'impression de graphiques dans IODE32 restait dans le programme
    GODE32. Il fallait donc quitter le programme GODE (a-X) pour revenir
    � IODE32. Cette erreur est � pr굎ent corrig괻.

&TI Reports
컴컴컴�
    La macro %0% est le nombre d'arguments du rapport.

&TI Simulation
컴컴컴컴컴
    La simulation peut 늯re interrompu par l'utilisateur.

&TI Xode
컴컴
    Nouveau format d'importation : PRN d'AREMOS : le fichier
    des variables se pr굎ente comme suit :
&CO
	"VARNAME" val1 val2 ....
	...
&TX

>

<Version 4.44> (04/01/1994)
    Version 4.44 (04/01/1994)
    컴컴컴컴컴컴컴컴컴컴컴컴�

&TI Dessaisonalisation
컴컴컴컴컴컴컴컴컴
    Cette fonction est op굍ationnelle pour les s굍ies comprenant des
    nombres n괾atifs. (corrig괻)

&TI Installation
컴컴컴컴컴컴
    Nouveau programme d'installation, guidant l'utilisateur, notamment
    en indiquant l'espace disponible sur chaque disque, en modifiant
    le fichier autoexec.bat et en permettant d'adapter le fichier
    printcap de d괽inition des imprimantes.

&TI Rapport
컴컴컴�
    La macro %0% est le nombre d'arguments du rapport.


&TI Xode
컴컴
    Nouveaux formats import굎 (variables et commentaires) : fichiers de
    type PRN g굈굍굎 par AREMOS.

&TI Simulation
컴컴컴컴컴
    Lorsqu'une 굌uation n'est pas d괽inie explicitement par rapport �
    son endog둵e ou lorsque celle-ci appara똳 plusieurs fois dans
    l'굌uation, l'algorithme de simulation essaie de r굎oudre cette
    굌uation par une m굏hode de Newton. Si cette m굏hode ne fournit pas
    de r굎ultat, une m굏hode de type s괹ante recherche � son tour une
    solution pour l'굌uation.

    Il n'est cependant pas garanti qu'une solution soit obtenue dans
    tous les cas. Les fonctions non continues (singularit굎) comme
&CO
	X := a + b * 1 / (X + 1)
&TX
    peuvent poser des probl둴es en passant par la valeur -1.
    En cas de probl둴e, la seule solution actuelle est de modifier la
    forme de l'굌uation :
&CO
	(X - a) * (X + 1) := b
&TX
>

