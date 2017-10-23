#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Nikooo777"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <EasyHTTP>

#pragma newdecls required


public Plugin myinfo = 
{
	name = "Crypto-Trades",
	author = PLUGIN_AUTHOR,
	description = "A plugin that allows Crypto transactions between players",
	version = PLUGIN_VERSION,
	url = "https://go-free.info"
};

public void OnPluginStart()
{

}

public void OnMapStart()
{

}

stock bool IsValidClient(int client)
{ 
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || IsFakeClient(client))
	{
		return false; 
	}
	return IsClientInGame(client); 
}