# ContactsController is responsible for listing, editing and removing contacts
class ContactsController < ApplicationController

  before_action :require_logged_user
  before_action :set_contact, only: [:edit, :update, :destroy]

  def index
    @contacts = current_user.contacts
  end

  def new
    @contact = Contact.new
    create_custom_field_values(@contact)
  end

  def create
    @contact = current_user.contacts.new(contact_params)

    if @contact.save
      flash[:success] = 'Contact was successfully created'
      redirect_to contacts_path
    else
      render 'new'
    end
  end

  def edit
    create_custom_field_values(@contact)
  end

  def update
    if @contact.update(contact_params)
      flash[:success] = 'Contact was successfully updated'
      redirect_to contacts_path
    else
      render 'edit'
    end

  end

  def destroy
    @contact.destroy

    flash[:danger] = 'Contact was successfully deleted'
    redirect_to contacts_path
  end


  private
    def set_contact
      @contact = Contact.includes(:custom_field_values => :custom_field).find(params[:id])
    end

    def contact_params
      params.require(:contact)
        .permit(:name, :email, custom_field_values_attributes: [:id, :value, :drop_down_value_id, :custom_field_id])
    end

    # create empty custom field values for all custom_fields
    # if a value already exists, skip creation
    def create_custom_field_values(contact)
      existing_custom_fields = contact.custom_field_values.collect { |custom_field_value| custom_field_value.custom_field }
      current_user.custom_fields.each do |custom_field|
        unless existing_custom_fields.include?(custom_field)
          new_value = contact.custom_field_values.new
          new_value.custom_field = custom_field
        end
      end
    end
end
