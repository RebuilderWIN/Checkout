class InventoryStatusDecorator < ApplicationDecorator
  decorates :inventory_status
  decorates_association :inventory_record

  def name
    h.t("inventory_status.#{source.name}")
  end

  def to_s
    name
  end

end
