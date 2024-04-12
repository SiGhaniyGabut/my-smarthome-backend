module Serializers
  class Switch < ApplicationSerializer
    fields :pin, :pin_alias, :mode, :state, :active
  end
end
