require "active_support/concern"
require "mongoid_auto_inc/incrementor"

module Mongoid
  module AutoInc
    extend ActiveSupport::Concern

    module ClassMethods
      def auto_increment(name, options={ })
        field name, :type => Integer

        before_create do
          val = MongoidAutoInc::Incrementor.new(name, options.merge(object: self)).inc
          self.send("#{name}=", val) unless self[name.to_sym].present?
        end
      end
    end
  end
end

