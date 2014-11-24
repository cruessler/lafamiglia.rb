module VillaHelper
  def coordinates villa
    "(#{villa.x}|#{villa.y})"
  end

  def resources villa
    render partial: 'common/resources', locals: { villa: villa,
                                                  resource_gains: villa.resource_gains(3600) }
  end

  def costs costs
    render partial: 'common/costs', locals: { resource_1: costs[:resource_1],
                                              resource_2: costs[:resource_2],
                                              resource_3: costs[:resource_3] }
  end
end
