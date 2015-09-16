class ProvidersUser < ActiveRecord::Base
  belongs_to :provider
  belongs_to :user
end
