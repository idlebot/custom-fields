# ContactsController is responsible for listing, editing and removing contacts
class ContactsController < ApplicationController

  before_action :require_logged_user
  before_action :set_contact, only: [:edit, :update, :destroy]


  def index
    @contacts = Contact.all
  end

  def new
    @contact = Contact.new
  end

  def create

  end

  def edit

  end

  def update


  end

  def destroy

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
end
