class Model < ActiveRecord::Base

  ## Mixins ##

  # search can autocomplete on this model
  include Autocomplete

  # apply authorization roles to this model
  resourcify

  # convert empty string attributes to null
  strip_attributes


  ## Associations ##

  belongs_to :brand,      :inverse_of => :models
  has_many   :components, :inverse_of => :model
  has_many   :kits, :through => :components, :dependent => :destroy
  has_and_belongs_to_many :categories


  ## Validations ##

  validates :name, :presence => true
  validates :name, :uniqueness => true
  validates_presence_of :brand


  ## Mass-assignable attributes ##

  attr_accessible(:brand_id,
                  :category_ids,
                  :description,
                  :name,
                  :training_required)

  ## Class Methods ##

  def self.checkoutable
    joins(:kits).where("kits.tombstoned = ? AND kits.checkoutable = ?", false, true).uniq
  end

  # TODO: implement this
  # def self.reservable(from_date, to_date)
  # end

  def self.brand(brand_id)
    joins(:brand).where('brands.id = ?', brand_id.to_i)
  end

  # TODO: test this
  def self.category(category_id)
    joins(:categories).where('categories.id = ?', category_id.to_i)
  end


  ## Instance Methods ##

  # this is specific to the select2 widget used in the kit form view
  # TODO: move this to a decorator?
  def as_json(options={})
    {
      :id   => id,
      :text => branded_name
    }
  end

  def branded_name
    return "#{ brand } #{ name }"
  end

  # returns a list of checkout locations which have business hours
  def checkout_locations
    locations = kits.collect { |k| k.location }
    locations.uniq!
    locations.select { |l| l.business_hours.count > 0 }
  end

  def checkoutable?
    kits.checkoutable.count > 0
  end

  def checkoutable_kits
    kits.where("kits.tombstoned = ? AND kits.checkoutable = ?", false, true).uniq
  end

  # TODO: test this
  # returns a JSON object with the available checkout days for each
  # kit, grouped by location. Consumed by the javascript date picker
  def checkout_days_json(days_out = 90)
    locations = {}
    checkoutable_kits.each do |kit|
      if locations[kit.location.id].nil?
        locations[kit.location.id] = { 'kits' => [] }
      end
      kit_hash = {
        'kit_id' => kit.id,
        'days_reservable' => kit.days_reservable(days_out)
      }
      locations[kit.location.id]['kits'] << kit_hash
    end
    return locations
  end

  # callback to populate :autocomplete
  def generate_autocomplete
    # you'll have to customize this
    s = self.branded_name
    s = s.truncate(45, omission: "", separator: " ") if s.length > 45
    self.autocomplete = Model.normalize(s)
  end

  # helper for generating asset tags with links to their kits
  def kit_asset_tags
    ats = components.collect { |c| [c.asset_tag, c.kit] }
    ats.sort_by! { |a| a.first }
  end

  def training_required?
    training_required
  end

  # TODO: implement reservable?

  def to_s
    name
  end

  def to_param
    "#{ id } #{ branded_name }".parameterize
  end

end
