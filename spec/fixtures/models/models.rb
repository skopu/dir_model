def models
  [OpenStruct.new({
   id: 42,
   zone_name: 'zone_name.png',
   zone: File.new('spec/fixtures/image.png'),
 }),OpenStruct.new({
   id: 69,
   zone_name: 'fu_zone_name.png',
   zone: File.new('spec/fixtures/image.png'),
 })]
end
