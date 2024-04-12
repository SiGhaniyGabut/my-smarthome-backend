# About Application.cr File
#
# This is Amber application main entry point. This file is responsible for loading
# initializers, classes, and all application related code in order to have
# Amber::Server boot up.
#
# > We recommend not modifying the order of the requires since the order will
# affect the behavior of the application.

require "amber"
require "./settings"
require "./logger"
require "./i18n"
require "./database"
require "./initializers/**"

# uncomment these 4 lines to enable plugins
# require "../plugins/plugins"

# Add Helpers
require "../src/helpers/**"

# Start Generator Dependencies: Don't modify.
require "../src/channels/**"
require "../src/sockets/**"
require "../src/models/**"
# End Generator Dependencies

require "../src/controllers/application_controller"
require "../src/controllers/**"
require "./routes"

# Enable PubSub processing
require "../src/pub_sub/**" 

# Enable Jobs processing
require "../src/jobs/**"

# Enable Model Serializers
require "../src/serializers/**" 