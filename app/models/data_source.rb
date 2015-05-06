require 'securerandom'
class DataSource < ActiveRecord::Base
  before_create :set_data_number
  def set_data_number
    if self.data_source_number && !self.data_source_number.blank?
      self.data_source_number = data_source_number
    else
      self.data_source_number = SecureRandom.random_number(99999999).to_s
    end
  end
end
