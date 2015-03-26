namespace :data do
  desc "Fix counter caches"
  task fix_counter_caches: :environment do
    MessageStatus.transaction do
      MessageStatus.all.each do |s|
        s.update_attribute :read, false if s.read.nil?
      end
    end

    Report.transaction do
      Report.all.each do |r|
        r.update_attribute :read, false if r.read.nil?
      end
    end

    Player.transaction do
      Player.all.each do |p|
        p.update_attribute :unread_messages_count, p.message_statuses.where('read = ?', false).count
        p.update_attribute :unread_reports_count, p.reports.where('read = ?', false).count
      end
    end
  end
end
