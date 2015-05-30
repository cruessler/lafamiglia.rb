module EventHandler
  class ConquestReportGenerator
    def initialize(delivered_at)
      @delivered_at = delivered_at
    end

    def deliver!(origin, target)
      @origin, @target = origin, target

      ConquestReport.create(player: @origin.player,
                          title: title_for(@origin),
                          data: data,
                          read: false,
                          delivered_at: @delivered_at)

      ConquestReport.create(player: @target.player,
                          title: title_for(@target),
                          data: data,
                          read: false,
                          delivered_at: @delivered_at)
    end

    def title_for villa
      case
      when villa == @origin
        I18n.t('reports.conquest.title.on_player',
               origin: @origin.to_s,
               target_player: @target.player.to_s,
               target: @target.to_s)
      when villa == @target
        I18n.t('reports.conquest.title.from_player',
               origin_player: @origin.player.to_s,
               origin: @origin.to_s,
               target: @target.to_s)
      end
    end

    def data
      ActiveSupport::JSON.encode({ origin_id: @origin.id, target_id: @target.id })
    end
  end
end
