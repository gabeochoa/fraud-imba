import express from 'express'
import index from './app/index.html'

import { spyfall_process } from './spyfall_server.imba'

const app = express!

app.use(express.json())

const api_url = /api\/[a-zA-Z]*\/[a-zA-Z0-9]*\/[a-zA-Z0-9]*/

def process res, path, data=null
	const [_empty, _api, game, action, room] = path;
	if game == "spyfall" 
		return res.send(spyfall_process(action, room, data))
	return res.sendStatus(404)

app.post(api_url) do(req,res)
	const path = req.path.split("/")
	if path.length < 4 then return res.sendStatus(404)
	return process(res, path, req.body)

app.get(/api\/[a-zA-Z]*\/[a-zA-Z0-9]*\/[a-zA-Z0-9]*/) do(req,res)
	const path = req.path.split("/")
	if path.length < 4 then return res.sendStatus(404)
	return process(res, path, req.body)

app.get(/.*/) do(req,res)
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)
	res.send index.body

imba.serve app.listen(3000)