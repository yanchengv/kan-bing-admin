class BlockContent < ActiveRecord::Base
  belongs_to :page_block, :foreign_key => :block_id
end
