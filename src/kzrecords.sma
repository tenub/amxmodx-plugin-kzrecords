#include <amxmodx>
#include <sqlx>

new g_CvarWebBase, g_CvarSqlHost, g_CvarSqlUser, g_CvarSqlPass, g_CvarSqlDb, g_CvarSqlTable
new g_WebBase[64], g_SqlHost[64], g_SqlUser[64], g_SqlPass[64], g_SqlDb[64], g_SqlTable[64]

public plugin_init()
{
	register_plugin("KZ player records", "1.0", "pvab")

	g_CvarSqlHost = create_cvar("kz_sql_host", KZ_SQL_HOST)
	g_CvarSqlUser = create_cvar("kz_sql_user", KZ_SQL_USER)
	g_CvarSqlPass = create_cvar("kz_sql_pass", KZ_SQL_PASS)
	g_CvarSqlDb = create_cvar("kz_sql_db", KZ_SQL_DB)
	g_CvarSqlTable = create_cvar("kz_sql_table", KZ_SQL_TABLE)
}

public plugin_cfg()
{

	get_pcvar_string(g_CvarWebBase, g_WebBase, 63)
	get_pcvar_string(g_CvarSqlHost, g_SqlHost, 63)
	get_pcvar_string(g_CvarSqlUser, g_SqlUser, 63)
	get_pcvar_string(g_CvarSqlPass, g_SqlPass, 63)
	get_pcvar_string(g_CvarSqlDb, g_SqlDb, 63)
	get_pcvar_string(g_CvarSqlTable, g_SqlTable, 63)

	SqlTuple = SQL_MakeDbTuple(host, user, pass, db)

	new errnum, error[256]
	new Handle:sqlconnection = SQL_Connect(SqlTuple, errnum, error, 255)

	if (sqlconnection != Empty_Handle)
	{
		SQL_QueryAndIgnore(sqlconnection,
			"CREATE TABLE IF NOT EXISTS `%s` (\
				`map` varchar(32) NOT NULL,\
				`authid` varchar(35) NOT NULL,\
				`name` varchar(32) NOT NULL,\
				`time` decimal(13,6) NOT NULL,\
				`date` datetime NOT NULL,\
				`weapon` varchar(32) NOT NULL,\
				`cp` int(10) NOT NULL,\
				`gc` int(10) NOT NULL)")

		SQL_FreeHandle(sqlconnection)
	}
	else
	{
		log_amx("%i %s", errnum, error)
	}

}

/**
 * Function called when player hits stop timer
 *
 * @param string table[] Possible values: kz_pro15, kz_nub15, kz_wpn15
 * @param string authid[]
 * @param string name[]
 * @param float time
 * @param integer cp
 * @param integer gc
 * @param string weapon[]
 *
 * @return boolean Prevents other plugins from attaching to this function
 */
public Top15Check(const table[], authid[], name[], Float:time, cp, gc, const weapon[])
{
	new map[32]

	get_mapname(map, 31)

	static data[128]
	formatex(data, 127, "^"%s^" ^"%s^" ^"%s^" ^"%f^" ^"%i^" ^"%i^" ^"%s^"", table, authid, name, time, cp, gc, weapon)

	static query[128]
	formatex(query, 127, "SELECT time FROM `%s` WHERE authid=^"%s^" AND map=^"%s^"", table, authid, map)

	SQL_ThreadQuery(SqlTuple, "Top15CheckQuery", query, data, 127)

	return PLUGIN_HANDLED
}
