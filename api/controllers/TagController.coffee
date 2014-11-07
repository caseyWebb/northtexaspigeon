 # TagController
 #
 # @description :: Server-side logic for managing tags
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =

  find: (req, res) ->
    Tag.find (err, tags) ->
      return res.serverError(err) if err?
      res.ok({ tags: tags })

  findOne: (req, res) ->
    Tag.findContentFor req.param('tag'), (err, content) ->
      return res.serverError(err) if err?
      res.ok(content, 'tag/findOne')