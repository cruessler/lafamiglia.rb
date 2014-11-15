module VillaHelper
  def coordinates villa
    "(#{villa.x}|#{villa.y})"
  end

  def resources villa
    render partial: 'common/resources', locals: { villa: villa,
                                                  resource_gains: villa.resource_gains(3600) }
  end
end
