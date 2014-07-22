require! {
	\any-db
	'./crud'
	sql
	σ: highland
}

conn = any-db.create-connection 'sqlite3://test.db'
quote = sql.define do
	name: \quote
	columns:
		* name: \id     data-type: 'varchar(100)'
		* name: \author data-type: 'varchar(100)'
		* name: \text   data-type: 'varchar(100)'

query = (q, cb)-->
	crud.run-query conn, q .otherwise (σ [null]) .flat-map cb

s = do ->
	<- query quote.create!.if-not-exists!.to-query!
	<- query crud.create quote, id:\1 author:'Matt Brennan' text:'Mucking about'
	query (crud.read quote), -> σ [it]


s.to-array console.log
