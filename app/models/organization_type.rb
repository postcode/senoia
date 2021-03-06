# == Schema Information
#
# Table name: organization_types
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class OrganizationType < ActiveRecord::Base
  has_many :organizations

  def self.find_organizations(name)
    type = OrganizationType.find_by_name(name)
    type.present? ? organizations = Organization.all.where(organization_type_id: type.id).sort_by(&:name) : organizations = [NullOrganization.new]
    organizations = [NullOrganization.new] unless organizations.present?
    organizations
  end

  def self.find_permitters
    type = OrganizationType.find_by_name("Event Permitter")
    type.present? ? organizations = Organization.all.where(organization_type_id: type.id).sort_by(&:name) : organizations = [NullOrganization.new]
    organizations = [NullOrganization.new] unless organizations.present?
    type.add_other(organizations) if type.present?
    organizations
  end

  def self.find_promoters
    type = OrganizationType.find_by_name("Event Producer")
    type.present? ? organizations = Organization.all.where(organization_type_id: type.id).sort_by(&:name) : organizations = [NullOrganization.new]
    organizations = [NullOrganization.new] unless organizations.present?
    type.add_other(organizations) if type.present?
    organizations
  end

  def self.find_providers
    type = OrganizationType.find_by_name("EMS Provider")
    type.present? ? organizations = Organization.all.where(organization_type_id: type.id).sort_by(&:name) : organizations = [NullOrganization.new]
    organizations = [NullOrganization.new] unless organizations.present?
    type.add_other(organizations) if type.present?
    organizations
  end

  def add_other(list)
    other = Organization.find_by_name("Other")
    if list.include?(other)
      list.delete(other)
      list.push(other)
    end
    list
  end

  class NullOrganization
    def id
      0
    end

    def name
      'N/A'
    end

    def email
      'zombie@fake.com'
    end

    def phone_number
      '9999999999'
    end

    def address
      '123 fake st'
    end
  end
end
