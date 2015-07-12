module ControllerHelpers
  extend ActiveSupport::Concern
 
  included do
    routes { GreenFlag::Engine.routes }
  end
end