json.villas @villas do |v|
  json.extract! v, :id, :name, :x, :y

  json.player do
    json.extract! v.player, :id
  end
end

json.dimensions @dimensions
