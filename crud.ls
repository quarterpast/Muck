σ = require \highland

# run-query :: Connection → Query → Stream Result
exports.run-query = (conn, {text, values})-->
	σ conn.query text, values

exports.create = (model, data)-->
	model.insert data
	.to-query!

exports.read = (model)->
	model.select do
		model.star!
	.from model
	.to-query!

exports.update = (model, id, data)-->
	model.update data
	.where model.id.equals id
	.to-query!

exports.delete = (model, id)-->
	model.delete!
	.where model.id.equals id
	.to-query!
