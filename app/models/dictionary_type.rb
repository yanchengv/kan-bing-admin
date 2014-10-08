class DictionaryType < ActiveRecord::Base
  has_many :dictionaries, :foreign_key => "dictionary_type_id", :dependent => :destroy
end
