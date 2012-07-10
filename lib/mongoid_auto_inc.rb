require "active_support/concern"
require "mongoid_auto_inc/incrementor"

module Mongoid
  module AutoInc
    extend ActiveSupport::Concern

    module ClassMethods
      def auto_increment(name, options={ })
        field name, :type => Integer

        before_create { self.send("#{name}=", MongoidAutoInc::Incrementor.new(name, options.merge(object: self)).inc) unless self[name.to_sym].present? }
      end
    end
  end
end

