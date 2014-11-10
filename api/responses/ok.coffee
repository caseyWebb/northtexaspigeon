###
 * 200 (OK) Response
 *
 * Usage:
 * return res.ok();
 * return res.ok(data);
 * return res.ok(data, 'auth/login');
 *
 * @param  {Object} data
 * @param  {String|Object} options
 *          - pass string to render specified view
 ###

module.exports = (data, options) ->

  # Get access to `req`, `res`, & `sails`
  req = @req
  res = @res
  sails = req._sails

  sails.log.silly('res.ok() :: Sending 200 ("OK") response')

  # Set status code
  res.status(200)

  # If appropriate, serve data as JSON
  if (req.wantsJSON && !req.param('forceHTML') && req.session.user?)
    return res.json(data)

  # If second argument is a string, we take that to mean it refers to a view.
  # If it was omitted, use an empty object (`{}`)
  options = if (typeof options == 'string')
              { view: options }
            else
              options || {};

  # If a view was provided in options, serve it.
  # Otherwise try to guess an appropriate view, or if that doesn't
  # work, just send JSON.
  if (options.view)
    return res.view(options.view, data)

  # If no second argument provided, try to serve the implied view,
  # but fall back to sending JSON if no view can be inferred.
  else return res.guessView data, () ->
    return res.json
      err: "I know you wanted a view, but alas, I couldn't find one, so here is the data...",
      data: data