/* A2M */

LINE 2 COL 1 NL 20 NC 78
START

..esc ~

#include "macros.h"

<Le programme A2M>
    Le programme A2M
    컴컴컴컴컴컴컴컴

..esc ~

.~a'a2m.gif'

Le programme ~ca2m~C convertit des textes ASCII comprenant ou non des commandes
A2M en divers autres formats et permet de lancer l'impression de
fichiers sur divers types d'imprimantes selon des proc괺ures d괽inies
par l'utilisateur.

&EN <Introduction>
&EN <L'interface utilisateur> : le panneau principal
&EN <Le menu File>            : quitter l'application
&EN <Le menu Options>         : les options de conversion
&EN <Le menu HTML Tools>      : op굍ations sur des fichiers HTML
&EN <Le menu Help>            : l'aide en ligne

>


<Introduction>
    Introduction
    컴컴컴컴컴컴

Les commandes A2M sont des commandes de formatage de paragraphes ou de
textes, elle permettent 괾alement d'inclure et de formater des graphiques,
des tableaux, de g굍er les couleurs du document, etc...

Un fichier en format A2M peut 늯re traduit en diff굍ents formats :

&EN GDI, format d'impression directe sous Windows
&EN RTF, interpr굏able par Word, WordPerfect, etc
&EN MIF, langage structur� des documents Frame Maker
&EN RTF-HLP, source d'un fichier d'aide de Windows 95
&EN HTML, format des documents Internet (Web)
&EN CSV, comma separated value

Selon la destination de l'impression, des tags ou commandes seront soit
interpr굏굎 diff굍emment, soit inop굍ants. Ainsi par exemple, les images ne
peuvent 늯re incorpor괻s dans des fichiers ASCII ou les sujets d'aide n'ont
de signification que dans le cadre des fichiers d'aide.

>


<L'interface utilisateur>
    L'interface utilisateur
    컴컴컴컴컴컴컴컴컴컴컴�

L'interface utilisateur comprend, outre les 굃굆ents classiques d'une
fen늯re Windows:

&EN le menu d굍oulant permetant notamment de d괽inir les options de
conversion. Les points du menu sont d괹rite ci-apr둺.

&EN le bouton "Translate" qui lance la conversion du document A2M

&EN le bouton "Exit" qui permet de quitter l'application

&EN le bouton "Help" qui donne acc둺 � l'aide en ligne

&EN le menu d굍oulant "Destination" qui permet de d괽inir le type de
conversion � op굍er sur le document A2M. Un clic dans la fl둩he vers le bas
de ce champ donne la liste des destinations possibles.

&EN le champ "Input file" qui doit contenir le nom du fichier � convertir.
Le bouton "..." � droite du champ permet de parcourir le syst둴e de fichier
afin de localiser ce fichier si n괹essaire.

&EN le champ "Destination file" qui doit contenir (sauf dans le cas d'une
impression directe sur une imprimante windows) le nom du fichier de
destination, r굎ultat de la conversion. Le bouton "..." � droite du champ
permet de parcourir le syst둴e de fichier afin de pr괹iser la localisation
de ce fichier.

Les touches de fonction F10, Esc et F1 permettent respectivement de
lancer la conversion, de quitter l'application ou d'appeler l'aide en ligne
de l'application. D'autres touches de fonction sont 굒entuellement actives
dans les autres pages, leur liste apparait en commentaire en bas de fen늯re.

Pendant la conversion, un message en bas de fen늯re informe l'utilisateur du
d굍oulement des op굍ations (nombre d'objet lus et interpr굏굎, nombre de
pages imprim괻s).

Enfin, le programme peut 늯re lanc� en cliquant sur un fichier A2M identifi�
par l'icone appropri괻 � l'aide de l'exploreur de Windows. Dans ce cas, le
nom du fichier s굃ectionn� est automatiquement import� dans le champ "Input
File" de l'application.

>


<Le menu File>
    Le menu File
    컴컴컴컴컴컴

Le menu File permet de quitter l'application. On peut quitter l'application
괾alement avec le bouton "Exit" du panneau principal ou en tapant
simultan굆ent les touches ALT et X en n'importe quel endroit du programme.

>
<Le menu Options>
    Le menu Options
    컴컴컴컴컴컴컴�

.~a'a2mopt.gif'

Le menu option donne acc둺 aux param둻res de d괽inition du fichier A2M
d'origine (panneau "General") ainsi qu'aux param둻res pouvant modifer le
r굎ultat final de la conversion en diff굍ents formats (imprimante, MIF, RTF,
HTML, ....).

Les options standard sont correctes dans la grandes majorit� des cas, et
l'utilisateur n'a pas en principe � les modifier.

Les modifications sont conserv괻s lors des utilisations ult굍ieures du
programme.

Les param둻res suivants sont accessibles:

&EN <la fiche "General">        : structure du fichier A2M d'origine
&EN <la fiche "Windows printer">: particularit굎 d'une impression
&EN <la fiche "MIF">            : output dans un fichier MIF
&EN <la fiche "RTF">            : output dans un fichier RTF
&EN <la fiche "HTML">           : output dans un fichier HTML
&EN <la fiche "CSV">            : output dans un fichier CSV


>

<la fiche "General">
    La fiche "General"
    컴컴컴컴컴컴컴컴컴
.~a'a2mgnl.png'

Nous renvoyons au manuel de r괽굍ence pour les d굏ails de la syntaxe de A2M.

&EN Le caract둹e d'괹happement (Escape character) permet de d괽inir le
caract둹e qui d괷ute une s굌uence d'attribut typographiques, d'insertion
d'objet ou d'hyperlien dans la suite du texte. Par d괽aut, ce caract둹e est
le BACKSLASH (\). La commande ".esc" dans le fichier A2M permet de modifier
cette option.

&EN Le caract둹e de commande est celui qui annonce, en d괷ut de ligne, une
commande de mise en page du document.

&EN Le caract둹e de d괽inition est le caract둹e de d괷ut d'une macro
(define). Ce caract둹e est interpr굏� uniquement si le mot qui le suit est
une macro. Si ce n'est pas le cas, il est imprim� comme tel.

>

<la fiche "Windows printer">
    la fiche "Windows printer"
    컴컴컴컴컴컴컴컴컴컴컴컴컴

La fiche permet de configurer certaines options de filtrages appliqu괻s sur
le fichier A2M avant l'envoi sur le pilote d'impression de Windows.

.~a'a2mwin.gif'

Pour le texte, l'utilisateur peut choisir de conserver les attributs de
couleur, la num굍otation des paragraphes, la police et la taille du
caract둹e et l'incr굆ent utilis� par la commande d'attribut typographique S.

Pour la page, l'utilisateur peut d괽inir les marges et les r괽굍ences de
haut et de bas de page.

Pour les tableaux et les graphiques, l'utilisateur peut choisir diverses
options de d괹oupage et de mise en page.


>
<la fiche "CSV">
    La fiche "CSV"
    컴컴컴컴컴컴컴

La fiche CSV permet de param둻rer la conversion de tableaux en format A2M en
format CSV (comma saparated value).

.~a'a2mcsv.gif'

On peut d괽inir le s굋arateur de cellules, le caract둹e "quote" et le
remplacement 굒entuel du contenu "Not Available".


>
<la fiche "MIF">
    La fiche "MIF"
    컴컴컴컴컴컴컴

La fiche permet de configurer certaines options de filtrages appliqu괻s sur
le fichier A2M lors de la transformation en fichier MIF (Maker Interchange
Format).

.~a'a2mmif.gif'

L'utilisateur peut choisir la police et la taille des caract둹es � utiliser
dans le texte et les tableaux.


Pour les tableaux l'utilisateur peut choisir diverses
options de d괹oupage et de formatage (taille des colonnes et quadrillage).

On peut enfin inclure ou non l'ancrage d'images (commande .a dans le fichier
A2M).

>
<la fiche "RTF">
    La fiche "RTF"
    컴컴컴컴컴컴컴

La fiche permet de configurer certaines options de filtrages appliqu괻s sur
le fichier A2M lors de la transformation en fichier RTF (Rich Text Format).

.~a'a2mrtf.gif'

Pour le texte, l'utilisateur peut choisir de conserver la num굍otation des
paragraphes, la police et la taille du caract둹e et l'incr굆ent utilis� par
la commande d'attribut typographique S.

Pour les tableaux, l'utilisateur peut choisir diverses
options de d괹oupage et de mise en page (taille des colonnes et
quadrillage).

Enfin, certaines options peuvent 늯re d괽inies en vue de la pr굋aration d'un
fichier pr늯 � 늯re compil� par compilateur d'aide de Windows (Help Compiler
for Windows).



>
<la fiche "HTML">
    La fiche "HTML"
    컴컴컴컴컴컴컴�

La fiche permet de configurer certaines options de filtrages appliqu괻s sur
le fichier A2M lors de la transformation en fichier HTML (HyperText Markup
Language, version 2.0 standardis괻 par la note RFC1866).

.~a'a2mhtm.gif'

L'utilisateur peut choisir la police et la taille des caract둹es � utiliser
dans le texte et les tableaux.


Pour les tableaux l'utilisateur peut choisir un filtrage couleur et
l'굋aisseur de l'encadrement.

Enfin, l'utilisateur peut sp괹ifier diverses options propres au langage
HTML comme un titre ou des options paticuli둹es � la commande BODY.


>


<Le menu HTML Tools>
    Le menu HTML Tools
    컴컴컴컴컴컴컴컴컴

.~a'a2mhtml.gif'

Le menu HTML Tools donne acc둺 � une s굍ie d'outils permettant de modifier
un fichier HTML apr둺 sa cr괶tion:

&EN <Split HTML file>           : d괹oupe un fichier HTML
&EN <Generate Table of Contents>: g굈둹e une table des mati둹es
&EN <Replace a HTML section>    : remplace une section de fichier

Les r괽굍ences internes dans le fichier et entre 굃굆ents des nouveaux
fichiers sont conh굍entes.


>
<Split HTML file>
    Split HTML file
    컴컴컴컴컴컴컴�

Ce programme d괹oupe un fichier HTML en sous fichiers. Les d괹oupes
ont lieu sur les tags Hn qui indiquent les niveaux de chapitres
dans les fichiers HTML.

A partir d'un fichier unique, 굒entuellement de grande taille, un
nombre quelconque de fichiers sont g굈굍굎, selon le niveau de d괹oupe
demand�.

Le titre de chaque sous-fichier est repris dans le fichier de niveau
sup굍ieur avec le lien vers le sous-fichier.


Les noms des fichiers g굈굍굎 sont constitu굎 en ajoutant un
num굍o d'ordre � la racine du fichier output.

La page permet de sp괹ifier les param둻res utiles � la d괹oupe:

&EN Le nom du fichier source et
&EN le niveau n de la d괹oupe.
&EN La racine du nom du fichier output
&EN Le titre, l'image du background et l'icone de retour � la page
    pr괹edente.
>

<Generate Table of Contents>
    Generate Table of Contents
    컴컴컴컴컴컴컴컴컴컴컴컴컴

Ce programme analyse un fichier HTML et ses sous fichiers. Il g굈굍e
simultan굆ent une table des mati둹es sur base des tags <<Hn>> (qui
indiquent les niveaux de chapitres dans les fichiers HTML).

Le titre de chaque chapitre est repris avec le lien vers le
sous-fichier et si un tag NAME est pr굎ent, vers la position
dans ce sous-fichier.

Le fichier r굎ultat n'est pas un fichier HTML complet dans la mesure o�
il est par la suite destinn� � 늯re int괾r� dans un fichier plus vaste.

Le fichier d괷ute par un tag sp괹ial !STARTTOC et se termine par
un autre: !ENDTOC. Ces deux tags pourront par la suite servir
d'indication au sous-programme de substitution (voir "Replace a HTML
section").

.~a'a2mhtm2.gif'

La page permet de sp괹ifier le fichier source, le fichier r굎ultat et le
niveau de chapitre � inclure dans la table des mati둹es.


>
<Replace a HTML section>
    Replace a HTML section
    컴컴컴컴컴컴컴컴컴컴컴

Ce programme recherche deux tags sp괹iaux (from TAG et to TAG) dans un
fichier et remplace tout ce qui se trouve entre ces deux tags par le contenu
d'un autre fichier.

Cette fonction est particuli둹ement utile dans le cas des fichiers HTML:
elle permet par exemple de remplacer en une seule op굍ation les barres
de navigation dans tous les fichiers d'un site, ou d'inclure une table
des mati둹es (!STARTTOC et !ENDTOC).


.~a'a2mhtm3.gif'

La page permet de d괽inir les tags de d괷ut et de fin de substitution (par
d괽aut !STARTHEADER et !STOPHEADER), le fichier contenant le texte �
substituer et le fichier o� doit s'op굍er la substitution. Il est possible
(et recommand�) de sauvegarder le texte d'origine (backup) et de parcourir
r괹urcivement un arbre de r굋ertoires.

>




<Le menu Help>
    Le menu Help
    컴컴컴컴컴컴

Ce point de la barre d'action permet d'appeler, au m늤e titre que la touche
F1 ou le bouton Help, une aide conceptuelle en ligne avec table des mati둹es
et index.

>
















