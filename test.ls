require! {
	\any-db
	'./crud'
	handle: oban
	dram.ok, dram.with-header, dram.not-found
	sodor.Controller
	http
	sql
	livewire.route
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

json = (with-header \Content-type \application/json) . ok . JSON.stringify

class Quote extends Controller
	list: @root ->
		read! .collect! .flat-map json

	show: @root (id)->
		quote <- find {id} .flat-map
		if quote? then json that
		else not-found "quote #id not found"

	create: @root @post ->
		data <- lw.json @request .flat-map
		<- create data .flat-map
		find data .head! .flat-map json

	destroy: @root @delete (id)->
		quote <- find {id} .flat-map
		if quote?
			destroy id
				.map -> ''
				.flat-map ok
		else not-found "quote #id not found"


server = http.create-server handle route Quote.routes!
<- server.listen process.env.PORT ? 3000
init!
