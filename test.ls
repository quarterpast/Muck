require! {
	'karma-sinon-expect'.expect
	crud: './index.js'
	sql
}

test = sql.define do
	name: \test
	columns:
		* name: \id data-type: 'int'
		* name: \a data-type: 'varchar(100)'
		* name: \b data-type: 'varchar(100)'
		* name: \c data-type: 'varchar(100)'

export 'Muck':
	'init':
		'creates a table if it doesn\'t exist': ->
			expect do
				crud.init test .to-query! .text
			.to.be 'CREATE TABLE IF NOT EXISTS "test" ("id" int, "a" varchar(100), "b" varchar(100), "c" varchar(100))'

	'create':
		'inserts a row': ->
			query = crud.create test, a:'a' b:'b' c:'c' .to-query!
			expect query.text .to.be 'INSERT INTO "test" ("a", "b", "c") VALUES ($1, $2, $3)'
			expect query.values .to.eql ['a' 'b' 'c']

	'read-cols':
		'selects columns': ->
			query = crud.read-cols test, [test.a] .to-query!
			expect query.text .to.be 'SELECT "test"."a" FROM "test"'

	'read':
		'selects star': ->
			query = crud.read test .to-query!
			expect query.text .to.be 'SELECT "test".* FROM "test"'

	'find':
		'selects star where': ->
			query = crud.find test, a:'a' .to-query!
			expect query.text .to.be 'SELECT "test".* FROM "test" WHERE ("test"."a" = $1)'
			expect query.values .to.eql ['a']

	'update':
		'updates where id': ->
			query = crud.update test, 1 a:'a' .to-query!
			expect query.text .to.be 'UPDATE "test" SET "a" = $1 WHERE ("test"."id" = $2)'
			expect query.values .to.eql ['a', 1]

	'destroy':
		'deletes where id': ->
			query = crud.destroy test, 1 .to-query!
			expect query.text .to.be 'DELETE FROM "test" WHERE ("test"."id" = $1)'
			expect query.values .to.eql [1]
