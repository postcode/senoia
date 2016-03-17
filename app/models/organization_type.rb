class OrganizationType < ActiveRecord::Base
  has_many :organizations

  def self.find_organizations(name)
    type = OrganizationType.find_by_name(name)
    type.present? ? Organization.all.where(organization_type_id: type.id) : 'No Organizations'
  end
end