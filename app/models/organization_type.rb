class OrganizationType < ActiveRecord::Base
  has_many :organizations

  def self.find_organizations(name)
    type = OrganizationType.find_by_name(name)
    type.present? ? organizations = Organization.all.where(organization_type_id: type.id) : organizations =[ NullOrganization.new]
    organizations.empty? ? organizations =[ NullOrganization.new] : organizations
  end

  def self.find_permitters
    type = OrganizationType.find_by_name("Event Permitter")
    type.present? ? organizations = Organization.all.where(organization_type_id: type.id) : organizations =[ NullOrganization.new]
    organizations.empty? ? organizations =[ NullOrganization.new] : organizations
  end
  
  def self.find_promoters
    type = OrganizationType.find_by_name("Event Producer")
    type.present? ? organizations = Organization.all.where(organization_type_id: type.id) : organizations =[ NullOrganization.new]
    organizations.empty? ? organizations =[ NullOrganization.new] : organizations
  end

  def self.find_providers
    type = OrganizationType.find_by_name("EMS Provider")
    type.present? ? organizations = Organization.all.where(organization_type_id: type.id) : organizations =[ NullOrganization.new]
    organizations.empty? ? organizations =[ NullOrganization.new] : organizations
  end
end