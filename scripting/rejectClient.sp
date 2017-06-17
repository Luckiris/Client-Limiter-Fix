#pragma semicolon 1

#include <sourcemod>

#pragma newdecls required

//variables
int client_online;

//convars
ConVar convar_maxclient;

public Plugin myinfo = 
{
	name = "Reject client",
	author = "Luckiris",
	description = "Reject client when server is full (block connect by console)",
	version = "1.0",
	url = "http://dream-community.de/"
};

public void OnPluginStart()
{
	client_online = 0;
	convar_maxclient = CreateConVar("rejectClient_maxplayers", "20", "Maximum number of players that the server should have.");
	AutoExecConfig(true, "rejectClient");
}

public void OnClientConnected(int client)
{
	client_online++;
}

public void OnClientPostAdminCheck(int client)
{
	if ((client_online >= convar_maxclient.IntValue) && (!CheckCommandAccess(client, "sm_admin", ADMFLAG_BAN, true)))
	{
		KickClient(client, "Server is full !");
	}
}

public void OnClientDisconnect_Post(int client)
{
	client_online--;
}