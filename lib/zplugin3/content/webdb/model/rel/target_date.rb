# encoding: utf-8
module Zplugin3::Content::Webdb::Model::Rel::TargetDate
  def self.included(mod)
    mod.has_many :dates, :foreign_key => 'entry_id', :class_name => 'Webdb::EntryDate',
      :dependent => :destroy

    mod.after_save :save_target_dates
  end

  def in_target_dates
    unless val = @in_target_dates
      val = []
      dates.each {|event| val << event.attributes}
      @in_target_dates = val
    end
    @in_target_dates
  end

  def in_target_dates=(values)
    @dates = values
    @in_target_dates = @dates
  end

  def save_target_dates
    return true  unless @dates
    return false unless id
    return false if @_sent_target_dates
    @_sent_target_dates = true
    @dates.each do |key, in_target_date|
      event_date = in_target_date[:event_date] || nil
      next if event_date.blank?
      option_value = in_target_date[:option_value] || nil
      item_name    = in_target_date[:name] || nil
      event = self.dates.where(Webdb::EntryDate.arel_table[:event_date].eq(event_date))
        .where(name: item_name).first || self.dates.new
      event.entry_id      = id
      event.event_date    = event_date
      event.option_value  = option_value
      event.name          = item_name
      event.save
    end
    return true
  end


end