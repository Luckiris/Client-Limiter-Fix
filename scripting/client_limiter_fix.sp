#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

/* Global var of the plugin */
int gClientsOnline; // -> Counter of the clients who are online

/* ConVar of the plugin */
ConVar cvMaxClients; // -> ConVar of the client limit

public Plugin myinfo = 
{
	name = "CLient Limiter Fix",
	author = "Luckiris",
	description = "Reject client when server is full (limit set up in cfg)",
	version = "1.2",
	url = "http://dream-community.de/"
};

public void OnPluginStart()
{
	/* Loading the translations */
	LoadTranslations("clientLimiter.phrases");
	
	/* Initialisation of the counter of online clients */
	gClientsOnline = 0;
	
	/* ConVar of the limit stored in the config file */
	cvMaxClients = CreateConVar("sm_clientLimiter_maxplayers", "20", "Maximum number of players that the server should have.");
	
	/* Creation of the config file */
	AutoExecConfig(true, "clientLimiter");
}

public void OnClientConnected(int client)
{
	/* A new client is connected to the server
	   Increasing the global var of the counter of online clients
	*/ 
	gClientsOnline++;
}

public void OnClientPostAdminCheck(int client)
{
	/* Check if the number of online client is outside the limits 
	   Check at the same moment if the client has the ban flag
	   
	   IF the client dosen't meet the requirments
	   THEN the client is kicked from the server
	*/
	if ((gClientsOnline > GetConVarInt(cvMaxClients)) && (!CheckCommandAccess(client, "sm_admin", ADMFLAG_BAN, true)))
	{
		KickClient(client, "%t", "Kicked");
	}
}

public void OnClientDisconnect_Post(int client)
{
	/* A client left the server
	   Decreasing the global var of the counter of online clients
	*/ 
	gClientsOnline--;
}