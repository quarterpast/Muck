require! {
	'karma-sinon-expect'.expect
	crud: './index.js'
	sql
}

test = sql.define do
	name: \test
	columns:
		* name: \a data-type: 'varchar(100)'
		* name: \b data-type: 'varchar(100)'
		* name: \c data-type: 'varchar(100)'

export 'Muck':
	'init':
		'creates a table if it doesn\'t exist': ->
			expect do
				crud.init test .to-query! .text
			.to.be 'CREATE TABLE IF NOT EXISTS "test" ("a" varchar(100), "b" varchar(100), "c" varchar(100))'

	'create':
		'inserts a row': ->
			query = crud.create test, a:'a' b:'b' c:'c' .to-query!
			expect query.text .to.be 'INSERT INTO "test" ("a", "b", "c") VALUES ($1, $2, $3)'
			expect query.values .to.eql ['a' 'b' 'c']
