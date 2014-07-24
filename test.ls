require! {
	\any-db
	'./crud'
	handle: oban
	resp: dram
	lw: livewire
	http
	sql
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

json = (obj)->
	resp.ok JSON.stringify obj
		.with-header \Content-type \application/json

app = lw.route [
	lw.get  '/quote' -> read! .collect! .flat-map json
	lw.get  '/quote/:id' ({params})->
		quote <- find {params.id} .flat-map
		if quote?
			json that
		else resp.not-found "quote #{params.id} not found"
	lw.post '/quote' (req)->
		data <- lw.json req .flat-map
		<- create data .flat-map
		find data .head! .flat-map json
	lw.delete '/quote/:id' ({params})->
		quote <- find {params.id} .flat-map
		if quote?
			<- destroy params.id .flat-map
			resp.ok!
		else resp.not-found "quote #{params.id} not found"
]

server = http.create-server handle app
<- server.listen process.env.PORT ? 3000
init!
