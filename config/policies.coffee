###
Policy Mappings
(sails.config.policies)

Policies are simple functions which run **before** your controllers.
You can apply one or more policies to a given controller, or protect
its actions individually.

Any policy file (e.g. `api/policies/authenticated.js`) can be accessed
below by its filename, minus the extension, (e.g. "authenticated")

For more information on how policies work, see:
http://sailsjs.org/#/documentation/concepts/Policies

For more information on configuring policies, check out:
http://sailsjs.org/#/documentation/reference/sails.config/sails.config.policies.html
###


module.exports.policies =


  '*': 'isAuthenticated'

  AuthController: true

  UserController:
    create: 'isAdmin'
    update: 'isAdmin'
    destroy: false # users should be disabled, not deleted
    invite: 'isAdmin'
    resetPassword: true

  ArticleController:
    find: true
    findOne: true
    findByCategory: true
    comment: true

  PictureController:
    find: true
    findOne: true
    comment: true

  VideoController:
    find: true
    findOne: true
    comment: true

  TagController:
    find: true
    findOne: true

  AdvertisementController:
    find: true
    create: 'isAdmin'
    update: 'isAdmin'

  HomepageController: true

  EmailController:
    create: true

    