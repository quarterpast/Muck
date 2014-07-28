# Muck

Expressive CRUD for [any-db](https://github.com/grncdr/node-any-db).

```bash
npm install muck
```

## Usage

The easiest way to start using Muck is to create a class with `connection` and `model` methods. Then mix in `muck.mixin` however you like, and:

```javascript
var muck  = require('muck');
var anyDb = require('any-db');
var sql   = require('sql');

var connection = anyDb.createConnection('sqlite3://foo.db');
var fooModel   = sql.define({
	name: 'foo',
	columns: [
		{name: 'id', dataType: 'integer primary key autoincrement'},
		{name: 'name', dataType: 'varchar(50)'}
	]
});

function Foo() {
	this.init(); // create the table if it doesn't exist
}

_.extend(Foo.prototype, muck.mixin, {
	model: function() { return fooModel },
	connection: function() { return connection }
});

var foo = new Foo();
foo.insert({name: 'bar'}).flatMap(function() {
	return foo.read();
}).toArray(function(foos) {
	console.log(foos); //⇒ [{id: 1, name:'bar'}]
});
```

## API
### Mixin
The mixin expects to be mixed in to an object of type `{connection :: → Connection, model :: → Model}`, where `Connection` is an [any-db](https://github.com/grncdr/node-any-db) connection (or something that has a `query` method and returs streams or arrays) and `Model` is an [sql](https://github.com/brianc/node-sql) definition.
### Querying
#### `run-query :: Connection → Query → Stream Row`
Runs the query on the connection, returning a Highland stream of result rows. If it's a query that has no results, e.g. `
### Query generators
#### `init :: Model → Query`
Generates a `CREATE TABLE IF NOT EXISTS` query.
#### `create :: Model → Map ColName Value → Query`
Generates an `INSERT INTO ... VALUES ...` query.
#### `read-cols :: Model → [ColName] → Query`
Generates a `SELECT ...colnames FROM ...` query.
#### `read :: Model → Query`
Generates a `SELECT * FROM ...` query.
#### `find :: Model → Map ColName Value → Query`
Generates a `SELECT * FROM ... WHERE ...` query.
#### `update :: Model → Id → Map ColName Value → Query`
Generates a `UPDATE ... SET ... WHERE (id = ...)` query.
#### `destroy :: Model → Id → Query`
Generates a `DELETE FROM ... WHERE (id = ...)` query.

## Licence
MIT.


