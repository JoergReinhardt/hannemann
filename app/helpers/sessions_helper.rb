# SESSION HELPER 
# muessen angemeldet & abgemeldet werden. Da jeder Request in sich gschlossen
# ist, muss der User jedes mal auf's neue authentifiziert werden. Das laueft
# mittels session coockies.
#
# Da man sich mit dem Coockie nicht jedes mal neu auseinandersetzen muss,
# erzeugen wir noch eine 'signed_in?' und eine 'current_user' Funktion.
# Erstere ergibt 'true', oder 'false' in Abhaengigkeit des Anmeldestatus,
# 'current_user' gibt die Instanz des aktuell eingelogten Users zurueck.

module SessionsHelper

  # SIGN_IN
  # sign_in setzt das remember token im cookie des users und den current_user
  # auf den frisch eingeloggten user.  current_user ist eigentlich eine
  # Funktion und kennt keine Zuweisung, diese muss erst implementiert ewrden
  # (siehe Unten)

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    current_user = user
  end

  # SIGNED_IN?
  # signed_in? ergibt true, oder false, je nachdem, ob der User eingeloggt ist.
  # Benutzt dafuer ebenfalls current_user

  def signed_in?
    !current_user.nil?
  end

  # SIGN_OUT
  # sign_out speichert den current user noch einmal ohne Veraenderungen ab,
  # dadurch entsteht ein neues remember_token als Nebeneffekt setzt den
  # current_user auf nil und entfernt das coockie
  #
  # self.current_user.save(validate: false)
  # hat den Nebeneffekt das remember_token neu zu setzen. Keine
  # Validation, weil Passwort nicht bekannt und nicht benoetigt.

  def sign_out
    current_user.save(validate: false)
    current_user = nil
    cookies.delete(:remember_token)
  end

  # CURRENT_USER=
  # Zuweisungsoperator der Funktion current_user definieren, weil Funktionen
  # eigentlich keine Zuweisungen kennen. Die current_user Instanz kann auf die
  # Art und Weise wie eine Variable zugewiesen werden. Nimmt ein user Object
  # als Parameter.

  def current_user=(user)
    @current_user = user
  end

  # CURRENT_USER
  # current_user ist eine Instanz Funktion mit Rueckgabewert, der bei jedem
  # Request vergessen wird die current_user Funktion schaut erst einmal nach,
  # ob der Wert vielleicht noch gesetzt ist fuer denn Fall das Er bereits
  # zuvor im selben Request benoetigt wurde, denn dann muss nicht die
  # Datenbank bemueht werden.ansonsten wird der User anhand des im cookie
  # gespeicehrten Wertes gefunden und zugewiesen.

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

end
