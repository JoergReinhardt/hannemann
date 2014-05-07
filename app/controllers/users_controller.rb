# encoding: utf-8
class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  # NEW
  # erzeugt ein leeres User Objekt und weist es der Instanz Variable @user zu,
  # damit ein Formular fuer das User Objekt Instanziert werden kann

  def new
    @user = User.new
  end

  # CREATE
  # erzeugt ein neues User Objekt und speichert es in der Datenbank. Der create
  # Kontroller ist die submit Adresse des im 'new' controller instanzierten
  # Formulares. Submit erfolgt mittels 'post' Methode.  Bei Erfolg wird der
  # User auf seine Profilseite weiter geleitet, ansonsten geht es zurück zur
  # new action mit einem neuen, leeren Formular und user Objekt.
  #
  # Die 'sign_in' Funktion wird im SessionsHelper definiert und ueber den
  # ApplicationCotroller in alle weiteren Controllern eingebunden.
  #
  # Der 'params' hash stammt in diesem Fall aus dem 'POST' Request und ist ein
  # verschachteltes Dictionary. '@user' ist die syntax, um auf das login
  # Attribut des frisch erzeugten User Objektes zu verseisen und muss an
  # 'user_path()' als Argument übergeben werden, weil sonst automatisch die ID
  # an Stelle des notwendigen 'login' parameters gesetzt wir (sane defaults
  # over configuration am Arsch)
  #
  # Der '@title' muß gesetzt werden, damit der 'full_title' helper nicht
  # explodiert. Warum der nicht vom Formular mittels 'provide' zur Verfügung
  # gestellt werden kann, ist mir unklar.

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Wilkommen im Verwaltungsbereich"
      sign_in @user
      redirect_to user_path(@user)
    else
      @title = "Benutzer anlegen"
      render 'new'
    end
  end

  # EDIT
  # instanziert eine Instanz des User Objektes und uebergibt Sie an das
  # Formular zum Veraendern des User Profiles. Anhand des login Parameters, der
  # durch die 'match' fuktion aus 'routes' gesetzt wird, werden die Daten des
  # richtigen Users vorgelegt.
  #
  # Der 'params' hash stammt aus der URL, wird von der 'match' Funktion
  # ausgefiltert und gesetzt. Da es sich um eine 'GET' Anfrage handelt ist der
  # hash NICHT verschachtelt.

  def edit
    @user = User.find_by_login(params[:id])
  end

  # UPDATE
  # Der 'update' Controller ist die submit Adresse des in 'edit' erzeugten
  # Formulares. Er findet die richtige Instanz des User Objektes anhand des
  # login parameters aus der URL. Der 'params' hash stammt aus einem 'POST'
  # Request und ist daher wieder ein verschachteltes Dictionary, um an den
  # 'loin' Parameter zu gelangen, müssen also zwei paar eckige Klammern her:
  # '[:user][:login]'
  #
  # an die 'User.update' Funktion wird dann der ganze ':user' sub-hash aus dem
  # params hash übergeben. Er enthält alle Parameter die in den Feldern des
  # edit Formulares gesetzt wurden.
  #
  # Die Instanz wird dann mit den Werten aus dem params hash geupdatet (stammen
  # aus dem 'edit_user' Formular, aus der edit action des user controllers via
  # 'POST' Request). Anschliessend wird der User eingelogt und zu seinem Profil
  # umgeleitet. Dabei muss wieder der 'login' Parameter aus der @user Instanz
  # als Parameter an 'user_path' übergeben werden, da ansonsten automagisch die
  # ':id' eingesetzt wird.
 
  def update
    logger.debug "xxxxxxxxx#{params}"
    @user = User.find_by_login(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profil erfolgreich geändert"
      sign_in @user
      redirect_to user_path(@user)
    else
      @title = "Benutzer editieren"
      render 'edit'
    end
  end

  # SHOW
  # Zeigt das Profil eines Users. Hier ist der 'params' hash wieder flach, weil
  # es sich um einen 'GET' Request handelt und die Parameter aus der URL
  # stammen und durch die 'match' Funktion in 'routes' ausgefiltert und gesetzt
  # werden.

  def show
    @user = User.find_by_login(params[:id])
  end

  # INDEX
  # Zeigt die Profil aller User
 
  def index
    @users = User.paginate(page: params[:page] )
  end

  # DESTROY
  # logt den user aus, zerstört das session coockie mittels der 'sign_out'
  # Funktion aus dem sessions_helper und sezt ein neues remember_token fuer die
  # naechste Session

  def destroy
#    logger.debug "xxxxxxxxx#{params}"
    User.find_by_login(params[:id]).destroy
    flash[:success] = "Benutzer gelöscht."
    redirect_to users_path
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Bitte anmelden"
      end
    end

    def correct_user
      @user = User.find_by_login(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
