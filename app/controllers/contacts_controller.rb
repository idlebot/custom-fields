# ContatctsController is responsible for listing, editing and removing contacts
class ContactsController < ApplicationController

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

  def destrou

  end


  private
    def set_contact
      @contact = Contact.find(params[:id])
    end
end
