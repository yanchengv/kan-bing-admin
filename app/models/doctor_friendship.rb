class DoctorFriendship < ActiveRecord::Base
  attr_accessible :doctor1_id, :doctor2_id
  belongs_to :doctor1,:foreign_key => :doctor1_id  , class_name:"Doctor"
  belongs_to :doctor2,:foreign_key => :doctor2_id, class_name:"Doctor"
  # has_one :doctor1, class_name:"Doctor"
  # has_one :doctor2, class_name:"Doctor"
  def self.is_friends(doctor1_id,doctor2_id)
    flag = false
    @fri_doc1 = DoctorFriendship.where(:doctor1_id => doctor1_id,:doctor2_id => doctor2_id)
    if @fri_doc1.count>0
      flag = true
    end
    @fri_doc2 = DoctorFriendship.where(:doctor1_id => doctor2_id,:doctor2_id => doctor1_id)
    if @fri_doc2.count>0
      flag = true
    end
    return flag
  end

end
