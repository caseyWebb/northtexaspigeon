module.exports =

  sitemap: (req, res) ->
    Sitemap.generateXML (sitemap) ->
      res.header 'Content-Type', 'application/xml'
      res.send(sitemap)