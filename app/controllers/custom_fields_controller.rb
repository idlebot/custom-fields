# CustomFieldsController is responsible for listing, editing and removing custom_fields
class CustomFieldsController < ApplicationController
  before_action :require_logged_user
  before_action :set_custom_field, only: [:edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @custom_fields = current_user.custom_fields
  end

  def new
    @custom_field = CustomField.new
    @custom_field.type = TextCustomField.name
    @custom_field.drop_down_values.new
  end

  def create
    @custom_field = current_user.custom_fields.new(custom_field_params)
    if @custom_field.save
      flash[:success] = "#{@custom_field.type_description} was successfully created"
      redirect_to custom_fields_path
    else
      render 'new'
    end
  end

  def edit
    @custom_field.drop_down_values.new
  end

  def update
    if @custom_field.update(custom_field_params)
      flash[:success] = 'Custom field was successfully updated'
      redirect_to custom_fields_path
    else
      render 'edit'
    end
  end

  def destroy
    @custom_field.destroy

    flash[:danger] = 'Custom field was successfully deleted'
    redirect_to custom_fields_path
  end

  private

  def set_custom_field
    @custom_field = CustomField.find(params[:id])
  end

  def custom_field_params
    params.require(:custom_field).permit(:field_name, :type, drop_down_values_attributes: [:id, :value, :_destroy])
  end

  def ensure_owner
    unless @custom_field.user == current_user
      flash[:danger] = 'Invalid custom field'
      redirect_to contacts_path
    end
  end
end
