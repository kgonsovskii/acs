#ifndef TSS_SQLITE_HPP_INCLUDED
#define TSS_SQLITE_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include <sqlite3.h>
#include <boost/noncopyable.hpp>
#include <boost/format.hpp>

#ifdef MSWINDOWS
#	pragma comment(lib, "sqlite3.lib")
#endif

namespace tss {

//INTEGER PRIMARY KEY AUTOINCREMENT
class SQLite: private boost::noncopyable
{
public:
	struct Error: public std::runtime_error
	{
		Error(int code_, const std::string& msg): std::runtime_error(msg), code(code_) {}
		const int code;
	};//Error

	class Stmt: private boost::noncopyable
	{
	public:
		Stmt(const SQLite& db_, const char *sql): db(db_), _stmt(NULL)
		{
			db.prepare(sql, &_stmt);
		}
		~Stmt()
		{
			if (_stmt)
				db.finalize(_stmt);
		}

		void bind(int no, int value) const
		{
			const int rc = sqlite3_bind_int(_stmt, no, value);
			if (rc)
				db._err(rc);
		}
		void bind(int no, double value) const
		{
			const int rc = sqlite3_bind_double(_stmt, no, value);
			if (rc)
				db._err(rc);
		}
		void bind(int no, const void *value, int size, bool isStatic = false) const
		{
			const int rc = sqlite3_bind_blob(_stmt, no, value, size, isStatic? SQLITE_STATIC: SQLITE_TRANSIENT);
			if (rc)
				db._err(rc);
		}

		int step() const
		{
			const int rc = sqlite3_step(_stmt);
			if (!(rc == SQLITE_DONE || rc == SQLITE_ROW))
				db._err(rc);
			return rc;
		}

		const char *columnText(int idx) const throw()
		{
			return reinterpret_cast<const char *>(sqlite3_column_text(_stmt, idx));
		}

		const char *columnBlob(int idx) const throw()
		{
			return reinterpret_cast<const char *>(sqlite3_column_blob(_stmt, idx));
		}

		int columnInt(int idx) const throw()
		{
			return sqlite3_column_int(_stmt, idx);
		}

		sqlite3_stmt *handle() const { return _stmt; }
		operator sqlite3_stmt *() const { return _stmt; }
		const SQLite& db;
	private:
		sqlite3_stmt *_stmt;
	};//Stmt

	SQLite(const char *filename)
	{
		const int rc = sqlite3_open(filename, &_db);
		if (rc) {
			struct X
			{
				X(sqlite3 *db_): db(db_) {}
				~X() { sqlite3_close(db); }
				sqlite3 *db;
			};
			_err(rc);
		}
	}
	~SQLite()
	{
		const int rc = sqlite3_close(_db);
		if (rc)
			_err(rc);
	}
	void exec(const char *sql, sqlite3_callback callbackFunc = NULL, void *callbackFunc1Arg = NULL) const
	{
		const int rc = sqlite3_exec(_db, sql, callbackFunc, callbackFunc1Arg, NULL);
		if (rc) {
			_err(rc);
		}
	}	
	void prepare(const char *sql, sqlite3_stmt **stmt, const char **sqlTail = NULL) const
	{
		const int rc = sqlite3_prepare_v2(_db, sql, -1, stmt, sqlTail);
		if (rc)
			_err(rc);
	}
	void finalize(sqlite3_stmt *stmt) const
	{
		const int rc = sqlite3_finalize(stmt);
		if (rc)
			_err(rc);
	}
	void reset(sqlite3_stmt *stmt) const
	{
		const int rc = sqlite3_reset(stmt);
		if (rc)
			_err(rc);
	}
	void exclusive() const { exec("PRAGMA locking_mode=EXCLUSIVE"); }
	void dropTable(const char *name) const { exec(boost::str(boost::format("DROP TABLE %s") %name).c_str()); }
	void vacuum() const { exec("VACUUM"); }
	sqlite3 *handle() const throw() { return _db; }
protected:
	sqlite3 *_db;
	void _err(int rc) const
	{
		boost::format f("SQLite: #%d, '%s'.");
		f %rc %sqlite3_errmsg(_db);
		throw Error(rc, f.str());
	}
};

}

#endif
