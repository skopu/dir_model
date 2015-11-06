class ImageExportDir < ImageDir
  include DirModel::Export

  def root
    "tmp/root_dir_#{source_model.id}"
  end

  def dir
    'Sectors'
  end

  def sub_dir
    source_model.sector_name
  end

  def image_name
    source_model.zone_name
  end

  def image
    source_model.zone
  end
end
