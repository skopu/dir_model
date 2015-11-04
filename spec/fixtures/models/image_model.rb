class ModelImage

  def id
    42
  end

  def sector_name
    'sector_name'
  end

  def zone_name
    'zone_name'
  end

  def zone
    File.new('spec/fixtures/image.png')
  end
end
