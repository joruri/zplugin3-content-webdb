class Webdb::CsvLine < ApplicationRecord
  belongs_to :csv

  def csv_data
    data
  end

  def csv_data_attributes
    data_attributes
  end

  def csv_data_extras
    data_extras
  end

  def csv_data_errors
    data_errors
  end

  def data_invalids
    [['無','0'],['有','1']]
  end

end
