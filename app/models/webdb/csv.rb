require 'csv'
class Webdb::Csv < ApplicationRecord

  attr_accessor :file

  has_many :csv_lines, ->{order(:id) }, :dependent => :destroy
  has_many :valid_csv_lines, ->{where(data_invalid: 0).order(:id) }, :class_name => 'Webdb::CsvLine'
  has_many :invalid_csv_lines, ->{where(data_invalid: 1).order(:id) }, :class_name => 'Webdb::CsvLine'

  belongs_to :db, :foreign_key => :db_id, :class_name => 'Webdb::Db'

  before_create :set_defaults
  before_validation :set_file_attributes, :on => :create

  def parse_states
    [['未処理','prepare'], ['処理中','progress'], ['完了','finish']]
  end

  def parse_state_label
    parse_states.rassoc(parse_state).try(:first)
  end

  def parse_state_prepare?
    parse_state == 'prepare'
  end

  def parse_state_progress?
    parse_state == 'progress'
  end

  def parse_state_finish?
    parse_state == 'finish'
  end

  def register_states
    [['未処理','prepare'], ['処理中','progress'], ['完了','finish']]
  end

  def register_state_label
    register_states.rassoc(register_state).try(:first)
  end

  def register_state_prepare?
    register_state == 'prepare'
  end

  def register_state_progress?
    register_state == 'progress'
  end

  def register_state_finish?
    register_state == 'finish'
  end

  def progressing?
    parse_state_progress? || register_state_progress?
  end

  def registerable?
    parse_state_finish? && register_state_prepare?
  end

private

  def set_file_attributes
    if file.blank?
      return errors.add(:base, "ファイルを入力して下さい。")
    end

    begin
      data = NKF::nkf('-w8 -Lw', file.read)
      return errors.add(:base, "ファイルが空です。") if data.blank?
      data = data.gsub(/\xE3\x80\x9C/, "\xEF\xBD\x9E")
      self.parse_total = CSV.parse(data, :headers => true).size # format check
    rescue => e
      return errors.add(:base, "ファイル形式が不正です。(#{e})")
    end

    self.filename = file.original_filename
    self.filedata = data
  end

  def set_defaults
    self.csv_type ||= self.class.name
    self.parse_state ||= 'progress'
    self.register_state ||= 'prepare'
  end
end
