create = (model, data)-->
	model.insert data
	.to-query!

read = (model)->
	model.select do
		model.star!
	.from model
	.to-query!

update = (model, id, data)-->
	model.update data
	.where model.id.equals id
	.to-query!

delete = (model, id)-->
	model.delete!
	.where model.id.equals id
	.to-query!
