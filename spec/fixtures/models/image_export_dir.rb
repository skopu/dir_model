class ImageExportDir < ImageDir
  include DirModel::Export

  def image_name
    source_model.zone_name
  end

  def image
    source_model.zone
  end
end
