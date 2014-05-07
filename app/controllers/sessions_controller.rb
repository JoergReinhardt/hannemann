# encoding: utf-8
class SessionsController < ApplicationController

  def new
  end

  # CREATE
  # Session erzeugen: Der user wird anhand seines logins aus den session
  # parametern (also dem coockie) gesucht. Es handelt sich um einen
  # verschachtelten hash, daher zweimal eckige Klammern um auf die einzelnen
  # Session Parameter zugreifen zu koennen  Ist der User vorhanden und das
  # passwort stimmt, wird er mit 'sign_in' (siehe sessions_helper) eingelogt.
  # Am Ende wird Er zu seinem Profil weitergeleitet, indem an 'user_path' der
  # parameter user.login uebergeben wird

  def create
    user = User.find_by_login(params[:session][:login])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user_path(user.login)
    else
      flash.now[:error] = "Ungültige Passwort / Login Kombination"
      render 'new'
    end
  end

  # DESTROY
  # Die 'destroy' Action verwendet die 'sign_out' Funktion aus dem
  # SessionsHelper udn leitet auf die Startseite weiter.

  def destroy
    sign_out
    redirect_to root_path
  end

end
