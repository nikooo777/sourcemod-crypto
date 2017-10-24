#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Nikooo777"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>
#include <httpreq>

#pragma newdecls required
#define RPC_PORT 9245
#define RPC_USER "lbry"
#define RPC_PASSWORD "change_m3"

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
    RegConsoleCmd("sm_wallet", getWalletAddress, "Returns an address associated with your account");
}

public void OnRequestComplete(bool bSuccess, int iStatusCode, StringMap tHeaders, const char[] sBody, int iErrorType, int iErrorNum, any data)
{
    if (bSuccess) {
        PrintToServer("finished request with status code %d", iStatusCode);

        PrintToServer("headers:");

        char sKey[128], sValue[512];
        StringMapSnapshot tHeadersSnapshot = tHeaders.Snapshot();
        for (int i = 0; i < tHeadersSnapshot.Length; ++i) {
            tHeadersSnapshot.GetKey(i, sKey, sizeof(sKey));
            tHeaders.GetString(sKey, sValue, sizeof(sValue));
            PrintToServer("%s => %s", sKey, sValue);
        }
        PrintToChat(data, "Your personal address LBRY is: %s",sBody);
        PrintToServer("response: %s", sBody);
    } else {
        PrintToServer("failed request with error type %d, error num %d", iErrorType, iErrorNum);
    }
}

public Action getWalletAddress(int client, int args)
{
    if (!IsValidClient(client))
        return Plugin_Handled;

    char steamid[MAX_STEAMAUTH_LENGTH];
    GetClientAuthId(client, AuthId_SteamID64, steamid, sizeof(steamid), true);

    char data[MAX_BODY_SIZE];
    Format(data, sizeof(data), "{\"method\":\"getaccountaddress\",\"params\":[\"%s\"]}", steamid);
    HTTPRequest req = HTTPRequest("POST", "http://localhost", "OnRequestComplete",client,data);
    req.debug = true;
    //req.headers.SetString("content-type", "application/json");
    //req.data = data;
    req.SendRequest();
    return Plugin_Handled;
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