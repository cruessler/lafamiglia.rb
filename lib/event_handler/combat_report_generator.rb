module EventHandler
  class CombatReportGenerator
    def initialize(delivered_at, combat)
      @delivered_at, @combat = delivered_at, combat
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
          @target.occupation.origin.player
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
      data = @combat.report_data :winner,
                                 :attacker_before_combat, :attacker_loss,
                                 :defender_before_combat, :defender_loss,
                                 :occupation_began?

      if @combat.attacker_survived? && !@combat.occupation_began?
        data.merge!({ plundered_resources: @combat.plundered_resources })
      end

      data.merge({ origin_id: @origin.id, target_id: @target.id })
    end
  end
end
