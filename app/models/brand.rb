class Brand < ActiveRecord::Base

  #
  # Mixins
  #

  include Autocomplete
  strip_attributes


  #
  # Associations
  #

  has_many :component_models


  #
  # Validations
  #

  validates :name, :presence   => true
  validates :name, :uniqueness => {:case_sensitive => false}


  #
  # Mass-assignable Attributes
  #

  attr_accessible :name


  #
  # Class Methods
  #

  def self.having_tombstoned_kits
    joins(:component_models => :kits).where("kits.tombstoned = ?", true).uniq
  end

  def self.not_having_circulating_kits
    joins(:component_models => :kits).where("kits.circulating = ?", false).uniq
  end

  def self.having_circulating_kits
    joins(:component_models => :kits).where("kits.tombstoned = ? AND kits.circulating = ?", false, true).uniq
  end


  #
  # Instance Methods
  #

  # TODO: move this to a decorator. something specific to select2
  def as_json(options={})
    {
      id: id,
      text: name
    }
  end

  def to_param
    "#{ id } #{ name }".parameterize
  end

  def to_s
    name
  end

end
