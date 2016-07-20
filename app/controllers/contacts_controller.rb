# ContactsController is responsible for listing, editing and removing contacts
class ContactsController < ApplicationController

  before_action :require_logged_user
  before_action :set_contact, only: [:edit, :update, :destroy]

  def index
    @contacts = current_user.contacts
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user = current_user
    if @contact.save
      flash[:success] = 'Contact was successfully created'
      redirect_to contacts_path
    else
      render 'new'
    end
  end

  def edit

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
      @contact = Contact.find(params[:id])
    end

    def require_logged_user
      unless logged_in?
        flash[:danger] = 'Must be logged in'
        redirect_to root_path
      end
    end

    def contact_params
      params.require(:contact).permit(:name, :email)
    end
end
