class ImageImportDir < ImageDir
  include DirModel::Import

  # /Sectors
  # /Sectors/Sector_1.png
  # /Zones
  # /Zones/Sector_1/Zone_1.png

  # file regex: -> { /Zones\/Sector_(?<sector_id>.*)\/Zone_(?<zone_id>.*)\.(?<extension>png|jpg)/ }

  protected

  def model
    sector.zones.find(zone_id)
  end

  def method
    :blueprint
  end

  def image
    File.open(path)
  end

  private

  def sector_id
    regex[:sector_id]
  end

  def sector
    Sector.find(sector_id)
  end

  def zone_id
    regex[:zone_id]
  end

  def zone
    sector.zones.find(zone_id)
  end

end
