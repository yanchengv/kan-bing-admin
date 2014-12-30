class GroupsSkill < ActiveRecord::Base
  belongs_to :skill, foreign_key: :skill_id
  belongs_to :group, foreign_key: :group_id
end
