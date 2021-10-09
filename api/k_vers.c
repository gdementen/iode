/*
 * @author Jean-Marc PAUL
 * @author Geert BRYON
 *
 * Functions to retrieve the current IODE version.
 *
 *    char *K_LastVersion()
 *    char *K_CurrentVersion()
 */

#include "iode.h"

/********************************************************
Retourne un string allou� contenant le contenu du fichier
 version.txt sur le site iode.plan.be.
*********************************************************/

/**
 *  Returns in an allocated string the content of the file http://iode.plan.be/version.txt. 
 *  That file contains the string "IODE <major>.<minor>" with the latest version of IODE.
 *  
 *  @return     char* last version of IODE on the web site.
 *  
 *  @note   The function SCR_HttpGetFile("iode.plan.be", 80, "version.txt") does not work as expected. Therefore, 
 *          the value returned is the current IODE version (K_CurrentVersion()) as of version 6.xx.
 *  
 *   TODO: specify the version (6.xx) from which the file could no longer be read from the website.
 */
char *K_LastVersion()
{
    char *vers;

    /* Annul� car le retour http ne fonctionne plus comme avant.
    vers = SCR_HttpGetFile("iode.plan.be", 80, "version.txt");

    Debug("iode version => '%s'\n", vers);
    if(vers) {
    	if(strlen(vers) > 9) vers[9] = 0;
    	return(vers);
    }
    return(K_CurrentVersion());
    */

    return(K_CurrentVersion());
}

/********************************************************
Retourne un string allou� contenant la version courante de IODE
"IODE 6.45" par exemple.
*********************************************************/

/**
 *  Returns in an allocated string with the IODE version of the current executable in the form 
 *      "IODE <major>.<minor>" where minor and major come from iode.ini. 
 *  
 *  @return     char* current version of IODE
 *   
 */

char *K_CurrentVersion()
{
    char buf[30];

    sprintf(buf, "IODE %d.%d", IODE_VERSION_MAJOR, IODE_VERSION_MINOR);
    return(SCR_stracpy(buf));
}

