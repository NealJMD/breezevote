module Deliverable
  extend ActiveSupport::Concern

  included do
    enum status: [:unknown, :delivery_requested, :client_handle, :delivered, :voted]
  end

end
