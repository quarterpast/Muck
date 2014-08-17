σ = require \highland

# run-query :: Connection → Query → Stream Result
export run-query = (conn, sql)-->
	{text, values} = sql.to-query!
	σ conn.query text, values

export init = (model)->
	model.create!.if-not-exists!

export create = (model, data)-->
	model.insert data

export read-cols = (model, columns)-->
	model.select columns

export read = (model)->
	read-cols model, model.star!

export find = (model, props)-->
	read model .where props

export update = (model, id, data)-->
	model.update data
	.where model.id.equals id

export destroy = (model, id)-->
	model.delete!
	.where model.id.equals id

export done = Object.create null

to-method = (fn)->
	(...args)->
		result = @run-query fn @model!, ...args
		return if has-results fn then result
		else result.otherwise [done]

run-query-method = (sql)->
	run-query @connection!, sql

has-results = (in [read, read-cols, find])

export mixin = {[
	k
	if k is \runQuery then run-query-method else to-method v
] for k,v of exports}
