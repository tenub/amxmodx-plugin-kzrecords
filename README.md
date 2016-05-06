# amxmodx-plugin-webcommands

> Register client commands to show web URLs. Only commands specified in the `kz_web_commands` CVAR will be registered. A client command will be appended to a base URL and the resulting URL will be shown to the client in a MOTD window

## Notes

There are two ways to set the required CVAR values:

1. Set `DEFAULT_WEB_BASE_URL` and `DEFAULT_WEB_COMMANDS` values directly in source code and compile
2. Set `kz_web_base` and `kz_web_commands` values in `amxx.cfg`  
   *Note*: these will overwrite the default values after the game server has completed its initial run

## Usage

### `DEFAULT_WEB_BASE_URL`

Default CVAR value for base URL. A sensible initial value has been set

### `DEFAULT_WEB_COMMANDS`

Default CVAR value for commands list. A sensible initial value has been set

### `kz_web_base`

CVAR for base URL

### `kz_web_commands`

CVAR for commands list
