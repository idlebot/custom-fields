class DropDownCustomField < CustomField
  def self.model_name
    CustomField.model_name
  end

  validates :drop_down_values, :length => { :minimum => 1 }
end
