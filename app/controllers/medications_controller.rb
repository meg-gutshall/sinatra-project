class MedicationsController < ApplicationController

  # List medications by user
  get '/medications' do
    user_check
    @meds = Medication.where(user_id: current_user.id).abc_name
    @current_meds = @meds.current.abc_name
    @previous_meds = @meds.previous.abc_name
    erb :'/medications/list_medications'
  end

  # Render the new medication form
  get '/medications/new' do
    user_check
    erb :'/medications/new_medication'
  end

  # Create a new medication based on the input collected from the user
  post '/medications' do
    user_check
    @med = Medication.create(params[:med])
    @med.update(start_date: params[:med][:start_date]+"-01")
    @med.update(end_date: params[:med][:end_date]+"-01")
    @med.update(user_id: current_user.id)
    redirect "/medications/#{@med.slug}"
  end

  # Show medication details
  get '/medications/:slug' do
    @med = Medication.find_by_slug(params[:slug])
    user_check_stray
    erb :'/medications/medication_detail'
  end

  # Automatically assign values that show user has stopped taking medication
  get '/medications/:slug/stop-med' do
    @med = Medication.find_by_slug(params[:slug])
    user_check_stray
    @med.update(currently_taking: "false")
    @med.update(end_date: Time.now)
    redirect "/medications/#{@med.slug}/reactions/new"
  end

  # Render the edit medication form
  get '/medications/:slug/edit' do
    @med = Medication.find_by_slug(params[:slug])
    user_check_stray
    erb :'/medications/edit_medication'
  end

  # Edit a reaction based on the input collected from the user
  patch '/medications/:slug' do
    @med = Medication.find_by_slug(params[:slug])
    user_check_stray
    @med.update(params[:med])
    @med.update(start_date: params[:med][:start_date]+"-01")
    @med.update(end_date: params[:med][:end_date]+"-01")
    redirect "/medications/#{@med.slug}"
  end

  # Delete a medication
  delete '/medications/:slug' do
    @med = Medication.find_by_slug(params[:slug])
    user_check_stray
    @med.delete
    redirect "/medications"
  end

end