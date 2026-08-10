class Physical::Connection <  ActiveRecord::Base
  after_save :create_reverse_connection, if: ->(c) { self.class.find_by(local: c.distant, distant: c.local, link_type: c.link_type.try(:id)).nil? }
  after_destroy :destroy_reverse_connection

  belongs_to :local, :class_name => 'Physical::Port', required: false
  belongs_to :distant, :class_name => 'Physical::Port'
  belongs_to :link_type, optional: true

  private

  def create_reverse_connection
    reverse = Physical::Connection.find_by(local_id: distant_id_previously_was, distant: local)
    if reverse.nil? 
      # Creation
      Physical::Connection.create(local: distant, distant: local, link_type: link_type)
    else
      # Update
      reverse.update(local: distant, distant: local, link_type: link_type||nil)
    end
  end

  def destroy_reverse_connection 
    # Le delete n'appelle pas le callback after_destroy
    Physical::Connection.find_by(local: distant, distant: local).delete
  end
end