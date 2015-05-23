module Dispatcher
  class CombatReportGenerator
    def initialize(delivered_at, combat_data)
      @delivered_at, @combat_data = delivered_at, combat_data
    end

    def deliver!(origin, target)
      @origin, @target = origin, target

      CombatReport.create(player: @origin.player,
                          title: title_for(@origin),
                          data: data,
                          read: false,
                          delivered_at: @delivered_at)

      if @origin.player != @target.player
        deliver_to = if @target.occupied?
          @target.occupied_by.occupying_villa.player
        else
          @target.player
        end

        CombatReport.create(player: deliver_to,
                            title: title_for(@target),
                            data: data,
                            read: false,
                            delivered_at: @delivered_at)
      end
    end

    def title_for villa
      case
      when @origin.player == @target.player
        I18n.t('reports.combat.title.same_player',
               origin: @origin.to_s,
               target: @target.to_s)
      when villa == @origin
        I18n.t('reports.combat.title.on_player',
               origin: @origin.to_s,
               target_player: @target.player.to_s,
               target: @target.to_s)
      when villa == @target
        I18n.t('reports.combat.title.from_player',
               origin_player: @origin.player.to_s,
               origin: @origin.to_s,
               target: @target.to_s)
      end
    end

    def data
      ActiveSupport::JSON.encode @combat_data.merge({ origin_id: @origin.id, target_id: @target.id })
    end
  end
end
