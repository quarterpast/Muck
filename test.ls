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
		* name: \id     data-type: 'integer primary key autoincrement'
		* name: \author data-type: 'varchar(100)'
		* name: \text   data-type: 'varchar(100)'

query   = crud.run-query conn
init    = query . -> crud.init quote
create  = query . crud.create  quote
read    = query . -> crud.read quote
find    = query . crud.find    quote
update  = query . crud.update  quote
destroy = query . crud.destroy quote

s = do ->
	<- init! .flat-map
	<- create author: 'Matt Brennan' text: 'Mucking about' .flat-map
	find author: 'Matt Brennan' .last!

s.to-array console.log
